# Implicit Bias-Like Patterns in Reasoning Models

**Authors:** Messi H.J. Lee (Washington University in St. Louis), Calvin K. Lai (Rutgers, The State University of New Jersey)

## Overview

This capsule contains replication materials for the Reasoning Model Implicit Association Test (RM-IAT). Implicit biases refer to automatic mental processes that shape perceptions, judgments, and behaviors. Prior work on "implicit bias" in LLMs has focused primarily on model outputs rather than the processes underlying them. The RM-IAT measures implicit bias-like *processing* in reasoning models — LLMs that generate step-by-step reasoning before producing a final answer — by comparing reasoning token usage across association-compatible vs. association-incompatible task conditions.

Five reasoning models are examined: **o3-mini**, **DeepSeek-R1**, **gpt-oss-20b**, **Qwen3-8B**, and **Claude 3.7 Sonnet**. Across 10 IAT variants, o3-mini, DeepSeek-R1, gpt-oss-20b, and Qwen3-8B consistently expend more reasoning tokens on association-incompatible tasks, suggesting greater computational effort when processing counter-stereotypical information. Claude 3.7 Sonnet exhibits reversed or inconsistent patterns, likely due to embedded safety mechanisms that flag socially sensitive associations.

---

## Repository Structure

```
rm-iat/
├── environment/
│   └── Dockerfile              # Docker image specification
├── .codeocean/
│   └── environment.json        # CodeOcean environment configuration
├── metadata/
│   └── metadata.yml            # Capsule metadata (title, description, authors)
├── code/
│   ├── run                     # Bash entry point (calls Rscript analyze/rmiat/main.R)
│   ├── capsule.Rproj           # RStudio project file
│   ├── analyze/
│   │   ├── rmiat/
│   │   │   ├── main.R          # Master script: runs all analyses sequentially
│   │   │   ├── o3-mini/        # Analysis scripts for o3-mini
│   │   │   ├── DeepSeek-R1/    # Analysis scripts for DeepSeek-R1
│   │   │   ├── Claude3.7/      # Analysis scripts for Claude 3.7 Sonnet
│   │   │   ├── gpt-oss-20b/    # Analysis scripts for gpt-oss-20b
│   │   │   └── Qwen3-8B/       # Analysis scripts for Qwen3-8B
│   │   ├── viz/
│   │   │   ├── visualize.R         # Cross-model effect size visualization (Figure 2)
│   │   │   └── visualize_refusals.R # Refusal rate visualization (Figure 3)
│   │   ├── stm/
│   │   │   ├── stm.R               # Fits STM (K=4) on reasoning text
│   │   │   ├── topic3.R            # Analyzes Topic 3 in detail
│   │   │   └── extracted_words.txt # Keywords removed during STM preprocessing
│   │   └── downstream/
│   │       ├── analyze_validity.R   # Convergent validity analysis (WAT & RDT)
│   │       └── describe_downstream.R # Descriptive stats for downstream tasks
│   ├── collect/                # Data collection scripts (RM-IAT)
│   │   ├── Claude4.5/
│   │   ├── DeepSeek-V4/
│   │   ├── gpt-oss-20b/
│   │   └── Qwen3-8B/
│   └── collect_downstream/     # Data collection scripts (WAT & RDT)
├── data/
│   ├── rmiat/
│   │   ├── o3-mini/            # IAT datasets for o3-mini (10 CSV files)
│   │   ├── DeepSeek-R1/        # IAT datasets for DeepSeek-R1 (10 CSV files)
│   │   ├── Claude3.7/          # IAT datasets for Claude 3.7 Sonnet (10 CSV files)
│   │   ├── gpt-oss-20b/        # IAT datasets for gpt-oss-20b (10 CSV files)
│   │   ├── Qwen3-8B/           # IAT datasets for Qwen3-8B (10 CSV files)
│   │   └── rm_iat_effect_sizes.csv  # Aggregated effect sizes across models
│   └── downstream/
│       ├── wat/                # Word Association Task results
│       └── decision/           # Resume Decision Task results
└── results/                    # Output directory (PDFs written here)
```

### Per-Model Analysis Scripts

Each model directory under `code/analyze/rmiat/` contains the same set of scripts:

| Script | Description | Reproduces |
|---|---|---|
| `mixed.R` | Mixed-effects models (`tokens ~ condition + (1\|prompt)`) | Table S5 |
| `effect_sizes.R` | Cohen's *d* effect sizes (with and without refusals) | Table S8 |
| `refusals.R` | Counts refusals; t-test comparing token counts | Table S3 |
| `descriptive.R` | Descriptive statistics (mean/SD tokens by IAT and condition) | Table S4 |
| `iat.R` | Counts "IAT" mentions in reasoning text | Not in current manuscript draft |

> **Note:** `iat.R` is not run for o3-mini because reasoning tokens were not available for that model.

---

## Data

Each model directory under `data/rmiat/` contains 10 CSV files corresponding to 10 IAT variants:

| File | Target concepts | Attribute dimension |
|---|---|---|
| `flowers_insects.csv` | Flowers vs. Insects | Pleasant / Unpleasant |
| `instruments_weapons.csv` | Instruments vs. Weapons | Pleasant / Unpleasant |
| `race_original.csv` | Race (original) | Pleasant / Unpleasant |
| `race_bertrand.csv` | Race (Bertrand names) | Pleasant / Unpleasant |
| `race_nosek.csv` | Race (Nosek stimuli) | Pleasant / Unpleasant |
| `career_family.csv` | Career vs. Family | Career / Family |
| `math_arts.csv` | Math vs. Arts | Math / Arts |
| `science_arts.csv` | Science vs. Arts | Science / Arts |
| `mental_physical.csv` | Mental vs. Physical health | Temporary / Permanent |
| `young_old.csv` | Young vs. Old | Pleasant / Unpleasant |

### Data Schema

Each CSV file contains the following columns:

| Column | Description |
|---|---|
| `word` | Target concept word presented to the model |
| `group` | Category of the word (e.g., "Flowers", "Insects") |
| `attribute` | Attribute the model associated with the word (e.g., "Pleasant", "Unpleasant"); used to detect refusals |
| `thought` | Model's reasoning/thinking text (chain-of-thought) |
| `tokens` | Number of reasoning tokens used |
| `condition` | `"Stereotype-Consistent"` or `"Stereotype-Inconsistent"` |
| `prompt` / `prompt_id` | Prompt identifier for random effects (column name varies by model) |

A **refusal** is recorded when the `attribute` value falls outside the expected set for that IAT (e.g., any value other than "Pleasant" or "Unpleasant" for `flowers_insects`).

---

## Environment & Dependencies

The analyses run in a Docker container built on **RStudio Server (Ubuntu 22.04, R 4.5.1)**.

Key R packages (pinned versions):

| Package | Version | Use |
|---|---|---|
| `tidyverse` | 2.0.0 | Data manipulation and visualization |
| `lme4` | 1.1-37 | Mixed-effects models |
| `lmerTest` | 3.1-3 | P-values for mixed models |
| `afex` | 1.5-0 | ANOVA / regression |
| `effsize` | 0.8.1 | Cohen's *d* |
| `stm` | 1.3.8 | Structural Topic Modeling |
| `tm` | 0.7-16 | Text preprocessing |
| `ggsci` | 4.0.0 | Color palettes |
| `ggsignif` | 0.6.4 | Significance annotations |
| `Cairo` | 1.6-5 | PDF graphics output |

All dependencies are pre-installed in the capsule environment. No manual installation is required when running on CodeOcean.

**Required non-standard hardware:** None. All analyses run on standard CPU hardware.

**Typical install time (local):** Building the Docker image takes approximately 10–20 minutes on a normal desktop, depending on internet speed and hardware. Installing R and all packages manually (without Docker) takes approximately 10–15 minutes.

---

## Replication Steps

### On CodeOcean (recommended)

Click **Reproducible Run** in the capsule interface. CodeOcean will execute `code/run`, which calls:

```bash
Rscript analyze/rmiat/main.R
```

This runs all analyses sequentially and writes results to the `results/` directory.

### Locally (with Docker)

1. **Clone or download** this capsule.
2. **Build the Docker image** from `environment/Dockerfile`:
   ```bash
   docker build -t rm-iat environment/
   ```
3. **Run the container**, mounting the capsule directory:
   ```bash
   docker run --rm \
     -v "$(pwd)":/capsule \
     -w /capsule/code \
     rm-iat Rscript analyze/rmiat/main.R
   ```
4. Outputs will appear in the `results/` directory.

### Locally (without Docker)

Ensure R 4.5.1 and all packages listed above are installed, then:

```r
setwd("path/to/rm-iat/code")
source("analyze/rmiat/main.R")
```

---

## Running on Your Own Data

To run the RM-IAT analysis on a new model's data:

1. **Prepare your CSV files.** Each IAT variant requires one CSV with the columns described in [Data Schema](#data-schema) above: `word`, `group`, `attribute`, `thought`, `tokens`, `condition`, and `prompt` (or `prompt_id`). Name the files to match the 10 IAT variants listed in the [Data](#data) section (e.g., `flowers_insects.csv`).

2. **Add a model directory.** Create a folder under `data/rmiat/` for your model (e.g., `data/rmiat/MyModel/`) and place your 10 CSV files there.

3. **Copy an analysis script directory.** Duplicate an existing model directory under `code/analyze/rmiat/` (e.g., copy `code/analyze/rmiat/DeepSeek-R1/` to `code/analyze/rmiat/MyModel/`).

4. **Update the data path.** In each copied script, change the path that reads the CSV files to point to `data/rmiat/MyModel/`. Search for the string `DeepSeek-R1` (or whichever model you copied) and replace it with your model directory name.

5. **Source the scripts.** Run the individual analysis scripts directly:
   ```r
   setwd("path/to/rm-iat/code")
   source("analyze/rmiat/MyModel/mixed.R")
   source("analyze/rmiat/MyModel/effect_sizes.R")
   # etc.
   ```
   Or add your model's scripts to `main.R` following the existing pattern and run the full pipeline.

> **Note:** The `iat.R` script requires access to the model's raw reasoning text in the `thought` column. If reasoning tokens were not recorded, skip that script.

---

## Analysis Pipeline & Outputs

`main.R` runs all analyses in the following order:

| Step | Script(s) | Output | Reproduces |
|---|---|---|---|
| 1 | `rmiat/{model}/mixed.R` × 5 | Printed summaries, variance components, `.RData` per model | Table S5 |
| 2 | `rmiat/{model}/effect_sizes.R` × 5 | Cohen's *d* with/without refusals | Table S8 |
| 3 | `rmiat/{model}/refusals.R` × 5 | Refusal counts, t-tests | Table S3 |
| 4 | `rmiat/{model}/descriptive.R` × 5 | Mean/SD tokens by IAT × condition | Table S4 |
| 5 | `viz/visualize.R`, `viz/visualize_refusals.R` | `results/fig2.pdf`, `results/fig3.pdf` | Figures 2 & 3 |
| 6 | `rmiat/{model}/iat.R` × 4 | "IAT" mention counts by condition | Not in current manuscript draft |
| 7 | `stm/stm.R` → `stm/topic3.R` | Topic model output, Topic 3 analysis | Section S8 |
| 8 | `rmiat/o3-mini/sensitivity_analysis.R` | Sensitivity analysis output | Section S7 |
| 9 | `downstream/analyze_validity.R`, `downstream/describe_downstream.R` | Convergent validity results | Supplementary (WAT & RDT) |

### Key outputs

- **`results/fig2.pdf`** — Cross-model comparison of Cohen's *d* effect sizes with 95% CIs (Figure 2).
- **`results/fig3.pdf`** — Refusal rates by model, IAT, and condition.
- **Printed to console** — All tables (S3–S9) are printed during execution.

**Expected run time on a normal desktop:** The full pipeline (all 9 steps) takes approximately 10–20 minutes. The structural topic model (Step 7) is the most time-consuming step (~5–10 minutes); all other steps complete in under a minute each.

---

## Notes

- **o3-mini** is excluded from the IAT-mention analysis (Step 6) because reasoning tokens were not accessible for that model.
- The `gpt-oss-20b` datasets use a `prompt_id` column instead of `prompt` for the random effect in mixed models.
- The `descriptive.R` scripts standardize condition labels ("Stereotype-Consistent" → "Association-Compatible" / "Stereotype-Inconsistent" → "Association-Incompatible") for display.
- The STM preprocessing removes a set of task-specific keywords (listed in `code/analyze/stm/extracted_words.txt`) to avoid content confounds before topic modeling.

---

## License

This software is released under the **MIT License**, an [OSI-approved open-source license](https://opensource.org/licenses/MIT). See the `LICENSE` file in the root of this repository for the full license text.

**In brief:** You are free to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of this software for any purpose, with or without modification, provided that the original copyright notice and this permission notice are included in all copies or substantial portions of the software. The software is provided "as is", without warranty of any kind.
