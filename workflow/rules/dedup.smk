rule mark_duplicates:
    input:
        bam=f"results/aligned/{SAMPLE}.sorted.bam",
        bai=f"results/aligned/{SAMPLE}.sorted.bam.bai",
    output:
        bam=f"results/dedup/{SAMPLE}.dedup.bam",
        bai=f"results/dedup/{SAMPLE}.dedup.bam.bai",
        metrics=f"results/dedup/{SAMPLE}.dedup.metrics.txt",
    log:
        f"logs/mark_duplicates.{SAMPLE}.log",
    shell:
        "gatk MarkDuplicates "
        "-I {input.bam} "
        "-O {output.bam} "
        "-M {output.metrics} "
        "--CREATE_INDEX true "
        "> {log} 2>&1 && "
        f"mv results/dedup/{SAMPLE}.dedup.bai {{output.bai}}"
