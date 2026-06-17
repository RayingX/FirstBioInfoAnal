# 第一步：安装必要的包
# 如果还没装这两个包，先运行这两行（只运行一次）
if (!require("readr")) install.packages("readr")
if (!require("openxlsx")) install.packages("openxlsx")

library(readr)
library(openxlsx)
# 老版本保证可以下载，十分安全！

# 第二步：读取TCGA数据
# 1. 读取表达矩阵
# 注意：路径要和你截图里的文件夹结构一致
tcga_exp <- read_tsv("raw/TCGA_expression.tsv.gz", show_col_types = FALSE)

# 2. 读取临床信息
tcga_cli <- read_tsv("raw/TCGA_clinical.tsv.gz", show_col_types = FALSE)

# --- 简单的数据检查 ---
cat("TCGA 表达矩阵维度:", dim(tcga_exp), "\n") # 应该是 基因数 x 样本数
cat("TCGA 临床信息维度:", dim(tcga_cli), "\n")
head(tcga_cli[, 1:5]) # 看一眼前几列，确认有没有 OS.time, OS.status 等

# 第三步：读取CGGA数据
# 1. 读取表达矩阵
cgga_exp <- read.xlsx("raw/CGGA_expression.xlsx", sheet = 1)

# 2. 读取临床信息
cgga_cli <- read.xlsx("raw/CGGA_clinical.xlsx", sheet = 1)

# --- 简单的数据检查 ---
cat("CGGA 表达矩阵维度:", dim(cgga_exp), "\n")
cat("CGGA 临床信息维度:", dim(cgga_cli), "\n")

# 第四步：数据标准化+合并
# 1. 统一基因名为大写 (防止大小写不匹配)
rownames(tcga_exp) <- toupper(tcga_exp$gene_name) # 假设第一列叫 gene_name，如果不是请看 head(tcga_exp)
tcga_exp$gene_name <- NULL # 删掉第一列，只留数字

rownames(cgga_exp) <- toupper(cgga_exp$Gene) # CGGA 第一列通常叫 Gene
cgga_exp$Gene <- NULL

# 2. 取交集基因 (只保留两个数据集都有的基因)
common_genes <- intersect(rownames(tcga_exp), rownames(cgga_exp))
tcga_exp_clean <- tcga_exp[common_genes, ]
cgga_exp_clean <- cgga_exp[common_genes, ]

cat("最终用于分析的基因数量:", length(common_genes), "\n")

# 3. 保存处理好的数据 (方便下次直接用，不用重新读)
save(tcga_exp_clean, tcga_cli, cgga_exp_clean, cgga_cli, file = "data/processed_data.RData")
cat("数据处理完成！已保存。")
