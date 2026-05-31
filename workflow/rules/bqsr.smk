rule base_recalibrator:
    input:
        bam="results/dedup/NA12878_sim.dedup.bam",
        bai="results/dedup/NA12878_sim.dedup.bam.bai",
        ref="resources/reference.fasta",
        known="resources/sim_truth.chr20.vcf.gz",
        known_idx="resources/sim_truth.chr20.vcf.gz.tbi",
    output:
        table="results/bqsr/NA12878_sim.recal.table",
    log:
        "logs/base_recalibrator.log",
    shell:
        "gatk BaseRecalibrator "
        "-I {input.bam} "
        "-R {input.ref} "
        "--known-sites {input.known} "
        "-O {output.table} "
        "> {log} 2>&1"


rule apply_bqsr:
    input:
        bam="results/dedup/NA12878_sim.dedup.bam",
        bai="results/dedup/NA12878_sim.dedup.bam.bai",
        ref="resources/reference.fasta",
        table="results/bqsr/NA12878_sim.recal.table",
    output:
        bam="results/bqsr/NA12878_sim.recal.bam",
        bai="results/bqsr/NA12878_sim.recal.bam.bai",
    log:
        "logs/apply_bqsr.log",
    shell:
        "gatk ApplyBQSR "
        "-I {input.bam} "
        "-R {input.ref} "
        "--bqsr-recal-file {input.table} "
        "-O {output.bam} "
        "> {log} 2>&1 && "
        "mv results/bqsr/NA12878_sim.recal.bai {output.bai}"
