
## Messi H.J. Lee
# 

## Script date: 

# Install and/or load packages -------------------------------------------------

library(tidyverse)

# Import Data ------------------------------------------------------------------

flowers_insects = read.csv('../../../../data/rmiat/gpt-oss-20b/flowers_insects.csv') %>% 
  filter(attribute %in% c('pleasant', 'unpleasant')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition), 
         IAT = "Flowers/Insects +\nPleasant/Unpleasant")

instruments_weapons = read.csv('../../../../data/rmiat/gpt-oss-20b/instruments_weapons.csv') %>% 
  filter(attribute %in% c('pleasant', 'unpleasant')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition), 
         IAT = "Instruments/Weapons +\nPleasant/Unpleasant")

race_original = read.csv('../../../../data/rmiat/gpt-oss-20b/race_original.csv') %>% 
  filter(attribute %in% c('pleasant', 'unpleasant')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (1)")

race_bertrand = read.csv('../../../../data/rmiat/gpt-oss-20b/race_bertrand.csv') %>%  
  filter(attribute %in% c('pleasant', 'unpleasant')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (2)")

race_nosek = read.csv('../../../../data/rmiat/gpt-oss-20b/race_nosek.csv') %>%  
  filter(attribute %in% c('pleasant', 'unpleasant')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (3)")

career_family = read.csv('../../../../data/rmiat/gpt-oss-20b/career_family.csv') %>% 
  filter(attribute %in% c('career', 'family')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "Men/Women +\nCareer/Family")

math_arts = read.csv('../../../../data/rmiat/gpt-oss-20b/math_arts.csv') %>% 
  filter(attribute %in% c('math', 'arts')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "Men/Women +\nMathematics/Arts")

science_arts = read.csv('../../../../data/rmiat/gpt-oss-20b/science_arts.csv') %>% 
  filter(attribute %in% c('science', 'arts')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "Men/Women +\nScience/Arts")

mental_physical = read.csv('../../../../data/rmiat/gpt-oss-20b/mental_physical.csv') %>% 
  filter(attribute %in% c('temporary', 'permanent')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "Mental/Physical Diseases +\nTemporary/Permanent")

young_old = read.csv('../../../../data/rmiat/gpt-oss-20b/young_old.csv') %>%  
  filter(attribute %in% c('pleasant', 'unpleasant')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "Young/Old People +\nPleasant/Unpleasant")

gpt20b = rbind(flowers_insects, instruments_weapons, race_original, 
                race_bertrand, race_nosek, career_family, math_arts,
                science_arts, mental_physical, young_old) %>% 
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
  mutate(condition = case_when(
    condition == "Stereotype-Consistent" ~ "Association-Compatible",
    condition == "Stereotype-Inconsistent" ~ "Association-Incompatible",
    TRUE ~ condition
  ))

# Descriptive Statistics -------------------------------------------------------

gpt20b %>% 
  group_by(IAT, condition) %>% 
  summarise(
    mean_token = sprintf("%.2f", mean(tokens, na.rm = TRUE)),
    sd_token = sprintf("%.2f", sd(tokens, na.rm = TRUE))
  )

