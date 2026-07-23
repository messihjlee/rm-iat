## Anonymous
#
## Script date:

# 1. Setup ---------------------------------------------------------------------

library(tidyverse)
library(stm)
library(effsize)

load("stm.RData")

# 2. Model summary and overall topic proportions --------------------------------

summary(stm_model)
par(mar = c(2, 2, 2, 2))
plot(stm_model, labeltype = "frex", n = 5)

topic_props_pct <- round(colMeans(stm_model$theta) * 100, 2)
names(topic_props_pct) <- paste("Topic", seq_along(topic_props_pct))
print(topic_props_pct)

# 3. Estimate effects (condition * model * IAT) ---------------------------------

prep_effect <- estimateEffect(1:4 ~ condition * model * IAT,
                              stmobj = stm_model,
                              metadata = out$meta,
                              uncertainty = "Global")

# 4. Topic 3: regression table (main effects + interactions) -------------------

print(summary(prep_effect, topics = 3))

# 5. Topic 3: marginal effect of model -----------------------------------------

model_eff <- plot(prep_effect, covariate = "model", topics = 3,
                  method = "pointestimate",
                  printlegend = FALSE)

print(model_eff$means)
print(model_eff$cis)

# 6. Topic 3: marginal effect of condition -------------------------------------

cond_eff <- plot(prep_effect, covariate = "condition", topics = 3,
                 method = "pointestimate",
                 printlegend = FALSE)

print(cond_eff$means)
print(cond_eff$cis)

# 7. Topic 3: condition effect within each model (model x condition) -----------

model_levels <- as.character(unique(out$meta$model))

for (m in model_levels) {
  eff <- plot(prep_effect, covariate = "condition", topics = 3,
              method = "pointestimate",
              moderator = "model",
              moderator.value = m,
              printlegend = FALSE)

  cond_labels <- as.character(eff$uvals)
  means <- eff$means[[1]]
  cis   <- eff$cis[[1]]

  cat("\n", m, "\n")
  for (i in seq_along(cond_labels)) {
    cat(sprintf("  %-30s  %.2f  [%.2f, %.2f]\n",
                cond_labels[i],
                round(means[i] * 100, 2),
                round(cis[i, 1] * 100, 2),
                round(cis[i, 2] * 100, 2)))
  }
}

# 8. Topic 3: Association Incompatible effect by model x IAT -------------------

full_df     <- out$meta %>% mutate(topic3 = stm_model$theta[, 3])
model_order <- c("DeepSeek-R1", "Claude 3.7 Sonnet", "gpt-oss-20b", "Qwen3-8B")
iat_levels  <- levels(as.factor(out$meta$IAT))

lm_rows <- lapply(model_order, function(m) {
  lapply(iat_levels, function(iat) {
    df  <- full_df %>% filter(model == m, IAT == iat)
    fit <- lm(topic3 ~ condition, data = df)
    ct  <- summary(fit)$coefficients
    row <- ct["conditionAssociation Incompatible", ]
    data.frame(Model = m, IAT = iat,
               Estimate = round(row["Estimate"], 4),
               p_value  = row["Pr(>|t|)"],
               row.names = NULL)
  })
})

result_table <- do.call(rbind, do.call(c, lm_rows))

cohens_d_rows <- lapply(model_order, function(m) {
  lapply(iat_levels, function(iat) {
    df         <- full_df %>% filter(model == m, IAT == iat)
    x_incompat <- df %>% filter(condition == "Association Incompatible") %>% pull(tokens)
    x_compat   <- df %>% filter(condition == "Association Compatible")   %>% pull(tokens)
    d <- cohen.d(x_incompat, x_compat)$estimate
    data.frame(Model = m, IAT = iat, cohens_d = d, row.names = NULL)
  })
})

cohens_d_table <- do.call(rbind, do.call(c, cohens_d_rows))

cat('\n\nAssociation Incompatible effect by model and IAT:\n')
print(result_table, row.names = FALSE, digits = 5)

cat('\n\nCohen\'s d (Incompatible - Compatible) by model and IAT:\n')
print(cohens_d_table, row.names = FALSE, digits = 5)

cor.test(result_table$Estimate, cohens_d_table$cohens_d)
