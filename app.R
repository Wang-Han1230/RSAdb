# 安装必要的包（如果尚未安装）
# install.packages(c("shiny", "htmltools", "htmlwidgets", "base64enc", "Seurat", "tidyverse", "qs", "gridExtra", "ggpubr", "ggplot2", "reshape2", "Nebulosa", "DT"))

# 加载包
library(shiny)
library(htmltools)
library(htmlwidgets)
library(base64enc)
library(Seurat)
library(tidyverse)
library(qs)
library(gridExtra)
library(ggpubr)
library(ggplot2)
library(reshape2)
library(DT)

# 检查并安装Nebulosa包（如果尚未安装）
if (!requireNamespace("Nebulosa", quietly = TRUE)) {
  install.packages("Nebulosa", dependencies = TRUE)
}
library(Nebulosa)

# 定义论文数据
papers_data <- list(
  english = list(
    list(
      title = "USP47 inhibits m6A-dependent c-Myc translation to maintain regulatory T cell metabolic and functional homeostasis",
      authors = "Wang A, Huang H, Shi JH, Yu X, Ding R, Zhang Y, Han Q, Ni ZY*, Li X*, Zhao R*, Zou Q*",
      journal = "Journal of Clinical Investigation",
      year = "2023",
      if_value = "15.90",
      note = "并列通讯作者",
      link = "https://doi.org/10.1172/JCI169365"
    ),
    list(
      title = "MiR-103 protects from recurrent spontaneous abortion via inhibiting STAT1 mediated M1 macrophage polarization",
      authors = "Zhu X, Liu H, Zhang Z, Wei R, Zhou X, Wang Z, Zhao L, Guo Q, Zhang Y, Chu C, Wang L*, Li X*",
      journal = "International Journal of Biological Sciences",
      year = "2020",
      if_value = "10.75",
      note = "通讯作者",
      link = "https://doi.org/10.7150/ijbs.46144"
    ),
    list(
      title = "IL-6 Contributes to Deep Vein Thrombosis and Is Negatively Regulated by miR-338-5p",
      authors = "Zhang Y, Zhang Z, Wei R, Miao X, Sun S, Liang G, Chu C, Zhao L, Zhu X, Guo Q, Wang B*, Li X*",
      journal = "Arteriosclerosis, Thrombosis, and Vascular Biology",
      year = "2020",
      if_value = "10.514",
      note = "通讯作者",
      link = "https://doi.org/10.1161/ATVBAHA.119.313707"
    ),
    list(
      title = "MiR-337-3p suppresses proliferation of epithelial ovarian cancer by targeting PIK3CA and PIK3CB",
      authors = "Zhang Z, Zhang L, Wang B, Wei R, Wang Y, Wan J, Zhang C, Zhao L, Zhu X, Zhang Y, Chu C, Guo Q, Yin X, Li X*",
      journal = "Cancer Letters",
      year = "2020",
      if_value = "9.756",
      note = "通讯作者",
      link = "https://doi.org/10.1016/j.canlet.2019.10.021"
    ),
    list(
      title = "MIR937 amplification potentiates ovarian cancer progression by attenuating FBXO16 inhibition on ULK1-mediated autophagy",
      authors = "Zhang Z, Liu X, Chu C, Zhang Y, Li W, Yu X, Han Q, Sun H, Zhang Y, Zhu X, Chen L, Wei R, Fan N, Zhou M, Li X*",
      journal = "Cell Death & Disease",
      year = "2024",
      if_value = "8.1",
      note = "通讯作者",
      link = "https://doi.org/10.1038/s41419-024-07120-8"
    ),
    list(
      title = "Dendritic cells in pregnancy and pregnancy-associated diseases",
      authors = "Wei R, Lai N, Zhao L, Zhang Z, Zhu X, Guo Q, Chu C, Fu X, Li X*",
      journal = "Biomedicine & Pharmacotherapy",
      year = "2021",
      if_value = "7.419",
      note = "通讯作者",
      link = "https://doi.org/10.1016/j.biopha.2021.110921"
    ),
    list(
      title = "Research Progress on the STAT Signaling Pathway in Pregnancy and Pregnancy-Associated Disorders",
      authors = "Li L, Zhang Z, Li H, Zhou M, Li F, Chu C, Zhang Y, Zhu X, Jiu H*, Li X*",
      journal = "Frontiers in Immunology",
      year = "2024",
      if_value = "7.3",
      note = "通讯作者",
      link = ""
    ),
    list(
      title = "miR-130b-3p regulates M1 macrophage polarization via targeting IRF1",
      authors = "Guo Q, Zhu X, Wei R, Zhao L, Zhang Z, Yin X, Zhang Y, Chu C, Wang B*, Li X*",
      journal = "Journal of Cellular Physiology",
      year = "2021",
      if_value = "6.513",
      note = "通讯作者",
      link = "https://doi.org/10.1002/jcp.29987"
    ),
    list(
      title = "Emerging role of miRNAs, lncRNAs, and circRNAs in pregnancy-associated diseases",
      authors = "Fu X, Li Y, Zhang Z, Wang B, Wei R, Chu C, Xu K, Li L, Liu Y, Li X*",
      journal = "Chinese Medical Journal",
      year = "2023",
      if_value = "6.133",
      note = "通讯作者",
      link = "https://doi.org/10.1097/CM9.0000000000002595"
    )
  ),
  
  chinese = list(
    list(
      title = "寿胎丸抑制滋养细胞miR-29c-3p/Caspase-8/GSDME 焦亡信号轴治疗URSA 的作用与机制研究",
      authors = "许珂，张振，魏然，褚楚，李莉华，刘泳琳，高淑凤，范楠楠，周苗苗，石飞飞，李霞*",
      journal = "中国免疫学杂志",
      year = "2023",
      if_value = "",
      note = "通讯作者",
      link = ""
    ),
    list(
      title = "寿胎丸靶向miR-374c-5p/ATG12信号轴减轻滋养细胞自噬治疗原因不明复发性自然流产",
      authors = "付笑笑，褚楚，黑国真，魏然，朱肖肖，张振，赵霖，郭强，许珂，李霞*",
      journal = "中国免疫学杂志",
      year = "2022",
      if_value = "",
      note = "通讯作者",
      link = ""
    ),
    list(
      title = "miR-664b-3p调控Caspase-1介导细胞焦亡在深静脉血栓形成中的作用",
      authors = "褚楚，刘文，郭红，赵霖，魏然，张振，郭强，朱肖肖，王彬*，李霞*",
      journal = "山东医药",
      year = "2021",
      if_value = "",
      note = "通讯作者",
      link = ""
    ),
    list(
      title = "原因不明复发性自然流产患者血清IL-10水平变化及其与miR-513c-5p的调控关系",
      authors = "尹红,魏然,张振,朱肖肖,郭强,褚楚,付笑笑,赵霖,李霞*",
      journal = "山东医药",
      year = "2021",
      if_value = "",
      note = "通讯作者",
      link = ""
    ),
    list(
      title = "无创产前基因检测与传统唐筛效果的对比研究",
      authors = "魏娜，郝超，张俊梅，潘彬，舒静，李霞*",
      journal = "中国城乡企业卫生",
      year = "2020",
      if_value = "",
      note = "通讯作者",
      link = ""
    ),
    list(
      title = "深静脉血栓形成患者外周血miR-374a-5p、IL-10水平变化及其调控关系",
      authors = "刘婧,张云虹,赵霖,朱肖肖,张振,魏然,郭强,尹训强,周宪宾,王彬,李霞*",
      journal = "山东医药",
      year = "2019",
      if_value = "",
      note = "通讯作者",
      link = ""
    ),
    list(
      title = "原因不明复发性自然流产患者外周血IL-6、let-7d-5p水平变化及其关系",
      authors = "谷兆琪，尹训强，王东梅，张云虹，魏然，张振，朱肖肖，郭强，周宪宾，褚楚，赵霖，李霞*",
      journal = "山东医药",
      year = "2019",
      if_value = "",
      note = "通讯作者",
      link = ""
    ),
    list(
      title = "原因不明复发性自然流产患者外周血pDC、miR-6165水平变化及其调控机制",
      authors = "郑象昭，尹训强，王东梅，张云虹，张振，魏然，朱肖肖，郭强，周宪宾，褚楚，赵霖，李霞*",
      journal = "山东医药",
      year = "2019",
      if_value = "",
      note = "通讯作者",
      link = ""
    ),
    list(
      title = "STAT1信号通路在全反式维甲酸诱导人白血病细胞向粒细胞分化过程中的作用与机制",
      authors = "孙琳琳，郭强，朱肖肖，张振，赵霖，魏然，施引，尹训强，张云虹，姜国胜*，李霞*",
      journal = "山东医药",
      year = "2018",
      if_value = "",
      note = "通讯作者",
      link = ""
    ),
    list(
      title = "STAT3信号通路在人急性单核细胞白血病细胞向树突状细胞分化中的作用及机制探讨",
      authors = "施引，朱肖肖，张振，郭强，赵霖，魏然，孙琳琳，尹训强，张云虹，姜国胜*，李霞*",
      journal = "山东医药",
      year = "2018",
      if_value = "",
      note = "通讯作者",
      link = ""
    )
  )
)

# 定义主UI
ui <- fluidPage(
  tags$head(
    tags$title("RSAdb — Single-cell omics big data platform for recurrent spontaneous abortion"),
    tags$style(HTML('
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
      }
      
      body {
        background-color: #f5f7fa;
        color: #333;
        line-height: 1.6;
      }
      
      .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
      }
      
      /* Navigation */
      .navbar {
        background-color: #1a3c6e;
        padding: 15px 0;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      }
      
      .nav-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
      }
      
      .logo {
        color: white;
        font-size: 1.8rem;
        font-weight: bold;
      }
      
      .nav-links {
        display: flex;
        list-style: none;
      }
      
      .nav-links li {
        margin-left: 25px;
      }
      
      .nav-links a {
        color: white;
        text-decoration: none;
        padding: 8px 15px;
        border-radius: 4px;
        transition: background-color 0.3s;
      }
      
      .nav-links a.active {
        background-color: #e74c3c;
        box-shadow: 0 0 0 2px #e74c3c;
      }
      
      .nav-links a:hover {
        background-color: rgba(255,255,255,0.1);
      }
      
      /* Header Section */
      .header {
        background-color: #1a6bb3;
        color: white;
        padding: 60px 0;
        margin-bottom: 40px;
      }
      
      .header-content {
        max-width: 900px;
      }
      
      .header h1 {
        font-size: 2.8rem;
        margin-bottom: 20px;
      }
      
      .header p {
        font-size: 1.2rem;
        margin-bottom: 15px;
      }
      
      /* Content Sections */
      .section {
        background: white;
        border-radius: 8px;
        padding: 30px;
        margin-bottom: 30px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
      }
      
      .section-title {
        font-size: 1.8rem;
        margin-bottom: 20px;
        color: #2c3e50;
        border-bottom: 2px solid #3498db;
        padding-bottom: 10px;
      }
      
      .section-subtitle {
        font-size: 1.4rem;
        margin: 25px 0 15px 0;
        color: #1a3c6e;
        padding-left: 10px;
        border-left: 4px solid #e74c3c;
      }
      
      .stats-box {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 30px;
        text-align: center;
      }
      
      .stats-title {
        font-size: 1.2rem;
        margin-bottom: 10px;
        font-weight: 600;
      }
      
      .stats-value {
        font-size: 2.5rem;
        font-weight: bold;
        margin-bottom: 10px;
      }
      
      .stats-subtitle {
        font-size: 0.9rem;
        opacity: 0.9;
      }
      
      .capabilities-list {
        list-style-type: none;
        padding-left: 0;
      }
      
      .capabilities-list li {
        padding: 10px 0;
        padding-left: 30px;
        position: relative;
      }
      
      .capabilities-list li:before {
        content: "•";
        color: #3498db;
        font-weight: bold;
        font-size: 1.5rem;
        position: absolute;
        left: 0;
        top: 5px;
      }
      
      .image-gallery {
        display: flex;
        flex-wrap: wrap;
        gap: 30px;
        justify-content: space-between;
      }
      
      .image-item {
        flex: 1 1 300px;
        display: flex;
        flex-direction: column;
        margin-bottom: 20px;
      }
      
      .image-placeholder {
        height: 300px;
        background-color: #ecf0f1;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 15px;
        overflow: hidden;
      }
      
      .image-placeholder img {
        width: 100%;
        height: 100%;
        object-fit: contain;
      }
      
      .image-caption {
        padding: 15px;
        background-color: #f8f9fa;
        border-radius: 8px;
      }
      
      .update-box {
        background-color: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        border-left: 4px solid #3498db;
      }
      
      .update-item {
        padding: 10px 0;
        border-bottom: 1px dashed #ddd;
      }
      
      .update-item:last-child {
        border-bottom: none;
      }
      
      .update-date {
        font-weight: bold;
        color: #2c3e50;
      }
      
      .use-cases {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
      }
      
      .use-case {
        flex: 1 1 250px;
        background: #f0f7ff;
        padding: 20px;
        border-radius: 8px;
        border-left: 4px solid #3498db;
      }
      
      footer {
        text-align: center;
        padding: 20px;
        margin-top: 40px;
        background-color: #2c3e50;
        color: white;
        border-radius: 8px;
      }
      
      /* Introduction page styles */
      .paper-list-container {
        max-height: 600px;
        overflow-y: auto;
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 15px;
        background: #f8f9fa;
      }
      
      .paper-card {
        background: white;
        border-left: 4px solid #3498db;
        padding: 20px;
        margin-bottom: 15px;
        border-radius: 4px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        transition: transform 0.2s;
      }
      
      .paper-card:hover {
        transform: translateX(5px);
      }
      
      .paper-title {
        color: #2c3e50;
        font-weight: 600;
        margin-bottom: 8px;
        font-size: 1rem;
      }
      
      .paper-authors {
        color: #666;
        font-size: 0.85rem;
        margin-bottom: 5px;
      }
      
      .paper-journal {
        color: #3498db;
        font-weight: 500;
        font-size: 0.85rem;
        margin-bottom: 5px;
      }
      
      .paper-meta {
        display: flex;
        gap: 15px;
        font-size: 0.8rem;
        color: #777;
      }
      
      .if-badge {
        background-color: #2ecc71;
        color: white;
        padding: 2px 8px;
        border-radius: 12px;
        font-size: 0.75rem;
        font-weight: 600;
      }
      
      .corresponding-badge {
        background-color: #e74c3c;
        color: white;
        padding: 2px 8px;
        border-radius: 12px;
        font-size: 0.75rem;
        font-weight: 600;
      }
      
      /* Query页面样式 */
      .sidebar-panel {
        background: white;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        margin-bottom: 20px;
      }
      
      .main-panel {
        background: white;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
      }
      
      .gene-input-section {
        margin-bottom: 20px;
      }
      
      .gene-input-section label {
        display: block;
        font-weight: 600;
        margin-bottom: 8px;
        color: #2c3e50;
      }
      
      .gene-input-section input {
        width: 100%;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 14px;
      }
      
      .gene-input-section .btn-update {
        background-color: #3498db;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 4px;
        cursor: pointer;
        font-weight: 600;
        width: 100%;
        margin-top: 10px;
        transition: background-color 0.3s;
      }
      
      .gene-input-section .btn-update:hover {
        background-color: #2980b9;
      }
      
      .data-info-section {
        margin-top: 20px;
      }
      
      .data-info-section h4 {
        color: #2c3e50;
        margin-bottom: 10px;
        border-bottom: 2px solid #3498db;
        padding-bottom: 5px;
      }
      
      .gene-validation {
        margin-bottom: 20px;
        padding: 15px;
        border-radius: 8px;
      }
      
      .gene-validation.valid {
        background-color: #e8f6e8;
        border-left: 4px solid #2ecc71;
      }
      
      .gene-validation.invalid {
        background-color: #fdeaea;
        border-left: 4px solid #e74c3c;
      }
      
      /* Expression Binary页面样式 */
      .binary-settings {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        border-left: 4px solid #3498db;
        margin-bottom: 20px;
      }
      
      .fisher-result {
        background: #f0f8ff;
        padding: 15px;
        border-radius: 8px;
        border: 1px solid #3498db;
        margin-top: 20px;
        font-size: 0.9rem;
      }
      
      .fisher-result h5 {
        color: #2c3e50;
        margin-bottom: 10px;
        font-size: 1rem;
      }
      
      @media (max-width: 768px) {
        .nav-container {
          flex-direction: column;
        }
        
        .nav-links {
          margin-top: 15px;
        }
        
        .nav-links li {
          margin: 0 10px;
        }
        
        .header h1 {
          font-size: 2rem;
        }
        
        .image-gallery, .use-cases {
          flex-direction: column;
        }
      }
    '))
  ),
  
  # 导航栏
  tags$nav(
    class = "navbar",
    tags$div(
      class = "container nav-container",
      tags$div(class = "logo", "RSAdb"),
      tags$ul(
        class = "nav-links",
        tags$li(tags$a(id = "nav-home", href = "#", class = "active", "Home")),
        tags$li(tags$a(id = "nav-query", href = "#", "Query")),
        tags$li(tags$a(id = "nav-introduction", href = "#", "Introduction"))
      )
    )
  ),
  
  # 页面内容
  tabsetPanel(
    id = "main_tabs",
    type = "hidden",
    
    # 首页（Home）
    tabPanel(
      "Home",
      
      # Header Section
      tags$div(
        class = "header",
        tags$div(
          class = "container",
          tags$div(
            class = "header-content",
            tags$h1("RSAdb — Single-cell omics big data platform for recurrent spontaneous abortion"),
            tags$p("RSAdb is a comprehensive open-access resource for investigating transcriptomic alterations associated with gene expression patterns within single-cell omics datasets at the maternal-fetal interface in human recurrent spontaneous abortion (RSA)."),
            tags$p("The database comprises 73,025 cells and 25,858 genes spanning 28 distinct cell types derived from the maternal-fetal interface of both normal pregnancy (NP) and recurrent spontaneous abortion (RSA), generated through unified standardized data analysis workflows with systematic cell type annotation protocols.")
          )
        )
      ),
      
      # Main Content
      tags$div(
        class = "container",
        
        # What you can do with RSAdb
        tags$div(
          class = "section",
          tags$h2(class = "section-title", "What you can do with RSAdb"),
          tags$ul(
            class = "capabilities-list",
            tags$li("The interface provides interactive exploration of 25,858 genes across 32 distinct cellular subpopulations systematically characterized at the maternal-fetal interface in NP and RSA cohorts."),
            tags$li("Researchers can directly generate publication-ready visualizations of NP-RSA transcriptional divergence through integrated analytical modules, including: Dimensionality reduction (DimPlot), Differentiation trajectory (AlluvialPlot), Cellular preference mapping (GroupPreferencePlot), Expression distribution (VlnPlot), Spatial localization (FeaturePlot/DensityPlot)."),
            tags$li("Run flexible gene set scoring on 5,809 curated datasets using a single or paired gene set to identify upstream regulators of your biology of interest."),
            tags$li("Reproducible results: One-click access to datasets, consolidated downloads, and step-by-step case studies to guide typical research workflows.")
          )
        ),
        
        # Analysis Results
        # 在Home页面的Analysis Modules部分，修正图片描述
        tags$div(
          class = "section",
          tags$h2(class = "section-title", "Analysis Modules"),
          tags$div(
            class = "image-gallery",
            # 第一张：Expression Binary Analysis
            tags$div(
              class = "image-item",
              tags$div(
                class = "image-placeholder",
                uiOutput("alluvialPlotImage")
              ),
              tags$div(
                class = "image-caption",
                tags$h3("Cell Type-specific Expression Violin Plot"),
                tags$p("This analysis displays detailed expression patterns across multiple cell types with statistical significance testing between experimental conditions.")
              )
            ),
            # 第二张：Cell Type Atlas t-SNE Projection
            tags$div(
              class = "image-item",
              tags$div(
                class = "image-placeholder",
                uiOutput("vlnPlotImage")
              ),
              tags$div(
                class = "image-caption",
                tags$h3("Expression Binary Analysis Bar Plot"),
                tags$p("This chart provides a quick comparison of positive/negative expression ratios between experimental groups using a binary classification approach.")
              )
            ),
            # 第三张：Cell Type-specific Expression Violin Plot
            tags$div(
              class = "image-item",
              tags$div(
                class = "image-placeholder",
                uiOutput("dimPlotImage")
              ),
              tags$div(
                class = "image-caption",
                tags$h3("Cell Type Atlas t-SNE Projection"),
                tags$p("This visualization maps the cellular landscape using dimensionality reduction to reveal inherent clustering patterns of different cell populations.")
              )
            )
          )
        ),
        
        # Use Cases
        tags$div(
          class = "section",
          tags$h2(class = "section-title", "Use Cases"),
          tags$div(
            class = "use-cases",
            tags$div(
              class = "use-case",
              tags$h3("Discover regulatory genes"),
              tags$p("Identify regulatory genes associated with recurrent spontaneous abortion by comparing NP and RSA samples.")
            ),
            tags$div(
              class = "use-case",
              tags$h3("Illuminate disease mechanisms"),
              tags$p("Explore changes in cellular subpopulations at the maternal-fetal interface to reveal potential molecular mechanisms of RSA.")
            ),
            tags$div(
              class = "use-case",
              tags$h3("Prioritize potential therapeutic targets"),
              tags$p("Prioritize potential therapeutic targets from perturbation transcriptomes quickly, transparently, and at scale.")
            )
          )
        ),
        
        # News and Update
        tags$div(
          class = "section",
          tags$h2(class = "section-title", "News and Update"),
          tags$div(
            class = "update-box",
            tags$div(
              class = "update-item",
              tags$span(class = "update-date", "2025-11-28"),
              ": RSAdb first release 1.0.0: GPSA analysis"
            ),
            tags$div(
              class = "update-item",
              tags$span(class = "update-date", "2025-11-19"),
              ": RSAdb web finished by using shiny"
            ),
            tags$div(
              class = "update-item",
              tags$span(class = "update-date", "2025-04-23"),
              ": RSAdb data curation finished and snakemake pipeline built to download and pretreat data"
            ),
            tags$div(
              class = "update-item",
              tags$span(class = "update-date", "2024-01-22"),
              ": RSAdb data curation started"
            )
          )
        )
      ),
      
      # Footer
      tags$footer(
        tags$div(
          class = "container",
          tags$p("© 2025 RSAdb — Single-cell omics big data platform for recurrent spontaneous abortion. All rights reserved.")
        )
      )
    ),
    
    # Query页面
    tabPanel(
      "Query",
      tags$div(
        class = "container",
        tags$div(
          class = "section",
          tags$h1("Single-cell omics big data platform for recurrent spontaneous abortion", 
                  style = "font-size: 2rem; margin-bottom: 30px; color: #2c3e50;"),
          
          fluidRow(
            # 左侧边栏
            column(
              3,
              tags$div(
                class = "sidebar-panel",
                tags$div(
                  class = "gene-input-section",
                  tags$label("Enter Gene Name"),
                  textInput("gene_select", NULL, value = "CD69"),
                  actionButton("update_plots", "Update Plots", class = "btn-update")
                ),
                
                tags$div(
                  class = "data-info-section",
                  tags$h4("Data Information"),
                  verbatimTextOutput("data_info")
                )
              )
            ),
            
            # 主面板
            column(
              9,
              tags$div(
                class = "main-panel",
                # 数据加载状态
                verbatimTextOutput("load_status"),
                
                # 基因验证状态
                uiOutput("gene_validation"),
                
                # 主要可视化图表
                tabsetPanel(
                  id = "query_tabs",
                  tabPanel("Violin Plot", plotOutput("violin_plot", height = "600px")),
                  tabPanel("Feature Plot", plotOutput("feature_plot", height = "800px")),
                  tabPanel("Density Plot", plotOutput("density_plot", height = "800px")),
                  # Expression Binary标签页
                  tabPanel("Expression Binary", 
                           fluidRow(
                             column(6,
                                    tags$div(
                                      class = "binary-settings",
                                      tags$h4("Expression Binary Settings"),
                                      sliderInput("expression_threshold", "Expression Threshold (%):",
                                                  min = 0, max = 100, value = 50, step = 1),
                                      actionButton("update_binary", "Update Binary Analysis", 
                                                   class = "btn-update"),
                                      tags$div(
                                        class = "fisher-result",
                                        tags$h5("Fisher's Exact Test Results:"),
                                        verbatimTextOutput("fisher_test_result")
                                      )
                                    )
                             ),
                             column(6,
                                    plotOutput("binary_stacked_barplot", height = "500px")
                             )
                           )
                  )
                )
              )
            )
          )
        )
      )
    ),
    
    # Introduction页面
    tabPanel(
      "Introduction",
      tags$div(
        class = "container",
        
        # Header Section
        tags$div(
          class = "header",
          tags$div(
            class = "header-content",
            tags$h1("山东中医药大学中医药免疫调控创新团队")
          )
        ),
        
        # 团队详细介绍section
        tags$div(
          class = "section",
          tags$div(
            style = "line-height: 1.8; font-size: 1.1rem; text-align: justify;",
            tags$p("李霞教授领衔的中医药免疫调控创新团队长期致力于中医药免疫调控关键机制研究。团队聚焦'肾主生殖'等经典中医理论，结合现代免疫学等多学科交叉前沿技术，在中医药防治原因不明复发性自然流产、调节肿瘤免疫微环境及抗血管炎症损伤关键机制等方面开展了系统性探索。"),
            tags$p("相关研究工作得到国家自然科学基金项目、山东省自然科学基金重大项目等支持，团队以通讯作者或共同通讯作者身份在NCB、J Clin Invest、Cancer Letter、Cell Death Dis、ATVB、Int J Biol Sci.等国际权威期刊发表多篇研究成果，获得山东省科技进步二等奖、中华中医药科技成果二等奖、中国妇幼健康科技成果二等奖等多项奖励，有力推动了中医药免疫调控领域的技术进步。")
          )
        ),
        
        # 统计信息
        tags$div(
          class = "section",
          tags$h2(class = "section-title", "Publication Statistics"),
          tags$div(
            class = "stats-container",
            style = "display: flex; gap: 20px; flex-wrap: wrap;",
            tags$div(
              class = "stats-box",
              style = "flex: 1 1 200px;",
              tags$div(class = "stats-title", "SCI-indexed paper"),
              tags$div(class = "stats-value", "47 articles"),
              tags$div(class = "stats-subtitle", "35 papers as corresponding author, 5 papers as first author")
            ),
            tags$div(
              class = "stats-box",
              style = "flex: 1 1 200px; background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);",
              tags$div(class = "stats-title", "Corresponding or First Author Paper"),
              tags$div(class = "stats-value", "40 articles"),
              tags$div(class = "stats-subtitle", "Total IF 206.05")
            ),
            tags$div(
              class = "stats-box",
              style = "flex: 1 1 200px; background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);",
              tags$div(class = "stats-title", "中文核心期刊论文"),
              tags$div(class = "stats-value", "41 articles"),
              tags$div(class = "stats-subtitle", "其中通讯作者26篇，第一作者9篇")
            )
          )
        ),
        
        # 英文论文列表
        tags$div(
          class = "section",
          tags$h2(class = "section-title", "SCI-indexed paper/ (Selected)"),
          tags$div(
            class = "paper-list-container",
            style = "max-height: 700px;",
            uiOutput("english_paper_list")
          )
        ),
        
        # 中文论文列表
        tags$div(
          class = "section",
          tags$h2(class = "section-title", "中文核心期刊论文 (Selected)"),
          tags$div(
            class = "paper-list-container",
            style = "max-height: 700px;",
            uiOutput("chinese_paper_list")
          )
        )
      )
    )
  ),
  
  # JavaScript
  tags$script(
    '// 为导航链接添加点击事件处理
    document.addEventListener("click", function(e) {
      // 检查点击的是否是导航链接
      if (e.target.id === "nav-home") {
        e.preventDefault();
        Shiny.setInputValue("nav_click", "Home");
      } else if (e.target.id === "nav-introduction") {
        e.preventDefault();
        Shiny.setInputValue("nav_click", "Introduction");
      } else if (e.target.id === "nav-query") {
        e.preventDefault();
        Shiny.setInputValue("nav_click", "Query");
      }
    });
    
    // 监听标签页变化，更新导航链接的active状态
    Shiny.addCustomMessageHandler("update_nav_active", function(message) {
      // 移除所有active类
      var links = document.querySelectorAll(".nav-links a");
      links.forEach(function(link) {
        link.classList.remove("active");
      });
      // 为当前标签页的链接添加active类
      document.getElementById("nav-" + message.tab.toLowerCase()).classList.add("active");
    });
  ')
)

# 定义主Server
server <- function(input, output, session) {
  # 监听导航点击事件，切换标签页
  observeEvent(input$nav_click, {
    updateTabsetPanel(session, "main_tabs", selected = input$nav_click)
    session$sendCustomMessage("update_nav_active", list(tab = input$nav_click))
  })
  
  # 监听标签页变化，更新导航状态
  observeEvent(input$main_tabs, {
    session$sendCustomMessage("update_nav_active", list(tab = input$main_tabs))
  })
  
  # 首页（Home）的Server逻辑
  
  # 检查并准备DimPlot图片
  output$dimPlotImage <- renderUI({
    if(file.exists("t-SNE.png")) {
      img_data <- base64encode("t-SNE.png")
      img_src <- paste0("data:image/png;base64,", img_data)
    } else {
      warning("t-SNE.png file not found, using placeholder image")
      img_src <- "https://via.placeholder.com/400x300/3498db/ffffff?text=Dimensionality+Reduction"
    }
    tags$img(src = img_src, alt = "Dimensionality Reduction")
  })
  
  # 检查并准备AlluvialPlot图片
  output$alluvialPlotImage <- renderUI({
    if(file.exists("voilin.png")) {
      group_img_data <- base64encode("voilin.png")
      group_img_src <- paste0("data:image/png;base64,", group_img_data)
    } else {
      warning("voilin.png file not found, using placeholder image")
      group_img_src <- "https://via.placeholder.com/400x300/2ecc71/ffffff?text=Cell+Type+Composition"
    }
    tags$img(src = group_img_src, alt = "Cell Type Composition Analysis")
  })
  
  # 检查并准备VlnPlot图片
  output$vlnPlotImage <- renderUI({
    if(file.exists("percentage.png")) {
      percentage_img_data <- base64encode("percentage.png")
      percentage_img_src <- paste0("data:image/png;base64,", percentage_img_data)
    } else {
      warning("percentage.png file not found, using placeholder image")
      percentage_img_src <- "https://via.placeholder.com/400x300/e74c3c/ffffff?text=t-SNE+Visualization"
    }
    tags$img(src = percentage_img_src, alt = "t-SNE Visualization by Cell Type")
  })
  
  # Introduction页面的Server逻辑 - 英文论文列表
  output$english_paper_list <- renderUI({
    papers <- papers_data$english
    
    if (length(papers) == 0) {
      return(tags$p("No SCI paper data available."))
    }
    
    # 创建英文论文卡片
    paper_cards <- lapply(seq_along(papers), function(i) {
      p <- papers[[i]]
      tags$div(
        class = "paper-card",
        tags$div(
          class = "paper-title",
          if(nchar(p$link) > 0 && p$link != "") {
            tags$a(href = p$link, target = "_blank", p$title)
          } else {
            tags$span(p$title)
          }
        ),
        tags$div(class = "paper-authors", p$authors),
        tags$div(
          class = "paper-journal",
          paste0(p$journal, " (", p$year, ")")
        ),
        tags$div(
          class = "paper-meta",
          if(nchar(p$if_value) > 0) {
            tags$span(class = "if-badge", paste0("IF: ", p$if_value))
          },
          tags$span(class = "corresponding-badge", p$note)
        )
      )
    })
    
    tagList(paper_cards)
  })
  
  # Introduction页面的Server逻辑 - 中文论文列表
  output$chinese_paper_list <- renderUI({
    papers <- papers_data$chinese
    
    if (length(papers) == 0) {
      return(tags$p("No Chinese core journal paper data available."))
    }
    
    # 创建中文论文卡片
    paper_cards <- lapply(seq_along(papers), function(i) {
      p <- papers[[i]]
      tags$div(
        class = "paper-card",
        tags$div(
          class = "paper-title",
          if(nchar(p$link) > 0 && p$link != "") {
            tags$a(href = p$link, target = "_blank", p$title)
          } else {
            tags$span(p$title)
          }
        ),
        tags$div(class = "paper-authors", p$authors),
        tags$div(
          class = "paper-journal",
          paste0(p$journal, " (", p$year, ")")
        ),
        tags$div(
          class = "paper-meta",
          if(nchar(p$if_value) > 0) {
            tags$span(class = "if-badge", paste0("IF: ", p$if_value))
          },
          tags$span(class = "corresponding-badge", p$note)
        )
      )
    })
    
    tagList(paper_cards)
  })
  
  # Query页面的Server逻辑
  
  # 加载数据
  seu_data <- reactive({
    tryCatch({
      message("Starting to load data...")
      data <- qread("input.data.qs")
      message("Data loading completed!")
      return(data)
    }, error = function(e) {
      message("Data loading error: ", e$message)
      return(NULL)
    })
  })
  
  # 显示数据加载状态
  output$load_status <- renderPrint({
    if (is.null(seu_data())) {
      "❌ Data loading failed! Please check if the input.data.qs file exists and is in the correct format."
    } else {
      "✅ Data loaded successfully"
    }
  })
  
  # 显示数据基本信息
  output$data_info <- renderPrint({
    req(seu_data())
    cat("Number of cells: ", ncol(seu_data()), "\n")
    cat("Number of genes: ", nrow(seu_data()), "\n")
    cat("Cell types: ", length(unique(seu_data()$Celltype)), "\n")
    cat("Experimental groups: ", length(unique(seu_data()$Group)), "\n")
  })
  
  # 辅助函数：查找相似的基因名称
  findSimilarGenes <- function(query, all_genes, all_genes_lower) {
    prefix_matches <- grep(paste0("^", query), all_genes_lower, value = FALSE)
    contains_matches <- grep(query, all_genes_lower, value = FALSE)
    all_matches <- unique(c(prefix_matches, contains_matches))
    if (length(all_matches) > 0) {
      return(all_genes[utils::head(all_matches, 5)])
    } else {
      return(NULL)
    }
  }
  
  # 创建一个reactive表达式来处理基因验证逻辑
  validated_gene <- reactive({
    req(seu_data(), input$gene_select)
    gene_name <- input$gene_select
    
    if (is.null(gene_name) || gene_name == "") {
      return(list(exists = FALSE, name = gene_name, message = "Please enter a valid gene name", suggestions = NULL))
    }
    
    gene_name_lower <- tolower(gene_name)
    all_genes <- rownames(seu_data())
    all_genes_lower <- tolower(all_genes)
    
    if (gene_name_lower %in% all_genes_lower) {
      original_gene_name <- all_genes[which(all_genes_lower == gene_name_lower)[1]]
      return(list(exists = TRUE, name = original_gene_name, message = NULL, suggestions = NULL))
    } else {
      suggestions <- findSimilarGenes(gene_name_lower, all_genes, all_genes_lower)
      message_text <- paste0("Gene '", gene_name, "' is not found in the dataset")
      return(list(exists = FALSE, name = gene_name, message = message_text, suggestions = suggestions))
    }
  })
  
  # 显示基因验证状态 - 响应更新按钮
  output$gene_validation <- renderUI({
    validation <- validated_gene()
    
    if (validation$exists) {
      tags$div(
        class = "gene-validation valid",
        HTML(paste0("✓ Gene '<strong>", validation$name, "</strong>' is present in the dataset"))
      )
    } else {
      error_msg <- tags$div(
        class = "gene-validation invalid",
        HTML(paste0("✗ Error: ", validation$message, ", please check the gene name"))
      )
      
      if (!is.null(validation$suggestions) && length(validation$suggestions) > 0) {
        suggestions_msg <- tags$div(
          style = "background-color: #f0f8ff; padding: 10px; border-radius: 5px; border-left: 4px solid blue; margin-top: 10px;",
          tags$p("<strong>Possible gene names:</strong>"),
          tags$ul(
            lapply(validation$suggestions, function(gene) {
              tags$li(gene, style = "margin: 2px 0;")
            })
          )
        )
        return(tags$div(error_msg, suggestions_msg))
      } else {
        return(error_msg)
      }
    }
  }) %>% bindEvent(input$update_plots, input$update_binary)
  
  # 绘制基因表达小提琴图
  output$violin_plot <- renderPlot({
    req(seu_data(), validated_gene())
    validation <- validated_gene()
    
    if (validation$exists) {
      tryCatch({
        input.gene <- validation$name
        
        # 修复：使用layer参数替代已弃用的slot参数
        df <- tryCatch({
          # 尝试使用新的layer参数（Seurat v5）
          FetchData(seu_data(), vars = c(input.gene, "Celltype", "Group"), layer = "data")
        }, error = function(e) {
          # 如果layer参数失败，回退到slot参数（Seurat v4）
          FetchData(seu_data(), vars = c(input.gene, "Celltype", "Group"), slot = "data")
        })
        
        df.m <- melt(df, id.vars = c("Celltype", "Group"),
                     variable.name = "Gene", value.name = "Expression")
        colors <- c("#4575B4", "#A50026")
        
        ggplot(df.m, aes(x = Celltype, y = Expression, color = Group, fill = Group)) + 
          geom_boxplot(position = position_dodge(1), width = 0.3, outlier.shape = NA, 
                       color = "black", alpha = 0.7) +  
          geom_violin(position = position_dodge(1), scale = "width", 
                      color = "black", alpha = 0.4) + 
          theme_classic() +
          scale_fill_manual(values = colors) +
          scale_color_manual(values = colors) +
          theme(axis.ticks = element_line(color = "black"),
                axis.ticks.length = unit(0.2, "cm"),
                axis.title.y = element_text(colour = "black", size = 14),
                axis.title.x = element_text(colour = "black", size = 14),
                axis.text.y = element_text(colour = "black", size = 13),
                axis.text.x = element_text(colour = "black", size = 13, 
                                           angle = 45, 
                                           hjust = 1, 
                                           vjust = 1)) + 
          ggpubr::stat_compare_means(aes(group=Group), method = "wilcox.test", label = "p.signif") + 
          ylab(paste0("Expression level of ", input.gene)) +
          xlab("") + 
          labs(title = "") +
          theme(legend.position = "right") + 
          theme(plot.title = element_text(colour="black", hjust = 0.5, size = 12))
      }, error = function(e) {
        ggplot() +
          geom_text(aes(x = 0, y = 0, label = paste0("Failed to generate violin plot: ", e$message)), 
                    size = 5, color = "red", hjust = 0.5, vjust = 0.5) +
          theme_void()
      })
    } else {
      ggplot() +
        geom_text(aes(x = 0, y = 0, label = paste0(validation$message, "\nPlease check the gene name")), 
                  size = 6, color = "red", hjust = 0.5, vjust = 0.5) +
        theme_void()
    }
  }) %>% bindEvent(input$update_plots)
  
  # Generate feature plots (4 plots: t-SNE reference + 3 expression plots)
  output$feature_plot <- renderPlot({
    req(seu_data(), validated_gene())
    validation <- validated_gene()
    
    if (validation$exists) {
      tryCatch({
        library(gridExtra)
        
        # 与原始代码一致的颜色方案
        cbPalette <- c("lightgrey", "#FF7373")
        
        # 1. 细胞类型注释的t-SNE图
        p1 <- DimPlot(seu_data(), reduction = "tsne", group.by = "Celltype", label = TRUE, raster = FALSE) +
          scale_color_manual(values = c("#FF7043", "#FFAB91", "#FBE9E7", "#AFB42B", "#DCE775",
                                        "#F48FB1", "#EC407A", "#C2185B", "#DC0000", "#FFCCBC",
                                        "#FF7043", "#BBFFBB", "#00F100", "#008600", "#CCFDFF",
                                        "#99F8FF", "#65EFFF", "#32E3FF", "#00A9CC", "#007A99",
                                        "#F2DACD", "#CC9B7A", "#17BECF", "#8F7EE5", "#6551CC",
                                        "#FFFFA0", "#FFAD72", "#91D1C2", "#8491B4", "#F9F9C6",
                                        "#ECEE00", "#BCBD22", "#C6DBEF", "#C8C8C8")) +
          labs(title = "1. t-SNE Visualization of Cell Types") +
          theme(plot.title = element_text(hjust = 0.5, size = 12),
                axis.text = element_text(size = 8),
                axis.title = element_text(size = 10))
        
        # 2. 所有样本的基因表达
        p2 <- FeaturePlot(seu_data(), reduction = "tsne", features = validation$name, 
                          cols = cbPalette, raster = FALSE) +
          labs(title = paste0("2. ", validation$name, " Expression in All Samples")) +
          theme(plot.title = element_text(hjust = 0.5, size = 12),
                axis.text = element_text(size = 8),
                axis.title = element_text(size = 10))
        
        # 3. NP组的基因表达
        np_data <- subset(seu_data(), subset = Group == "NP")
        p3 <- FeaturePlot(np_data, reduction = "tsne", features = validation$name, 
                          cols = cbPalette, raster = FALSE) +
          labs(title = paste0("3. ", validation$name, " Expression in NP Group")) +
          theme(plot.title = element_text(hjust = 0.5, size = 12),
                axis.text = element_text(size = 8),
                axis.title = element_text(size = 10))
        
        # 4. URSA组的基因表达
        ursa_data <- subset(seu_data(), subset = Group == "URSA")
        p4 <- FeaturePlot(ursa_data, reduction = "tsne", features = validation$name, 
                          cols = cbPalette, raster = FALSE) +
          labs(title = paste0("4. ", validation$name, " Expression in URSA Group")) +
          theme(plot.title = element_text(hjust = 0.5, size = 12),
                axis.text = element_text(size = 8),
                axis.title = element_text(size = 10))
        
        # 四宫格布局
        grid.arrange(p1, p2, p3, p4, ncol = 2)
        
      }, error = function(e) {
        error_msg <- paste0("Failed to generate feature plots: ", e$message)
        if (length(e$call) > 0) {
          error_msg <- paste0(error_msg, "\nCall: ", deparse(e$call)[1])
        }
        ggplot() +
          geom_text(aes(x = 0, y = 0, label = error_msg), 
                    size = 4, color = "red", hjust = 0.5, vjust = 0.5) +
          theme_void()
      })
    } else {
      ggplot() +
        geom_text(aes(x = 0, y = 0, label = paste0(validation$message, "\nPlease check the gene name")), 
                  size = 6, color = "red", hjust = 0.5, vjust = 0.5) +
        theme_void()
    }
  }) %>% bindEvent(input$update_plots)
  
  # 修改您的密度图渲染函数 - 使用正确的函数调用
  output$density_plot <- renderPlot({
    req(seu_data(), validated_gene())
    validation <- validated_gene()
    
    if (validation$exists) {
      tryCatch({
        library(gridExtra)
        library(Nebulosa)  # 明确加载 Nebulosa
        
        # 1. 细胞类型注释的t-SNE图
        p1 <- DimPlot(seu_data(), reduction = "tsne", group.by = "Celltype", label = TRUE, raster = FALSE) +
          scale_color_manual(values = c("#FF7043", "#FFAB91", "#FBE9E7", "#AFB42B", "#DCE775",
                                        "#F48FB1", "#EC407A", "#C2185B", "#DC0000", "#FFCCBC",
                                        "#FF7043", "#BBFFBB", "#00F100", "#008600", "#CCFDFF",
                                        "#99F8FF", "#65EFFF", "#32E3FF", "#00A9CC", "#007A99",
                                        "#F2DACD", "#CC9B7A", "#17BECF", "#8F7EE5", "#6551CC",
                                        "#FFFFA0", "#FFAD72", "#91D1C2", "#8491B4", "#F9F9C6",
                                        "#ECEE00", "#BCBD22", "#C6DBEF", "#C8C8C8")) +
          labs(title = "1. t-SNE Visualization of Cell Types") +
          theme(plot.title = element_text(hjust = 0.5, size = 12),
                axis.text = element_text(size = 8),
                axis.title = element_text(size = 10))
        
        # 使用正确的 Nebulosa 函数调用
        # 新版本的 Nebulosa 可能需要不同的参数
        tryCatch({
          # 2. 所有样本的密度图
          p2 <- plot_density(seu_data(), features = validation$name, reduction = "tsne") +
            theme(panel.grid = element_blank(),
                  plot.title = element_text(hjust = 0.5, size = 12),
                  axis.text = element_text(size = 8),
                  axis.title = element_text(size = 10)) +
            labs(title = paste0("2. ", validation$name, " NP + URSA"))
          
          # 3. NP组的密度图
          subdata1 <- subset(seu_data(), subset = Group == "NP")
          p3 <- plot_density(subdata1, features = validation$name, reduction = "tsne") +
            theme(panel.grid = element_blank(),
                  plot.title = element_text(hjust = 0.5, size = 12),
                  axis.text = element_text(size = 8),
                  axis.title = element_text(size = 10)) +
            labs(title = paste0("3. ", validation$name, " (NP)"))
          
          # 4. URSA组的密度图
          subdata2 <- subset(seu_data(), subset = Group == "URSA")
          p4 <- plot_density(subdata2, features = validation$name, reduction = "tsne") +
            theme(panel.grid = element_blank(),
                  plot.title = element_text(hjust = 0.5, size = 12),
                  axis.text = element_text(size = 8),
                  axis.title = element_text(size = 10)) +
            labs(title = paste0("4. ", validation$name, " (URSA)"))
          
        }, error = function(e) {
          # 如果标准调用失败，尝试其他参数组合
          cat("标准调用失败，尝试替代方案:", e$message, "\n")
          
          # 尝试使用 calculate_density 函数
          if ("calculate_density" %in% ls("package:Nebulosa")) {
            cat("尝试使用 calculate_density 函数\n")
            # 使用 calculate_density 手动计算密度
            density_data <- calculate_density(seu_data(), features = validation$name, reduction = "tsne")
            # 这里需要根据返回的数据结构手动绘图
            # 由于时间关系，我们先回退到 FeaturePlot
            stop("使用calculate_density需要额外处理")
          } else {
            stop(e)  # 重新抛出错误，触发外层的回退机制
          }
        })
        
        # 四宫格布局
        grid.arrange(p1, p2, p3, p4, ncol = 2)
        
      }, error = function(e) {
        # 错误处理 - 回退到 FeaturePlot
        cat("Nebulosa 密度图失败，使用 FeaturePlot 回退:", e$message, "\n")
        
        library(gridExtra)
        cbPalette <- c("lightgrey", "#FF7373")
        
        # 1. 细胞类型注释的t-SNE图
        p1 <- DimPlot(seu_data(), reduction = "tsne", group.by = "Celltype", label = TRUE, raster = FALSE) +
          scale_color_manual(values = c("#FF7043", "#FFAB91", "#FBE9E7", "#AFB42B", "#DCE775",
                                        "#F48FB1", "#EC407A", "#C2185B", "#DC0000", "#FFCCBC",
                                        "#FF7043", "#BBFFBB", "#00F100", "#008600", "#CCFDFF",
                                        "#99F8FF", "#65EFFF", "#32E3FF", "#00A9CC", "#007A99",
                                        "#F2DACD", "#CC9B7A", "#17BECF", "#8F7EE5", "#6551CC",
                                        "#FFFFA0", "#FFAD72", "#91D1C2", "#8491B4", "#F9F9C6",
                                        "#ECEE00", "#BCBD22", "#C6DBEF", "#C8C8C8")) +
          labs(title = "1. t-SNE Visualization of Cell Types") +
          theme(plot.title = element_text(hjust = 0.5, size = 12),
                axis.text = element_text(size = 8),
                axis.title = element_text(size = 10))
        
        # 2-4. 使用 FeaturePlot
        p2 <- FeaturePlot(seu_data(), reduction = "tsne", features = validation$name, 
                          cols = cbPalette, raster = FALSE) +
          theme(panel.grid = element_blank(),
                plot.title = element_text(hjust = 0.5, size = 12),
                axis.text = element_text(size = 8),
                axis.title = element_text(size = 10)) +
          labs(title = paste0("2. ", validation$name, " NP + URSA (FeaturePlot)"))
        
        subdata1 <- subset(seu_data(), subset = Group == "NP")
        p3 <- FeaturePlot(subdata1, reduction = "tsne", features = validation$name, 
                          cols = cbPalette, raster = FALSE) +
          theme(panel.grid = element_blank(),
                plot.title = element_text(hjust = 0.5, size = 12),
                axis.text = element_text(size = 8),
                axis.title = element_text(size = 10)) +
          labs(title = paste0("3. ", validation$name, " (NP)"))
        
        subdata2 <- subset(seu_data(), subset = Group == "URSA")
        p4 <- FeaturePlot(subdata2, reduction = "tsne", features = validation$name, 
                          cols = cbPalette, raster = FALSE) +
          theme(panel.grid = element_blank(),
                plot.title = element_text(hjust = 0.5, size = 12),
                axis.text = element_text(size = 8),
                axis.title = element_text(size = 10)) +
          labs(title = paste0("4. ", validation$name, " (URSA)"))
        
        # 四宫格布局
        grid.arrange(p1, p2, p3, p4, ncol = 2)
      })
    } else {
      ggplot() +
        geom_text(aes(x = 0, y = 0, label = paste0(validation$message, "\nPlease check the gene name")), 
                  size = 6, color = "red", hjust = 0.5, vjust = 0.5) +
        theme_void()
    }
  }) %>% bindEvent(input$update_plots)
  
  # 同样修复Expression Binary分析中的FetchData调用
  binary_analysis <- reactive({
    req(seu_data(), validated_gene())
    validation <- validated_gene()
    
    if (validation$exists) {
      tryCatch({
        input.gene <- validation$name
        
        # 修复：使用layer参数替代已弃用的slot参数
        df <- tryCatch({
          # 尝试使用新的layer参数（Seurat v5）
          FetchData(seu_data(), vars = c(input.gene, "Celltype", "Group"), layer = "data")
        }, error = function(e) {
          # 如果layer参数失败，回退到slot参数（Seurat v4）
          FetchData(seu_data(), vars = c(input.gene, "Celltype", "Group"), slot = "data")
        })
        
        # 计算表达阈值（基于百分比）
        threshold_value <- quantile(df[[input.gene]], probs = input$expression_threshold/100, na.rm = TRUE)
        
        # 根据阈值分类为阴阳表达
        df$expression_binary <- ifelse(df[[input.gene]] > threshold_value, "Positive", "Negative")
        df$expression_binary <- factor(df$expression_binary, levels = c("Positive", "Negative"))
        
        return(list(data = df, gene = input.gene, threshold = threshold_value))
        
      }, error = function(e) {
        return(list(error = paste("Binary analysis failed:", e$message)))
      })
    } else {
      return(list(error = "Gene not found in data"))
    }
  }) %>% bindEvent(input$update_binary)
  
  # 生成堆叠柱状图
  output$binary_stacked_barplot <- renderPlot({
    analysis_result <- binary_analysis()
    
    if (!is.null(analysis_result$error)) {
      ggplot() +
        geom_text(aes(x = 0, y = 0, label = analysis_result$error), 
                  size = 5, color = "red", hjust = 0.5, vjust = 0.5) +
        theme_void()
    } else {
      df <- analysis_result$data
      
      # 计算比例
      prop_data <- df %>%
        group_by(Group, expression_binary) %>%
        summarise(count = n(), .groups = 'drop') %>%
        group_by(Group) %>%
        mutate(proportion = count / sum(count) * 100)
      
      # 创建堆叠柱状图
      ggplot(prop_data, aes(x = Group, y = proportion, fill = expression_binary)) +
        geom_col(position = "stack") +
        geom_text(aes(label = sprintf("%.1f%%", proportion)), 
                  position = position_stack(vjust = 0.5), 
                  color = "white", size = 4, fontface = "bold") +
        scale_fill_manual(values = c("Positive" = "#E74C3C", "Negative" = "#3498DB")) +
        labs(title = paste0("Expression Binary Analysis for ", analysis_result$gene),
             subtitle = paste0("Threshold: ", round(analysis_result$threshold, 3), " (", input$expression_threshold, "th percentile)"),
             x = "Group", 
             y = "Percentage (%)",
             fill = "Expression") +
        theme_minimal() +
        theme(
          plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
          plot.subtitle = element_text(size = 12, hjust = 0.5),
          axis.title = element_text(size = 12, face = "bold"),
          axis.text = element_text(size = 10),
          legend.title = element_text(size = 12, face = "bold"),
          legend.text = element_text(size = 10)
        )
    }
  }) %>% bindEvent(input$update_binary)
  
  # Fisher精确检验结果
  output$fisher_test_result <- renderPrint({
    analysis_result <- binary_analysis()
    
    if (!is.null(analysis_result$error)) {
      cat("Fisher's exact test cannot be performed due to data loading error.")
    } else {
      df <- analysis_result$data
      
      # 创建2x2列联表
      contingency_table <- table(df$Group, df$expression_binary)
      
      # 执行Fisher精确检验
      fisher_result <- fisher.test(contingency_table)
      
      cat("Contingency Table:\n")
      print(contingency_table)
      cat("\nFisher's Exact Test Results:\n")
      cat("p-value:", format.pval(fisher_result$p.value, digits = 4), "\n")
      cat("Odds Ratio:", round(fisher_result$estimate, 3), "\n")
      cat("95% Confidence Interval:", round(fisher_result$conf.int[1], 3), "-", round(fisher_result$conf.int[2], 3), "\n")
    }
  }) %>% bindEvent(input$update_binary)
}

# 运行应用
shinyApp(ui = ui, server = server)