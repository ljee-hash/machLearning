# 8.7 图与树


## 树表

给定一个表树，id是树节点的标识符，而p_id是其父节点的ID。

```
+----+------+
| id | p_id |
+----+------+
| 1  | null |
| 2  | 1    |
| 3  | 1    |
| 4  | 2    |
| 5  | 2    |
+----+------+
```
树中的每个节点可以是以下三种类型之一：

  - Leaf：如果节点是叶节点。
  - Root：如果节点是树的根。
  - Inner：节点既不是叶节点也不是根节点。

编写查询以打印节点ID和节点类型。按节点ID对输出进行排序。以上示例的结果是：

```
+----+------+
| id | Type |
+----+------+
| 1  | Root |
| 2  | Inner|
| 3  | Leaf |
| 4  | Leaf |
| 5  | Leaf |
+----+------+
```

### 说明

- Node '1' 是 root 节点, 因为其父节点为 NULL 且子节点为 '2' and '3'.
- Node '2' 是 inner 节点, 因为其具有父节点 '1' 以及子节点 '4' and '5'.
- Node '3', '4' 和 '5' 是 Leaf 节点, 因为他们具有 parent 节点且没有子节点.

- 树的整个样子如下:

```
			  1
			/   \
                      2       3
                    /   \
                  4       5
```

**注意** 如果树上只有一个节点，则只需输出其根属性。


### Solution

#### 方法一: 使用 `sql UNION ` [Accepted]

**思路:** 

我们可以通过在此表中按其定义判断每个记录来打印节点类型。`Root`：它根本没有父节点 `Inner`：它是某些节点的父节点，并且它本身具有一个非NULL的父节点。 `Leaf`：除上述两个以外的其他情况

**算法:**

我们通过节点类型的定义进行转换，我们可以得到如下代码片段

`Root节点`: 对于Root节点，它没有任何一个Parent节点


```sql
SELECT
    id, 'Root' AS Type
FROM
    tree
WHERE
    p_id IS NULL
```

`Leaf节点`: 对于Leaf节点，除有一个Parent节点之外没有任何Child节点

```sql
SELECT
    id, 'Leaf' AS Type
FROM
    tree
WHERE
    id NOT IN (SELECT DISTINCT
            p_id
        FROM
            tree
        WHERE
            p_id IS NOT NULL)
        AND p_id IS NOT NULL
```


`Inner节点`: 对于Inner节点，有Parent节点,且有Child节点

```sql
SELECT
    id, 'Inner' AS Type
FROM
    tree
WHERE
    id IN (SELECT DISTINCT
            p_id
        FROM
            tree
        WHERE
            p_id IS NOT NULL)
        AND p_id IS NOT NULL
```

因此，上述问题其中一个解决方案就是通过 `UNION` 连接所有情况.

MySQL
```sql
SELECT
    id, 'Root' AS Type
FROM
    tree
WHERE
    p_id IS NULL

UNION

SELECT
    id, 'Leaf' AS Type
FROM
    tree
WHERE
    id NOT IN (SELECT DISTINCT
            p_id
        FROM
            tree
        WHERE
            p_id IS NOT NULL)
        AND p_id IS NOT NULL

UNION

SELECT
    id, 'Inner' AS Type
FROM
    tree
WHERE
    id IN (SELECT DISTINCT
            p_id
        FROM
            tree
        WHERE
            p_id IS NOT NULL)
        AND p_id IS NOT NULL
ORDER BY id;

```

#### 方法二: 通过流程控制语句 `CASE` [Accepted]

**算法:**

这个想法与上面的解决方案相似，但是通过利用流控制语句使代码更简单，这有效地基于不同的输入值进行不同的输出。在这种情况下，我们可以使用CASE语句

MySQL
```sql
SELECT
    id AS `Id`,
    CASE
        WHEN tree.id = (SELECT atree.id FROM tree atree WHERE atree.p_id IS NULL)
          THEN 'Root'
        WHEN tree.id IN (SELECT atree.p_id FROM tree atree)
          THEN 'Inner'
        ELSE 'Leaf'
    END AS Type
FROM
    tree
ORDER BY `Id`
;
```

> MySQL 提供流程控制语句除 `CASE`. 还可以使用 `IF` 进行流程控制

#### 方法三: 通过流程控制语句 `IF` [Accepted]


**算法:**

使用 `IF` 进行简化

MYSQL
```sql
SELECT
    atree.id,
    IF(ISNULL(atree.p_id),
        'Root',
        IF(atree.id IN (SELECT p_id FROM tree), 'Inner','Leaf')) Type
FROM
    tree atree
ORDER BY atree.id
```
## 左右树表

通过上述`树表`的例子可以看出，设计树形的数据结构一直是十分考验开发者的能力，最常用的方案有主从表方案和继承关系（parent_id）方案。

### 主从表方案

**缺点**

最大的缺点就是树形结构的深度扩展困难，一般来说都是固定的、适合深度固定的需求

### 继承关系方案设计

**优点**

设计和实现自然，非常直观和方便

**缺点**

由于直接记录了节点之间的继承关系，因此对Tree的任何CRUD操作都将是低效的，主要原因是频繁的"递归"操作，递归过程不断地访问数据库

每次数据库IO都会有时间开销。因此此方案比较适合Tree规模比较小的情况，可以借助于缓存机制来做优化，将Tree信息载入内存进行处理，避免直接对数据库的IO的性能开销









