rule simulate_reads:
    input:
        ref="resources/reference.fasta",
    output:
        r1="data/NA12878_sim.bwa.read1.fastq.gz",
        r2="data/NA12878_sim.bwa.read2.fastq.gz",
        truth="data/NA12878_sim.mutations.vcf",
    params:
        prefix="data/NA12878_sim",
        cov=30,
        seed=42,
    log:
        "logs/simulate_reads.log",
    threads: 1
    shell:
        "dwgsim -C {params.cov} -1 150 -2 150 "
        "-e 0.005 -E 0.005 -r 0.001 -R 0.15 -z {params.seed} "
        "{input.ref} {params.prefix} > {log} 2>&1"
