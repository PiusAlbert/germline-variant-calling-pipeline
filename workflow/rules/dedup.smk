rule mark_duplicates:
    input:
        bam="results/aligned/NA12878_sim.sorted.bam",
        bai="results/aligned/NA12878_sim.sorted.bam.bai",
    output:
        bam="results/dedup/NA12878_sim.dedup.bam",
        bai="results/dedup/NA12878_sim.dedup.bam.bai",
        metrics="results/dedup/NA12878_sim.dedup.metrics.txt",
    log:
        "logs/mark_duplicates.log",
    shell:
        "gatk MarkDuplicates "
        "-I {input.bam} "
        "-O {output.bam} "
        "-M {output.metrics} "
        "--CREATE_INDEX true "
        "> {log} 2>&1 && "
        "mv results/dedup/NA12878_sim.dedup.bai {output.bai}"
