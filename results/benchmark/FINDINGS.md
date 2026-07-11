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

## Path B — MarkDuplicates on downsampled real data
PERCENT_DUPLICATION = 0.095% (near-zero, comparable to simulated data).

NOT because NA12878 lacks PCR duplicates — because the data acquisition
destroyed detectable duplicate structure:
- Started from GIAB's 300x aligned BAM, streamed chr20, downsampled with `-s 0.1`.
- Downsampling independently drops each read, so both copies of a duplicate
  pair surviving has probability ~0.1 x 0.1 = ~1%. Duplicate pairs are shattered.
- Result: MarkDuplicates correctly finds ~no duplicates in the DOWNSAMPLED subset.

Lesson: real-data metrics are contingent on upstream provenance. A duplication
rate reflects the processing history of the reads, not just the biology.
Reading 0.095% as "NA12878 has no duplicates" would be wrong — the correct
reading is "no detectable duplicates survive 10% downsampling."
