## Descriptive statistics for WAT and RDT downstream tasks.
## Shows raw group-level scores (not effect sizes) per model per condition.

library(tidyverse)

root <- "../../../"

# ── 1. Load data ───────────────────────────────────────────────────────────────
# WAT: mean_g1/mean_g2 are raw association scores per target group
# (g1 = positively-associated group per original IAT; mental_physical exception: g1=mental)
wat <- read_csv(paste0(root, "data/downstream/wat/wat_effect_sizes.csv")) %>%
  select(model, experiment, g1 = mean_g1, g2 = mean_g2)

# RDT: mean_pos/mean_neg are proportion of positive decisions per target group
rdt <- read_csv(paste0(root, "data/downstream/decision/decision_effect_sizes.csv")) %>%
  select(model, experiment, pos = mean_pos, neg = mean_neg)

# ── 2. Experiment ordering ─────────────────────────────────────────────────────
exp_order <- c(
  "flowers_insects", "instruments_weapons",
  "race_original", "race_bertrand", "race_nosek",
  "career_family", "math_arts", "science_arts",
  "mental_physical", "young_old"
)

# ── 3. Descriptives: M/SD of group scores across models ───────────────────────
wat_desc <- wat %>%
  group_by(experiment) %>%
  summarise(task = "WAT", n_models = n(),
            M_g1 = mean(g1), SD_g1 = sd(g1),
            M_g2 = mean(g2), SD_g2 = sd(g2), .groups = "drop")

rdt_desc <- rdt %>%
  group_by(experiment) %>%
  summarise(task = "RDT", n_models = n(),
            M_pos = mean(pos), SD_pos = sd(pos),
            M_neg = mean(neg), SD_neg = sd(neg), .groups = "drop")

cat("=== WAT: M/SD of group scores across models ===\n")
print(wat_desc %>% mutate(experiment = factor(experiment, levels = exp_order)) %>%
        arrange(experiment), n = Inf)

cat("\n=== RDT: M/SD of group scores across models ===\n")
print(rdt_desc %>% mutate(experiment = factor(experiment, levels = exp_order)) %>%
        arrange(experiment), n = Inf)

# ── 4. Per-model wide tables ───────────────────────────────────────────────────
join_model_wat <- function(df, mdl, suffix) {
  df %>% filter(model == mdl) %>%
    select(experiment, !!paste0("WAT_g1_", suffix) := g1,
                       !!paste0("WAT_g2_", suffix) := g2)
}
join_model_rdt <- function(df, mdl, suffix) {
  df %>% filter(model == mdl) %>%
    select(experiment, !!paste0("RDT_pos_", suffix) := pos,
                       !!paste0("RDT_neg_", suffix) := neg)
}

combined <- tibble(experiment = exp_order) %>%
  left_join(join_model_wat(wat, "GPT_20B",   "GPT_20B"),   by = "experiment") %>%
  left_join(join_model_wat(wat, "Qwen3-8B",  "Qwen3_8B"),  by = "experiment") %>%
  left_join(join_model_rdt(rdt, "GPT_20B",   "GPT_20B"),   by = "experiment") %>%
  left_join(join_model_rdt(rdt, "Qwen3-8B",  "Qwen3_8B"),  by = "experiment")

cat("\n=== Per-model group scores ===\n")
print(combined %>% mutate(experiment = factor(experiment, levels = exp_order)) %>%
        arrange(experiment), n = Inf)
