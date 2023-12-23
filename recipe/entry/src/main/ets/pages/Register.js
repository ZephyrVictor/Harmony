import http from '@ohos.net.http';
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
struct Register extends   {
    constructor() { }
    //发送他娘的臭请求的函数，还是他妈的粘贴大法好啊
    //你妈的previewer不要再暴毙了
    Handle(username, password) {
        let httpRequest = http.createHttp();
        httpRequest.request(
        // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
        "127.0.0.1:5000/register", {
            method: http.RequestMethod.POST,
            // 开发者根据自身业务需要添加header字段
            header: {
                'Content-Type': 'application/json'
            },
            // 当使用POST请求时此字段用于传递内容
            extraData: {
                "userid": username,
                "password": password
            },
            expectDataType: http.HttpDataType.OBJECT,
            usingCache: true,
            priority: 1,
            connectTimeout: 60000,
            readTimeout: 60000,
            usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
        }, (err, data) => {
            if (!err) {
                // data.result为HTTP响应内容，可根据业务需要进行解析
                console.info('Result:' + JSON.stringify(data.result));
                console.info('code:' + JSON.stringify(data.responseCode));
                if (JSON.stringify(data.result) != '{"msg":"success","username":"' + username + '"}') {
                    if (JSON.stringify(data.result) == '{"msg":"userExist"}') {
                        promptAction.showToast({
                            message: "用户已经存在",
                            duration: 1000
                        });
                    }
                }
                else {
                    promptAction.showToast({
                        message: "注册成功",
                        duration: 1000
                    });
                    router.pushUrl({
                        url: 'pages/recipe',
                        params: {
                            username: this.username
                        },
                    });
                }
                // data.header为HTTP响应头，可根据业务需要进行解析
                console.info('header:' + JSON.stringify(data.header));
                console.info('cookies:' + JSON.stringify(data.cookies)); // 8+
            }
            else {
                console.info('error:' + JSON.stringify(err));
                // 取消订阅HTTP响应头事件
                httpRequest.off('headersReceive');
                // 当该请求使用完毕时，调用destroy方法主动销毁
                httpRequest.destroy();
            }
        });
        return "something";
    }
    build() {
            .height('100%');
    }
}
//# sourceMappingURL=Register.js.map