import router from '@ohos.router'
@Entry
@Component
struct CommonResult {
  @StorageLink('nums') nums: string[] = [];
  @StorageLink('ret') ret: string[] = [];

  build() {
    Column({ space: 20 }) {
      Row(){
        //返回图标
        SymbolGlyph($r('sys.symbol.chevron_left_circle'))
          .fontWeight(FontWeight.Normal)
          .fontColor([Color.White])
          .fontSize(56)
          .onClick(() => {
            this.nums=[]
            router.pushUrl({
              url: "pages/CommonMode"
            })
          })
        Text('计算结果')
          .fontSize(25)
          .fontColor(Color.White)
          .width('100%')
          .fontWeight(700)
      }

      Row() {
        Text('选择的数字：')
          .fontColor(Color.White)
        ForEach(this.nums, (item: string) => {
          Text(item)
            .fontColor(Color.White)
          Text('  ')
        })
      }

      ForEach(this.ret, (item: string) => {
        Text(item)
          .fontSize('24')
          .fontWeight(700)
          .fontColor(Color.White)
          .width('100%')
          .padding(15)
      })


    }.backgroundImage($r("app.media.pk2"))
    .backgroundImageSize(1)
    .backgroundImagePosition(Alignment.Bottom)
    .height("100%")
  }
}


