# Benchmark: raw HaplotypeCaller calls vs dwgsim truth (chr20, NA12878_sim)

## Results (raw, unfiltered)
- True Positives:  60,516
- False Positives:  1,797
- False Negatives:  3,364
- Precision: 97.1%
- Recall:    94.7%
- F1:        95.9%

## Filtering decision: DO NOT FILTER
Investigated standard GATK hard-filter metrics for TP/FP separation:
- QD:   TP median 13.18 vs FP 18.56 (FP higher; distributions overlap fully)
- FS:   both 0 (no strand bias in simulated data)
- DP:   27 vs 28 (no separation)
- AB:   0.57 vs 0.58 (no separation)
- QUAL: TP 350 vs FP 512 (FP higher-confidence)

Conclusion: dwgsim's uniform-random error model produces FPs as
high-confidence, strand-balanced error-stacks. GATK hard-filters target
real-sequencer artifact signatures (strand/mapping/position bias) that are
ABSENT here. No conventional filter improves precision without costing more
recall. Standard best-practice filters are context-dependent, not universal.

## Implication for Path B
On real Illumina reads, FPs will carry genuine artifact signatures and the
GATK hard-filters will separate populations as designed. Filtering becomes
meaningful only with realistic error structure.
