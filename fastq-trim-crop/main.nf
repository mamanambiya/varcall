#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Define processes using DSL2 syntax
// process log_tool_version_multiqc {
//     tag { "${params.project_name}.ltVM" }
//     echo true
//     publishDir "${params.out_dir}/", mode: 'copy', overwrite: false
//     label 'gatk'

//     output:
//     path("tool.multiqc.version")

//     script:
//     """
//     multiqc --version > tool.multiqc.version
//     """
// }

process run_trimmomatic {
    tag { "${params.project_name}.${sample_id}.rT" }
    publishDir "${params.out_dir}/${sample_id}", mode: 'copy', overwrite: false
    cpus { "${params.trimmomatic_threads}" }
    label 'trimmomatic'

    input:
        tuple val(sample_id), path(fastq_r1_file), path(fastq_r2_file)

    output:
        path("*.gz")
        // file("${sample_id}_trim_out.log")
    
    script:
        """
        trimmomatic \
            PE -phred33 \
            -threads ${params.trimmomatic_threads} \
            ${fastq_r1_file} \
            ${fastq_r2_file} \
            ${sample_id}_R1.gz \
            ${sample_id}_R1_unpaired.gz \
            ${sample_id}_R2.gz \
            ${sample_id}_R2_unpaired.gz \
            CROP:${params.crop} 2> ${sample_id}_trim_out.log
        """
}

// process run_multiqc {
//     tag { "${params.project_name}.rMqc" }
//     publishDir "${params.out_dir}/", mode: 'copy', overwrite: false
//     label 'multiqc'

//     input:
//     file('*')

//     output:
//     file('multiqc_report.html') 

//     script:
//     """
//     multiqc .
//     """
// }

// Define the workflow
workflow {

    // Get sample info from sample sheet
    samples = Channel.fromPath( file(params.sample_sheet) )
            .splitCsv(header: true, sep: '\t')
            .map{row ->
                def sample_id = row['SampleID']
                def fastq_r1_file = file(row['FastqR1'])
                def fastq_r2_file = file(row['FastqR2'])
                return [ sample_id, fastq_r1_file, fastq_r2_file ]
            }
            
    run_trimmomatic(samples)
    // trimmomatic_trim_files.collect() | run_multiqc
}

// workflow.onComplete {
//     println ( workflow.success ? """
//         Pipeline execution summary
//         ---------------------------
//         Completed at: ${workflow.complete}
//         Duration    : ${workflow.duration}
//         Success     : ${workflow.success}
//         workDir     : ${workflow.workDir}
//         exit status : ${workflow.exitStatus}
//         """ : """
//         Failed: ${workflow.errorReport}
//         exit status : ${workflow.exitStatus}
//         """
//     )
// }