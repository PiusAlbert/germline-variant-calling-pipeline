#!/usr/bin/env Rscript
# Descriptive analysis of a germline VCF: Ti/Tv, substitution spectrum,
# variant density. Reproducible artifact of the interactive exploration.
#
# Usage: Rscript workflow/scripts/analyze_vcf.R <input.vcf.gz> <output_dir>

suppressPackageStartupMessages({
  library(VariantAnnotation)
  library(tidyverse)
})

# --- Args (fall back to project defaults if run bare) ---
args <- commandArgs(trailingOnly = TRUE)
vcf_path <- if (length(args) >= 1) args[1] else "results/called/NA12878_sim.raw.vcf.gz"
out_dir  <- if (length(args) >= 2) args[2] else "results/analysis"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

message("Loading: ", vcf_path)
vcf <- readVcf(vcf_path, genome = "hg38")
message("Loaded ", nrow(vcf), " variants, ", ncol(vcf), " sample(s)")

# --- Ti/Tv + substitution spectrum (SNVs only, alignment-safe) ---
vcf_snv <- vcf[isSNV(vcf)]
ref <- as.character(ref(vcf_snv))
alt <- as.character(unlist(alt(vcf_snv)))
stopifnot(length(ref) == length(alt))          # assert before computing

sub <- paste0(ref, ">", alt)
transitions <- c("A>G", "G>A", "C>T", "T>C")
ti <- sum(sub %in% transitions)
tv <- sum(!(sub %in% transitions))

spectrum <- as.data.frame(table(sub))
names(spectrum) <- c("substitution", "count")
write_csv(spectrum, file.path(out_dir, "substitution_spectrum.csv"))

titv <- tibble(
  transitions = ti,
  transversions = tv,
  ti_tv_ratio = round(ti / tv, 4),
  n_snv = length(ref)
)
write_csv(titv, file.path(out_dir, "titv_summary.csv"))
message("Ti/Tv = ", titv$ti_tv_ratio, " (Ti=", ti, ", Tv=", tv, ")")

# --- Variant density along the chromosome ---
df <- tibble(position = start(rowRanges(vcf)))
p_density <- ggplot(df, aes(x = position / 1e6)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "white") +
  labs(title = "Variant density along chr20",
       subtitle = paste0(nrow(df), " variants, 1 Mb bins"),
       x = "Position (Mb)", y = "Variants per Mb") +
  theme_minimal()
ggsave(file.path(out_dir, "variant_density_chr20.png"),
       p_density, width = 10, height = 4, dpi = 120)

# --- Substitution spectrum barplot ---
p_spec <- ggplot(spectrum, aes(x = substitution, y = count,
                               fill = substitution %in% transitions)) +
  geom_col() +
  scale_fill_manual(values = c("grey60", "firebrick"),
                    labels = c("Transversion", "Transition"),
                    name = NULL) +
  labs(title = "Substitution spectrum",
       subtitle = paste0("Ti/Tv = ", titv$ti_tv_ratio),
       x = NULL, y = "Count") +
  theme_minimal()
ggsave(file.path(out_dir, "substitution_spectrum.png"),
       p_spec, width = 8, height = 4, dpi = 120)

message("Done. Outputs written to ", out_dir)
