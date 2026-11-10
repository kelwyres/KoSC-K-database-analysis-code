
#!/bin/bash

# input file of K locus protein seqs (multi fasta format) here called kosc_k.faa

mmseqs createdb kosc_k.faa DB
fake_pref DB DB allvsallpref
mmseqs align DB DB allvsallpref allvsallaln -a
mmseqs convertalis DB DB allvsallaln allvsall.tsv