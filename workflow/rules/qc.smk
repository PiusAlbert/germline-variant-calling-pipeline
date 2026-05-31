rule fastqc_raw:
    input:
        r1="data/NA12878_sim.bwa.read1.fastq.gz",
        r2="data/NA12878_sim.bwa.read2.fastq.gz",
    output:
        html_r1="results/qc/fastqc_raw/NA12878_sim.bwa.read1_fastqc.html",
        zip_r1="results/qc/fastqc_raw/NA12878_sim.bwa.read1_fastqc.zip",
        html_r2="results/qc/fastqc_raw/NA12878_sim.bwa.read2_fastqc.html",
        zip_r2="results/qc/fastqc_raw/NA12878_sim.bwa.read2_fastqc.zip",
    params:
        outdir="results/qc/fastqc_raw",
    log:
        "logs/fastqc_raw.log",
    threads: 2
    shell:
        "fastqc -t {threads} -o {params.outdir} {input.r1} {input.r2} > {log} 2>&1"


rule multiqc:
    input:
        "results/qc/fastqc_raw/NA12878_sim.bwa.read1_fastqc.zip",
        "results/qc/fastqc_raw/NA12878_sim.bwa.read2_fastqc.zip",
    output:
        html="results/qc/multiqc/multiqc_report.html",
    params:
        indir="results/qc/fastqc_raw",
        outdir="results/qc/multiqc",
        name="multiqc_report",
    log:
        "logs/multiqc.log",
    shell:
        "multiqc {params.indir} -o {params.outdir} -n {params.name} --force > {log} 2>&1"
