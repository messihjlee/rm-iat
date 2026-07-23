## Sensitivity Analysis: Monte Carlo Simulation for o3-mini 64-token grouping
## This script simulates 1,000 versions of the data to test result stability.

library(tidyverse)
library(effsize)

set.seed(42) # For reproducibility

# Helper Function: Simulate 'true' values within the 64-token bins
# If tokens = 128, it picks a random number between 65 and 128.
simulate_tokens <- function(tokens) {
  runif(length(tokens), min = tokens - 63, max = tokens)
}

# Master Function: Run Simulation and Calculate Effect Size Distribution
run_rm_iat_sim <- function(filepath, attr_filter, n_sims = 1000) {
  # Load and filter data
  df <- read.csv(filepath) %>% 
    filter(attribute %in% attr_filter)
  
  # Run simulations
  sim_estimates <- replicate(n_sims, {
    df_sim <- df %>% mutate(tokens_sim = simulate_tokens(tokens))
    
    d_result <- cohen.d(
      df_sim %>% filter(condition == 'Stereotype-Inconsistent') %>% pull(tokens_sim),
      df_sim %>% filter(condition == 'Stereotype-Consistent') %>% pull(tokens_sim)
    )
    return(d_result$estimate)
  })
  
  # Calculate Median and 95% Simulation Interval
  stats <- quantile(sim_estimates, probs = c(0.025, 0.5, 0.975))
  return(stats)
}

# Run Simulations for all 10 RM-IATs -------------------------------------------

cat("Starting Monte Carlo Sensitivity Analysis (1,000 iterations per test)...\n")

# 1. Flowers/Insects
res1 <- run_rm_iat_sim('../../../../data/rmiat/o3-mini/flowers_insects.csv', c('Pleasant', 'Unpleasant'))
print("1. Flowers/Insects:"); print(res1)

# 2. Instruments/Weapons
res2 <- run_rm_iat_sim('../../../../data/rmiat/o3-mini/instruments_weapons.csv', c('Pleasant', 'Unpleasant'))
print("2. Instruments/Weapons:"); print(res2)

# 3. Race Original
res3 <- run_rm_iat_sim('../../../../data/rmiat/o3-mini/race_original.csv', c('Pleasant', 'Unpleasant'))
print("3. Race (1):"); print(res3)

# 4. Race Bertrand
res4 <- run_rm_iat_sim('../../../../data/rmiat/o3-mini/race_bertrand.csv', c('Pleasant', 'Unpleasant'))
print("4. Race (2):"); print(res4)

# 5. Race Nosek
res5 <- run_rm_iat_sim('../../../../data/rmiat/o3-mini/race_nosek.csv', c('Pleasant', 'Unpleasant'))
print("5. Race (3):"); print(res5)

# 6. Career/Family
res6 <- run_rm_iat_sim('../../../../data/rmiat/o3-mini/career_family.csv', c('Career', 'Family'))
print("6. Career/Family:"); print(res6)

# 7. Math/Arts
res7 <- run_rm_iat_sim('../../../../data/rmiat/o3-mini/math_arts.csv', c('Math', 'Arts'))
print("7. Math/Arts:"); print(res7)

# 8. Science/Arts
res8 <- run_rm_iat_sim('../../../../data/rmiat/o3-mini/science_arts.csv', c('Science', 'Arts'))
print("8. Science/Arts:"); print(res8)

# 9. Mental/Physical
res9 <- run_rm_iat_sim('../../../../data/rmiat/o3-mini/mental_physical.csv', c('Temporary', 'Permanent'))
print("9. Mental/Physical:"); print(res9)

# 10. Young/Old
res10 <- run_rm_iat_sim('../../../../data/rmiat/o3-mini/young_old.csv', c('Pleasant', 'Unpleasant'))
print("10. Young/Old:"); print(res10)