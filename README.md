# RollerView
卷帘效果父视图

// y 在window上的Y开始向下卷出显示 调用此方法弹出
let roller = RollerView.sharedInstance(y: 64)
roller.show(subView: subView)


需要收起的时候， subView上调用一下此方法
RollerView.hiddenRoller(from: self)
