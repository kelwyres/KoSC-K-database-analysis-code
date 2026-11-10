
Mash v2.3 used throughout

 - Mash was performed using the Assembly De-replicator thresholds (k-mer size; sketch size)
 
 - Mash was only performed on all Final dataset (here called Test_dataset) genomes n=4055; Test_dataset are QC-passed and de-duplicated (1 assembly per Biosample was retained during de-duplication)
 
```
mash sketch \
  -p 16 \
  -k 21 \
  -s 10000 \
  -l Test_dataset_assemblies.txt \
  -o mash_sketch
```

```
mash dist \
  -p 16 \
  mash_sketch.msh \
  mash_sketch.msh \
  > mash_distances.tsv
```

```
awk -F'\t' '
BEGIN {
    OFS=","
    print "Query,Reference,Distance,P_value,Shared_hashes"
}
$1 < $2 {
    print $1,$2,$3,$4,$5
}' mash_distances.tsv > mash_distances.csv

```


R code:
```
library(tidyverse)
library(igraph)
```

```
# Read metadata and keep only the final dataset genomes
metadata <- read.csv(
  "~/Ko_db/S1_final.csv",
  check.names = FALSE
) %>%
  filter(Test_dataset == "yes")
```

```
# Read in the Mash distances and remove .fasta extension
mash <- read.csv(
  "~/Ko_db/Metadata/mash_distances.csv",
  check.names = FALSE
) %>%
  mutate(
    Query = sub("\\.fasta$", "", basename(Query)),
    Reference = sub("\\.fasta$", "", basename(Reference))
  )
```

*note that we only ran Mash on QC pass genomes so don't need to re-filter*

```
# Make a list of all genomes in the final dataset (here called Test_dataset)
assemblies <- metadata$Assembly
```

```
# Keep genome pairs with Mash distance <= 0.003
edges <- mash %>%
  filter(Distance <= 0.003) %>%
  select(Query, Reference)
```

```
# Include all Test_dataset genomes
# Genomes with no match <= 0.003 will stay as singletons
vertices <- tibble(name = assemblies)
```

```
# Make a graph where genomes are joined if their Mash distance is <= 0.003
g <- graph_from_data_frame(
  edges,
  directed = FALSE,
  vertices = vertices
)
```

```
# Find connected groups of genomes
# Each connected group is one Mash cluster
clusters <- components(g)

```


```
# Make a table to assign each Test_dataset genome to its Mash cluster
mash_clusters <- tibble(
  Assembly = names(clusters$membership),
  Mash_cluster = as.integer(clusters$membership)
)
```

```
# Merge Mash cluster w/ metadata
metadata_clustered <- metadata %>%
  left_join(
    mash_clusters,
    by = "Assembly"
  )
```

```
# Count genomes per Mash cluster
metadata_clustered %>%
  count(Mash_cluster, sort = TRUE)

```

```
# Keep one genome per Mash cluster/ST/K/country/year combination
# If there is more than one, keep the assembly with the highest N50
selected <- metadata_clustered %>%
  group_by(
    Mash_cluster,
    ST,
    `Best match K locus`,
    Country,
    Collection_year
  ) %>%
  arrange(desc(N50), Assembly, .by_group = TRUE) %>%
  slice(1) %>%
  ungroup()
```

```
# Note the genomes kept in the de-replicated dataset
metadata_clustered <- metadata_clustered %>%
  mutate(
    Included_in_dereplicated_dataset = if_else(
      Assembly %in% selected$Assembly,
      "yes",
      "no"
    )
  )
```

```
# Check how many genomes were kept /removed
table(metadata_clustered$Included_in_dereplicated_dataset)

# Save the final metadata 
write.csv(
  metadata_clustered,
  "~/Ko_db/Metadata/ST_K_Country_Year_mash0.003.csv",
  row.names = FALSE
)

```

```
# Summarise 
cluster_sizes <- metadata_clustered %>% count(Mash_cluster)

tibble(Summary=c("Test_dataset","Mash clusters","Singleton Mash clusters","Genomes in non-singleton clusters","De-replicated dataset"),
       n=c(nrow(metadata_clustered), nrow(cluster_sizes), sum(cluster_sizes$n==1), sum(cluster_sizes$n[cluster_sizes$n>1]), nrow(selected)))

```

| Summary                           |     n |
| --------------------------------- | ----: |
| Test_dataset                      | 4,055 |
| Mash clusters                     | 1,074 |
| Singleton Mash clusters           |   638 |
| Genomes in non-singleton clusters | 3,417 |
| De-replicated dataset             | 2,244 |
