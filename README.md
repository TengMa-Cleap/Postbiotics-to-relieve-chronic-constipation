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
galah cluster --ani 95 --min-aligned-fraction 30 --output-cluster-definition all_bins_80_5.cls.tsv -t 32 --genome-fasta-list all_bins_80_5.path
less -S all_bins_80_5.cls.tsv | perl -a -F"\t" -lne '@F[0]=~/.*\/(.*?).fa/; $o1=$1; @F[1]=~/.*\/(.*?).fa/; $o2=$1; print "$o1\t$o2" ' | sort -k1 | perl -a -F"\t" -lne 'BEGIN{$n=""; $c=0}; if(@F[0] ne $n){ $c++; $n=@F[0]}; $o="SGB.".$c; print "$_\t$o" ' | csvtk join -t -T -H -f"2;1" - 0.4_all_80_5_bins/all_80_5_bins_cm.s | perl -a -F"\t" -lne '$score=@F[4]-5*@F[5]; print "$_\t$score" ' |  sort -t $'\t' -k1,1 -k9,9nr -k7,7nr | perl -a -F"\t" -lne 'BEGIN{$n="";}; if(@F[0] ne $n){$o="Rep_genome"; $n=@F[0]}else{$o="Member"}; print "$_\t$o" ' > all_bins_80_5.cls.rep
grep Rep all_bins_80_5.cls.rep | cut -f2,3 | perl -lane 'print "cp -d /ddnstor/imau_sunzhihong/imau_liyl/Autism/Healthy_child/0.4_all_80_5_bins/bins_80_5/@F[0].fa rep_genome/@F[1].fa" ' | rush {} -j 5

5：For relative abundance:
Bin_abundance.sh -s first_sample.list.s -r /ddnstor/imau_sunzhihong/userdata/data_mat/meta_item/diarrhea/0.5_all_SGBs/rep_genome -o 0.6_all_SGBs_abundance -t 32

6：For species alignment and annotation:
fastANI --ql own_list --refList ref_list.tsv --visualize --matrix -o GTDB_query -t 136 # For ref_list.tsv, you can use the latest published database, such as DTDB database
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




