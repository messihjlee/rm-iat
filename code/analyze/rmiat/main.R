# Main script to run all analyses sequentially

## 1) Summary output of mixed-effects models
## Reproduces Table S6 - S10 of the Supplementary Materials.

### o3-mini
setwd("~/capsule/code/analyze/rmiat/o3-mini")
source("mixed.R", echo = TRUE)

### DeepSeek-R1
setwd("~/capsule/code/analyze/rmiat/DeepSeek-R1")
source("mixed.R", echo = TRUE)

### Claude3.7
setwd("~/capsule/code/analyze/rmiat/Claude3.7")
source("mixed.R", echo = TRUE)

### gpt-oss-20b
setwd("~/capsule/code/analyze/rmiat/gpt-oss-20b")
source("mixed.R", echo = TRUE)

### Qwen3-8B
setwd("~/capsule/code/analyze/rmiat/Qwen3-8B")
source("mixed.R", echo = TRUE)

## 2) Effect Sizes
## Reproduces Table S3

### o3-mini
setwd("~/capsule/code/analyze/rmiat/o3-mini")
source("effect_sizes.R", echo = TRUE)

### DeepSeek-R1
setwd("~/capsule/code/analyze/rmiat/DeepSeek-R1")
source("effect_sizes.R", echo = TRUE)

### Claude3.7
setwd("~/capsule/code/analyze/rmiat/Claude3.7")
source("effect_sizes.R", echo = TRUE)

### gpt-oss-20b
setwd("~/capsule/code/analyze/rmiat/gpt-oss-20b")
source("effect_sizes.R", echo = TRUE)

### Qwen3-8B
setwd("~/capsule/code/analyze/rmiat/Qwen3-8B")
source("effect_sizes.R", echo = TRUE)

## 3) Number of refusals
## Reproduces Table S4

### o3-mini
setwd("~/capsule/code/analyze/rmiat/o3-mini")
source("refusals.R", echo = TRUE)

### DeepSeek-R1
setwd("~/capsule/code/analyze/rmiat/DeepSeek-R1")
source("refusals.R", echo = TRUE)

### Claude3.7
setwd("~/capsule/code/analyze/rmiat/Claude3.7")
source("refusals.R", echo = TRUE)

### gpt-oss-20b
setwd("~/capsule/code/analyze/rmiat/gpt-oss-20b")
source("refusals.R", echo = TRUE)

### Qwen3-8B
setwd("~/capsule/code/analyze/rmiat/Qwen3-8B")
source("refusals.R", echo = TRUE)

## 4) Descriptive Statistics
## Reproduces Table S5

### o3-mini
setwd("~/capsule/code/analyze/rmiat/o3-mini")
source("descriptive.R", echo = TRUE)

### DeepSeek-R1
setwd("~/capsule/code/analyze/rmiat/DeepSeek-R1")
source("descriptive.R", echo = TRUE)

### Claude3.7
setwd("~/capsule/code/analyze/rmiat/Claude3.7")
source("descriptive.R", echo = TRUE)

### gpt-oss-20b
setwd("~/capsule/code/analyze/rmiat/gpt-oss-20b")
source("descriptive.R", echo = TRUE)

### Qwen3-8B
setwd("~/capsule/code/analyze/rmiat/Qwen3-8B")
source("descriptive.R", echo = TRUE)

## 5) Visualization 
## Reproduces Figure 2 and 3

setwd("~/capsule/code/analyze/viz")
source("visualize.R", echo = TRUE)
source("visualize_refusals.R", echo = TRUE)

## 6) Mentioning of "IAT"
## Reproduces analysis in Section 3.1 and Table S11

### o3-mini is not included as reasoning tokens for o3-mini were unavailable.

### DeepSeek-R1
setwd("~/capsule/code/analyze/rmiat/DeepSeek-R1")
source("iat.R", echo = TRUE)

### Claude3.7
setwd("~/capsule/code/analyze/rmiat/Claude3.7")
source("iat.R", echo = TRUE)

### gpt-oss-20b
setwd("~/capsule/code/analyze/rmiat/gpt-oss-20b")
source("iat.R", echo = TRUE)

### Qwen3-8B
setwd("~/capsule/code/analyze/rmiat/Qwen3-8B")
source("iat.R", echo = TRUE)

## 7) Structural Topic Model (STM)
## Reproduces analysis in Section S1
setwd("~/capsule/code/analyze/stm")
source("stm.R", echo = TRUE)
source("topic3.R", echo = TRUE)

## 8) Supplementary Analaysis
## Reproduces sensitivity analysis in Section S2
setwd("~/capsule/code/analyze/rmiat/o3-mini")
source("sensitivity_analysis.R", echo = TRUE)

## 9) Downstream Analysis (WAT & RDT)
## Reproduces convergent validity results in the last section of the Supplementary Materials

setwd("~/capsule/code/analyze/downstream")
source("analyze_validity.R",   echo = TRUE)
source("describe_downstream.R", echo = TRUE)

## Complete
print("Run Complete")

