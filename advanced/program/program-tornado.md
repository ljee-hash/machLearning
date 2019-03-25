# Tornado框架

## 简介

Tornado全称Tornado Web Server，是一个用Python语言写成的Web服务器兼Web应用框架，由FriendFeed公司在自己的网站FriendFeed中使用，被Facebook收购以后框架以开源软件形式开放给大众。

## 特点

作为Web框架，是一个轻量级的Web框架，类似于另一个Python web 框架Web.py，其拥有异步非阻塞IO的处理方式。

作为Web服务器，Tornado有较为出色的抗负载能力，官方用nginx反向代理的方式部署Tornado和其它Python web应用框架进行对比，结果最大浏览量超过第二名近40%。[1]

## 性能

Tornado有着优异的性能。它试图解决C10k问题，即处理大于或等于一万的并发，下表是和一些其他Web框架与服务器的对比:

**处理器为 AMD Opteron, 主频2.4GHz, 4核[2]** 

| 服务 | 部署 | QPS |
|-------|:---------------------:|:---------------------:|
|Tornado |	nginx, 4进程   | 	8213    | 
|Tornado |	1个单线程进程   | 	3353    | 
|Django |	Apache/mod_wsgi   | 	2223    | 
|web.py |	Apache/mod_wsgi   | 	2066    | 
|CherryPy |	独立   | 	785    | 



## 参考

https://zh.wikipedia.org/wiki/Tornado
