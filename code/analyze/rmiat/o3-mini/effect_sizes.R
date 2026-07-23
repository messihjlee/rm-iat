
## Messi H.J. Lee
# 

## Script date: 

# Install and/or load packages -------------------------------------------------

library(tidyverse)
library(effsize)

# Import Data ------------------------------------------------------------------

flowers_insects = read.csv('../../../../data/rmiat/o3-mini/flowers_insects.csv') %>% 
  filter(attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition), 
         IAT = "Flowers/Insects +\nPleasant/Unpleasant")

instruments_weapons = read.csv('../../../../data/rmiat/o3-mini/instruments_weapons.csv') %>% 
  filter(attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition), 
         IAT = "Instruments/Weapons +\nPleasant/Unpleasant")

race_original = read.csv('../../../../data/rmiat/o3-mini/race_original.csv') %>% 
  filter(attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (1)")

race_bertrand = read.csv('../../../../data/rmiat/o3-mini/race_bertrand.csv') %>%  
  filter(attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (2)")

race_nosek = read.csv('../../../../data/rmiat/o3-mini/race_nosek.csv') %>%  
  filter(attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (3)")

career_family = read.csv('../../../../data/rmiat/o3-mini/career_family.csv') %>% 
  filter(attribute %in% c('Career', 'Family')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Men/Women +\nCareer/Family")

math_arts = read.csv('../../../../data/rmiat/o3-mini/math_arts.csv') %>% 
  filter(attribute %in% c('Math', 'Arts')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Men/Women +\nMathematics/Arts")

science_arts = read.csv('../../../../data/rmiat/o3-mini/science_arts.csv') %>% 
  filter(attribute %in% c('Science', 'Arts')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Men/Women +\nScience/Arts")

mental_physical = read.csv('../../../../data/rmiat/o3-mini/mental_physical.csv') %>% 
  filter(attribute %in% c('Temporary', 'Permanent')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Mental/Physical Diseases +\nTemporary/Permanent")

young_old = read.csv('../../../../data/rmiat/o3-mini/young_old.csv') %>%  
  filter(attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Young/Old People +\nPleasant/Unpleasant")

# Effect sizes -----------------------------------------------------------------

cohen.d(flowers_insects %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        flowers_insects %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))

cohen.d(instruments_weapons %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        instruments_weapons %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))

cohen.d(race_original %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        race_original %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))

cohen.d(race_bertrand %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        race_bertrand %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))

cohen.d(race_nosek %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        race_nosek %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))

cohen.d(career_family %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        career_family %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))

cohen.d(math_arts %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        math_arts %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))

cohen.d(science_arts %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        science_arts %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))

cohen.d(mental_physical %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        mental_physical %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))

cohen.d(young_old %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        young_old %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))

# Import Data (with refusals) --------------------------------------------------

flowers_insects = read.csv('../../../../data/rmiat/o3-mini/flowers_insects.csv') %>% 
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition), 
         IAT = "Flowers/Insects +\nPleasant/Unpleasant")

instruments_weapons = read.csv('../../../../data/rmiat/o3-mini/instruments_weapons.csv') %>% 
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition), 
         IAT = "Instruments/Weapons +\nPleasant/Unpleasant")

race_original = read.csv('../../../../data/rmiat/o3-mini/race_original.csv') %>% 
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (1)")

race_bertrand = read.csv('../../../../data/rmiat/o3-mini/race_bertrand.csv') %>%  
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (2)")

race_nosek = read.csv('../../../../data/rmiat/o3-mini/race_nosek.csv') %>%  
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (3)")

career_family = read.csv('../../../../data/rmiat/o3-mini/career_family.csv') %>% 
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Men/Women +\nCareer/Family")

math_arts = read.csv('../../../../data/rmiat/o3-mini/math_arts.csv') %>% 
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Men/Women +\nMathematics/Arts")

science_arts = read.csv('../../../../data/rmiat/o3-mini/science_arts.csv') %>% 
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Men/Women +\nScience/Arts")

mental_physical = read.csv('../../../../data/rmiat/o3-mini/mental_physical.csv') %>% 
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Mental/Physical Diseases +\nTemporary/Permanent")

young_old = read.csv('../../../../data/rmiat/o3-mini/young_old.csv') %>%  
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Young/Old People +\nPleasant/Unpleasant")

# Effect sizes (with refusals) -------------------------------------------------

cohen.d(flowers_insects %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        flowers_insects %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))

cohen.d(instruments_weapons %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        instruments_weapons %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))

cohen.d(race_original %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        race_original %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))

cohen.d(race_bertrand %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        race_bertrand %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))

cohen.d(race_nosek %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        race_nosek %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))

cohen.d(career_family %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        career_family %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))

cohen.d(math_arts %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        math_arts %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))

cohen.d(science_arts %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        science_arts %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))

cohen.d(mental_physical %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        mental_physical %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))

cohen.d(young_old %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens),
        young_old %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens))


