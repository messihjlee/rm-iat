
## Anonymous
# 

## Script date: 

# Install and/or load packages -------------------------------------------------

library(tidyverse)

# Import Data ------------------------------------------------------------------

flowers_insects = read.csv('../../../../data/rmiat/DeepSeek-R1/flowers_insects.csv') %>% 
  filter(attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition), 
         IAT = "Flowers/Insects +\nPleasant/Unpleasant")

instruments_weapons = read.csv('../../../../data/rmiat/DeepSeek-R1/instruments_weapons.csv') %>% 
  filter(attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition), 
         IAT = "Instruments/Weapons +\nPleasant/Unpleasant")

race_original = read.csv('../../../../data/rmiat/DeepSeek-R1/race_original.csv') %>% 
  filter(attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (1)")

race_bertrand = read.csv('../../../../data/rmiat/DeepSeek-R1/race_bertrand.csv') %>%  
  filter(attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (2)")

race_nosek = read.csv('../../../../data/rmiat/DeepSeek-R1/race_nosek.csv') %>%  
  filter(attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (3)")

career_family = read.csv('../../../../data/rmiat/DeepSeek-R1/career_family.csv') %>% 
  filter(attribute %in% c('Career', 'Family')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Men/Women +\nCareer/Family")

math_arts = read.csv('../../../../data/rmiat/DeepSeek-R1/math_arts.csv') %>% 
  filter(attribute %in% c('Math', 'Arts')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Men/Women +\nMathematics/Arts")

science_arts = read.csv('../../../../data/rmiat/DeepSeek-R1/science_arts.csv') %>% 
  filter(attribute %in% c('Science', 'Arts')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Men/Women +\nScience/Arts")

mental_physical = read.csv('../../../../data/rmiat/DeepSeek-R1/mental_physical.csv') %>% 
  filter(attribute %in% c('Temporary', 'Permanent')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Mental/Physical Diseases +\nTemporary/Permanent")

young_old = read.csv('../../../../data/rmiat/DeepSeek-R1/young_old.csv') %>%  
  filter(attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Young/Old People +\nPleasant/Unpleasant")

rbind(flowers_insects, instruments_weapons, race_original, 
                race_bertrand, race_nosek, career_family, math_arts,
                science_arts, mental_physical, young_old) %>% 
  mutate(IAT = as.factor(IAT)) %>% 
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
  )) %>%
  mutate(iat = str_detect(thought, 'IAT')) %>%
  filter(iat) %>%
  nrow()

