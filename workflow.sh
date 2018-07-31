Rscript scripts/table_and_experiment.R

Rscript scripts/class1_pep_in_experiment_heatmap.R

Rscript scripts/class2_psite_in_experiment_heatmap.R

Rscript scripts/class1-3_genes.R

Rscript scripts/class1_genes_in_experiment_barplot.R

Rscript scripts/class1_genes_GO.R

Rscript scripts/class1_genes_GO_heatmap.R

Rscript scripts/class1_genes_GO_Excel.R


# protein descrition and sequence #
module add fastxtoolkit/0.0.13
wget -c ftp://ftp.arabidopsis.org/home/tair/Proteins/TAIR10_protein_lists/TAIR10_pep_20101214
cat TAIR10_pep_20101214|fasta_formatter -t|sed 's/ | /\t/g'|cut -f1-3,5|sed 's/Symbols: //'|sed 's/>//'|sort|uniq > TAIR10_pep_desc_seq.tsv

# combine supp. tables #
module add bedtools/2.25.0
Rscript scripts/combine_supp_tables.R
./scripts/format_table.py|sort -k2,2 -k4,4n -k7,7 -k8,8|uniq|groupBy -g 1-8 -c 9 -o sum > tables/combine_supp_tables_reformat.tsv

## protein domain
wget -c ftp://ftp.arabidopsis.org/home/tair/Proteins/Domains/TAIR10_all.domains
wget -c ftp://ftp.arabidopsis.org/home/tair/Proteins/Domains/README -o TAIR10_all.domains_README
cat TAIR10_pep_20101214|grep '>'|sed -r 's/ \| /\t/g'|sed 's/>//'|sed 's/LENGTH=/\t/'|cut -f1,3,5|awk -F "\t" '{print "CHAIN\t"$2"\t1\t"$3"\t"$3"\t"$1"\t"$1"\t3702\t1"}' > tables/domains.tsv
cat TAIR10_all.domains|grep 'HMMPfam'|cut -f1,3,6,7,8|awk '{print "DOMAIN\t"$3"\t"$4"\t"$5"\t"$5-$4+1"\t"$1"\t"$1"\t3702\t1"}' >> tables/domains.tsv

cd Rplumber/
./run_image_daemon.sh
cd -

./run_Shiny_daemon.sh

