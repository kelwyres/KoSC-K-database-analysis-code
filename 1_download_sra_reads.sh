while read -r line; do
python enaBrowserTools/python3/enaDataGet.py -f fastq "$line"
done < sra_accession.txt
