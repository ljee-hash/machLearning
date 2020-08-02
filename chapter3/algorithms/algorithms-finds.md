# 4.1.6.1 查找

在日常生活中，几乎每天都要进行一些查找的工作，在电话簿中查阅某个人的电话号码；在电脑的文件夹中查找某个具体的文件等等。本节主要介绍用于查找操作的数据结构——查找表。

查找表是由同一类型的数据元素构成的集合。例如电话号码簿和字典都可以看作是一张查找表。

一般对于查找表有以下几种操作：
1. 在查找表中查找某个具体的数据元素；
1. 在查找表中插入数据元素；
1. 从查找表中删除数据元素；

## 查找的基本概念


### 1. 基本概念

查找是一种常用的基本运算。

<font color=red style="font-size: 1.3em;" > 静态查找表和动态查找表 </font>


查找表是指由同一类型的数据元素(或记录)构成的集合。由于"集合"这种数据结构中的数据元素之间存在完全松散的关系，因此，查找表是一种非常灵活的数据结构。

【读场景】对查找表经常要进行的两种操作如下:

<table><tr><td bgcolor=PowderBlue>
 (1) 查找某个特定的数据是否在查找表中。
 (2) 检索某个特定的数据元素的各个属性。
 
 通常将只进行这两种操作的查找表称之为静态查找表
</td></tr></table>

【写场景】对查找表要经常进行的另外两种操作如下:

<table><tr><td bgcolor=PowderBlue>
 (1) 在查找表中插入一个数据元素。
 (2) 从查找表中删除一个数据元素。
</td></tr></table>

若查找过程中同时插入查找表中不存在的数据元素，或者从查找表中删除已存在的某个数据元素，则称之为动态查找表。


<font color=red style="font-size: 1.3em;" > 关键字 </font>


<font color=#008000> 关键字 </font> 是数据元素（或记录）的某个数据项的值，用它来识别（标识）这个数据元素。</br>
<font color=#008000> 主关键字 </font> 是指能唯一标示一个数据元素的关键字。</br>
<font color=#008000> 次关键字 </font> 是指能标识多个元素的关键词。</br>

在查找表查找某个特定元素时，前提是需要知道这个元素的一些属性。例如，每个人上学的时候都会有自己唯一的学号，因为你的姓名、年龄都有可能和其他人是重复的，唯独学号不会重复。<font color=red>而学生具有的这些属性（学号、姓名、年龄等）都可以称为 </font><font color=#008000> 关键字 </font>。</br>

关键字又细分为主关键字和次关键字。若某个关键字可以唯一地识别一个数据元素时，称这个关键字为主关键字，例如学生的学号就具有唯一性；<font color=red>反之，像学生姓名、年龄这类的关键字，由于不具有唯一性，称为 </font> <font color=#008000> 次关键字 </font>。</br>



<font color=red style="font-size: 1.3em;" > 如何进行查找？ </font> </br>


根据给定的某个值，在查找表中确定是否存在一个其关键字等于给定值的记录或数据元素。

若表中存在这样一个记录，则称为查找成功，此时给出整个记录的信息，或者指出记录在查找表中的位置；
若表中不存在关键字等于给定值的记录，则称查找不成功，此时的查找结果用一个"空"记录或"空"指针表示。


不同的查找表，其使用的查找方法是不同的。例如每个人都有属于自己的朋友圈，都有自己的电话簿，电话簿中数据的排序方式是多种多样的，有的是按照姓名的首字母进行排序，这种情况在查找时，就可以根据被查找元素的首字母进行顺序查找；有的是按照类别（亲朋好友）进行排序。在查找时，就需要根据被查找元素本身的类别关键字进行排序。
具体的查找方法需要根据实际应用中具体情况而定。

本章从静态查找表、动态查找表和哈希表的角度具体分析针对不同的查找表可供选择的查找算法。




### 2. 平均查找长度

对于查找算法来说，其基本操作是"将记录的关键词与给定值进行比较"。因此，通常以"以其关键字和给定值进行过比较的记录个数的期望值"作为衡量查找算法的好坏的依据。


为确定记录在查找表中的位置，需和给定的关键字值进行比较的次数的期望值称为查找算法在查找成功时的平均查找长度。


对于含有 n 个记录的表，查找成功时的平均查找长度定义为

$$
ASL =  \sum\limits_{i=1}^\infty {P_iC_i} 
$$

其中，$$ p_i $$ 为对表中第 i 个记录进行查找的概率，且 $$ \sum\limits_{i=1}^\infty {P_i} = 1 $$ ，一般情况下，均认为查找每个元素记录的概率是相等的，即 $$ P_i = \frac{1}{n} $$；$$ C_i $$ 为找到表中其关键字与给定值相等的记录时(为第 i 个记录)，和给定值已进行过比较的关键词个数，显然，$$ C_i $$ 随查找方法的不同而不同。



$$ 
\hat{f}\left( \xi \right) = \sum\limits_{-\infty}^\infty {f(x)e^{-2\pi i x \xi}  dx}  
$$


$$ \vec{\nabla} \times \vec{H} = \vec{J} + \frac{\partial \vec{D}}{\partial t} $$


$$ i \hbar \frac{\partial}{\partial t}\Psi(t) = \hat H \Psi(t) $$



$$ \frac{df}{dt} = \lim _{(h \rightarrow 0)} \frac{f(t+h)-f(t)}{h}$$


$$
\int_a^bu\frac{d^2v}{dx^2}\,dx
	=\left.u\frac{dv}{dx}\right|_a^b
	-\int_a^b\frac{du}{dx}\frac{dv}{dx}\,dx.
	
	
\lim_{q\to\infty}\|f(x)\|_q 
	=\max_{x}|f(x)|,
$$


参见: [参考](https://www.authorea.com/users/3/articles/165181-latex-mathematics-examples)




## 静态查找表的查找方法

### 1. 顺序查找

顺序查找的基本思路是: 

- 从表的一端开始，逐个进行记录的关键字和给定值比较，若找到一个记录的关键字和给定值相等，则查找成功；
- 若整个表中的记录均比较过，仍未找到关键字等于给定值的记录，则查找失败。

顺序查找方法对于顺序存储方式和链式存储方式的查找表都适用。


- 从顺序查找的过程可知道，$$ C_i $$ 的取值决定于所查记录在表中的位置。按需叉好啊的记录正好是表中的第一个记录，仅需比较一次；
- 若查找成功时找到的是表中的最后一个记录，则需比较 n 次。

从表尾开始查找时正好相反。

一般情况下， $$ C_i = n-i+1 $$ , 因此在等概率的情况下，顺序查找成功的平均查找长度为：

$$
ASL_{ss} = \sum\limits_{i=1}^{n} P_iC_i = \frac{1}{n} \sum\limits_{i=1}^{n} \left( n-i+1 \right) = \frac{n+1}{2}
$$

也就是说，成功查找的平均比较次数约为表长的一半。若所查找记录不在表中，则必须进行 n 次( 不设监视哨兵，设置监视哨时为 n+1 次) 比较才能确定失败。。监视哨是指查找表用一维数存储时，将待查找的记录放置在查找表的第一个记录之前或最后一个记录之后，从而在查找过程中避免对数组元素下标进行合法性检查。

<font color=#008000>与其他方法相比缺点</font>，顺序查找方法在 n 值比较大时，其平均查找长度比较大，查找效率比较低。

<font color=#008000>但这种方法也有优点</font>，那就是算法简单且适应面广，对查找表的结构没有要求，无论记录是否按关键字有序排列均可应用


### 2. 折半查找


$$
ASL_{bs} = \sum\limits_{i=1}^{n} P_iC_i = \frac{1}{n} \sum\limits_{i=1}^{n} \left( {J}\times{2^{j-1}} \right) = \frac{n+1}{n}log_{2} \left(  n+1 \right) - 1
$$


### 3. 分块查找




## 动态查找表

动态查找表的特点是表结构本身是在查找过程中动态生成的，即对于给定值 key ， 若表中存在关键字等于 key 的记录，则查找成功返回；否则，插入关键字为 key 的记录。

### 二叉树排序

[详情见]()













