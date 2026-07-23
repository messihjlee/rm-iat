"""
LLM Implicit Bias Task — Qwen3-8B (local)
Same task as collect_wat_api.py; uses Qwen3's <think>...</think> response format.

Output: ../../data/downstream/wat/Qwen3-8B/{experiment_name}.csv
"""

import os
import random
import argparse
import pandas as pd
import torch
from tqdm import tqdm
from transformers import AutoTokenizer, AutoModelForCausalLM

from collect_wat_api import (
    WORD_GROUPS, EXPERIMENTS, IMPLICIT_TEMPLATES, N_ITERATIONS, parse_response,
)

MODEL_NAME = "Qwen3-8B"


class Qwen3Evaluator:
    def __init__(self, model_path):
        self.tokenizer = AutoTokenizer.from_pretrained(model_path)
        self.model = AutoModelForCausalLM.from_pretrained(
            model_path, device_map="auto", torch_dtype="auto"
        )

    def query(self, prompt, max_retries=3):
        messages = [{"role": "user", "content": prompt}]
        for attempt in range(max_retries):
            text = self.tokenizer.apply_chat_template(
                messages, tokenize=False, add_generation_prompt=True, enable_thinking=True
            )
            model_inputs = self.tokenizer([text], return_tensors="pt").to(self.model.device)
            with torch.no_grad():
                generated_ids = self.model.generate(**model_inputs, max_new_tokens=4096)
            output_ids = generated_ids[0][len(model_inputs.input_ids[0]):].tolist()
            full_response = self.tokenizer.decode(output_ids, skip_special_tokens=True).strip()

            if "<think>" not in full_response or "</think>" not in full_response:
                continue

            think_end = full_response.find("</think>")
            thinking_token_ids = []
            for token_id in output_ids:
                decoded = self.tokenizer.decode(thinking_token_ids + [token_id], skip_special_tokens=True)
                thinking_token_ids.append(token_id)
                if "</think>" in decoded:
                    break

            response = full_response[think_end + 8:].strip()
            return len(thinking_token_ids), response

        print(f"  [WARN] Failed thinking tags after {max_retries} attempts")
        return None, None


def run_experiment(exp_name, evaluator):
    g1, g2, a1, a2 = EXPERIMENTS[exp_name]
    g1_words = WORD_GROUPS[g1]
    g2_words = WORD_GROUPS[g2]
    attr_words = WORD_GROUPS[a1] + WORD_GROUPS[a2]
    attr_pole = {w: a1 for w in WORD_GROUPS[a1]}
    attr_pole.update({w: a2 for w in WORD_GROUPS[a2]})

    results = []
    total = N_ITERATIONS * len(IMPLICIT_TEMPLATES)

    with tqdm(total=total, desc=exp_name) as pbar:
        for iteration in range(N_ITERATIONS):
            if random.random() > 0.5:
                group0, group1 = random.choice(g1_words), random.choice(g2_words)
                group0_pole, group1_pole = g1, g2
            else:
                group0, group1 = random.choice(g2_words), random.choice(g1_words)
                group0_pole, group1_pole = g2, g1

            shuffled = attr_words.copy()
            random.shuffle(shuffled)
            attributes_str = str(shuffled)

            for template_name, template in IMPLICIT_TEMPLATES.items():
                prompt = template.format(group0=group0, group1=group1, attributes=attributes_str)
                thinking_tokens, response = evaluator.query(prompt)
                assignments = parse_response(response)

                for attr in attr_words:
                    results.append({
                        "experiment":     exp_name,
                        "model":          MODEL_NAME,
                        "template":       template_name,
                        "iteration":      iteration,
                        "group0":         group0,
                        "group1":         group1,
                        "group0_pole":    group0_pole,
                        "group1_pole":    group1_pole,
                        "attribute":      attr,
                        "attr_pole":      attr_pole[attr],
                        "thinking_tokens": thinking_tokens,
                        "group_assigned": assignments.get(attr.lower()) if assignments else None,
                        "raw_response":   response,
                    })

                pbar.update(1)
                pbar.set_postfix({"iter": iteration, "template": template_name})

    return results


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--model_path", default="/home/mts/ssd_16tb/member/lhj/llm/Qwen3_8B")
    parser.add_argument("--experiments", nargs="+", default=list(EXPERIMENTS.keys()))
    parser.add_argument("--out_dir", default="../../data/downstream/wat")
    args = parser.parse_args()

    evaluator = Qwen3Evaluator(args.model_path)
    save_dir = os.path.join(args.out_dir, MODEL_NAME)
    os.makedirs(save_dir, exist_ok=True)

    for exp_name in args.experiments:
        print(f"[Qwen3-8B] Running implicit: {exp_name}...")
        results = run_experiment(exp_name, evaluator)
        df = pd.DataFrame(results)
        save_path = os.path.join(save_dir, f"{exp_name}.csv")
        df.to_csv(save_path, index=False)
        print(f"  Saved {save_path} — {len(df)} rows")


if __name__ == "__main__":
    main()
