# 1. 安装必要的包
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("TCGAbiolinks")

# 2. 加载包
library(TCGAbiolinks)

# 3. 定义查询 (根据论文，主要关注 IDH-mutant astrocytoma，对应 TCGA 里的 LGG 项目)
# 注意：TCGA-GBM 里也有一部分 IDH-mutant，但 LGG 是主要来源
query <- GDCquery(
  project = "TCGA-LGG", 
  data.category = "Transcriptome Profiling",
  data.type = "Gene Expression Quantification",
  workflow.type = "HTSeq - Counts" # 论文里通常用 Counts 做差异分析
)

# 4. 下载数据 (这一步比较慢，取决于网速，大概几个G)
GDCdownload(query)

# 5. 准备数据 (解压缩并整理成 R 能用的对象)
data <- GDCprepare(query)

# 6. 保存下来，以后直接用
save(data, file = "data/raw/TCGA_LGG_HTSeq.RData")
