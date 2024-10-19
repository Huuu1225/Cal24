import promptAction from'@ohos.promptAction';
import router from '@ohos.router'
import { it } from '@ohos/hypium';
import {ShowCard} from './CommonMode'

@Entry
@Component
struct CommonMode {
  @State arr1: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
  @State arr2: number[] = [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,24, 25]
  @State arr3: number[] = [26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38]
  @State arr4: number[] = [39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51]
  @State nums: string[] = [];
  @State showArr: number[] = []
  @State showSuit:number[]=[]
  @State show : boolean = false
  @State show2 : boolean = false
  @State ith: number = 0;

  build() {
    Column() {
      Text('每轮选择四张牌并确认,第'+this.ith.toString()+'轮成功')
        .fontWeight(FontWeight.Bold)
        .fontSize(20)
      //展示选择的扑克
      ShowCard({showArr:this.showArr})
      //按钮行
      ButtonRow({showSuit:this.showSuit,showArr:this.showArr,
        show:this.show,show2:this.show2,nums:this.nums,ith:this.ith,
        arr1:this.arr1,arr2:this.arr2,arr3:this.arr3,arr4:this.arr4})
      //展示所有扑克
      AllCard({arr:this.arr1,showSuit:this.showSuit,showArr:this.showArr,
        show:this.show,show2:this.show2,nums:this.nums,cardId:1})
      AllCard({arr:this.arr2,showSuit:this.showSuit,showArr:this.showArr,
        show:this.show,show2:this.show2,nums:this.nums,cardId:2})
      AllCard({arr:this.arr3,showSuit:this.showSuit,showArr:this.showArr,
        show:this.show,show2:this.show2,nums:this.nums,cardId:3})
      AllCard({arr:this.arr4,showSuit:this.showSuit,showArr:this.showArr,
        show:this.show,show2:this.show2,nums:this.nums,cardId:4})
      //返回图标
      SymbolGlyph($r('sys.symbol.chevron_left_circle'))
        .fontWeight(FontWeight.Normal)
        .fontColor([Color.Black])
        .padding(45)
        .fontSize(56)
        .onClick(() => {
          router.pushUrl({
            url:"pages/Index"
          })
        })

    }.backgroundImage($r("app.media.pk3"))
    .backgroundImageSize(1)
    .backgroundImagePosition(Alignment.Bottom)
    .height("100%")
  }
}
//按钮,相比CommonMode页面，撤销时会回退扑克回到池子
@Component
struct ButtonRow {
  @Link showSuit:number[]
  @Link arr1:number[]
  @Link arr2:number[]
  @Link arr3:number[]
  @Link arr4:number[]
  @Link showArr:number[]
  @Link nums:string[]
  @Link show:boolean
  @Link show2:boolean
  @Link ith: number
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample(),
  })
  build() {
    Row() {
      SymbolGlyph($r('sys.symbol.ohos_trash'))
        .fontWeight(FontWeight.Normal)
        .fontSize(56)
        .onClick(() => {
          switch (this.showSuit[this.showSuit.length-1]){
            case 1:
              this.arr1.push(this.showArr[this.showArr.length-1])
              break
            case 2:
              this.arr2.push(this.showArr[this.showArr.length-1])
              break
            case 3:
              this.arr3.push(this.showArr[this.showArr.length-1])
              break
            case 4:
              this.arr4.push(this.showArr[this.showArr.length-1])
              break
          }
          this.showSuit.pop()
          this.showArr.pop()
          this.nums.pop()
          this.show2 = false
          if (this.showArr.length == 0)
            this.show = false
        })
        .width("40%")
        .visibility(this.show ? Visibility.Visible : Visibility.Hidden)

      SymbolGlyph($r('sys.symbol.checkmark_circle'))
        .fontWeight(FontWeight.Normal)
        .fontSize(56)
        .onClick(() => {
          const num1 = parseFloat(this.nums[0]);
          const num2 = parseFloat(this.nums[1]);
          const num3 = parseFloat(this.nums[2]);
          const num4 = parseFloat(this.nums[3]);
          const flag = calc24(num1, num2, num3, num4);
          if (flag) {
            console.log(`可以得到24`);
            promptAction.showToast({
              message: '选择正确，继续选择'
            })
            this.ith++;
          } else {
            console.log(`无法得到24`);
            this.dialogController.open()
          }
          this.nums.length=0;
          this.showArr.length=0;
          this.showSuit.length=0;
          this.show=false;
          this.show2=false;
        })
        .width("10%")
        .visibility(this.show2 ? Visibility.Visible : Visibility.Hidden)
    }
  }
}
//扑克
@Component
struct AllCard {
  @Link arr:number[]
  @Link showSuit:number[]
  @Link showArr:number[]
  @Link nums:string[]
  @Link show:boolean
  @Link show2:boolean
  @State cardId:number=0
  build() {
    List() {
      ForEach(this.arr, (item: number,index:number) => {
        ListItem() {
          Image('images/' + item + '.png')
            .width(80)
            .height(100)
            .border({ width: 2 })
            .objectFit(ImageFit.Fill)
            .autoResize(true)
            .onClick(() => {//相比CommonMode页面，选择扑克会从池子中删除该扑克
              if (this.showArr.length < 4 && !this.showArr.includes(item)) {
                this.showArr.push(item)
                this.showSuit.push(this.cardId)
                this.nums.push(((item+2)%13).toString())
                this.arr.splice(index,1)
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
//自定义弹窗
@CustomDialog
struct CustomDialogExample {
  controller: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({}),
  })
  build() {
    Column() {
      Text('选择错误,返回首页').fontSize(20).margin({ top: 10, bottom: 10 })
        Button('返回')
          .onClick(() => {
            this.controller.close()
            router.pushUrl({
              url:"pages/Index"
            })
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }

}

//计算逻辑，将CommonMode的代码略作修改
function calc24(num1: number, num2: number, num3: number, num4: number): boolean {
  const nums = [num1, num2, num3, num4];
  const ops = ['+', '-', '*', '/'];
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
  // 尝试所有数字和运算符的排列组合，返回是否可以得到24
  const tryOps = (a: number, b: number, c: number, d: number): boolean => {
    for (const op1 of ops) {
      for (const op2 of ops) {
        for (const op3 of ops) {
          const results = [
            applyOp(applyOp(applyOp(a, b, op1), c, op2), d, op3),
            applyOp(applyOp(a, b, op1), applyOp(c, d, op3), op2),
            applyOp(a, applyOp(applyOp(b, c, op2), d, op3), op1),
            applyOp(a, applyOp(b, applyOp(c, d, op3), op2), op1),
            applyOp(applyOp(a, applyOp(b, c, op2), op1), d, op3)
          ];
          for (let result of results) {
            if (Math.abs(result - 24) < 1e-6) {
              return true;
            }
          }
        }
      }
    }
    return false;
  };
  // 对所有排列组合尝试运算
  const perms = permutations(nums);
  for (const perm of perms) {
    if (tryOps(perm[0], perm[1], perm[2], perm[3])) {
      return true; // 如果找到一个组合可以得到24，返回true
    }
  }
  return false; // 如果所有组合都无法得到24，返回false
}
