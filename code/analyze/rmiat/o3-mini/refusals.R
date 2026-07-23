## Anonymous
# 
## Script date: 

# Install and/or load packages -------------------------------------------------

library(tidyverse)

# Import Data ------------------------------------------------------------------

flowers_insects = read.csv('../../../../data/rmiat/o3-mini/flowers_insects.csv') %>% 
  mutate(refusal = !attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition), 
         IAT = "Flowers/Insects +\nPleasant/Unpleasant")

instruments_weapons = read.csv('../../../../data/rmiat/o3-mini/instruments_weapons.csv') %>% 
  mutate(refusal = !attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition), 
         IAT = "Instruments/Weapons +\nPleasant/Unpleasant")

race_original = read.csv('../../../../data/rmiat/o3-mini/race_original.csv') %>% 
  mutate(refusal = !attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (1)")

race_bertrand = read.csv('../../../../data/rmiat/o3-mini/race_bertrand.csv') %>%  
  mutate(refusal = !attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (2)")

race_nosek = read.csv('../../../../data/rmiat/o3-mini/race_nosek.csv') %>%  
  mutate(refusal = !attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (3)")

career_family = read.csv('../../../../data/rmiat/o3-mini/career_family.csv') %>% 
  mutate(refusal = !attribute %in% c('Career', 'Family')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Men/Women +\nCareer/Family")

math_arts = read.csv('../../../../data/rmiat/o3-mini/math_arts.csv') %>% 
  mutate(refusal = !attribute %in% c('Math', 'Arts')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Men/Women +\nMathematics/Arts")

science_arts = read.csv('../../../../data/rmiat/o3-mini/science_arts.csv') %>% 
  mutate(refusal = !attribute %in% c('Science', 'Arts')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Men/Women +\nScience/Arts")

mental_physical = read.csv('../../../../data/rmiat/o3-mini/mental_physical.csv') %>% 
  mutate(refusal = !attribute %in% c('Temporary', 'Permanent')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Mental/Physical Diseases +\nTemporary/Permanent")

young_old = read.csv('../../../../data/rmiat/o3-mini/young_old.csv') %>%  
  mutate(refusal = !attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Young/Old People +\nPleasant/Unpleasant")

o3mini = rbind(flowers_insects, instruments_weapons, race_original, 
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
  mutate(condition = as.factor(condition))

# Compare number of refusals by RM-IAT -----------------------------------------

o3mini %>% 
  group_by(IAT) %>% 
  summarise(refusal_by_IAT = sum(refusal))

# Compare token counts between refusal and non-refusal -------------------------

t.test(o3mini %>% filter(refusal) %>% pull(tokens),
       o3mini %>% filter(!refusal) %>% pull(tokens)) # simple comparison

# Compare number of refusals by condition --------------------------------------

o3mini %>% 
  filter(refusal) %>% 
  count(condition) %>% 
  mutate(pct = n / sum(n) * 100)

