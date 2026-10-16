# 3.2.8 拉普拉斯变换（Laplace Transform）

在概率论与随机过程、概率生成函数及矩母函数（MGF）的推导中，**拉普拉斯变换**是一个将复杂的微积分运算转化为代数运算的强力工具。

### 1. 核心概念与直观框架

拉普拉斯变换可以将时间域（或原空间）的函数 $f(t)$ 映射到复频域 $s$ 空间。在统计学中，它常与期望算子结合，用来求解随机变量的特征与概率密度。

```mermaid
graph LR
    A["原函数 f t (概率密度或矩母函数)"] -->|Laplace变换: \int_0^\infty e^{-st} f t dt| B["复频域函数 F s"]
    B -->|代数运算 (求导/卷积简化)| C[求解高阶矩或微分方程]
    style A fill:#fff9c4,stroke:#fbc02d,stroke-width:2px
    style B fill:#c8e6c9,stroke:#388e3c,stroke-width:2px

```

### 2. 数学定义

对于定义在 $t \ge 0$ 上的函数 $f(t)$，其单边拉普拉斯变换定义为：

$$F(s) = \mathcal{L}\{f(t)\} = \int_{0}^{\infty} e^{-st} f(t) dt$$

#### 在概率论中的核心应用：矩母函数（MGF）

随机变量 $X$ 的矩母函数定义为 $M_X(t) = \mathbb{E}[e^{tX}]$。如果将 $t$ 视为负的拉普拉斯变元，MGF 本质上就是概率密度函数 $p(x)$ 的拉普拉斯变换的变体：


$$M_X(t) = \int_{-\infty}^{\infty} e^{tx} p(x) dx$$


通过对 MGF 求导，我们可以极其简便地获取随机变量的各项原点矩（均值、方差等）。

---
