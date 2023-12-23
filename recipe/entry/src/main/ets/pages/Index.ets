import router from '@ohos.router';
@Entry
@Component
struct Index {
  build() {
    Row() {
      Column() {
        Box()
          .margin(15)
      }
      .width('100%')
    }
    .height('100%')
    .backgroundImage('/entryability/bg1.jpg')
    .backgroundImageSize(ImageSize.Cover)
  }
}
//封装成一个组件
@Component
struct Box{
  build(){
    Row(){
      Column(){
        Text("Cooking a \nDelicious Food\nEasily")
          .fontSize(34)
          .fontWeight(FontWeight.Bold)
          .margin({top:200})
          .fontColor(Color.White)
        Text("choose any recipes you would like to cook")
          .fontSize(15)
          .fontColor(Color.White)
          .margin({top:28})
        Button('Log in')
          .type(ButtonType.Normal)
          .borderRadius(10)
          .backgroundColor(0xFD7600)
          .width('230')
          .margin({top:28})
          .onClick(()=>{
            router.pushUrl({url:'pages/Login'})
          })

        Button('Register')
          .type(ButtonType.Normal)
          .borderRadius(10)
          .backgroundColor(Color.Black)
          .borderColor(0xFD7600)
          .borderWidth(3)
          .margin({top:28})
          .width('230')
          .onClick(()=>{
            router.pushUrl({url:'pages/Register'})
          })
      }
    }
  }
}