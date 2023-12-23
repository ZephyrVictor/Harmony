import router from '@ohos.router';
import http from '@ohos.net.http';
class Ingredient {
    constructor(name) {
        this.name = name;
    }
}
//文章缩略图类
class Article {
    constructor(cover, desc, id, ingredient, name) {
        this.cover = cover;
        this.desc = desc;
        this.id = id;
        this.ingredient = ingredient;
        this.name = name;
    }
}
struct Searchres extends   {
    constructor() { }
    build() {
        ;
    }
}
struct list extends  {
    constructor() { }
    searchTheList(id) {
        let articleList = [];
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
                let articleList = [];
                // 对数据进行处理
                if (data.result && typeof data.result === 'object' && 'data' in data.result && Array.isArray(data.result.data)) {
                    // 将 JSON 数据解析为 Article 类型的数组
                    articleList = data.result.data.map((item) => {
                        // 解析每个文章的食材信息
                        const ingredients = item.ingredient.map((ingredientData) => new Ingredient(ingredientData.name));
                        // 判断 desc 是否为空，如果为空则设置默认值
                        const description = item.desc ? item.desc : "这道菜没有简介哦！";
                        // 创建 Article 实例
                        return new Article(item.cover, description, item.id, ingredients, item.name);
                    });
                }
                // 更新 articles 数组
                this.articles = articleList;
                console.info(articleList.toString());
            }
            else {
                console.info('error:' + JSON.stringify(err));
                // 取消订阅HTTP响应头事件
                httpRequest.off('headersReceive');
                // 当该请求使用完毕时，调用destroy方法主动销毁
                httpRequest.destroy();
            }
        });
        return articleList;
    }
    aboutToAppear() {
        console.info("hello" + this.Id);
        this.articles = this.searchTheList(this.Id);
        console.info(this.articles.toString());
    }
    aboutToHide() {
        console.info("the list has been deactivated");
        delete this.articles;
    }
    build() {
        ;
    }
}
//# sourceMappingURL=searchres.js.map