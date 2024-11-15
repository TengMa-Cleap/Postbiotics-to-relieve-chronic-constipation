# Postbiotics-to-relieve-chronic-constipation

Multifaceted Mechanisms Underlying the Efficacy of a Postbiotic and its Components in Promoting Colonic Transit and Alleviating Chronic Constipation in Humans and Mice

Metagenomic analysis pipeline (Bacteriome and phageome)

1：For quality control and de_hosting：

klab_metaqc qc -s data.list -t human -j 10 -o qc_result_folder_rmhuman -f # klab_metaqc is a simple process combining the above two tools

2：For assembling：

ls -d *| parallel -j 5 megahit -m 0.5 --min-contig-len 200 -t 10 --out-dir {}_Output_ass --out-prefix {} -1 {}/{}.rmhost.r1.fq.gz -2 {}/{}.rmhost.r2.fq.gz ::: * # parallel code

3：For genome Binning:

Bin_as_binning.sh -s cons_sample.list.s -o 0.3_all_bins/0.3.1_bin_results 

4：For genome de_replicate:

dRep compare drep.out -p 140 -pa 0.9 -sa 0.95 -nc 0.3 --S_algorithm fastANI -g bins_80_5/* less drep_out/data_tables/Cdb.csv | sed 's/.fa//g' | sed -e 's/,/\t/g' | csvtk join -t -T -H - all_80_5_bins_cm.s | perl -a -F"\t" -lne '$sc=@F[10]-5*@F[11]; $n50=@F[17]; $gs=@F[13]; print "@F[0]\t@F[1]\t$sc\t$n50\t$gs" ' | sort -k2,2 -k3,3nr -k4,4nr -k5,5nr | perl -lane 'if(@F[1] ne $n){print $_; $n=@F[1]}' > 0.4.3_SGB.info cat 0.4.3_SGB.info | awk -F "\t" {'print $1'} > all_SGBs_names; cat all_SGBs_names | parallel -j 50 cp bins_80_5/{}.fa ../0.5_all_SGBs/0.5.1_all_SGBs

5：For relative abundance:

Bin_abundance.sh -s first_sample.list.s -r /ddnstor/imau_sunzhihong/userdata/data_mat/meta_item/diarrhea/0.5_all_SGBs/rep_genome -o 0.6_all_SGBs_abundance -t 32

6：For species alignment and annotation:

Bin_get_gtdb_annotation.sh -l own_list -o new # For ref_list.tsv, you can use the latest published database, such as DTDB database

7：For Bacteriophage identification:

ls -d ../01_filtered_renamed_assembly/*fa | parallel --plus --dryrun VIBRANT_run.py -i ../01_filtered_renamed_assembly/{/} -t 10 | parallel -j 6 {} # VIBRANT

ls -d *fa | rush --dry-run 'checkv end_to_end -d /mnt1/database/Checkv_db/checkv-db-v1.0 {} {..}.checkv -t 10' | rush -j 10 {} # checkv

tree -if 0.2_VIBRANT | grep phages_combined.fna | parallel -j 10 cat {} > 0.2_VIBRANT.fna

tree -if 0.3_checkv | grep -w viruses.fna | parallel cat {} > 0.3_checkv.fna

tree -if 0.3_checkv | grep -w proviruses.fna | parallel cat {} > 0.3_checkv_pro.fna

grep '>' 0.3_checkv_pro.fna | perl -lane '$=~/>(.*)(\d+) \d+/; print "$1$2\t$1"' > 0.3_checkv_pro.name

less -S 0.2_VIBRANT.summ | perl -lane 'if(@F[0]=~/(.*)fragment/){$o=$1}else{$o=@F[0]}; print "$\t$o"' > 0.2_VIBRANT.summ.s1

csvtk join -t -T -H 0.3_checkv.summ.cut 0.2_VIBRANT.summ.s1 -f"1;4" -k | perl -lane 'print $_ if ! @F[3] ' | csvtk join -t -T -H - 0.3_checkv_pro.name -f"1;2" -k | perl -a -F"\t" -lne 'if(@F[5]){print @F[5]}else{print @F[0]}' > 0.3_checkv.summ.cut.ext.list

csvtk join -t -T -H 0.3_checkv.summ.cut 0.2_VIBRANT.summ.s1 -f"1;4" -k | perl -lane 'print $_ if ! @F[3] ' | csvtk join -t -T -H - 0.3_checkv_pro.name -f"1;2" -k | perl -a -F"\t" -lne 'if(@F[5]){print @F[5]}else{print @F[0]}' > 0.3_checkv.summ.cut.ext.list

cat 0.3_checkv.fna 0.3_checkv_pro.fna > 0.3_checkv.all.fna

18_select_target_seq_fast.py 0.3_checkv.all.fna 0.3_checkv.summ.cut.ext.list 0.3_checkv.slect.fna

cat 0.3_checkv.slect.fna 0.2_VIBRANT.fna > all.vir.fna

18_select_target_length_seq.py all.vir.fna all.vir.5K.fna 5000

nucl_cluster.sh -i all.vir.fna -o vir_cluster.out

amino_acid_identity.py --in_faa cluster_out/all_phage.faa --in_blast cluster_out/blastp.tsv --out_tsv ./aai.tsv

cat Sample.list | parallel --dry-run 'bwa-mem2 mem cluster.fasta clean_data/{}/{}.clean.r1.fq.gz clean_data/{}/{}.clean.r1.fq.gz | samtools view -bS - -@ 5 | samtools sort -@ 5 - -o all_sample.results/{}.sort.bam' | parallel -j 3 {}

ls -d all_sample.results/*bam | parallel --plus --dryrun 'coverm contig --bam-files {} -t 10 --min-read-percent-identity 0.95 --min-covered-fraction 40 -m mean rpkm covered_bases > all_prophage_abundance/{/..}.coverm' | parallel -j 10 {}




