## External Validity Analysis
## Tests whether RM-IAT d effect sizes correlate with WAT and RDT bias scores.
## Unit of analysis: (model × bias_category) cell.

library(tidyverse)

root <- "../../../"

# ── 1. Load RM-IAT d scores ────────────────────────────────────────────────────
rm_iat <- read_csv(paste0(root, "data/rmiat/rm_iat_effect_sizes.csv")) %>%
  select(model, experiment, rmiat_d = cohens_d)

# ── 2. Load WAT effect sizes ───────────────────────────────────────────────────
wat <- read_csv(paste0(root, "data/downstream/wat/wat_effect_sizes.csv")) %>%
  select(model, experiment, wat_d)

# ── 3. Load RDT effect sizes ───────────────────────────────────────────────────
rdt <- read_csv(paste0(root, "data/downstream/decision/decision_effect_sizes.csv")) %>%
  select(model, experiment, rdt_d)

# ── 4. Join ────────────────────────────────────────────────────────────────────
wat_combined <- inner_join(rm_iat, wat, by = c("model", "experiment"))
OS_MODELS <- c("GPT_20B", "Qwen3-8B")

rdt_combined <- inner_join(rm_iat, rdt, by = c("model", "experiment")) %>%
  filter(model %in% OS_MODELS, !is.na(rdt_d))

cat(sprintf("\nWAT dataset: %d cells\n", nrow(wat_combined)))
cat(sprintf("RDT dataset: %d cells\n\n", nrow(rdt_combined)))

# ── 5. Correlations ────────────────────────────────────────────────────────────
cat("=== RM-IAT d vs WAT d ===\n")
wat_pearson  <- cor.test(wat_combined$rmiat_d, wat_combined$wat_d, method = "pearson")
wat_spearman <- cor.test(wat_combined$rmiat_d, wat_combined$wat_d, method = "spearman")
cat("Pearson r:\n");  print(wat_pearson)
cat("\nSpearman rho:\n"); print(wat_spearman)

cat("\n=== RM-IAT d vs RDT d ===\n")
rdt_pearson  <- cor.test(rdt_combined$rmiat_d, rdt_combined$rdt_d, method = "pearson")
rdt_spearman <- cor.test(rdt_combined$rmiat_d, rdt_combined$rdt_d, method = "spearman")
cat("Pearson r:\n");  print(rdt_pearson)
cat("\nSpearman rho:\n"); print(rdt_spearman)

# ── 6. Summary table ───────────────────────────────────────────────────────────
summary_tbl <- tibble(
  outcome  = c("WAT", "WAT", "RDT", "RDT"),
  method   = c("Pearson", "Spearman", "Pearson", "Spearman"),
  r        = c(wat_pearson$estimate,  wat_spearman$estimate,
               rdt_pearson$estimate,  rdt_spearman$estimate),
  p        = c(wat_pearson$p.value,   wat_spearman$p.value,
               rdt_pearson$p.value,   rdt_spearman$p.value),
  n        = c(nrow(wat_combined), nrow(wat_combined),
               nrow(rdt_combined), nrow(rdt_combined)),
  ci_lower = c(wat_pearson$conf.int[1], NA, rdt_pearson$conf.int[1], NA),
  ci_upper = c(wat_pearson$conf.int[2], NA, rdt_pearson$conf.int[2], NA),
)
cat("\n=== Summary ===\n")
print(summary_tbl, n = Inf)


# ── 7. Per-experiment and per-model breakdowns ─────────────────────────────────
cat("\n--- WAT: correlation by experiment ---\n")
wat_combined %>%
  group_by(experiment) %>%
  summarise(r = cor(rmiat_d, wat_d), n = n(), .groups = "drop") %>%
  arrange(desc(abs(r))) %>%
  print(n = Inf)

cat("\n--- WAT: correlation by model ---\n")
wat_combined %>%
  group_by(model) %>%
  summarise(r = cor(rmiat_d, wat_d), n = n(), .groups = "drop") %>%
  arrange(desc(abs(r))) %>%
  print(n = Inf)

cat("\n--- RDT: correlation by experiment ---\n")
rdt_combined %>%
  group_by(experiment) %>%
  summarise(r = cor(rmiat_d, rdt_d), n = n(), .groups = "drop") %>%
  arrange(desc(abs(r))) %>%
  print(n = Inf)

cat("\n--- RDT: correlation by model ---\n")
rdt_combined %>%
  group_by(model) %>%
  summarise(r = cor(rmiat_d, rdt_d), n = n(), .groups = "drop") %>%
  arrange(desc(abs(r))) %>%
  print(n = Inf)
