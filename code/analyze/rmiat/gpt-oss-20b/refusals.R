## Anonymous
# 
## Script date: 
# Install and/or load packages -------------------------------------------------

library(tidyverse)

# Function to calculate refusals -----------------------------------------------

calculate_refusals <- function(df_name, filter_attributes) {
  df_full <- get(df_name)
  df_filtered <- df_full %>% filter(attribute %in% filter_attributes)
  refusals <- nrow(df_full) - nrow(df_filtered)
  return(data.frame(
    dataset = df_name,
    total_rows = nrow(df_full),
    filtered_rows = nrow(df_filtered),
    refusals = refusals,
    refusal_rate = round(refusals / nrow(df_full) * 100, 2)
  ))
}

# Import Data ------------------------------------------------------------------

flowers_insects_raw = read.csv('../../../../data/rmiat/gpt-oss-20b/flowers_insects.csv')
flowers_insects = flowers_insects_raw %>% 
  filter(attribute %in% c('pleasant', 'unpleasant')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition), 
         IAT = "Flowers/Insects +\nPleasant/Unpleasant")

instruments_weapons_raw = read.csv('../../../../data/rmiat/gpt-oss-20b/instruments_weapons.csv')
instruments_weapons = instruments_weapons_raw %>% 
  filter(attribute %in% c('pleasant', 'unpleasant')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition), 
         IAT = "Instruments/Weapons +\nPleasant/Unpleasant")

race_original_raw = read.csv('../../../../data/rmiat/gpt-oss-20b/race_original.csv')
race_original = race_original_raw %>% 
  filter(attribute %in% c('pleasant', 'unpleasant')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (1)")

race_bertrand_raw = read.csv('../../../../data/rmiat/gpt-oss-20b/race_bertrand.csv')
race_bertrand = race_bertrand_raw %>%  
  filter(attribute %in% c('pleasant', 'unpleasant')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (2)")

race_nosek_raw = read.csv('../../../../data/rmiat/gpt-oss-20b/race_nosek.csv')
race_nosek = race_nosek_raw %>%  
  filter(attribute %in% c('pleasant', 'unpleasant')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (3)")

career_family_raw = read.csv('../../../../data/rmiat/gpt-oss-20b/career_family.csv')
career_family = career_family_raw %>% 
  filter(attribute %in% c('career', 'family')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "Men/Women +\nCareer/Family")

math_arts_raw = read.csv('../../../../data/rmiat/gpt-oss-20b/math_arts.csv')
math_arts = math_arts_raw %>% 
  filter(attribute %in% c('math', 'arts')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "Men/Women +\nMathematics/Arts")

science_arts_raw = read.csv('../../../../data/rmiat/gpt-oss-20b/science_arts.csv')
science_arts = science_arts_raw %>% 
  filter(attribute %in% c('science', 'arts')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "Men/Women +\nScience/Arts")

mental_physical_raw = read.csv('../../../../data/rmiat/gpt-oss-20b/mental_physical.csv')
mental_physical = mental_physical_raw %>% 
  filter(attribute %in% c('temporary', 'permanent')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "Mental/Physical Diseases +\nTemporary/Permanent")

young_old_raw = read.csv('../../../../data/rmiat/gpt-oss-20b/young_old.csv')
young_old = young_old_raw %>%  
  filter(attribute %in% c('pleasant', 'unpleasant')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "Young/Old People +\nPleasant/Unpleasant")

# Calculate refusals for each dataset ------------------------------------------

refusal_summary <- rbind(
  calculate_refusals("flowers_insects_raw", c('pleasant', 'unpleasant')),
  calculate_refusals("instruments_weapons_raw", c('pleasant', 'unpleasant')),
  calculate_refusals("race_original_raw", c('pleasant', 'unpleasant')),
  calculate_refusals("race_bertrand_raw", c('pleasant', 'unpleasant')),
  calculate_refusals("race_nosek_raw", c('pleasant', 'unpleasant')),
  calculate_refusals("career_family_raw", c('career', 'family')),
  calculate_refusals("math_arts_raw", c('math', 'arts')),
  calculate_refusals("science_arts_raw", c('science', 'arts')),
  calculate_refusals("mental_physical_raw", c('temporary', 'permanent')),
  calculate_refusals("young_old_raw", c('pleasant', 'unpleasant'))
)

# Display refusal summary
print("Refusal Summary:")
print(refusal_summary)

# Create a more readable summary with IAT names
refusal_summary_readable <- refusal_summary %>%
  mutate(IAT_Name = case_when(
    dataset == "flowers_insects_raw" ~ "Flowers/Insects + Pleasant/Unpleasant",
    dataset == "instruments_weapons_raw" ~ "Instruments/Weapons + Pleasant/Unpleasant", 
    dataset == "race_original_raw" ~ "European/African Americans + Pleasant/Unpleasant (1)",
    dataset == "race_bertrand_raw" ~ "European/African Americans + Pleasant/Unpleasant (2)",
    dataset == "race_nosek_raw" ~ "European/African Americans + Pleasant/Unpleasant (3)",
    dataset == "career_family_raw" ~ "Men/Women + Career/Family",
    dataset == "math_arts_raw" ~ "Men/Women + Mathematics/Arts",
    dataset == "science_arts_raw" ~ "Men/Women + Science/Arts", 
    dataset == "mental_physical_raw" ~ "Mental/Physical Diseases + Temporary/Permanent",
    dataset == "young_old_raw" ~ "Young/Old People + Pleasant/Unpleasant"
  )) %>%
  select(IAT_Name, total_rows, filtered_rows, refusals, refusal_rate)

print("\nReadable Refusal Summary:")
print(refusal_summary_readable)
