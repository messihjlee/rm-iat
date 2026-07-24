## Messi H.J. Lee
# 

## Script date: 2026-02-21

# Install and/or load packages -------------------------------------------------
if(!require("tidyverse")){install.packages("tidyverse", dependencies = TRUE); require("tidyverse")}
if(!require("ggsci")){install.packages("ggsci", dependencies = TRUE); require("ggsci")}
if(!require("Cairo")){install.packages("Cairo", dependencies = TRUE); require("Cairo")}

# Helper function to load and tag IAT data without pre-filtering attributes ----
load_iat_data <- function(path, model_name) {
  # Define the files and their corresponding IAT labels
  files <- list(
    "flowers_insects.csv" = "Flowers/Insects +\nPleasant/Unpleasant",
    "instruments_weapons.csv" = "Instruments/Weapons +\nPleasant/Unpleasant",
    "race_original.csv" = "European/African Americans +\nPleasant/Unpleasant (1)",
    "race_bertrand.csv" = "European/African Americans +\nPleasant/Unpleasant (2)",
    "race_nosek.csv" = "European/African Americans +\nPleasant/Unpleasant (3)",
    "career_family.csv" = "Men/Women +\nCareer/Family",
    "math_arts.csv" = "Men/Women +\nMathematics/Arts",
    "science_arts.csv" = "Men/Women +\nScience/Arts",
    "mental_physical.csv" = "Mental/Physical Diseases +\nTemporary/Permanent",
    "young_old.csv" = "Young/Old People +\nPleasant/Unpleasant"
  )
  
  combined_df <- data.frame()
  
  for (f in names(files)) {
    full_path <- paste0(path, f)
    if (file.exists(full_path)) {
      temp_df <- read.csv(full_path) %>%
        mutate(IAT = files[[f]], model = model_name)
      
      # Standardize column names (handling prompt vs prompt_id)
      if ("prompt_id" %in% colnames(temp_df)) {
        temp_df <- temp_df %>% rename(prompt = prompt_id)
      }
      
      combined_df <- rbind(combined_df, temp_df %>% select(condition, attribute, tokens, IAT, model))
    }
  }
  return(combined_df)
}

# Import and Process Data ------------------------------------------------------

# We load raw data for all models to ensure refusals are NOT filtered out
o3mini      = load_iat_data('../../../data/rmiat/o3-mini/', "o3-mini")
claude      = load_iat_data('../../../data/rmiat/Claude3.7/', "Claude 3.7 Sonnet")
deepseek_r1 = load_iat_data('../../../data/rmiat/DeepSeek-R1/', "DeepSeek-R1")
gpt20b      = load_iat_data('../../../data/rmiat/gpt-oss-20b/', "gpt-oss-20b")
qwen3       = load_iat_data('../../../data/rmiat/Qwen3-8B/', "Qwen3-8B")

all_IATs = rbind(o3mini, claude, deepseek_r1, gpt20b, qwen3) %>% 
  mutate(condition = case_when(
    condition == "Stereotype-Consistent" ~ "Association Compatible",
    condition == "Stereotype-Inconsistent" ~ "Association Incompatible",
    TRUE ~ condition
  ))

# Calculate Refusals (exact match, mirroring each model's own refusals.R) ------
# gpt-oss-20b and Qwen3-8B were prompted/parsed with lowercase category labels;
# all other models use Title Case. Matching is case-sensitive and untrimmed to
# stay consistent with rmiat/{model}/refusals.R, which produces Table S3.

lower_case_models <- c("gpt-oss-20b", "Qwen3-8B")

get_allowed_attributes <- function(iat) {
  if (grepl("Pleasant/Unpleasant", iat)) return(c("Pleasant", "Unpleasant"))
  if (iat == "Men/Women +\nCareer/Family") return(c("Career", "Family"))
  if (iat == "Men/Women +\nMathematics/Arts") return(c("Math", "Arts"))
  if (iat == "Men/Women +\nScience/Arts") return(c("Science", "Arts"))
  if (iat == "Mental/Physical Diseases +\nTemporary/Permanent") return(c("Temporary", "Permanent"))
  stop("Unrecognized IAT: ", iat)
}

refusal_data <- all_IATs %>%
  mutate(refusal = mapply(function(attr, iat, mdl) {
    allowed <- get_allowed_attributes(iat)
    if (mdl %in% lower_case_models) allowed <- tolower(allowed)
    !(attr %in% allowed)
  }, attribute, IAT, model)) %>%
  group_by(model, IAT, condition) %>%
  summarise(
    refusal_pct = (sum(refusal) / n()) * 100,
    .groups = 'drop'
  )

# Drop IATs where the total refusal rate across all models/conditions is 0 ------

iats_with_refusals <- refusal_data %>%
  group_by(IAT) %>%
  summarise(total_refusal_sum = sum(refusal_pct), .groups = 'drop') %>%
  filter(total_refusal_sum > 0) %>%
  pull(IAT)

refusal_filtered <- refusal_data %>%
  filter(IAT %in% iats_with_refusals)

# Set factor levels for remaining data -----------------------------------------

refusal_filtered = refusal_filtered %>% 
  mutate(model = factor(model, levels = c('o3-mini', 'DeepSeek-R1', 'Claude 3.7 Sonnet', 
                                          'gpt-oss-20b', 'Qwen3-8B'))) %>%
  mutate(IAT = factor(IAT, levels = c("Flowers/Insects +\nPleasant/Unpleasant", 
                                      "Instruments/Weapons +\nPleasant/Unpleasant",
                                      "European/African Americans +\nPleasant/Unpleasant (1)",
                                      "European/African Americans +\nPleasant/Unpleasant (2)",
                                      "European/African Americans +\nPleasant/Unpleasant (3)",
                                      "Men/Women +\nCareer/Family",
                                      "Men/Women +\nMathematics/Arts",
                                      "Men/Women +\nScience/Arts",
                                      "Mental/Physical Diseases +\nTemporary/Permanent",
                                      "Young/Old People +\nPleasant/Unpleasant"))) %>%
  mutate(IAT = fct_drop(IAT)) # Correct function from the forcats/tidyverse package

# Visualization ----------------------------------------------------------------

# Short axis labels (full RM-IAT names remain in the underlying data/source data;
# only the x-axis display text is abbreviated to prevent label overflow)
short_iat_labels <- c(
  "European/African Americans +\nPleasant/Unpleasant (1)" = "Race(1)",
  "European/African Americans +\nPleasant/Unpleasant (2)" = "Race(2)",
  "European/African Americans +\nPleasant/Unpleasant (3)" = "Race(3)",
  "Men/Women +\nCareer/Family" = "Career/Family",
  "Men/Women +\nMathematics/Arts" = "Math/Arts",
  "Mental/Physical Diseases +\nTemporary/Permanent" = "Mental/Physical"
)

ggplot(refusal_filtered, aes(x = IAT, y = refusal_pct, fill = model)) +
  geom_col(position = position_dodge(width = 0.8),
           width = 0.8,
           color = "black") +
  facet_wrap(~condition, ncol = 2) + # Stacked is usually better for wide IAT labels
  geom_hline(yintercept = 0, color = "gray50") +
  # Use length of unique IATs in the filtered set for separators
  geom_vline(xintercept = seq(1.5, length(unique(refusal_filtered$IAT)) - 0.5, by = 1),
             linetype = "dotted", color = "gray70") +
  scale_x_discrete(labels = short_iat_labels) +
  scale_fill_jama() +
  theme_bw() +
  labs(
    y = "Refusal Rate (%)",
    fill = "Model"
  ) +
  theme(
    legend.position = "top",
    axis.title.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    strip.background = element_rect(fill = "gray95"),
    strip.text = element_text(face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

# Save result
ggsave('../../../results/fig3.pdf', width = 11, height = 6, dpi = 'retina', device = cairo_pdf)
