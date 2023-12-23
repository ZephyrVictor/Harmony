import router from '@ohos.router';
import http from '@ohos.net.http';
import promptAction from '@ohos.promptAction';
import prompt from '@ohos.prompt';
class Ingredient {
  amount: string;
  name: string;
};

class Instruction {
  step: number;
  text: string;
  url: string;
};

class RecipeData  {
  name: string;
  tips: string;
  ingredient: Ingredient[];
  instruction: Instruction[];

  constructor() {
    this.name = '';
    this.tips = '';
    this.ingredient = [];
    this.instruction = [];
  }
};

@Entry
@Component
struct Details {
  @State current_recipeId:string = router.getParams()['id'].toString()
  @State current_username:string = router.getParams()['username'].toString()
  // 示例数据 - 食材
  build(){
    Row(){
      Column(){
        detail({current_recipeId:this.current_recipeId})
      }
    }
  }
}
@Component
struct detail{
  @State example: RecipeData = new RecipeData();
  @State current_username:string = router.getParams()['username'].toString()
  current_recipeId:string;
  makeStar(id:string){
    let username:string = this.current_username
    let httpRequest = http.createHttp();
    httpRequest.request(
      // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
      "127.0.0.1:5000/star",
      {
        method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
        // 开发者根据自身业务需要添加header字段
        header: {
          'Content-Type': 'application/json'
        },
        // 当使用POST请求时此字段用于传递内容
        extraData: {
          "id": id,
          "username":this.current_username
        },
        expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
        usingCache: true, // 可选，默认为true
        priority: 1, // 可选，默认为1
        connectTimeout: 60000, // 可选，默认为60000ms
        readTimeout: 60000, // 可选，默认为60000ms
        usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
      }, (err, data) => {
      if (!err) {
          console.info(JSON.stringify(data.result))
          if(JSON.stringify(data.result)=='{"msg":"already favorited"}'){
            promptAction.showToast({
              message:"已经收藏过啦",
              duration:1000
            })
          }
        else{
          promptAction.showToast({
            message:"收藏成功",
            duration:1000
          })
        }
      } else {
        console.info('error:' + JSON.stringify(err));
        // 取消订阅HTTP响应头事件
        httpRequest.off('headersReceive');
        // 当该请求使用完毕时，调用destroy方法主动销毁
        httpRequest.destroy();
      }
    }
    );
  }
  aboutToAppear(){
    console.info(this.current_recipeId)
    this.searchTheId1(this.current_recipeId, (result) => {
      // 在回调函数中处理结果
      this.example = result;
      console.log(JSON.stringify(this.example));
    });
    // this.example =  this.searchTheId("322605")
    // console.info("hhhh")
    console.info(JSON.stringify(this.example))
    console.info(this.current_username)
  }
  aboutToDisappear(){
    console.info("deactivate")
  }
  searchTheId(id: string): RecipeData {

    let recipeData: RecipeData;
    let httpRequest = http.createHttp();
    httpRequest.request(
      "127.0.0.1:5000/getDetails?id=" + id,
      {
        method: http.RequestMethod.GET,
        expectDataType: http.HttpDataType.OBJECT,
        usingCache: true,
        priority: 1,
        connectTimeout: 60000,
        readTimeout: 60000,
        usingProtocol: http.HttpProtocol.HTTP1_1,
      },
      (err, data) => {
        if (!err) {
          // 对数据进行处理
          if (data.result && typeof data.result === 'object') {
            // 进行类型断言确保属性存在
            let resultData = data.result as {
              name?: string;
              tips?: string;
              ingredient?: Ingredient[];
              instruction?: Instruction[]
            };
            console.info(JSON.stringify(data.result));
            // 解析 JSON 数据为 RecipeData 类型
            recipeData = {
              name: resultData.name || '',
              tips: resultData.tips || '',
              ingredient: resultData.ingredient || [],
              instruction: resultData.instruction || [],
            };
            console.info(JSON.stringify(recipeData))
            // console.info(recipeData.name)

          }
        } else {
          console.info('error:' + JSON.stringify(err));
          // 取消订阅HTTP响应头事件
          httpRequest.off('headersReceive');
          // 当该请求使用完毕时，调用destroy方法主动销毁
          httpRequest.destroy();
        }
      }
    );
    return recipeData;
  }

  searchTheId1(id: string, callback: (recipeData: RecipeData) => void): void {
  let httpRequest = http.createHttp();
  httpRequest.request(
    "127.0.0.1:5000/getDetails?id=" + id,
    {
      method: http.RequestMethod.GET,
      expectDataType: http.HttpDataType.OBJECT,
      usingCache: true,
      priority: 1,
      connectTimeout: 60000,
      readTimeout: 60000,
      usingProtocol: http.HttpProtocol.HTTP1_1,
    },
    (err, data) => {
      if (!err) {
        // 对数据进行处理
        if (data.result && typeof data.result === 'object') {
          // 进行类型断言确保属性存在
          let resultData = data.result as {
            name?: string;
            tips?: string;
            ingredient?: Ingredient[];
            instruction?: Instruction[];
          };

          // 解析 JSON 数据为 RecipeData 类型
          const recipeData: RecipeData = {
            name: resultData.name || '',
            tips: resultData.tips || '',
            ingredient: resultData.ingredient || [],
            instruction: resultData.instruction || [],
          };

          // 调用回调函数传递结果
          callback(recipeData);
        }
      } else {
        console.info('error:' + JSON.stringify(err));
        // 取消订阅HTTP响应头事件
        httpRequest.off('headersReceive');
        // 当该请求使用完毕时，调用destroy方法主动销毁
        httpRequest.destroy();
      }
    }
  );
}
  build() {
    Row() {
      Column() {
        Column() {
          Row(){
            Text(this.example.name)
              .margin({ top: 10 })
              .fontSize(28)
              .fontColor(0xFD7600)
              .textAlign(TextAlign.Start)
            Button('收藏')
              .width(60)
              .backgroundColor(0xFD7600)
              .type(ButtonType.Circle)
              .margin({left:0})
              .onClick(()=>{
                  this.makeStar(this.current_recipeId)
              })
          }

          Text('小贴士:' + this.example.tips.toString())
            .margin({ top: 10 })
            .fontSize(20)
            .fontColor(Color.Gray)
            .width(300)
        }
        .justifyContent(FlexAlign.Start)

        List() {
          ListItem() {
            Column() {
              Text('原料')
                .fontSize(28)
              ForEach(
                this.example.ingredient,
                (item: Ingredient) => {
                  Row() {
                    Column() {
                      Text(item.name)
                        .fontSize(28)
                        .fontColor(0xFD7600)
                        .textAlign(TextAlign.Start)
                    }

                    Column() {
                      Text(item.amount)
                        .fontSize(28)
                        .fontColor("#D1B48C")
                        .margin({ left: 100 })
                        .textAlign(TextAlign.End)
                    }
                  }

                }
              )
            }
            .width('100%')
          }
          .backgroundColor('#F4F6F5')
          .margin(10)
          .borderRadius(10)

          ListItem() {
            Column({space:8}){
              List({space:8}){
                ForEach(
                  this.example.instruction,
                  (item:Instruction)=>{
                    ListItem(){
                      Row({space:10}){
                        Image(item.url)
                          .width(130)

                        Column({space:4}){
                          Text('步骤'+item.step.toString())
                            .fontSize(28)
                            .fontWeight(FontWeight.Bold)
                            .width(200)
                          Text(item.text)
                            .fontSize(18)
                            .width(190)
                            .maxLines(6)
                            .textOverflow({ overflow: TextOverflow.Ellipsis })
                        }
                        .height('100%')
                        .alignItems(HorizontalAlign.Start)
                        .width('90%')
                      }
                      .width('100%')
                      .backgroundColor('#F4F6F5')
                      .borderRadius(15)
                      .height(200)
                      .padding(10)
                    }

                  }
                )
              }
              .width('97%')

            }
            .justifyContent(FlexAlign.Center)
          }
          // .width(300)
        }
        .width('100%')

      }
      .height('100%')
    }
  }
}