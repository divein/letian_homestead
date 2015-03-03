## Letian 的 guohe homeStead 项目。

本项目主要用来果合的研发人员家中工作使用(在没有开发机的情况下)， 主要通过 vagrant + virtualbox 来提供支持。

主要致力于：

1. 本地的vagrant 开发环境设置。

* 自动配置开发环境的 ssh key 等内容。
* 自动安装 puppet 环境
* 支持 vagrant 启动时自定义脚本执行。 脚本放在 letian/files/exec-aways|exec-once|startup-always|startup-once 目录下。

2. puppet 提供器支持的开发环境支持
* 自动配置开发环境, namp开发环境，项目相应的 消息服务器， memache , redis配置
* 开发者账号，版本库等内容管理
* ...等等。。 

## 使用方法

### 设置执行环境

#### 安装 virtualbox. 目前 guohe_homestead 只支持 virtualbox, 其他虚拟机支持看情况。。

下载地址:

[win 下下载这个。](http://download.virtualbox.org/virtualbox/4.3.22/VirtualBox-4.3.22-98236-Win.exe)  
[mac下载这个。](http://download.virtualbox.org/virtualbox/4.3.22/VirtualBox-4.3.22-98236-OSX.dmg)  

#### 安装 vagrant. 

[下载地址:](https://www.vagrantup.com/downloads.html)

#### 设置 vagrant 目录 (mac,linux 用户忽略)

因为 vagrant 默认会在 `$HOME/.vagrant.d` 目录下建立box . 因为 windows默认的 `$HOME` 在 `C:\Users\xxxx` 下， 我们可以把 这个目录拷贝到
自己硬盘上一个大目录里:

> 把你的 C:\Users\xxxx\.vagrant.d  目录拷贝到 E盘吧（或者其他盘).

**然后设置环境变量:  VAGRANT_HOME : e:\.vagrant.d**
> (win: 右键我的电脑-》属性 -》高级系统设置 -》高级 -》 环境变量 )

#### 获取box, 这里我提供的都是官方提供的box. 目前guohe_homestead 只支持debian 和 ubuntu:
    
[官方 ubuntu box](https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/14.04/providers/virtualbox.box)
[我的百度网盘](http://pan.baidu.com/s/1jG3kNNw)

把上面的box 保存到硬盘(可以直接用上面网址， 但是网速。。上面文件可以用迅雷拉下来，在本地安装)

#### 安装box

```
 vagrant box add -name ubuntu_14  file:///e:/virtualbox.box
```
这样，这个box 会被安装到 VAGRANT_HOME 的boxs目录， 这样你下次还可以继续用。

#### 最后一步：
 在这个 guohe_homestead 目录下，在命令行中执行：

```
 d:\boxs\guohe_homestead\vagrant up
```

你可以等待完成了。

======================================================================================================

** 此项目还在开发中。。。甚至还没写puppet/manifests和对应的 template** 如果出现问题记得及时反馈。 谢谢。
