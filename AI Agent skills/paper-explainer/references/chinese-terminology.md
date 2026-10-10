# Chinese-English Statistical/Machine Learning Terminology Glossary

Maintain consistent terminology across all generated explanations. When introducing a term for the first time in a document, provide both Chinese and English forms.

## Core Statistical Concepts

| English | Chinese | Notes |
|---|---|---|
| Tensor | 张量 | Multi-dimensional array |
| Scalar | 标量 | Zero-order tensor |
| Vector | 向量 | First-order tensor |
| Matrix | 矩阵 | Second-order tensor |
| Covariate / Predictor | 协变量 / 预测变量 | Input variable |
| Response / Outcome | 响应变量 / 结果变量 | Output variable |
| Regression | 回归 | Predicting continuous outcome |
| Classification | 分类 | Predicting categorical outcome |
| Residual | 残差 | Observed minus predicted |
| Degrees of freedom | 自由度 | Number of free parameters |
| Bias-variance tradeoff | 偏差-方差权衡 | Underfitting vs overfitting balance |
| Overfitting | 过拟合 | Model too complex for data |
| Regularization | 正则化 | Penalizing model complexity |
| Cross-validation | 交叉验证 | Data-splitting for tuning |
| Consistency | 一致性 | Estimator converges to truth |
| Convergence rate | 收敛速度 | How fast estimator approaches truth |
| Asymptotic | 渐近 | As sample size → ∞ |

## Tensor-Specific Terminology

| English | Chinese | Notes |
|---|---|---|
| Outer product | 外积 | Symbol: $\circ$ |
| Inner product (tensor) | 张量内积 | Element-wise product then sum |
| CP decomposition (CANDECOMP/PARAFAC) | CP分解 / 规范多态分解 | Sum of rank-1 tensors |
| Tucker decomposition | Tucker分解 | Core tensor × factor matrices |
| CP rank | CP秩 | Number of rank-1 components |
| Mode-k unfolding / matricization | 模-k展开 / 矩阵化 | Reshape tensor along mode k |
| Vectorization | 向量化 | Flatten to vector |
| Khatri-Rao product | Khatri-Rao积 | Column-wise Kronecker product |
| Kronecker product | Kronecker积 | Symbol: $\otimes$ |
| Contracted tensor product | 收缩张量积 | Multi-mode tensor contraction |
| Broadcasting | 广播 | Element-wise function distribution |
| Rank-1 tensor | 秩1张量 | Single outer product of vectors |
| Multi-way / multi-dimensional array | 多维数组 | Alternative name for tensor |

## Nonparametric Regression Terms

| English | Chinese | Notes |
|---|---|---|
| Nonparametric regression | 非参数回归 | No fixed parametric form |
| B-spline | B样条 | Basis expansion for smooth functions |
| Spline basis function | 样条基函数 | Building blocks of spline |
| Knot | 节点 | Spline breakpoints |
| Smoothing parameter | 光滑参数 | Controls function roughness |
| Curse of dimensionality | 维度灾难 | Exponential sample size need |
| Additive model | 加性模型 | Sum of univariate functions |
| Single-index model | 单指标模型 | g(linear combination) form |
| Hölder condition | Hölder条件 | Smoothness condition on derivatives |
| Sub-Gaussian | 子高斯 | Tail probability ≤ Gaussian |

## Penalization & Optimization

| English | Chinese | Notes |
|---|---|---|
| Lasso (L1 penalty) | Lasso / L1惩罚 | Sparse solution |
| Ridge (L2 penalty) | 岭回归 / L2惩罚 | Shrinkage |
| Elastic net | 弹性网 | L1 + L2 combination |
| Penalized likelihood | 惩罚似然 | Likelihood + penalty term |
| Block coordinate descent | 块坐标下降 | Update parameter blocks sequentially |
| Alternating least squares (ALS) | 交替最小二乘 | Iterative factor matrix updates |
| Stationary point | 稳定点 | Gradient ≈ 0 |
| Global optimum | 全局最优 | True minimum |
| Identifiability | 可识别性 | Uniqueness of parameters |

## Bayesian Inference

| English | Chinese | Notes |
|---|---|---|
| Prior distribution | 先验分布 | Belief before seeing data |
| Posterior distribution | 后验分布 | Belief after seeing data |
| Full conditional | 全条件分布 | Conditional on all other parameters |
| Gibbs sampling | Gibbs采样 | MCMC via full conditionals |
| Credible interval | 可信区间 | Bayesian uncertainty interval |
| Posterior mode (MAP) | 后验众数 | Most probable parameter value |
| Jeffreys prior | Jeffreys先验 | Non-informative prior |

## Application Domains

| English | Chinese | Notes |
|---|---|---|
| Neuroimaging | 神经影像 | fMRI, EEG, ECoG |
| Voxel | 体素 | 3D pixel in brain imaging |
| Electrocorticography (ECoG) | 皮层电图 | Brain surface recording |
| fMRI | 功能磁共振成像 | Functional MRI |
| EEG | 脑电图 | Electroencephalography |
| Genomics | 基因组学 | Gene expression data |
| Recommendation system | 推荐系统 | User-item interaction |

## Phrase Templates

Use these patterns consistently:

- "直观理解" (intuitive understanding) — start informal explanations
- "通俗地说" (in plain terms) — introduce a simplified version
- "正式定义" (formal definition) — transition to precise definition
- "换句话说" (in other words) — rephrase a complex statement
- "值得注意的是" (it's worth noting) — highlight a subtle point
- "这意味着" (this means) — draw a concrete implication
- "关键在于" (the key insight is) — emphasize the central idea
- "下面通过一个具体的例子来说明" (let's illustrate with a concrete example) — before examples
