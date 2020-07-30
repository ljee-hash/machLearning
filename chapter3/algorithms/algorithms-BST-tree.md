# 4.1.4.1 BST二叉查找树

## 二叉查找树（Binary Search Tree）

二叉查找树（BST：Binary Search Tree）是一种特殊的二叉树，它改善了二叉树节点查找的效率。二叉查找树有以下性质：

对于任意一个节点 n，
- 其左子树（left subtree）下的每个后代节点（descendant node）的值都小于节点 n 的值；
- 其右子树（right subtree）下的每个后代节点的值都大于节点 n 的值。

所谓节点 n 的子树，可以将其看作是以节点 n 为根节点的树。子树的所有节点都是节点 n 的后代，而子树的根则是节点 n 本身。