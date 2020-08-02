# 4.1.4.5 红黑树算法和应用(更高级的二叉查找树)

## 定义


红黑树（R-B TREE，全称：Red-Black Tree），本身是一棵二叉查找树，在其基础上附加了两个要求：

1. 树中的每个结点增加了一个用于存储颜色的标志域；
1. 树中没有一条路径比其他任何路径长出两倍，整棵树要接近于“平衡”的状态。

> 这里所指的路径，指的是从任何一个结点开始，一直到其子孙的叶子结点的长度；接近于平衡：红黑树并不是平衡二叉树，只是由于对各路径的长度之差有限制，所以近似于平衡的状态。


<font color=red>红黑树对于结点的颜色设置不是任意的，需满足以下性质的二叉查找树才是红黑树：</font>

- 树中的每个结点颜色不是红的，就是黑的；
- 根结点的颜色是黑的；
- 所有为 nil 的叶子结点的颜色是黑的；（注意：叶子结点说的只是为空（nil 或 NULL）的叶子结点！）
- 如果此结点是红的，那么它的两个孩子结点全部都是黑的；
- 对于每个结点，从该结点到到该结点的所有子孙结点的所有路径上包含有相同数目的黑结点；


![图 1 红黑树](http://data.biancheng.net/uploads/allimg/171206/2-1G2061610041F.png)


<font color=red>注意：</font>

> 图中每个结点附带一个整形数值，表示的是此结点的黑高度（从该结点到其子孙结点中包含的黑结点数，用 bh(x) 表示（x 表示此结点）），nil 的黑高度为 0，颜色为黑色（在编程时为节省空间，所有的 nil 共用一个存储空间）。在计算黑高度时，也看做是一个黑结点。

<font color=red>红黑树中每个结点都有各自的黑高度，整棵树也有自己的黑高度，即为根结点的黑高度，例如图 1 中的红黑树的黑高度为 3。</font>



<font color=red>对于一棵具有 n 个结点的红黑树，树的高度至多为：2lg(n+1)。</font>

> 由此可推出红黑树进行查找操作时的时间复杂度为O(lgn)，因为对于高度为 h 的二叉查找树的运行时间为O(h)，而包含有 n 个结点的红黑树本身就是最高为 lgn（简化之后）的查找树（h=lgn），所以红黑树的时间复杂度为O(lgn)。

红黑树本身作为一棵二叉查找树，所以其任务就是用于动态表中数据的插入和删除的操作。在进行该操作时，避免不了会破坏红黑树的结构，此时就需要进行适当的调整，使其重新成为一棵红黑树，可以从两个方面着手对树进行调整：

- 调整树中某些结点的指针结构；
- 调整树中某些结点的颜色；


## 红黑树的旋转

当使用红黑树进行插入或者删除结点的操作时，可能会破坏红黑树的 5 条性质，从而变成了一棵普通树，此时就可以通过对树中的某些子树进行旋转，从而使整棵树重新变为一棵红黑树。

<font color=red>旋转操作：</font>分为左旋和右旋，同二叉排序树转平衡二叉树的旋转原理完全相同。例如图 2 表示的是对一棵二叉查找树中局部子树进行左旋和右旋操作：

![图 2 旋转操作](http://data.biancheng.net/uploads/allimg/171206/2-1G2061613253H.png)

<font color=red>左旋：</font>如图 2 所示，左旋时 y 结点变为该部分子树的根结点，同时 x 结点（连同其左子树 a）移动至 y 结点的左孩子。若 y 结点有左孩子 b，由于 x 结点需占用其位置，所以调整至 x 结点的右孩子处。

<font color=red>左旋操作的具体实现函数：</font>

```c
//T表示为树根，x 表示需要进行左旋的子树的根结点
void rbTree_left_rotate( RBT_Root* T, RB_TREE* x){
    RB_TREE* y = x->right;//找到根结点的右子树
   
    x->right = y->left;//将右子树的左孩子移动至结点 x 的右孩子处
    if(x->right != T->nil){//如果 x 的右子树不是nil，需重新连接 右子树的双亲结点为 x
        x->right->p = x;
    }
    y->p = x->p;//设置 y 的双亲结点为 x 的双亲结点
    //重新设置 y 的双亲结点同 y 的连接，分为 2 种情况：1、原 x 结点本身就是整棵树的数根结点，此时只需要将 T 指针指向 y；2、根据 y 中关键字同其父结点关键字的值的大小，判断 y 是父结点的左孩子还是右孩子
    if(y->p == T->nil){
        T->root = y;
    }else if(y->key < y->p->key){
        y->p->left = y;
    }else{
        y->p->right = y;
    }
    y->left = x;//将 x 连接给 y 结点的左孩子处
    x->p = y;//设置 x 的双亲结点为 y。
}

```

<font color=red>右旋：</font>如图 2 所示，同左旋是同样的道理，x 结点变为根结点，同时 y 结点连同其右子树 c 作为 x 结点的右子树，原 x 结点的右子树 b 变为 y 结点的左子树。


<font color=red>右旋的具体代码实现：</font>

```c
void rbTree_right_rotate( RBT_Root* T, RB_TREE* x){
    RB_TREE * y = x->left;
    x->left = y->right;
    if(T->nil != x->left){
        x->left->p = x;
    }
    y->p = x->p;
    if(y->p == T->nil){
        T->root = y;
    }else if(y->key < y->p->key){
        y->p->left= y;
    }else{
        y->p->right = y;
    }
    y->right = x;
    x->p = y;
}
```


## 红黑树中插入新结点


当创建一个红黑树或者向已有红黑树中插入新的数据时，只需要按部就班地执行以下 3 步：

- 由于红黑树本身是一棵二叉查找树，所以在插入新的结点时，完全按照二叉查找树插入结点的方法，找到新结点插入的位置；
- 将新插入的结点结点初始化，颜色设置为红色后插入到指定位置；（将新结点初始化为红色插入后，不会破坏红黑树第 5 条的性质）
- 由于插入新的结点，可能会破坏红黑树第 4 条的性质（若其父结点颜色为红色，就破坏了红黑树的性质），此时需要调整二叉查找树，想办法通过旋转以及修改树中结点的颜色，使其重新成为红黑树！



插入结点的第 1 步和第 2 步都非常简单，关键在于最后一步对树的调整！在红黑树中插入结点时，根据插入位置的不同可分为以下 3 种情况：

1. 插入位置为整棵树的树根。处理办法：只需要将插入结点的颜色改为黑色即可。
1. 插入位置的双亲结点的颜色为黑色。处理方法：此种情况不需要做任何工作，新插入的颜色为红色的结点不会破坏红黑树的性质。
1. 插入位置的双亲结点的颜色为红色。处理方法：由于插入结点颜色为红色，其双亲结点也为红色，破坏了红黑树第 4 条性质，此时需要结合其祖父结点和祖父结点的另一个孩子结点（父结点的兄弟结点，此处称为“叔叔结点”）的状态，分为 3 种情况讨论:

> 当前结点的父节点是红色，且“叔叔结点”也是红色：破坏了红黑树的第 4 条性质，解决方案为：将父结点颜色改为黑色；将叔叔结点颜色改为黑色；将祖父结点颜色改为红色；下一步将祖父结点认做当前结点，继续判断，处理结果如下图所示：

<font color=red>分析：</font>

此种情况下，由于父结点和当前结点颜色都是红色，所以为了不产生冲突，将父结点的颜色改为黑色。但是虽避免了破坏第 4 条，但是却导致该条路径上的黑高度增加了 1 ，破坏了第 5 条性质。但是在将祖父结点颜色改为红色、叔叔结点颜色改为黑色后，该部分子树没有破坏第 5 条性质。但是由于将祖父结点的颜色改变，还需判断是否破坏了上层树的结构，所以需要将祖父结点看做当前结点，继续判断。


> 当前结点的父结点颜色为红色，叔叔结点颜色为黑色，且当前结点是父结点的右孩子。解决方案：将父结点作为当前结点做左旋操作。

![](http://data.biancheng.net/uploads/allimg/171206/2-1G206161K4648.png)

<font color=red>提示：</font>
在进行以父结点为当前结点的左旋操作后，此种情况就转变成了第 3 种情况，处理过程跟第 3 种情况同步进行。
 

> 当前结点的父结点颜色为红色，叔叔结点颜色为黑色，且当前结点是父结点的左孩子。解决方案：将父结点颜色改为黑色，祖父结点颜色改为红色，从祖父结点处进行右旋处理。如下图所示：

![](http://data.biancheng.net/uploads/allimg/171206/2-1G206161Q4636.png)

<font color=red>分析：</font>

在此种情况下，由于当前结点 F 和父结点 S 颜色都为红色，违背了红黑树的性质 4，此时可以将 S 颜色改为黑色，有违反了性质 5，因为所有通过 S 的路径其黑高度都增加了 1 ，所以需要将其祖父结点颜色设为红色后紧接一个右旋，这样这部分子树有成为了红黑树。（上图中的有图虽看似不是红黑树，但是只是整棵树的一部分，以 S 为根结点的子树一定是一棵红黑树）


<font color=red>红黑树中插入结点的具体实现代码：</font>


```c
void RB_Insert_Fixup(RBT_Root* T, RB_TREE* x){
    //首先判断其父结点颜色为红色时才需要调整；为黑色时直接插入即可，不需要调整
    while (x->p->color == RED) {
        //由于还涉及到其叔叔结点，所以此处需分开讨论，确定父结点是祖父结点的左孩子还是右孩子
        if (x->p == x->p->p->left) {
            RB_TREE * y = x->p->p->right;//找到其叔叔结点
            //如果叔叔结点颜色为红色，此为第 1 种情况，处理方法为：父结点颜色改为黑色；叔叔结点颜色改为黑色；祖父结点颜色改为红色，将祖父结点赋值为当前结点，继续判断；
            if (y->color == RED) {
                x->p->color = BLACK;
                y->color = BLACK;
                x->p->p->color = RED;
                x = x->p->p;
            }else{
                //反之，如果叔叔结点颜色为黑色，此处需分为两种情况：1、当前结点时父结点的右孩子；2、当前结点是父结点的左孩子
                if (x == x->p->right) {
                    //第 2 种情况：当前结点时父结点的右孩子。解决方案：将父结点作为当前结点做左旋操作。
                    x = x->p;
                    rbTree_left_rotate(T, x);
                }else{
                    //第 3 种情况：当前结点是父结点的左孩子。解决方案：将父结点颜色改为黑色，祖父结点颜色改为红色，从祖父结点处进行右旋处理。
                    x->p->color = BLACK;
                    x->p->p->color = RED;
                    rbTree_right_rotate(T, x->p->p);
                }
            }
        }else{//如果父结点时祖父结点的右孩子，换汤不换药，只需将以上代码部分中的left改为right即可，道理是一样的。
            RB_TREE * y = x->p->p->left;
            if (y->color == RED) {
                x->p->color = BLACK;
                y->color = BLACK;
                x->p->p->color = RED;
                x = x->p->p;
            }else{
                if (x == x->p->left) {
                    x = x->p;
                    rbTree_right_rotate(T, x);
                }else{
                    x->p->color = BLACK;
                    x->p->p->color = RED;
                    rbTree_left_rotate(T, x->p->p);
                }
            }
        }
    }
    T->root->color = BLACK;
}
//插入操作分为 3 步：1、将红黑树当二叉查找树，找到其插入位置；2、初始化插入结点，将新结点的颜色设为红色；3、通过调用调整函数，将二叉查找树重新改为红黑树
void rbTree_insert(RBT_Root**T, int k){
    //1、找到其要插入的位置。解决思路为：从树的根结点开始，通过不断的同新结点的值进行比较，最终找到插入位置
    RB_TREE * x, *p;
    x = (*T)->root;
    p = x;
   
    while(x != (*T)->nil){
        p = x;
        if(k<x->key){
            x = x->left;
        }else if(k>x->key){
            x = x->right;
        }else{
            printf("\n%d已存在\n",k);
            return;
        }
    }
    //初始化结点，将新结点的颜色设为红色
    x = (RB_TREE *)malloc(sizeof(RB_TREE));
    x->key = k;
    x->color = RED;
    x->left = x->right =(*T)->nil;
    x->p = p;
   
    //对新插入的结点，建立与其父结点之间的联系
    if((*T)->root == (*T)->nil){
        (*T)->root = x;
    }else if(k < p->key){
        p->left = x;
    }else{
        p->right = x;
    }
    //3、对二叉查找树进行调整
    RB_Insert_Fixup((*T),x);
}
```

## 红黑树中删除结点

在红黑树中删除结点，思路更简单，只需要完成 2 步操作：

1. 将红黑树按照二叉查找树删除结点的方法删除指定结点；
1. 重新调整删除结点后的树，使之重新成为红黑树；（还是通过旋转和重新着色的方式进行调整）

在二叉查找树删除结点时，分为 3 种情况：

- 若该删除结点本身是叶子结点，则可以直接删除；
- 若只有一个孩子结点（左孩子或者右孩子），则直接让其孩子结点顶替该删除结点；
- 若有两个孩子结点，则找到该结点的右子树中值最小的叶子结点来顶替该结点，然后删除这个值最小的叶子结点。



以上三种情况最终都需要删除某个结点，此时需要判断删除该结点是否会破坏红黑树的性质。判断的依据是：

1. 如果删除结点的颜色为红色，则不会破坏；
1. 如果删除结点的颜色为黑色，则肯定会破坏红黑树的第 5 条性质，此时就需要对树进行调整，调整方案分 4 种情况讨论：


- 删除结点的兄弟结点颜色是红色，调整措施为：将兄弟结点颜色改为黑色，父亲结点改为红色，以父亲结点来进行左旋操作，同时更新删除结点的兄弟结点（左旋后兄弟结点发生了变化），如下图所示：


![](http://data.biancheng.net/uploads/allimg/171206/2-1G206162042Y4.png)


- 删除结点的兄弟结点及其孩子全部都是黑色的，调整措施为：将删除结点的兄弟结点设为红色，同时设置删除结点的父结点标记为新的结点，继续判断；
- 删除结点的兄弟结点是黑色，其左孩子是红色，右孩子是黑色。调整措施为：将兄弟结点设为红色，兄弟结点的左孩子结点设为黑色，以兄弟结点为准进行右旋操作，最终更新删除结点的兄弟结点；
- 删除结点的兄弟结点是黑色，其右孩子是红色（左孩子不管是什么颜色），调整措施为：将删除结点的父结点的颜色赋值给其兄弟结点，然后再设置父结点颜色为黑色，兄弟结点的右孩子结点为黑色，根据其父结点做左旋操作，最后设置替换删除结点的结点为根结点；


<font color=red>红黑树删除结点具体实现代码为：</font>


```c
void rbTree_transplant(RBT_Root* T, RB_TREE* u, RB_TREE* v){
    if(u->p == T->nil){
        T->root = v;
    }else if(u == u->p->left){
        u->p->left=v;
    }else{
        u->p->right=v;
    }
    v->p = u->p;
}
void RB_Delete_Fixup(RBT_Root**T,RB_TREE*x){
    while(x != (*T)->root && x->color == BLACK){
        if(x == x->p->left){
            RB_TREE* w = x->p->right;
            //第 1 种情况：兄弟结点是红色的
            if(RED == w->color){
                w->color = BLACK;
                w->p->color = RED;
                rbTree_left_rotate((*T),x->p);
                w = x->p->right;
            }
            //第2种情况：兄弟是黑色的，并且兄弟的两个儿子都是黑色的。
            if(w->left->color == BLACK && w->right->color == BLACK){
                w->color = RED;
                x = x->p;
            }
            //第3种情况
            if(w->left->color == RED && w->right->color == BLACK){
                w->left->color = BLACK;
                w->color = RED;
                rbTree_right_rotate((*T),w);
                w = x->p->right;
            }
            //第4种情况
            if (w->right->color == RED) {
                w->color = x->p->color;
                x->p->color = BLACK;
                w->right->color = BLACK;
                rbTree_left_rotate((*T),x->p);
                x = (*T)->root;
            }
        }else{
            RB_TREE* w = x->p->left;
            //第 1 种情况
            if(w->color == RED){
                w->color = BLACK;
                x->p->color = RED;
                rbTree_right_rotate((*T),x->p);
                w = x->p->left;
            }
            //第 2 种情况
            if(w->left->color == BLACK && w->right->color == BLACK){
                w->color = RED;
                x = x->p;
            }
            //第 3 种情况
            if(w->left->color == BLACK && w->right->color == RED){
                w->color = RED;
                w->right->color = BLACK;
                w = x->p->left;
            }
            //第 4 种情况
            if (w->right->color == BLACK){
                w->color=w->p->color;
                x->p->color = BLACK;
                w->left->color = BLACK;
                rbTree_right_rotate((*T),x->p);
                x = (*T)->root;
            }
        }
    }
    x->color = BLACK;//最终将根结点的颜色设为黑色
}
void rbTree_delete(RBT_Root* *T, int k){
    if(NULL == (*T)->root){
        return ;
    }
    //找到要被删除的结点
    RB_TREE * toDelete = (*T)->root;
    RB_TREE * x = NULL;
    //找到值为k的结点
    while(toDelete != (*T)->nil && toDelete->key != k){
        if(k<toDelete->key){
            toDelete = toDelete->left;
        }else if(k>toDelete->key){
            toDelete = toDelete->right;
        }
    }
    if(toDelete == (*T)->nil){
        printf("\n%d 不存在\n",k);
        return;
    }
    //如果两个孩子，就找到右子树中最小的结点，将之代替，然后直接删除该结点即可
    if(toDelete->left != (*T)->nil && toDelete->right != (*T)->nil){
        RB_TREE* alternative = rbt_findMin((*T), toDelete->right);
        k = toDelete->key = alternative->key;//这里只对值进行复制，并不复制颜色，以免破坏红黑树的性质
        toDelete = alternative;
    }
    //如果只有一个孩子结点（只有左孩子或只有右孩子），直接用孩子结点顶替该结点位置即可（没有孩子结点的也走此判断语句）。
    if(toDelete->left == (*T)->nil){
        x = toDelete->right;
        rbTree_transplant((*T),toDelete,toDelete->right);
    }else if(toDelete->right == (*T)->nil){
        x = toDelete->left;
        rbTree_transplant((*T),toDelete,toDelete->left);
    }
    //在删除该结点之前，需判断此结点的颜色：如果是红色，直接删除，不会破坏红黑树；若是黑色，删除后会破坏红黑树的第 5 条性质，需要对树做调整。
    if(toDelete->color == BLACK){
        RB_Delete_Fixup(T,x);
    }
    //最终可以彻底删除要删除的结点，释放其占用的空间
    free(toDelete);
}
```

## 本节完整实现代码


```c
#include <stdio.h>
#include <stdlib.h>

typedef enum {RED, BLACK} ColorType;
typedef struct RB_TREE{
    int key;
    struct  RB_TREE * left;
    struct  RB_TREE * right;
    struct  RB_TREE * p;
    ColorType color;
}RB_TREE;

typedef struct RBT_Root{
    RB_TREE* root;
    RB_TREE* nil;
}RBT_Root;

RBT_Root* rbTree_init(void);
void rbTree_insert(RBT_Root* *T, int k);
void rbTree_delete(RBT_Root* *T, int k);

void rbTree_transplant(RBT_Root* T, RB_TREE* u, RB_TREE* v);

void rbTree_left_rotate( RBT_Root* T, RB_TREE* x);
void rbTree_right_rotate( RBT_Root* T, RB_TREE* x);

void rbTree_inPrint(RBT_Root* T, RB_TREE* t);
void rbTree_prePrint(RBT_Root * T, RB_TREE* t);
void rbTree_print(RBT_Root* T);

RB_TREE* rbt_findMin(RBT_Root * T, RB_TREE* t);
RB_TREE* rbt_findMin(RBT_Root * T, RB_TREE* t){
    if(t == T->nil){
        return T->nil;
    }
    while(t->left != T->nil){
        t = t->left;
    }
    return t;
}
RBT_Root* rbTree_init(void){
    RBT_Root* T;
    T = (RBT_Root*)malloc(sizeof(RBT_Root));
    T->nil = (RB_TREE*)malloc(sizeof(RB_TREE));
    T->nil->color = BLACK;
    T->nil->left = T->nil->right = NULL;
    T->nil->p = NULL;
    T->root = T->nil;
    return T;
}

void RB_Insert_Fixup(RBT_Root* T, RB_TREE* x){
    //首先判断其父结点颜色为红色时才需要调整；为黑色时直接插入即可，不需要调整
    while (x->p->color == RED) {
        //由于还涉及到其叔叔结点，所以此处需分开讨论，确定父结点是祖父结点的左孩子还是右孩子
        if (x->p == x->p->p->left) {
            RB_TREE * y = x->p->p->right;//找到其叔叔结点
            //如果叔叔结点颜色为红色，此为第 1 种情况，处理方法为：父结点颜色改为黑色；叔叔结点颜色改为黑色；祖父结点颜色改为红色，将祖父结点赋值为当前结点，继续判断；
            if (y->color == RED) {
                x->p->color = BLACK;
                y->color = BLACK;
                x->p->p->color = RED;
                x = x->p->p;
            }else{
                //反之，如果叔叔结点颜色为黑色，此处需分为两种情况：1、当前结点时父结点的右孩子；2、当前结点是父结点的左孩子
                if (x == x->p->right) {
                    //第 2 种情况：当前结点时父结点的右孩子。解决方案：将父结点作为当前结点做左旋操作。
                    x = x->p;
                    rbTree_left_rotate(T, x);
                }else{
                    //第 3 种情况：当前结点是父结点的左孩子。解决方案：将父结点颜色改为黑色，祖父结点颜色改为红色，从祖父结点处进行右旋处理。
                    x->p->color = BLACK;
                    x->p->p->color = RED;
                    rbTree_right_rotate(T, x->p->p);
                }
            }
        }else{//如果父结点时祖父结点的右孩子，换汤不换药，只需将以上代码部分中的left改为right即可，道理是一样的。
            RB_TREE * y = x->p->p->left;
            if (y->color == RED) {
                x->p->color = BLACK;
                y->color = BLACK;
                x->p->p->color = RED;
                x = x->p->p;
            }else{
                if (x == x->p->left) {
                    x = x->p;
                    rbTree_right_rotate(T, x);
                }else{
                    x->p->color = BLACK;
                    x->p->p->color = RED;
                    rbTree_left_rotate(T, x->p->p);
                }
            }
        }
    }
    T->root->color = BLACK;
}
//插入操作分为 3 步：1、将红黑树当二叉查找树，找到其插入位置；2、初始化插入结点，将新结点的颜色设为红色；3、通过调用调整函数，将二叉查找树重新改为红黑树
void rbTree_insert(RBT_Root**T, int k){
    //1、找到其要插入的位置。解决思路为：从树的根结点开始，通过不断的同新结点的值进行比较，最终找到插入位置
    RB_TREE * x, *p;
    x = (*T)->root;
    p = x;
   
    while(x != (*T)->nil){
        p = x;
        if(k<x->key){
            x = x->left;
        }else if(k>x->key){
            x = x->right;
        }else{
            printf("\n%d已存在\n",k);
            return;
        }
    }
    //初始化结点，将新结点的颜色设为红色
    x = (RB_TREE *)malloc(sizeof(RB_TREE));
    x->key = k;
    x->color = RED;
    x->left = x->right =(*T)->nil;
    x->p = p;
    //对新插入的结点，建立与其父结点之间的联系
    if((*T)->root == (*T)->nil){
        (*T)->root = x;
    }else if(k < p->key){
        p->left = x;
    }else{
        p->right = x;
    }
    //3、对二叉查找树进行调整
    RB_Insert_Fixup((*T),x);
}
void rbTree_transplant(RBT_Root* T, RB_TREE* u, RB_TREE* v){
    if(u->p == T->nil){
        T->root = v;
    }else if(u == u->p->left){
        u->p->left=v;
    }else{
        u->p->right=v;
    }
    v->p = u->p;
}
void RB_Delete_Fixup(RBT_Root**T,RB_TREE*x){
    while(x != (*T)->root && x->color == BLACK){
        if(x == x->p->left){
            RB_TREE* w = x->p->right;
            //第 1 种情况：兄弟结点是红色的
            if(RED == w->color){
                w->color = BLACK;
                w->p->color = RED;
                rbTree_left_rotate((*T),x->p);
                w = x->p->right;
            }
            //第2种情况：兄弟是黑色的，并且兄弟的两个儿子都是黑色的。
            if(w->left->color == BLACK && w->right->color == BLACK){
                w->color = RED;
                x = x->p;
            }
            //第3种情况
            if(w->left->color == RED && w->right->color == BLACK){
                w->left->color = BLACK;
                w->color = RED;
                rbTree_right_rotate((*T),w);
                w = x->p->right;
            }
            //第4种情况
            if (w->right->color == RED) {
                w->color = x->p->color;
                x->p->color = BLACK;
                w->right->color = BLACK;
                rbTree_left_rotate((*T),x->p);
                x = (*T)->root;
            }
        }else{
            RB_TREE* w = x->p->left;
            //第 1 种情况
            if(w->color == RED){
                w->color = BLACK;
                x->p->color = RED;
                rbTree_right_rotate((*T),x->p);
                w = x->p->left;
            }
            //第 2 种情况
            if(w->left->color == BLACK && w->right->color == BLACK){
                w->color = RED;
                x = x->p;
            }
            //第 3 种情况
            if(w->left->color == BLACK && w->right->color == RED){
                w->color = RED;
                w->right->color = BLACK;
                w = x->p->left;
            }
            //第 4 种情况
            if (w->right->color == BLACK){
                w->color=w->p->color;
                x->p->color = BLACK;
                w->left->color = BLACK;
                rbTree_right_rotate((*T),x->p);
                x = (*T)->root;
            }
        }
    }
    x->color = BLACK;//最终将根结点的颜色设为黑色
}
void rbTree_delete(RBT_Root* *T, int k){
    if(NULL == (*T)->root){
        return ;
    }
    //找到要被删除的结点
    RB_TREE * toDelete = (*T)->root;
    RB_TREE * x = NULL;
    //找到值为k的结点
    while(toDelete != (*T)->nil && toDelete->key != k){
        if(k<toDelete->key){
            toDelete = toDelete->left;
        }else if(k>toDelete->key){
            toDelete = toDelete->right;
        }
    }
    if(toDelete == (*T)->nil){
        printf("\n%d 不存在\n",k);
        return;
    }
    //如果两个孩子，就找到右子树中最小的结点，将之代替，然后直接删除该结点即可
    if(toDelete->left != (*T)->nil && toDelete->right != (*T)->nil){
        RB_TREE* alternative = rbt_findMin((*T), toDelete->right);
        k = toDelete->key = alternative->key;//这里只对值进行复制，并不复制颜色，以免破坏红黑树的性质
        toDelete = alternative;
    }
    //如果只有一个孩子结点（只有左孩子或只有右孩子），直接用孩子结点顶替该结点位置即可（没有孩子结点的也走此判断语句）。
    if(toDelete->left == (*T)->nil){
        x = toDelete->right;
        rbTree_transplant((*T),toDelete,toDelete->right);
    }else if(toDelete->right == (*T)->nil){
        x = toDelete->left;
        rbTree_transplant((*T),toDelete,toDelete->left);
    }
    //在删除该结点之前，需判断此结点的颜色：如果是红色，直接删除，不会破坏红黑树；若是黑色，删除后会破坏红黑树的第 5 条性质，需要对树做调整。
    if(toDelete->color == BLACK){
        RB_Delete_Fixup(T,x);
    }
    //最终可以彻底删除要删除的结点，释放其占用的空间
    free(toDelete);
}

//T表示为树根，x 表示需要进行左旋的子树的根结点
void rbTree_left_rotate( RBT_Root* T, RB_TREE* x){
    RB_TREE* y = x->right;//找到根结点的右子树
   
    x->right = y->left;//将右子树的左孩子移动至结点 x 的右孩子处
    if(x->right != T->nil){//如果 x 的右子树不是nil，需重新连接 右子树的双亲结点为 x
        x->right->p = x;
    }
    y->p = x->p;//设置 y 的双亲结点为 x 的双亲结点
    //重新设置 y 的双亲结点同 y 的连接，分为 2 种情况：1、原 x 结点本身就是整棵树的数根结点，此时只需要将 T 指针指向 y；2、根据 y 中关键字同其父结点关键字的值的大小，判断 y 是父结点的左孩子还是右孩子
    if(y->p == T->nil){
        T->root = y;
    }else if(y->key < y->p->key){
        y->p->left = y;
    }else{
        y->p->right = y;
    }
    y->left = x;//将 x 连接给 y 结点的左孩子处
    x->p = y;//设置 x 的双亲结点为 y。
}

void rbTree_right_rotate( RBT_Root* T, RB_TREE* x){
    RB_TREE * y = x->left;
    x->left = y->right;
    if(T->nil != x->left){
        x->left->p = x;
    }
    y->p = x->p;
    if(y->p == T->nil){
        T->root = y;
    }else if(y->key < y->p->key){
        y->p->left= y;
    }else{
        y->p->right = y;
    }
    y->right = x;
    x->p = y;
}
void rbTree_prePrint(RBT_Root* T, RB_TREE* t){
    if(T->nil == t){
        return;
    }
    if(t->color == RED){
        printf("%dR ",t->key);
    }else{
        printf("%dB ",t->key);
    }
    rbTree_prePrint(T,t->left);
    rbTree_prePrint(T,t->right);
}
void rbTree_inPrint(RBT_Root* T, RB_TREE* t){
    if(T->nil == t){
        return ;
    }
    rbTree_inPrint(T,t->left);
    if(t->color == RED){
        printf("%dR ",t->key);
    }else{
        printf("%dB ",t->key);
    }
    rbTree_inPrint(T,t->right);
}

//输出红黑树的前序遍历和中序遍历的结果
void rbTree_print(RBT_Root* T){
    printf("前序遍历 ：");
    rbTree_prePrint(T,T->root);
    printf("\n");
    printf("中序遍历 ：");
    rbTree_inPrint(T,T->root);
    printf("\n");
}

int main(){
    RBT_Root* T = rbTree_init();
   
    rbTree_insert(&T,3);
    rbTree_insert(&T,5);
    rbTree_insert(&T,1);
    rbTree_insert(&T,2);
    rbTree_insert(&T,4);
    rbTree_print(T);
    printf("\n");
    rbTree_delete(&T,3);
    rbTree_print(T);

    return 0;
}

```

运行结果：
```shell
前序遍历 ：3B 1B 2R 5B 4R
中序遍历 ：1B 2R 3B 4R 5B

前序遍历 ：4B 1B 2R 5B
中序遍历 ：1B 2R 4B 5B
```
## 总结

本节介绍的红黑树，虽隶属于二叉查找树，但是二叉查找树的时间复杂度会受到其树深度的影响，而红黑树可以保证在最坏情况下的时间复杂度仍为O(lgn)。当数据量多到一定程度时，使用红黑树比二叉查找树的效率要高。

同平衡二叉树相比较，红黑树没有像平衡二叉树对平衡性要求的那么苛刻，虽然两者的时间复杂度相同，但是红黑树在实际测算中的速度要更胜一筹！

<font color=red>提示：</font>

平衡二叉树的时间复杂度是O(logn)，红黑树的时间复杂度为O(lgn)，两者都表示的都是时间复杂度为对数关系（lg 函数为底是 10 的对数，用于表示时间复杂度时可以忽略）。












