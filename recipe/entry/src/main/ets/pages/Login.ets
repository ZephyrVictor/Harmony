import http from '@ohos.net.http';
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
@Entry
@Component
struct Login {
  @State username :string = '';
  @State password :string = '';
  Handle(username:string,password:string):string{
    let httpRequest = http.createHttp();
    httpRequest.request(
      // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
      "127.0.0.1:5000/login",
      {
        method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
        // 开发者根据自身业务需要添加header字段
        header: {
          'Content-Type': 'application/json'
        },
        // 当使用POST请求时此字段用于传递内容
        extraData: {
          "userid": username,
          "password":password
        },
        expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
        usingCache: true, // 可选，默认为true
        priority: 1, // 可选，默认为1
        connectTimeout: 60000, // 可选，默认为60000ms
        readTimeout: 60000, // 可选，默认为60000ms
        usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
      }, (err, data) => {
      if (!err) {
        // data.result为HTTP响应内容，可根据业务需要进行解析
        console.info('Result:' + JSON.stringify(data.result));
        console.info('code:' + JSON.stringify(data.responseCode));
        if(JSON.stringify(data.result) != '{"msg":"success","username":"'+username+'"}'){
          if(JSON.stringify(data.result) == '{"msg":"userNotExist"}')
          {
            promptAction.showToast({
              message:"用户不存在",
              duration:1000
            })
          }
          else{
            promptAction.showToast({
              message:"用户密码错误",
              duration:1000
            })
          }
        }
        else{
          promptAction.showToast({
            message:"登录成功",
            duration:1000
          })
          router.pushUrl({
            url:'pages/recipe',
            params:{
              username:this.username,
            },
          })
        }
        // data.header为HTTP响应头，可根据业务需要进行解析
        console.info('header:' + JSON.stringify(data.header));
        console.info('cookies:' + JSON.stringify(data.cookies)); // 8+
      } else {
        console.info('error:' + JSON.stringify(err));
        // 取消订阅HTTP响应头事件
        httpRequest.off('headersReceive');
        // 当该请求使用完毕时，调用destroy方法主动销毁
        httpRequest.destroy();
      }
    }
    );
    return "something"
  }
  build() {
    Row() {
      Column() {
        Image('/entryability/thelogo.jpg')
          .width('158')
          .margin({bottom:50})
        Text("Log in")
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
        TextInput({placeholder:"请输入用户名"})
          .fontSize(18)
          .margin(10)
          .width(280)
          .onChange((value:string)=>{
            console.info(value);
            this.username = value;
          })
        TextInput({placeholder:"请输入密码"})
          .type(InputType.Password)
          .fontSize(18)
          .margin(10)
          .width(280)
          .onChange((value:string)=>{
            console.info(value);
            this.password = value;
          })
        Button("登录")
          .width(200)
          .margin({top:15})
          .backgroundColor(0xFD7600)
          .type(ButtonType.Normal)
          .borderRadius(10)
          .onClick(()=>{
            this.Handle(this.username,this.password)
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}