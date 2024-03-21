genedetector
--------------------------

For a given gene, how strongly is it expressed in a given cell type? Can I quantify this? How does the expression of a given gene compare across cell types?

Examples when this is useful to know:
- you have a list of candidate genes changing expression levels between conditions (like in my case different sleep states) and want to know whether they are actually expressed in the cell type in which it was detected to change in, i.e. checking for false positives
- comparing the number of genes expressed (above certain threshold) between different cell types
- comparing the expression of a gene in a cell type with morphological expression of a gene (e.g. by fluorescent in situ hybridization)
  
This repo contains the jupyter notebook with the code to address this question.

There are in total 9995 genes and 106762 individual cells detected in our [single cell RNA-seq dataset](https://www.nature.com/articles/s41593-023-01549-4). 
