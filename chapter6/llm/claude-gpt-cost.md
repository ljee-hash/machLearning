# Claude Code 的 token 都去哪了：从提示缓存到上下文重发的成本拆解

https://claude.com/blog/maximizing-the-value-of-your-claude-code-sessions
> Claude 这篇 Blog 表面上这是一篇"省 token 的技巧清单"，但它的真正价值在于把 Claude Code 的成本模型讲透：一次会话的开销是怎么产生的、钱花在了哪个环节、哪些操作会让成本突然跳升。理解了这个模型，那些技巧就不再是需要死记的规则，而是自然推导出来的结果。
> 开头点出了一个思维转变：过去的编程工具是固定费用（或免费），修一个测试和修五十个测试成本相同，所以"单个任务"没有价格。而在 agentic coding 工具里，同一个任务、同样的结果，可以花掉不同数量的 token——取决于你怎么用，Lydia 特别强调：效率不是指用更少的 token，是让用掉的 token 都花在你真正要解决的问题上。
