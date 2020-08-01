# 4.1.4.2 B树&B树变型


可视化
https://www.cs.usfca.edu/~galles/visualization/RedBlack.html



## 遍历二叉树的算法

![二叉树与普通树](./../../sources/images/traversing-binary-tree.png)

图(a)，是一棵二叉树，对于初学者而言遍历这棵二叉树无非有以下 2 种方式


### 层次遍历

前面讲过，树是有层次的，拿图(a) 来说，该二叉树的层次为 3。

<font color=#008000>层次遍历</font> :通过对树中各层的节点从左到右依次遍历，即可实现对正棵二叉树的遍历，此种方式称为层次遍历。

比如，对图(1) 中二叉树进行层次遍历，遍历过程如图所示：

![层序遍历二叉树](./../../sources/images/hierarchical-traversal-of-a-binary-tree.png)

### 普通遍历

其实，还有一种更普通的遍历二叉树的思想，即按照 "从上到下，从左到右" 的顺序遍历整棵二叉树。

还拿图 1 中的二叉树举例，其遍历过程如图所示：

![普通方式遍历二叉树](./../../sources/images/the-normal-way-of-traversal-a-binary-tree.png)

以上仅是从初学者的角度，对遍历二叉树的过程进行了分析。接下来我们从程序员的角度再对以上两种遍历方式进行剖析。

<table><tr><td bgcolor=PowderBlue>
这里，我们要建立一个共识，即成功遍历二叉树的标志是能够成功访问到二叉树中所有的节点。
</td></tr></table>

