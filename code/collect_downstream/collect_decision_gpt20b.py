"""
LLM Decision Bias Task — GPT_20B (local)
Two-stage inference: Task 1 and Task 2 are issued as separate forward passes so
that task2_thinking_tokens isolates decision-level reasoning effort.

Output: ../../data/downstream/decision/GPT_20B/{experiment_name}.csv
"""

import os
import warnings
import argparse
import pandas as pd
import torch
from tqdm import tqdm
from transformers import AutoTokenizer, AutoModelForCausalLM

from collect_decision_api import (
    EXPERIMENT_CONFIG, DECISION_EXPERIMENTS, N_ITERATIONS, build_tasks,
)

MODEL_NAME = "GPT_20B"


class GPT20BEvaluator:
    def __init__(self, model_path):
        self.tokenizer = AutoTokenizer.from_pretrained(model_path)
        self.model = AutoModelForCausalLM.from_pretrained(
            model_path, device_map="auto", torch_dtype="auto"
        )

    def _generate(self, messages, max_retries=3):
        """Single forward pass; returns (response_text, thinking_tokens)."""
        text = self.tokenizer.apply_chat_template(
            messages, tokenize=False, add_generation_prompt=True, enable_thinking=True
        )
        model_inputs = self.tokenizer([text], return_tensors="pt").to(self.model.device)

        for attempt in range(max_retries):
            with torch.no_grad():
                generated_ids = self.model.generate(**model_inputs, max_new_tokens=4096)
            output_ids = generated_ids[0][len(model_inputs.input_ids[0]):].tolist()
            full_response = self.tokenizer.decode(output_ids, skip_special_tokens=True).strip()

            analysis_start = full_response.lower().find("analysis")
            final_start = full_response.lower().find("assistantfinal")
            if analysis_start != -1 and final_start != -1:
                response = full_response[final_start + len("assistantfinal"):].strip()
                return response, len(output_ids)

            warnings.warn(
                f"Markers not found. Retrying... (attempt {attempt + 1}/{max_retries})"
            )

        print(f"  [WARN] Failed to find response markers after {max_retries} attempts")
        return None, None

    def query_two_stage(self, task1_prompt, task2_prompt):
        """Two sequential forward passes with shared conversation context."""
        t1_resp, t1_tokens = self._generate(
            [{"role": "user", "content": task1_prompt}]
        )
        if t1_resp is None:
            return None, None, None, None

        t2_resp, t2_tokens = self._generate([
            {"role": "user",      "content": task1_prompt},
            {"role": "assistant", "content": t1_resp},
            {"role": "user",      "content": task2_prompt},
        ])
        return t1_resp, t1_tokens, t2_resp, t2_tokens


def run_experiment(exp_name, evaluator):
    tasks = build_tasks(exp_name)
    results = []

    with tqdm(total=len(tasks), desc=exp_name) as pbar:
        for task in tasks:
            (iteration, variation_label, task1_prompt, task2_prompt,
             group0, group1, group0_pole, group1_pole,
             attribute0, attribute1, attr0_pole, attr1_pole) = task

            t1_resp, t1_tokens, t2_resp, t2_tokens = evaluator.query_two_stage(
                task1_prompt, task2_prompt
            )

            results.append({
                "experiment":            exp_name,
                "model":                 MODEL_NAME,
                "iteration":             iteration,
                "variation":             variation_label,
                "group0":                group0,
                "group1":                group1,
                "group0_pole":           group0_pole,
                "group1_pole":           group1_pole,
                "attribute0":            attribute0,
                "attribute1":            attribute1,
                "attr0_pole":            attr0_pole,
                "attr1_pole":            attr1_pole,
                "task1_prompt":          task1_prompt,
                "task1_response":        t1_resp,
                "task1_thinking_tokens": t1_tokens,
                "task2_prompt":          task2_prompt,
                "task2_response":        t2_resp,
                "task2_thinking_tokens": t2_tokens,
            })
            pbar.update(1)

    return results


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--model_path", default="/home/mts/ssd_16tb/member/lhj/llm/GPT_20B")
    parser.add_argument("--experiments", nargs="+", default=DECISION_EXPERIMENTS)
    parser.add_argument("--out_dir", default="../../data/downstream/decision")
    args = parser.parse_args()

    evaluator = GPT20BEvaluator(args.model_path)
    save_dir = os.path.join(args.out_dir, MODEL_NAME)
    os.makedirs(save_dir, exist_ok=True)

    for exp_name in args.experiments:
        print(f"[GPT_20B] Running decision: {exp_name}...")
        results = run_experiment(exp_name, evaluator)
        df = pd.DataFrame(results)
        save_path = os.path.join(save_dir, f"{exp_name}.csv")
        df.to_csv(save_path, index=False)
        print(f"  Saved {save_path} — {len(df)} rows")


if __name__ == "__main__":
    main()
