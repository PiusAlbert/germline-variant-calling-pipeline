SAMPLE = config["sample"]

rule bwa_map:
    input:
        ref=config["reference"],
        idx=multiext(config["reference"], ".amb", ".ann", ".bwt", ".pac", ".sa"),
        r1=config["reads"]["r1"],
        r2=config["reads"]["r2"],
    output:
        bam=f"results/aligned/{SAMPLE}.sorted.bam",
        bai=f"results/aligned/{SAMPLE}.sorted.bam.bai",
    params:
        rg=r"@RG\tID:{id}\tSM:{sm}\tPL:{pl}\tLB:{lb}\tPU:{pu}".format(
            id=config["readgroup"]["id"],
            sm=config["readgroup"]["sm"],
            pl=config["readgroup"]["pl"],
            lb=config["readgroup"]["lb"],
            pu=config["readgroup"]["pu"],
        ),
    log:
        f"logs/bwa_map.{SAMPLE}.log",
    threads: config["threads"]
    shell:
        "(bwa mem -t {threads} -R '{params.rg}' {input.ref} {input.r1} {input.r2} "
        "| samtools sort -@ {threads} -o {output.bam} -) 2> {log} && "
        "samtools index {output.bam}"
