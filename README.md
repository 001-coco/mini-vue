# mini-vue

从零实现一个 Vue3 风格的响应式系统 + 渲染器。纯 JavaScript，无运行时依赖。

## 运行

```bash
npm install
npm run dev
```


## 目录

```
src/
  shared.js                 工具函数
  reactivity/
    effect.js               effect / track / trigger（依赖收集核心）
    reactive.js             Proxy 响应式代理
    ref.js                  基础类型响应式
    computed.js             带缓存的派生值
  runtime/
    h.js                    创建 VNode
    renderer.js             mount / patch（diff）
  scheduler.js              微任务批量更新 + nextTick
  demo/main.js              演示应用
```



> 基于 Proxy 实现 `reactive` / `ref` 的依赖收集与派发更新，用 WeakMap→Map→Set 三级结构存储 target→key→effect 映射（WeakMap 弱引用避免内存泄漏）；用 effect 栈解决嵌套副作用的 `activeEffect` 覆盖问题，并在 effect 执行前清理旧依赖以处理分支切换；实现 `computed` 的脏标记 + 懒计算，依赖变化时只标记失效、下次读取才重算。
>
> 取舍：渲染器只做按下标对比的简化 diff，未实现 key 复用 —— 优先把响应式核心讲透。
| Proxy vs defineProperty | 新增/删除属性、数组下标、懒代理三点 |
| WeakMap→Map→Set | 为什么第一层必须是 WeakMap；Set 为什么能去重 |
| effect 栈 | 没有栈会发生什么；组件嵌套渲染就是嵌套 effect |
| cleanupEffect | 为什么要先清旧依赖；v-if 分支切换的具体场景 |
| computed 脏标记 | 依赖变化时为什么不立即重算；懒计算收益在哪 

| 问题 | 对应代码 |
|---|---|
| Proxy 为什么优于 defineProperty | `reactive.js` 顶部注释 + `deleteProperty` / `ownKeys` 拦截器 |
| 依赖收集为什么是 WeakMap→Map→Set | `effect.js` `targetMap` |
| 嵌套 effect 怎么解决 | `effect.js` `effectStack` |
| computed 为什么能缓存 | `computed.js` `_dirty` 脏标记 |
| nextTick 是什么原理 | `scheduler.js` 微任务队列 |
| 为什么要 cleanupEffect | `effect.js` `run()` 开头，处理 v-if 分支切换 |
| 数组 push 为什么会触发两次 | `trigger()` 中 ADD 额外触发 length，靠 scheduler 去重 |

