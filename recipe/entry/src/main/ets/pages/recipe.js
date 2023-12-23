import router from '@ohos.router';
import http from '@ohos.net.http';
//数据类声明
//原料类
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
struct Recipe extends   {
    constructor() { }
    TabBuilder(title, normalImg) {
            .width('100%')
            .height(50)
            .justifyContent(FlexAlign.Center);
    }
    build() {
            .height('100%');
    }
}
struct theRecipe extends  {
    constructor() { }
    TabBuilder(title, targetIndex) {
            .onClick(() => {
            this.articles = [];
        });
    }
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
            // if (!err) {
            //   // data.result为HTTP响应内容，可根据业务需要进行解析
            //   console.info('Result:' + JSON.stringify(data.result));
            //   console.info('code:' + JSON.stringify(data.responseCode));
            //
            //   // 对数据进行处理
            //   if (data.result && typeof data.result === 'object' && 'data' in data.result && Array.isArray((data.result as any).data)) {
            //     // 将 JSON 数据解析为 Article 类型的数组
            //     articleList = (data.result as any).data.map((item: any) => {
            //       // 解析每个文章的食材信息
            //       const ingredients: Ingredient[] = item.ingredient.map((ingredientData: any) => new Ingredient(ingredientData.name));
            //
            //       // 创建 Article 实例
            //       return new Article(item.cover, item.desc, item.id, ingredients, item.name);
            //     });
            //   }
            //
            //
            //
            // }
            // if (!err) {
            //   // data.result 为 HTTP 响应内容，可根据业务需要进行解析
            //   const resultData = data.result as { data?: any[] };
            //
            //   console.info('Result:' + JSON.stringify(data.result));
            //   console.info('code:' + JSON.stringify(data.responseCode));
            //
            //   // 对数据进行处理
            //   if (resultData.data && Array.isArray(resultData.data)) {
            //     // 遍历数组中的每个元素，每个元素都是一个单独的 Article 对象
            //     articleList = resultData.data.map((item: any) => {
            //       // 解析每个文章的食材信息
            //       const ingredients: Ingredient[] = item.ingredient.map((ingredientData: any) => new Ingredient(ingredientData.name));
            //
            //       // 创建 Article 实例
            //       return new Article(item.cover, item.desc, item.id, ingredients, item.name);
            //     });
            //   }
            // }
            // if (!err) {
            //
            //   if (data.result && typeof data.result === 'object' && 'data' in data.result && Array.isArray((data.result as any).data)) {
            //     // 将 JSON 数据解析为 Article 类型的数组
            //     articleList = (data.result as any).data.map((item: any) => {
            //       // 解析每个文章的食材信息
            //       const ingredients: Ingredient[] = item.ingredient.map((ingredientData: any) => new Ingredient(ingredientData.name));
            //
            //       // 创建 Article 实例
            //       return new Article(item.cover, item.desc, item.id, ingredients, item.name);
            //     });
            //   }
            //
            //   // 更新 articles 数组
            //   this.articles = articleList;
            // }
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
    //写完这个函数才想起来previewer没法输入中文 所以还是输入id吧
    searchTheKeyWords(keyword) {
        let articleList = [];
        let httpRequest = http.createHttp();
        httpRequest.request("127.0.0.1:5000/list?id=" + keyword, {
            method: http.RequestMethod.GET,
            expectDataType: http.HttpDataType.OBJECT,
            usingCache: true,
            priority: 1,
            connectTimeout: 60000,
            readTimeout: 60000,
            usingProtocol: http.HttpProtocol.HTTP1_1,
        }, (err, data) => {
            // if (!err) {
            //   // data.result为HTTP响应内容，可根据业务需要进行解析
            //   console.info('Result:' + JSON.stringify(data.result));
            //   console.info('code:' + JSON.stringify(data.responseCode));
            //
            //   // 对数据进行处理
            //   if (data.result && typeof data.result === 'object' && 'data' in data.result && Array.isArray((data.result as any).data)) {
            //     // 将 JSON 数据解析为 Article 类型的数组
            //     articleList = (data.result as any).data.map((item: any) => {
            //       // 解析每个文章的食材信息
            //       const ingredients: Ingredient[] = item.ingredient.map((ingredientData: any) => new Ingredient(ingredientData.name));
            //
            //       // 创建 Article 实例
            //       return new Article(item.cover, item.desc, item.id, ingredients, item.name);
            //     });
            //   }
            //
            //
            //
            // }
            // if (!err) {
            //   // data.result 为 HTTP 响应内容，可根据业务需要进行解析
            //   const resultData = data.result as { data?: any[] };
            //
            //   console.info('Result:' + JSON.stringify(data.result));
            //   console.info('code:' + JSON.stringify(data.responseCode));
            //
            //   // 对数据进行处理
            //   if (resultData.data && Array.isArray(resultData.data)) {
            //     // 遍历数组中的每个元素，每个元素都是一个单独的 Article 对象
            //     articleList = resultData.data.map((item: any) => {
            //       // 解析每个文章的食材信息
            //       const ingredients: Ingredient[] = item.ingredient.map((ingredientData: any) => new Ingredient(ingredientData.name));
            //
            //       // 创建 Article 实例
            //       return new Article(item.cover, item.desc, item.id, ingredients, item.name);
            //     });
            //   }
            // }
            // if (!err) {
            //
            //   if (data.result && typeof data.result === 'object' && 'data' in data.result && Array.isArray((data.result as any).data)) {
            //     // 将 JSON 数据解析为 Article 类型的数组
            //     articleList = (data.result as any).data.map((item: any) => {
            //       // 解析每个文章的食材信息
            //       const ingredients: Ingredient[] = item.ingredient.map((ingredientData: any) => new Ingredient(ingredientData.name));
            //
            //       // 创建 Article 实例
            //       return new Article(item.cover, item.desc, item.id, ingredients, item.name);
            //     });
            //   }
            //
            //   // 更新 articles 数组
            //   this.articles = articleList;
            // }
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
    build() {
        ;
    }
}
//预览信息的组件，封装了一下，好像这个tabBar切换界面的时候不会被释放，时间来不及了 简单复制一下组件试试
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
            // if (!err) {
            //   // data.result为HTTP响应内容，可根据业务需要进行解析
            //   console.info('Result:' + JSON.stringify(data.result));
            //   console.info('code:' + JSON.stringify(data.responseCode));
            //
            //   // 对数据进行处理
            //   if (data.result && typeof data.result === 'object' && 'data' in data.result && Array.isArray((data.result as any).data)) {
            //     // 将 JSON 数据解析为 Article 类型的数组
            //     articleList = (data.result as any).data.map((item: any) => {
            //       // 解析每个文章的食材信息
            //       const ingredients: Ingredient[] = item.ingredient.map((ingredientData: any) => new Ingredient(ingredientData.name));
            //
            //       // 创建 Article 实例
            //       return new Article(item.cover, item.desc, item.id, ingredients, item.name);
            //     });
            //   }
            //
            //
            //
            // }
            // if (!err) {
            //   // data.result 为 HTTP 响应内容，可根据业务需要进行解析
            //   const resultData = data.result as { data?: any[] };
            //
            //   console.info('Result:' + JSON.stringify(data.result));
            //   console.info('code:' + JSON.stringify(data.responseCode));
            //
            //   // 对数据进行处理
            //   if (resultData.data && Array.isArray(resultData.data)) {
            //     // 遍历数组中的每个元素，每个元素都是一个单独的 Article 对象
            //     articleList = resultData.data.map((item: any) => {
            //       // 解析每个文章的食材信息
            //       const ingredients: Ingredient[] = item.ingredient.map((ingredientData: any) => new Ingredient(ingredientData.name));
            //
            //       // 创建 Article 实例
            //       return new Article(item.cover, item.desc, item.id, ingredients, item.name);
            //     });
            //   }
            // }
            // if (!err) {
            //
            //   if (data.result && typeof data.result === 'object' && 'data' in data.result && Array.isArray((data.result as any).data)) {
            //     // 将 JSON 数据解析为 Article 类型的数组
            //     articleList = (data.result as any).data.map((item: any) => {
            //       // 解析每个文章的食材信息
            //       const ingredients: Ingredient[] = item.ingredient.map((ingredientData: any) => new Ingredient(ingredientData.name));
            //
            //       // 创建 Article 实例
            //       return new Article(item.cover, item.desc, item.id, ingredients, item.name);
            //     });
            //   }
            //
            //   // 更新 articles 数组
            //   this.articles = articleList;
            // }
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
//# sourceMappingURL=recipe.js.map