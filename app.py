import streamlit as st
import qs
import pandas as pd
import numpy as np
import plotly.express as px
import plotly.graph_objects as go
from scipy.stats import wilcoxon, fisher_exact
import seaborn as sns
import matplotlib.pyplot as plt
from itertools import combinations

# 设置页面标题和布局
st.set_page_config(
    page_title="RSAdb - Single-cell omics platform",
    page_icon="📊",
    layout="wide",
    initial_sidebar_state="expanded"
)

# 自定义CSS样式
st.markdown("""
<style>
    .main-header {
        font-size: 2.5rem;
        font-weight: bold;
        color: #2c3e50;
        text-align: center;
        margin-bottom: 1rem;
    }
    .sub-header {
        font-size: 1.2rem;
        color: #666;
        text-align: center;
        margin-bottom: 2rem;
    }
    .section-title {
        font-size: 1.5rem;
        color: #3498db;
        margin: 2rem 0 1rem 0;
        border-bottom: 2px solid #3498db;
        padding-bottom: 0.5rem;
    }
    .card {
        background-color: #f8f9fa;
        padding: 1.5rem;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        margin-bottom: 1.5rem;
    }
    .gene-valid {
        background-color: #d4edda;
        color: #155724;
        padding: 1rem;
        border-radius: 4px;
        margin: 1rem 0;
    }
    .gene-invalid {
        background-color: #f8d7da;
        color: #721c24;
        padding: 1rem;
        border-radius: 4px;
        margin: 1rem 0;
    }
</style>
""", unsafe_allow_html=True)

# 导航栏
nav_option = st.sidebar.selectbox(
    "导航",
    ("首页", "数据查询", "项目介绍")
)

# 数据加载
@st.cache_data

def load_data():
    try:
        with st.spinner("正在加载数据..."):
            # 尝试读取数据
            data = qs.read("input.data.qs")
            st.success("✅ 数据加载成功")
            return data
    except Exception as e:
        st.error(f"❌ 数据加载失败: {e}")
        return None

# 首页
if nav_option == "首页":
    st.markdown("<h1 class='main-header'>RSAdb</h1>", unsafe_allow_html=True)
    st.markdown("<p class='sub-header'>Single-cell omics big data platform for recurrent spontaneous abortion</p>", unsafe_allow_html=True)
    
    st.markdown("""
    <div class='card'>
        <p>RSAdb是一个综合性的开放访问资源，用于研究人类复发性自然流产（RSA）母胎界面单细胞组学数据集中与基因表达模式相关的转录组改变。</p>
        <p>该数据库包含来自正常妊娠（NP）和复发性自然流产（RSA）母胎界面的73,025个细胞和25,858个基因，涵盖28种不同的细胞类型，通过统一的标准化数据分析工作流程和系统的细胞类型注释协议生成。</p>
    </div>
    """, unsafe_allow_html=True)
    
    st.markdown("<h2 class='section-title'>平台功能</h2>", unsafe_allow_html=True)
    
    col1, col2, col3 = st.columns(3)
    
    with col1:
        st.markdown("""
        <div class='card'>
            <h3>🔬 交互式探索</h3>
            <p>探索母胎界面32种不同细胞亚群中的25,858个基因</p>
        </div>
        """, unsafe_allow_html=True)
    
    with col2:
        st.markdown("""
        <div class='card'>
            <h3>📊  publication-ready可视化</h3>
            <p>生成高质量图表，包括DimPlot、AlluvialPlot、VlnPlot等</p>
        </div>
        """, unsafe_allow_html=True)
    
    with col3:
        st.markdown("""
        <div class='card'>
            <h3>⚡ 灵活的基因集评分</h3>
            <p>使用单个或配对基因集对5,809个 curated数据集进行基因集评分</p>
        </div>
        """, unsafe_allow_html=True)

# 项目介绍
elif nav_option == "项目介绍":
    st.markdown("<h1 class='main-header'>项目介绍</h1>", unsafe_allow_html=True)
    
    st.markdown("""
    <div class='card'>
        <h3>团队介绍</h3>
        <p>李霞教授领衔的中医药免疫调控创新团队长期致力于中医药免疫调控关键机制研究。团队聚焦'肾主生殖'等经典中医理论，结合现代免疫学等多学科交叉前沿技术，在中医药防治原因不明复发性自然流产、调节肿瘤免疫微环境及抗血管炎症损伤关键机制等方面开展了系统性探索。</p>
        <p>相关研究工作得到国家自然科学基金项目、山东省自然科学基金重大项目等支持，团队以通讯作者或共同通讯作者身份在NCB、J Clin Invest、Cancer Letter、Cell Death Dis、ATVB、Int J Biol Sci.等国际权威期刊发表多篇研究成果。</p>
    </div>
    """, unsafe_allow_html=True)
    
    st.markdown("<h2 class='section-title'>发表统计</h2>", unsafe_allow_html=True)
    
    col1, col2, col3 = st.columns(3)
    
    with col1:
        st.markdown("""
        <div class='card' style='text-align: center;'>
            <h3 style='color: #3498db;'>SCI论文</h3>
            <p style='font-size: 2rem; font-weight: bold;'>47篇</p>
            <p>其中通讯作者35篇，第一作者5篇</p>
        </div>
        """, unsafe_allow_html=True)
    
    with col2:
        st.markdown("""
        <div class='card' style='text-align: center;'>
            <h3 style='color: #e74c3c;'>通讯/第一作者论文</h3>
            <p style='font-size: 2rem; font-weight: bold;'>40篇</p>
            <p>总影响因子206.05</p>
        </div>
        """, unsafe_allow_html=True)
    
    with col3:
        st.markdown("""
        <div class='card' style='text-align: center;'>
            <h3 style='color: #2ecc71;'>中文核心期刊论文</h3>
            <p style='font-size: 2rem; font-weight: bold;'>41篇</p>
            <p>其中通讯作者26篇，第一作者9篇</p>
        </div>
        """, unsafe_allow_html=True)

# 数据查询
elif nav_option == "数据查询":
    st.markdown("<h1 class='main-header'>数据查询</h1>", unsafe_allow_html=True)
    
    # 加载数据
    seu_data = load_data()
    
    if seu_data is not None:
        # 侧边栏 - 基因输入
        with st.sidebar:
            st.markdown("<h3>基因查询</h3>", unsafe_allow_html=True)
            gene_input = st.text_input("输入基因名称", value="CD69")
            update_plots = st.button("更新图表")
            
            # 数据信息
            st.markdown("<h3>数据信息</h3>", unsafe_allow_html=True)
            st.write(f"细胞数量: {seu_data.shape[1]}")
            st.write(f"基因数量: {seu_data.shape[0]}")
            st.write(f"细胞类型: {len(seu_data.obs['Celltype'].unique())}")
            st.write(f"实验组别: {len(seu_data.obs['Group'].unique())}")
        
        # 主面板
        tab1, tab2, tab3, tab4 = st.tabs(["小提琴图", "特征图", "密度图", "表达二元分析"])
        
        # 基因验证
        if update_plots:
            all_genes = seu_data.var_names.tolist()
            
            if gene_input in all_genes:
                st.markdown(f"<div class='gene-valid'>✓ 基因 '{gene_input}' 存在于数据集中</div>", unsafe_allow_html=True)
                
                # 小提琴图
                with tab1:
                    st.markdown("<h2 class='section-title'>基因表达小提琴图</h2>", unsafe_allow_html=True)
                    
                    try:
                        # 提取基因表达数据
                        gene_expr = seu_data[:, gene_input].X.toarray().flatten()
                        
                        # 准备绘图数据
                        plot_data = pd.DataFrame({
                            "Expression": gene_expr,
                            "Celltype": seu_data.obs["Celltype"].tolist(),
                            "Group": seu_data.obs["Group"].tolist()
                        })
                        
                        # 创建小提琴图
                        fig = px.violin(
                            plot_data, x="Celltype", y="Expression", color="Group",
                            box=True, points="all", hover_data=plot_data.columns,
                            title=f"{gene_input} 基因在不同细胞类型和组别的表达分布",
                            color_discrete_map={"NP": "#4575B4", "URSA": "#A50026"}
                        )
                        
                        # 更新布局
                        fig.update_layout(
                            xaxis_title="细胞类型",
                            yaxis_title=f"{gene_input} 表达水平",
                            xaxis_tickangle=-45,
                            height=600
                        )
                        
                        st.plotly_chart(fig, use_container_width=True)
                        
                    except Exception as e:
                        st.error(f"绘制小提琴图失败: {e}")
                
                # 特征图
                with tab2:
                    st.markdown("<h2 class='section-title'>基因表达特征图</h2>", unsafe_allow_html=True)
                    st.info("特征图功能开发中...")
                
                # 密度图
                with tab3:
                    st.markdown("<h2 class='section-title'>基因表达密度图</h2>", unsafe_allow_html=True)
                    st.info("密度图功能开发中...")
                
                # 表达二元分析
                with tab4:
                    st.markdown("<h2 class='section-title'>表达二元分析</h2>", unsafe_allow_html=True)
                    
                    # 表达阈值滑块
                    expression_threshold = st.slider("表达阈值 (%)", min_value=0, max_value=100, value=50, step=1)
                    
                    try:
                        # 提取基因表达数据
                        gene_expr = seu_data[:, gene_input].X.toarray().flatten()
                        
                        # 计算阈值
                        threshold_value = np.percentile(gene_expr, expression_threshold)
                        
                        # 分类为阳性/阴性
                        expression_binary = np.where(gene_expr > threshold_value, "Positive", "Negative")
                        
                        # 准备数据
                        binary_data = pd.DataFrame({
                            "Group": seu_data.obs["Group"].tolist(),
                            "Expression": expression_binary
                        })
                        
                        # 计算比例
                        prop_data = binary_data.groupby(["Group", "Expression"]).size().reset_index(name="Count")
                        prop_data["Proportion"] = prop_data.groupby("Group")["Count"].transform(lambda x: (x / x.sum()) * 100)
                        
                        # 创建堆叠柱状图
                        fig = px.bar(
                            prop_data, x="Group", y="Proportion", color="Expression",
                            title=f"{gene_input} 基因在不同组别中的表达比例",
                            color_discrete_map={"Positive": "#E74C3C", "Negative": "#3498DB"},
                            text=prop_data["Proportion"].round(1).astype(str) + "%"
                        )
                        
                        # 更新布局
                        fig.update_layout(
                            xaxis_title="组别",
                            yaxis_title="比例 (%)",
                            height=500
                        )
                        
                        st.plotly_chart(fig, use_container_width=True)
                        
                        # Fisher精确检验
                        st.markdown("<h3> Fisher精确检验结果</h3>", unsafe_allow_html=True)
                        
                        # 创建列联表
                        contingency_table = pd.crosstab(binary_data["Group"], binary_data["Expression"])
                        st.write("列联表:")
                        st.dataframe(contingency_table)
                        
                        # 执行Fisher精确检验
                        odds_ratio, p_value = fisher_exact(contingency_table)
                        
                        st.write(f"优势比 (Odds Ratio): {odds_ratio:.3f}")
                        st.write(f"p值 (p-value): {p_value:.4f}")
                        
                        # 显著性标记
                        if p_value < 0.001:
                            st.write("显著性: *** (p < 0.001)")
                        elif p_value < 0.01:
                            st.write("显著性: ** (p < 0.01)")
                        elif p_value < 0.05:
                            st.write("显著性: * (p < 0.05)")
                        else:
                            st.write("显著性: 无显著性差异 (p ≥ 0.05)")
                        
                    except Exception as e:
                        st.error(f"二元分析失败: {e}")
            
            else:
                st.markdown(f"<div class='gene-invalid'>✗ 错误: 基因 '{gene_input}' 不存在于数据集中，请检查基因名称</div>", unsafe_allow_html=True)
                
                # 查找相似基因
                similar_genes = [gene for gene in all_genes if gene_input.lower() in gene.lower()][:5]
                if similar_genes:
                    st.write("可能的基因名称:")
                    for gene in similar_genes:
                        st.write(f"- {gene}")
        
        else:
            st.info("请输入基因名称并点击'更新图表'按钮开始分析")
