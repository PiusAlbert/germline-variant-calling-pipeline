INTERVALS = ["0000", "0001", "0002", "0003"]


rule haplotype_caller_scatter:
    input:
        bam="results/bqsr/NA12878_sim.recal.bam",
        bai="results/bqsr/NA12878_sim.recal.bam.bai",
        ref="resources/reference.fasta",
        intervals="resources/intervals/{interval}-scattered.interval_list",
    output:
        vcf="results/called/scatter/NA12878_sim.{interval}.vcf.gz",
        tbi="results/called/scatter/NA12878_sim.{interval}.vcf.gz.tbi",
    params:
        ploidy=config["ploidy"],
    log:
        "logs/haplotype_caller.{interval}.log",
    threads: 1
    resources:
        mem_mb=2500
    shell:
        "gatk --java-options '-Xmx2g' HaplotypeCaller "
        "-I {input.bam} "
        "-R {input.ref} "
        "-L {input.intervals} "
        "-O {output.vcf} "
        "--sample-ploidy {params.ploidy} "
        "--native-pair-hmm-threads 1 "
        "> {log} 2>&1"


rule gather_vcfs:
    input:
        vcfs=expand("results/called/scatter/NA12878_sim.{interval}.vcf.gz", interval=INTERVALS),
        tbis=expand("results/called/scatter/NA12878_sim.{interval}.vcf.gz.tbi", interval=INTERVALS),
    output:
        vcf="results/called/NA12878_sim.raw.vcf.gz",
        tbi="results/called/NA12878_sim.raw.vcf.gz.tbi",
    log:
        "logs/gather_vcfs.log",
    shell:
        "gatk MergeVcfs "
        "$(for v in {input.vcfs}; do echo -n \"-I $v \"; done) "
        "-O {output.vcf} "
        "> {log} 2>&1"
