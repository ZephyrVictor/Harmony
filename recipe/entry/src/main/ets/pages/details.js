import http from '@ohos.net.http';
struct Details extends   {
    constructor() { }
    searchTheId(id) {
        let recipeData;
        let httpRequest = http.createHttp();
        httpRequest.request("127.0.0.1:5000/list?id=" + id, {
            method: http.RequestMethod.GET,
            expectDataType: http.HttpDataType.OBJECT,
            usingCache: true,
            priority: 1,
            connectTimeout: 60000,
            readTimeout: 60000,
            usingProtocol: http.HttpProtocol.HTTP1_1,
        }, (err, data) => {
            if (!err) {
                // 对数据进行处理
                if (data.result && typeof data.result === 'object') {
                    // 进行类型断言确保属性存在
                    let resultData = data.result;
                    // 解析 JSON 数据为 RecipeData 类型
                    recipeData = {
                        name: resultData.name || '',
                        tips: resultData.tips || '',
                        ingredient: resultData.ingredient || [],
                        instruction: resultData.instruction || [],
                    };
                }
            }
            else {
                console.info('error:' + JSON.stringify(err));
                // 取消订阅HTTP响应头事件
                httpRequest.off('headersReceive');
                // 当该请求使用完毕时，调用destroy方法主动销毁
                httpRequest.destroy();
            }
        });
        return;
    }
    build() {
            .height('100%');
    }
}
//# sourceMappingURL=details.js.map