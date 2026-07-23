
## Messi H.J. Lee
# 

## Script date: 

# Install and/or load packages -------------------------------------------------

library(tidyverse)
library(effsize)

# Import Data ------------------------------------------------------------------

flowers_insects = read.csv('../../../../data/rmiat/Qwen3-8B/flowers_insects.csv') %>% 
  filter(attribute %in% c('pleasant', 'unpleasant')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition), 
         IAT = "Flowers/Insects +\nPleasant/Unpleasant")

instruments_weapons = read.csv('../../../../data/rmiat/Qwen3-8B/instruments_weapons.csv') %>% 
  filter(attribute %in% c('pleasant', 'unpleasant')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition), 
         IAT = "Instruments/Weapons +\nPleasant/Unpleasant")

race_original = read.csv('../../../../data/rmiat/Qwen3-8B/race_original.csv') %>% 
  filter(attribute %in% c('pleasant', 'unpleasant')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (1)")

race_bertrand = read.csv('../../../../data/rmiat/Qwen3-8B/race_bertrand.csv') %>%  
  filter(attribute %in% c('pleasant', 'unpleasant')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (2)")

race_nosek = read.csv('../../../../data/rmiat/Qwen3-8B/race_nosek.csv') %>%  
  filter(attribute %in% c('pleasant', 'unpleasant')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (3)")

career_family = read.csv('../../../../data/rmiat/Qwen3-8B/career_family.csv') %>% 
  filter(attribute %in% c('career', 'family')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "Men/Women +\nCareer/Family")

math_arts = read.csv('../../../../data/rmiat/Qwen3-8B/math_arts.csv') %>% 
  filter(attribute %in% c('math', 'arts')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "Men/Women +\nMathematics/Arts")

science_arts = read.csv('../../../../data/rmiat/Qwen3-8B/science_arts.csv') %>% 
  filter(attribute %in% c('science', 'arts')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "Men/Women +\nScience/Arts")

mental_physical = read.csv('../../../../data/rmiat/Qwen3-8B/mental_physical.csv') %>% 
  filter(attribute %in% c('temporary', 'permanent')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "Mental/Physical Diseases +\nTemporary/Permanent")

young_old = read.csv('../../../../data/rmiat/Qwen3-8B/young_old.csv') %>%  
  filter(attribute %in% c('pleasant', 'unpleasant')) %>%
  mutate(prompt_id = as.factor(prompt_id),
         condition = as.factor(condition),
         IAT = "Young/Old People +\nPleasant/Unpleasant")

# Effect sizes -----------------------------------------------------------------

cohen.d(flowers_insects %>% filter(condition == 'Association Incompatible') %>% pull(tokens),
        flowers_insects %>% filter(condition == 'Association Compatible') %>% pull(tokens))

cohen.d(instruments_weapons %>% filter(condition == 'Association Incompatible') %>% pull(tokens),
        instruments_weapons %>% filter(condition == 'Association Compatible') %>% pull(tokens))

cohen.d(race_original %>% filter(condition == 'Association Incompatible') %>% pull(tokens),
        race_original %>% filter(condition == 'Association Compatible') %>% pull(tokens))

cohen.d(race_bertrand %>% filter(condition == 'Association Incompatible') %>% pull(tokens),
        race_bertrand %>% filter(condition == 'Association Compatible') %>% pull(tokens))

cohen.d(race_nosek %>% filter(condition == 'Association Incompatible') %>% pull(tokens),
        race_nosek %>% filter(condition == 'Association Compatible') %>% pull(tokens))

cohen.d(career_family %>% filter(condition == 'Association Incompatible') %>% pull(tokens),
        career_family %>% filter(condition == 'Association Compatible') %>% pull(tokens))

cohen.d(math_arts %>% filter(condition == 'Association Incompatible') %>% pull(tokens),
        math_arts %>% filter(condition == 'Association Compatible') %>% pull(tokens))

cohen.d(science_arts %>% filter(condition == 'Association Incompatible') %>% pull(tokens),
        science_arts %>% filter(condition == 'Association Compatible') %>% pull(tokens))

cohen.d(mental_physical %>% filter(condition == 'Association Incompatible') %>% pull(tokens),
        mental_physical %>% filter(condition == 'Association Compatible') %>% pull(tokens))

cohen.d(young_old %>% filter(condition == 'Association Incompatible') %>% pull(tokens),
        young_old %>% filter(condition == 'Association Compatible') %>% pull(tokens))

