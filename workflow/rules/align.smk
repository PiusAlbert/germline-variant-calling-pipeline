rule bwa_map:
    input:
        ref="resources/reference.fasta",
        idx=multiext("resources/reference.fasta", ".amb", ".ann", ".bwt", ".pac", ".sa"),
        r1="data/NA12878_sim.bwa.read1.fastq.gz",
        r2="data/NA12878_sim.bwa.read2.fastq.gz",
    output:
        bam="results/aligned/NA12878_sim.sorted.bam",
        bai="results/aligned/NA12878_sim.sorted.bam.bai",
    params:
        rg=r"@RG\tID:NA12878_sim\tSM:NA12878\tPL:ILLUMINA\tLB:lib1\tPU:unit1",
    log:
        "logs/bwa_map.log",
    threads: config["threads"]
    shell:
        "(bwa mem -t {threads} -R '{params.rg}' {input.ref} {input.r1} {input.r2} "
        "| samtools sort -@ {threads} -o {output.bam} -) 2> {log} && "
        "samtools index {output.bam}"
