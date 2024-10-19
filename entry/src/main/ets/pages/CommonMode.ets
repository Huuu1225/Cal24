import promptAction from'@ohos.promptAction';
import router from '@ohos.router'
import { curves } from '@kit.ArkUI';
@Entry
@Component
struct CommonMode {
  //扑克
  @State arr1: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
  @State arr2: number[] = [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,24, 25]
  @State arr3: number[] = [26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38]
  @State arr4: number[] = [39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51]
  //展示页面需要的变量
  @StorageLink('nums') nums: string[] = [];
  @StorageLink('ret') ret: string[] = [];
  //选中的扑克
  @State showArr: number[] = []
  //图标是否展示
  @State show : boolean = false
  @State show2 : boolean = false

  build() {
    Column() {
      Text('请选择不重复的四张牌')
        .fontStyle(FontStyle.Italic)
      //显示被选中的四张牌
      ShowCard({showArr:this.showArr})
      //撤销和确定
      ButtonRow({showArr:this.showArr,show:this.show,show2:this.show2,nums:this.nums,ret:this.ret})
      //List组件展示扑克
      AllCard({arr:this.arr1,showArr:this.showArr,show:this.show,show2:this.show2,nums:this.nums})
      AllCard({arr:this.arr2,showArr:this.showArr,show:this.show,show2:this.show2,nums:this.nums})
      AllCard({arr:this.arr3,showArr:this.showArr,show:this.show,show2:this.show2,nums:this.nums})
      AllCard({arr:this.arr4,showArr:this.showArr,show:this.show,show2:this.show2,nums:this.nums})
      //返回图标
      SymbolGlyph($r('sys.symbol.chevron_left_circle'))
        .fontWeight(FontWeight.Normal)
        .fontSize(56)
        .onClick(() => {
          router.pushUrl({
            url:"pages/Index"
          })
        })

    }.backgroundImage($r("app.media.pk1"))//背景图片
    .backgroundImageSize(1)
    .backgroundImagePosition(Alignment.Bottom)
    .height("100%")
  }
}

//自定义组件
@Component
//显示选择的扑克
export struct ShowCard {
  @State showArr: number[] = []
  // 动画
  private effect: TransitionEffect =
    TransitionEffect.OPACITY.animation({ curve: curves.springMotion(0.6, 0.8) })
      .combine(TransitionEffect.scale({ x: 0, y: 0 }))
      .combine(TransitionEffect.rotate({ angle: 90 }))
      .combine(TransitionEffect.translate({ y: 150 }).animation({ curve: curves.springMotion() }))
      .combine(TransitionEffect.move(TransitionEdge.END))

  build() {
    List() {
      ForEach(this.showArr, (item: number) => {
        ListItem() {
          Image('images/' + item + '.png')
            .width(80)
            .height(100)
            .border({ width: 2 })
            .objectFit(ImageFit.Fill)
            .autoResize(true)
            .position({ x: 0, y: 0 })
        }.transition(this.effect)
      })
    }
    .listDirection(Axis.Vertical)
    .lanes(4)
    .scrollBar(BarState.Auto)
    .width('100%').height('16%').backgroundColor(0xDDDCDDD).padding({ top: 6 })
  }
}

@Component
  //撤销和确认
struct ButtonRow {
  //@Link装饰的变量与其父组件中对应的数据源建立双向数据绑定，实现了双向同步。
  @Link nums: string[]
  @Link  ret: string[]
  @Link showArr: number[]
  @Link show : boolean
  @Link show2 : boolean
  build() {
    Row() {
      //自带的图标资源
      SymbolGlyph($r('sys.symbol.ohos_trash'))
        .fontWeight(FontWeight.Normal)
        .fontSize(56)
        .onClick(() => {
          this.showArr.pop()
          this.nums.pop()
          this.show2 = false
          if (this.showArr.length == 0)
            this.show = false
        })
        .visibility(this.show ? Visibility.Visible : Visibility.Hidden)
        .width("40%")
      //自带的图标资源
      SymbolGlyph($r('sys.symbol.checkmark_circle'))
        .fontWeight(FontWeight.Normal)
        .fontSize(56)
        .onClick(() => {
          const num1 = parseFloat(this.nums[0]);
          const num2 = parseFloat(this.nums[1]);
          const num3 = parseFloat(this.nums[2]);
          const num4 = parseFloat(this.nums[3]);
          const expression = calc24(num1, num2, num3, num4);
          if (expression) {
            this.ret = expression;
          } else {
            this.ret = ['无法通过四则运算得到24'];
          }
          router.pushUrl({
            url:"pages/CommonResult"
          })
        })
        .visibility(this.show2 ? Visibility.Visible : Visibility.Hidden)
        .width("10%")
    }

  }
}
@Component
  //展示扑克
struct AllCard {
  @Link arr:number[]
  @Link showArr: number[]
  @Link show : boolean
  @Link show2 : boolean
  @Link nums: string[]
  build() {
    List() {
      ForEach(this.arr, (item: number) => {
        ListItem() {
          Image('images/' + item + '.png')//另一种调用图片资源的方式
            .width(80)
            .height(100)
            .border({ width: 2 })
            .objectFit(ImageFit.Fill)
            .autoResize(true)
            .onClick(() => {
              if (this.showArr.length < 4 && !this.showArr.includes(item)) {
                this.showArr.push(item)
                this.nums.push(((item+2)%13).toString())
                this.show = true
                if (this.showArr.length == 4)
                  this.show2 = true
              } else {
                promptAction.showToast({
                  message: '不可添加'
                })
              }
            })
        }
      })
    }
    .height('15%')
    .listDirection(Axis.Horizontal)
    .lanes(1)
    .scrollBar(BarState.Auto)
  }
}
//计算逻辑模块
function calc24(num1: number, num2: number, num3: number, num4: number): string[] | null {
  const nums = [num1, num2, num3, num4];
  const ops = ['+', '-', '*', '/'];
  let res:string[]=[];
  // 对两个数进行加减乘除的运算并返回结果
  const applyOp = (a: number, b: number, op: string): number => {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        return b !== 0 ? a / b : Infinity;
      default:
        return Infinity;
    }
  };
  // 生成所有数字的排列组合
  const permutations = (arr: number[]): number[][] => {
    if (arr.length <= 1) return [arr];
    const result: number[][] = [];
    for (let i = 0; i < arr.length; i++) {
      const rest = permutations(arr.slice(0, i).concat(arr.slice(i + 1)));
      rest.forEach(r => result.push([arr[i], ...r]));
    }
    return result;
  };
  // 尝试所有数字和运算符的排列组合，返回具体表达式
  const tryOps = (a: number, b: number, c: number, d: number): string[] | null => {
    for (const op1 of ops) {
      for (const op2 of ops) {
        for (const op3 of ops) {
          const expressions = [
            `(((${a} ${op1} ${b}) ${op2} ${c}) ${op3} ${d})`,
            `((${a} ${op1} ${b}) ${op2} (${c} ${op3} ${d}))`,
            `(${a} ${op1} ((${b} ${op2} ${c}) ${op3} ${d}))`,
            `(${a} ${op1} (${b} ${op2} (${c} ${op3} ${d})))`,
            `(((${a} ${op1} (${b} ${op2} ${c})) ${op3} ${d}))`
          ];

          const results = [
            applyOp(applyOp(applyOp(a, b, op1), c, op2), d, op3),
            applyOp(applyOp(a, b, op1), applyOp(c, d, op3), op2),
            applyOp(a, applyOp(applyOp(b, c, op2), d, op3), op1),
            applyOp(a, applyOp(b, applyOp(c, d, op3), op2), op1),
            applyOp(applyOp(a, applyOp(b, c, op2), op1), d, op3)
          ];

          for (let i = 0; i < results.length; i++) {
            if (Math.abs(results[i] - 24) < 1e-6) {
              res.push(expressions[i]);
            }
          }
          if(res.length!=0)return res;
        }
      }
    }
    return null;
  };
  // 对所有排列组合尝试运算
  const perms = permutations(nums);
  for (const perm of perms) {
    const result = tryOps(perm[0], perm[1], perm[2], perm[3]);
    if (result !== null) {
      return result; // 返回表达式
    }
  }
  return null; // 如果没有结果，返回null
}
