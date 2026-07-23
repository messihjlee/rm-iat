
## Messi H.J. Lee
# 

## Script date: 

# Install and/or load packages -------------------------------------------------

library(tidyverse)
library(lmerTest)
library(lme4)
library(afex)
library(effsize)

# Import Data ------------------------------------------------------------------

flowers_insects = read.csv('../../../../data/rmiat/Claude3.7/flowers_insects.csv') %>% 
  filter(attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition), 
         IAT = "Flowers/Insects +\nPleasant/Unpleasant")

instruments_weapons = read.csv('../../../../data/rmiat/Claude3.7/instruments_weapons.csv') %>% 
  filter(attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition), 
         IAT = "Instruments/Weapons +\nPleasant/Unpleasant")

race_original = read.csv('../../../../data/rmiat/Claude3.7/race_original.csv') %>% 
  filter(attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (1)")

race_bertrand = read.csv('../../../../data/rmiat/Claude3.7/race_bertrand.csv') %>%  
  filter(attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (2)")

race_nosek = read.csv('../../../../data/rmiat/Claude3.7/race_nosek.csv') %>%  
  filter(attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "European/African Americans +\nPleasant/Unpleasant (3)")

career_family = read.csv('../../../../data/rmiat/Claude3.7/career_family.csv') %>% 
  filter(attribute %in% c('Career', 'Family')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Men/Women +\nCareer/Family")

math_arts = read.csv('../../../../data/rmiat/Claude3.7/math_arts.csv') %>% 
  filter(attribute %in% c('Math', 'Arts')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Men/Women +\nMathematics/Arts")

science_arts = read.csv('../../../../data/rmiat/Claude3.7/science_arts.csv') %>% 
  filter(attribute %in% c('Science', 'Arts')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Men/Women +\nScience/Arts")

mental_physical = read.csv('../../../../data/rmiat/Claude3.7/mental_physical.csv') %>% 
  filter(attribute %in% c('Temporary', 'Permanent')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Mental/Physical Diseases +\nTemporary/Permanent")

young_old = read.csv('../../../../data/rmiat/Claude3.7/young_old.csv') %>%  
  filter(attribute %in% c('Pleasant', 'Unpleasant')) %>%
  mutate(prompt = as.factor(prompt),
         condition = as.factor(condition),
         IAT = "Young/Old People +\nPleasant/Unpleasant")

# Mixed-Effects Models ---------------------------------------------------------

flowers_insects_model <- lmer(tokens ~ condition + (1|prompt), data = flowers_insects)
summary(flowers_insects_model)
as.data.frame(VarCorr(flowers_insects_model))
logLik(flowers_insects_model)

instruments_weapons_model <- lmer(tokens ~ condition + (1|prompt), data = instruments_weapons)
summary(instruments_weapons_model)
as.data.frame(VarCorr(instruments_weapons_model))
logLik(instruments_weapons_model)

race_original_model <- lmer(tokens ~ condition + (1|prompt), data = race_original)
summary(race_original_model)
as.data.frame(VarCorr(race_original_model))
logLik(race_original_model)

race_bertrand_model <- lmer(tokens ~ condition + (1|prompt), data = race_bertrand)
summary(race_bertrand_model)
as.data.frame(VarCorr(race_bertrand_model))
logLik(race_bertrand_model)

race_nosek_model <- lmer(tokens ~ condition + (1|prompt), data = race_nosek)
summary(race_nosek_model)
as.data.frame(VarCorr(race_nosek_model))
logLik(race_nosek_model)

career_family_model <- lmer(tokens ~ condition + (1|prompt), data = career_family)
summary(career_family_model)
as.data.frame(VarCorr(career_family_model))
logLik(career_family_model)

math_arts_model <- lmer(tokens ~ condition + (1|prompt), data = math_arts)
summary(math_arts_model)
as.data.frame(VarCorr(math_arts_model))
logLik(math_arts_model)

science_arts_model <- lmer(tokens ~ condition + (1|prompt), data = science_arts)
summary(science_arts_model)
as.data.frame(VarCorr(science_arts_model))
logLik(science_arts_model)

mental_physical_model <- lmer(tokens ~ condition + (1|prompt), data = mental_physical)
summary(mental_physical_model)
as.data.frame(VarCorr(mental_physical_model))
logLik(mental_physical_model)

young_old_model <- lmer(tokens ~ condition + (1|prompt), data = young_old)
summary(young_old_model)
as.data.frame(VarCorr(young_old_model))
logLik(young_old_model)

