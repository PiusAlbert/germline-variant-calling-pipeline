rule haplotype_caller:
    input:
        bam="results/bqsr/NA12878_sim.recal.bam",
        bai="results/bqsr/NA12878_sim.recal.bam.bai",
        ref="resources/reference.fasta",
    output:
        vcf="results/called/NA12878_sim.raw.vcf.gz",
        tbi="results/called/NA12878_sim.raw.vcf.gz.tbi",
    params:
        ploidy=config["ploidy"],
    log:
        "logs/haplotype_caller.log",
    shell:
        "gatk --java-options '-Xmx8g' HaplotypeCaller "
        "-I {input.bam} "
        "-R {input.ref} "
        "-O {output.vcf} "
        "--sample-ploidy {params.ploidy} "
        "> {log} 2>&1"
