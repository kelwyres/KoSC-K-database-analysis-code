
Python script: 
(1) Requires flanking genes (galF/ugd for KL and ugd/hisI for OL)

(2) Default blastn coverage and identity of 90% - can be changed when running the script (see below)

(3) Will only extract loci if both flanking genes meet the ID/cov theresholds AND are on one contig

(4) blastn hit summary will be written to summary.txt (in working directory) - can be used to guide coverage and ID thresholds for future runs 

get_locus.py
```
import os

import sys

import subprocess

from optparse import OptionParser

from Bio.Blast import NCBIXML

from Bio import SeqIO

  

def main():

usage = "usage: %prog [options]"

parser = OptionParser(usage=usage)

parser.add_option("-l", "--left", dest="leftflank", help="left flanking seq (e.g., ugd.fasta)", default="")

parser.add_option("-r", "--right", dest="rightflank", help="right flanking seq (e.g., hisI.fasta)", default="")

parser.add_option("-i", "--id", dest="id", help="% identity cutoff (default: 90)", default="90")

parser.add_option("-c", "--coverage", dest="coverage", help="% coverage cutoff (default: 90)", default="90")

parser.add_option("-o", "--output", dest="output", help="summary output file", default="summary.txt")

parser.add_option("-d", "--database", dest="database", help="capsular locus DB (optional)", default="")

parser.add_option("-n", "--name", dest="name", help="output tag (default: cps)", default="cps")

return parser.parse_args()

  

def run_blast(contig_file, query):

query_path, query_file = os.path.split(query)

if not os.path.exists(contig_file + ".nin"):

subprocess.run(["makeblastdb", "-in", contig_file, "-dbtype", "nucl", "-out", contig_file], check=True)

blast_out = contig_file + "_blast_" + query_file + ".xml"

subprocess.run(["blastn", "-query", query, "-db", contig_file, "-out", blast_out, "-outfmt", "5", "-task", "blastn"], check=True)

with open(blast_out) as result_handle:

blast_record = NCBIXML.read(result_handle)

return blast_record, blast_out

  

def get_blast_hit(blast_record, cov, identity, query_len):

for alignment in blast_record.alignments:

contig = alignment.title.split(' ')[1]

contig_len = alignment.length

for hsp in alignment.hsps:

aln_cov = float(hsp.align_length) / query_len * 100

aln_id = float(hsp.identities) / hsp.align_length * 100

if aln_cov > cov and aln_id > identity:

if hsp.sbjct_start <= hsp.sbjct_end:

flank_start = max(1, hsp.sbjct_start - (hsp.query_start - 1))

flank_end = min(contig_len, hsp.sbjct_end + (query_len - hsp.query_end))

else:

flank_start = min(contig_len, hsp.sbjct_start + (hsp.query_start - 1))

flank_end = max(1, hsp.sbjct_end - (query_len - hsp.query_end))

return contig, flank_start, flank_end, contig_len, aln_cov, aln_id

return None

  

def extract_sequence(contig_file, contig_id, start, end, reverse=False):

for record in SeqIO.parse(contig_file, "fasta"):

if record.id == contig_id:

subseq = record.seq[start-1:end]

if reverse:

subseq = subseq.reverse_complement()

record.id = f"{record.id}_{start}_{end}"

record.description = ""

record.seq = subseq

return record

return None

  

if __name__ == "__main__":

options, args = main()

cov = float(options.coverage)

identity = float(options.id)

  

with open(options.output, "w") as summary:

header = [

"file", "leftflank_contig", "leftflank_start", "leftflank_stop",

"rightflank_contig", "rightflank_start", "rightflank_stop", "output_fasta"

]

summary.write("\t".join(header) + "\n")

  

for contig_file in args:

base_name = os.path.basename(contig_file)

accession = os.path.splitext(base_name)[0]

  

left_blast, left_xml = run_blast(contig_file, options.leftflank)

left_len = left_blast.query_letters

left_hit = get_blast_hit(left_blast, cov, identity, left_len)

os.remove(left_xml)

  

right_blast, right_xml = run_blast(contig_file, options.rightflank)

right_len = right_blast.query_letters

right_hit = get_blast_hit(right_blast, cov, identity, right_len)

os.remove(right_xml)

  

if left_hit and right_hit and left_hit[0] == right_hit[0]:

contig = left_hit[0]

start = min(left_hit[1], left_hit[2], right_hit[1], right_hit[2])

end = max(left_hit[1], left_hit[2], right_hit[1], right_hit[2])

reverse = left_hit[1] > left_hit[2]

  

record = extract_sequence(contig_file, contig, start, end, reverse)

if record:

output_fasta = f"{accession}_{contig}_{options.name}.fasta"

SeqIO.write(record, output_fasta, "fasta")

  

summary.write("\t".join([

contig_file, contig, str(left_hit[1]), str(left_hit[2]),

contig, str(right_hit[1]), str(right_hit[2]),

output_fasta

]) + "\n")

else:

summary.write("\t".join([

contig_file, *(["NA"] * 6), "sequence_not_found"

]) + "\n")

else:

summary.write("\t".join([

contig_file, *(["NA"] * 6), "no_dual_hit"

]) + "\n")
```

To run script and extract loci on all .fasta files in current directory:

```
python3 get_loci.py -l galF.fasta -r ugd.fasta -i 80 -c 80 *.fasta
```

galF and ugd sequences used were taken from the *K. oxytoca sensu stricto* type strain - Genbank accession - GCA_900636985.1 [
](https://www.ncbi.nlm.nih.gov/nuccore/1539902381)


galF & ugd locus tags 

```
2282479..2283327
                     /gene="galF"
                     /locus_tag="NCTC13727_02169"

2305406..2306572
                     /gene="ugd"
                     /locus_tag="NCTC13727_02187"
```

galF:
https://www.ncbi.nlm.nih.gov/nuccore/LR134333.1?from=2282479&to=2283327&report=fasta 

ugd:
https://www.ncbi.nlm.nih.gov/nuccore/LR134333.1?from=2305406&to=2306572&report=fasta

