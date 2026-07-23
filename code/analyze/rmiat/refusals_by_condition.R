library(tidyverse)

base <- "../../../data/rmiat"

load_model <- function(model_dir, attr_map, capitalize = TRUE) {
  files <- list(
    flowers_insects   = list(valid = if (capitalize) c("Pleasant","Unpleasant") else c("pleasant","unpleasant"), label = "Flowers/Insects + Pleasant/Unpleasant"),
    instruments_weapons = list(valid = if (capitalize) c("Pleasant","Unpleasant") else c("pleasant","unpleasant"), label = "Instruments/Weapons + Pleasant/Unpleasant"),
    race_original     = list(valid = if (capitalize) c("Pleasant","Unpleasant") else c("pleasant","unpleasant"), label = "European/African Americans + Pleasant/Unpleasant (1)"),
    race_bertrand     = list(valid = if (capitalize) c("Pleasant","Unpleasant") else c("pleasant","unpleasant"), label = "European/African Americans + Pleasant/Unpleasant (2)"),
    race_nosek        = list(valid = if (capitalize) c("Pleasant","Unpleasant") else c("pleasant","unpleasant"), label = "European/African Americans + Pleasant/Unpleasant (3)"),
    career_family     = list(valid = if (capitalize) c("Career","Family")       else c("career","family"),       label = "Men/Women + Career/Family"),
    math_arts         = list(valid = if (capitalize) c("Math","Arts")           else c("math","arts"),           label = "Men/Women + Mathematics/Arts"),
    science_arts      = list(valid = if (capitalize) c("Science","Arts")        else c("science","arts"),        label = "Men/Women + Science/Arts"),
    mental_physical   = list(valid = if (capitalize) c("Temporary","Permanent") else c("temporary","permanent"), label = "Mental/Physical Diseases + Temporary/Permanent"),
    young_old         = list(valid = if (capitalize) c("Pleasant","Unpleasant") else c("pleasant","unpleasant"), label = "Young/Old People + Pleasant/Unpleasant")
  )

  purrr::map_dfr(names(files), function(fname) {
    path <- file.path(base, model_dir, paste0(fname, ".csv"))
    df <- read.csv(path)
    df %>%
      mutate(
        refusal   = !attribute %in% files[[fname]]$valid,
        IAT       = files[[fname]]$label,
        condition = as.character(condition),
        condition = case_when(
          condition %in% c("Stereotype-Consistent",   "Association Compatible")   ~ "Association Compatible",
          condition %in% c("Stereotype-Inconsistent",  "Association Incompatible") ~ "Association Incompatible",
          TRUE ~ condition
        )
      ) %>%
      select(refusal, IAT, condition)
  })
}

o3mini    <- load_model("o3-mini/o3-mini",           capitalize = TRUE)  %>% mutate(model = "o3-mini")
deepseek  <- load_model("DeepSeek-R1/DeepSeek-R1",   capitalize = TRUE)  %>% mutate(model = "DeepSeek-R1")
claude    <- load_model("Claude3.7/Claude3.7",        capitalize = TRUE)  %>% mutate(model = "Claude 3.7 Sonnet")
gpt20b    <- load_model("gpt-oss-20b/gpt-oss-20b",   capitalize = FALSE) %>% mutate(model = "gpt-oss-20b")
qwen      <- load_model("Qwen3-8B/Qwen3-8B",         capitalize = FALSE) %>% mutate(model = "Qwen-3 8B")

all_data <- bind_rows(o3mini, deepseek, claude, gpt20b, qwen)

iat_levels <- c(
  "Flowers/Insects + Pleasant/Unpleasant",
  "Instruments/Weapons + Pleasant/Unpleasant",
  "European/African Americans + Pleasant/Unpleasant (1)",
  "European/African Americans + Pleasant/Unpleasant (2)",
  "European/African Americans + Pleasant/Unpleasant (3)",
  "Men/Women + Career/Family",
  "Men/Women + Mathematics/Arts",
  "Men/Women + Science/Arts",
  "Mental/Physical Diseases + Temporary/Permanent",
  "Young/Old People + Pleasant/Unpleasant"
)

model_levels <- c("o3-mini", "DeepSeek-R1", "Claude 3.7 Sonnet", "gpt-oss-20b", "Qwen-3 8B")

result <- all_data %>%
  mutate(IAT = factor(IAT, levels = iat_levels),
         model = factor(model, levels = model_levels)) %>%
  group_by(IAT, model, condition) %>%
  summarise(refusals = sum(refusal)) %>%
  ungroup() %>%
  pivot_wider(names_from = c(model, condition), values_from = refusals, values_fill = list(refusals = 0)) %>%
  arrange(IAT)

print(result, n = Inf, width = Inf)
