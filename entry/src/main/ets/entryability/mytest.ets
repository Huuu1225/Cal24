
let all:number[][]=[[]]
let cnt:number=0

function swap(nums:number[],x:number,y:number):void{
  let t:number=nums[x]
  nums[x]=nums[y]
  nums[y]=t
}

function permutation(nums:number[],start:number,end:number){
  if(start===end){
    all[cnt++]=[...nums]//创建一个 nums 的副本，然后添加到 all 数组中 ， 或者使用 nums.slice(0)
  }
  else{
    for(let i=start;i<end;i++){
      swap(nums,start,i)
      permutation(nums,start+1,end)
      swap(nums,start,i)
    }
  }
}
let nums:number[]=[1,2,3,4]
permutation(nums,0,3)
for(let i:number=0;i<6;i++){
  console.log("lll",all[i])
}