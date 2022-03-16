# Tap-Order

## 目标

这是一个针对日本市场尝试的小项目，目标在于帮助微小型餐饮店实现自助型扫码点餐系统。

## 原型图

https://www.figma.com/file/Uz0iXmDtBXQieLae7wDLyx/Food-Ordering-App-(Community)-(Copy)?node-id=0%3A1
## build 方法

1. 等待 swift package manager 安装依赖库之后
2. 所有的target都勾掉 automatically manager signing，然后Team里选择none，如下图，就可以了。

<img width="921" alt="截屏2022-02-28 下午2 23 46" src="https://user-images.githubusercontent.com/3367000/155935004-845b2f82-f9b9-48e8-8d0f-010a09a7d0bf.png">

## App clip target 注意

如果添加了socket相关的代码后，app clip target需要相应的证书才能运行，主 app 不受这个影响，可以继续测试。
