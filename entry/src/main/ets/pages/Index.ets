import router from '@ohos.router'
@Entry
@Component
struct Index {
  @State GameName: string = '扑克牌24点计算'
  @State GameRule: string = '游戏   规则'
  @State GameRule1: string = '选择四张不重复的扑克牌，如果四张牌的数值能通过加减乘除计算出24，则选择正确，否则失败'
  build() {
    Column(){
      Text(this.GameName)
        .width(300)
        .textAlign(TextAlign.Center)
        .padding(0)
        .fontSize(30)
        .fontColor('#D2B48C')
      Text(this.GameRule)
        .fontSize(20)
        .margin({
          top: 130
        })
      Text(this.GameRule1)
        .padding({
          left: 50,
          right: 50
        })
      //普通模式
      ModeSel1()
      //死斗模式
      ModeSel2 ()
    }.backgroundImage($r("app.media.kuangjia"))
    .backgroundImageSize(1)
    .backgroundImagePosition(Alignment.Bottom)
    .height("100%")
  }
}
//自定义组件

//普通模式选择
@Component
struct ModeSel1 {
  build() {
    Row() {
      Image($r("app.media.Common"))//一种调用图片资源的方式，另一种在展示扑克是使用了
        .objectFit(ImageFit.Contain)
        .width("55%")
      Column(){
        Text('普通模式')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width("70%")
        Text('选择四张牌并查看可能的组合')
          .width("70%")
      }
      .onClick(() => {
        router.pushUrl({
          url:"pages/CommonMode"
        })
      })
    }
    .alignItems(VerticalAlign.Center)
    .margin({
      top: 40
    })
    .width('50%')
    .height('15%')
  }
}
//死斗模式选择
@Component
struct ModeSel2 {
  build() {
      Row() {
        Image($r("app.media.DeadFight"))
          .objectFit(ImageFit.Contain)
          .width("55%")
        Column() {
          Text('死斗模式')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .width("70%")
          Text('每轮选择四张扑克，直到选择的牌无法计算出24')
            .width("70%")
        }
        .onClick(() => {
          router.pushUrl({
            url: "pages/DeadMode"
          })
        })
      }
      .alignItems(VerticalAlign.Center)
      .margin({
        top: 30
      })
      .width('50%')
      .height('15%')
    }
}