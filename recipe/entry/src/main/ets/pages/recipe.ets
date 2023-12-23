import router from '@ohos.router';
import http from '@ohos.net.http';
//数据类声明
//原料类
let current_username:string = router.getParams()['username']
class Ingredient {
  name: string;

  constructor(name: string) {
    this.name = name;
  }
}
//文章缩略图类
class Article {
  cover: string;
  desc: string;
  id: number;
  ingredient: Ingredient[];
  name: string;

  constructor(cover: string, desc: string, id: number, ingredient: Ingredient[], name: string) {
    this.cover = cover;
    this.desc = desc;
    this.id = id;
    this.ingredient = ingredient;
    this.name = name;
  }
}

@Entry
@Component
struct Recipe {
  // @State current_username:string = router.getParams()['username'];

  @State foodName:string = ''

  @Builder TabBuilder(title: string, normalImg: Resource) {
    Column() {
      Image(normalImg)
        .size({ width: 25, height: 25 })
      Text(title)
        .fontColor('#6B6B6B')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }
  build() {
    Row() {
      Column() {
        Tabs({barPosition:BarPosition.End}) {
          TabContent() {
            theRecipe()
          }
          .tabBar(this.TabBuilder('食谱', $rawfile('theRecipeLogo.png')))
          TabContent() {
            starlist()
          }
          .tabBar(this.TabBuilder('我的收藏',$rawfile('userLogo.png')))
        }


      }
      .width('100%')
    }
    .height('100%')
  }
}

@Component
struct theRecipe{
  @State articles:Article[] =[]
  @State foodName:string = ''
  @Builder TabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
    }
    .onClick(() => {
      this.articles = []
    })
  }
  searchTheList(id: string): Article[] {
    let articleList: Article[] = [];

    let httpRequest = http.createHttp();
    httpRequest.request(
      "127.0.0.1:5000/list?id=" + id,
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
          let articleList: Article[] = [];

          // 对数据进行处理
          if (data.result && typeof data.result === 'object' && 'data' in data.result && Array.isArray((data.result as any).data)) {
            // 将 JSON 数据解析为 Article 类型的数组
            articleList = (data.result as any).data.map((item: any) => {
              // 解析每个文章的食材信息
              const ingredients: Ingredient[] = item.ingredient.map((ingredientData: any) => new Ingredient(ingredientData.name));

              // 判断 desc 是否为空，如果为空则设置默认值
              const description = item.desc ? item.desc : "这道菜没有简介哦！";

              // 创建 Article 实例
              return new Article(item.cover, description, item.id, ingredients, item.name);
            });
          }

          // 更新 articles 数组
          this.articles = articleList;
          console.info(articleList.toString())
        }

        else {
          console.info('error:' + JSON.stringify(err));
          // 取消订阅HTTP响应头事件
          httpRequest.off('headersReceive');
          // 当该请求使用完毕时，调用destroy方法主动销毁
          httpRequest.destroy();
        }
      }
    );

    return articleList;
  }
  //写完这个函数才想起来previewer没法输入中文 所以还是输入id吧
  searchTheKeyWords(keyword: string): Article[] {
    let articleList: Article[] = [];

    let httpRequest = http.createHttp();
    httpRequest.request(
      "127.0.0.1:5000/list?id=" + keyword,
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
          let articleList: Article[] = [];

          // 对数据进行处理
          if (data.result && typeof data.result === 'object' && 'data' in data.result && Array.isArray((data.result as any).data)) {
            // 将 JSON 数据解析为 Article 类型的数组
            articleList = (data.result as any).data.map((item: any) => {
              // 解析每个文章的食材信息
              const ingredients: Ingredient[] = item.ingredient.map((ingredientData: any) => new Ingredient(ingredientData.name));

              // 判断 desc 是否为空，如果为空则设置默认值
              const description = item.desc ? item.desc : "这道菜没有简介哦！";

              // 创建 Article 实例
              return new Article(item.cover, description, item.id, ingredients, item.name);
            });
          }

          // 更新 articles 数组
          this.articles = articleList;
          console.info(articleList.toString())
        }

        else {
          console.info('error:' + JSON.stringify(err));
          // 取消订阅HTTP响应头事件
          httpRequest.off('headersReceive');
          // 当该请求使用完毕时，调用destroy方法主动销毁
          httpRequest.destroy();
        }
      }
    );

    return articleList;
  }
  build(){
    Row(){
      Column(){
        Row(){
          TextInput({placeholder:"随便搜一搜"})
            .width(250)
            .onChange((value:string)=>{
              this.foodName = value
              console.info(this.foodName)
            })
          Button("搜索")
            .width(70)
            // .margin({top:15})
            .backgroundColor(0xFD7600)
            .type(ButtonType.Normal)
            .borderRadius(10)
            .onClick(()=>{
              router.pushUrl({
                url:'pages/details',
                params:{
                  id:this.foodName.toString(),
                  username:current_username
                }
              })
            })
        }.margin({top:18})

        Tabs({barPosition:BarPosition.Start}){
          TabContent(){
            list({Id:'3'})
          }
          .tabBar('家常菜')
          TabContent(){
            Column({space:8}){
              List({space:8}){
                ForEach(
                  this.articles,
                  (item:Article)=>{
                    ListItem(){
                      Row({space:10}){
                        Image(item.cover)
                          .width(100)
                        Column({space:4}){
                          Text(item.name)
                            .fontSize(18)
                            .fontWeight(FontWeight.Bold)
                            .width(200)
                          Text(item.desc)
                            .fontSize(15)
                            .width(190)
                            .maxLines(3)
                            .textOverflow({ overflow: TextOverflow.Ellipsis })
                        }
                        .height('100%')
                        .alignItems(HorizontalAlign.Start)
                        .width('90%')
                      }
                      .width('100%')
                      .backgroundColor('#F4F6F5')
                      .borderRadius(15)
                      .height(120)
                      .padding(10)
                    }
                    .onClick(()=>{
                      router.pushUrl({
                        url:'pages/details',
                        params:{
                          id:item.id.toString(),
                          username:current_username
                        }
                      })
                    })
                  }
                )
              }
              .width('90%')

            }
          }
          .tabBar('快手菜')
            .onClick(()=>{
              this.articles = []
              this.articles= this.searchTheList('4')
            })
          TabContent(){
            Column({space:8}){
              List({space:8}){
                ForEach(
                  this.articles,
                  (item:Article)=>{
                    ListItem(){
                      Row({space:10}){
                        Image(item.cover)
                          .width(100)
                        Column({space:4}){
                          Text(item.name)
                            .fontSize(18)
                            .fontWeight(FontWeight.Bold)
                            .width(200)
                          Text(item.desc)
                            .fontSize(15)
                            .width(190)
                            .maxLines(3)
                            .textOverflow({ overflow: TextOverflow.Ellipsis })
                        }
                        .height('100%')
                        .alignItems(HorizontalAlign.Start)
                        .width('90%')
                      }
                      .width('100%')
                      .backgroundColor('#F4F6F5')
                      .borderRadius(15)
                      .height(120)
                      .padding(10)
                    }
                    .onClick(()=>{
                      router.pushUrl({
                        url:'pages/details',
                        params:{
                          id:item.id.toString(),
                          username:current_username
                        }
                      })
                    })
                  }
                )
              }
              .width('90%')

            }
          }.onClick(()=>{
            this.articles = []
            this.articles= this.searchTheList('5')
          })
          .tabBar('下饭菜')
          TabContent(){
            Column({space:8}){
              List({space:8}){
                ForEach(
                  this.articles,
                  (item:Article)=>{
                    ListItem(){
                      Row({space:10}){
                        Image(item.cover)
                          .width(100)
                        Column({space:4}){
                          Text(item.name)
                            .fontSize(18)
                            .fontWeight(FontWeight.Bold)
                            .width(200)
                          Text(item.desc)
                            .fontSize(15)
                            .width(190)
                            .maxLines(3)
                            .textOverflow({ overflow: TextOverflow.Ellipsis })
                        }
                        .height('100%')
                        .alignItems(HorizontalAlign.Start)
                        .width('90%')
                      }
                      .width('100%')
                      .backgroundColor('#F4F6F5')
                      .borderRadius(15)
                      .height(120)
                      .padding(10)
                    }
                    .onClick(()=>{
                      router.pushUrl({
                        url:'pages/details',
                        params:{
                          id:item.id.toString(),
                          username:current_username
                        }
                      })
                    })
                  }
                )
              }
              .width('90%')

            }
          }.onClick(()=>{
            this.articles = []
            this.articles= this.searchTheList('6')
          })
          .tabBar('素菜')
          TabContent(){
            Column({space:8}){
              List({space:8}){
                ForEach(
                  this.articles,
                  (item:Article)=>{
                    ListItem(){
                      Row({space:10}){
                        Image(item.cover)
                          .width(100)
                        Column({space:4}){
                          Text(item.name)
                            .fontSize(18)
                            .fontWeight(FontWeight.Bold)
                            .width(200)
                          Text(item.desc)
                            .fontSize(15)
                            .width(190)
                            .maxLines(3)
                            .textOverflow({ overflow: TextOverflow.Ellipsis })
                        }
                        .height('100%')
                        .alignItems(HorizontalAlign.Start)
                        .width('90%')
                      }
                      .width('100%')
                      .backgroundColor('#F4F6F5')
                      .borderRadius(15)
                      .height(120)
                      .padding(10)
                    }
                    .onClick(()=>{
                      router.pushUrl({
                        url:'pages/details',
                        params:{
                          id:item.id.toString(),
                          username:current_username
                        }
                      })
                    })
                  }
                )
              }
              .width('90%')

            }
          }.onClick(()=>{
            this.articles = []
            this.articles= this.searchTheList('7')
          })
          .tabBar('大鱼大肉')
          TabContent(){
            Column({space:8}){
              List({space:8}){
                ForEach(
                  this.articles,
                  (item:Article)=>{
                    ListItem(){
                      Row({space:10}){
                        Image(item.cover)
                          .width(100)
                        Column({space:4}){
                          Text(item.name)
                            .fontSize(18)
                            .fontWeight(FontWeight.Bold)
                            .width(200)
                          Text(item.desc)
                            .fontSize(15)
                            .width(190)
                            .maxLines(3)
                            .textOverflow({ overflow: TextOverflow.Ellipsis })
                        }
                        .height('100%')
                        .alignItems(HorizontalAlign.Start)
                        .width('90%')
                      }
                      .width('100%')
                      .backgroundColor('#F4F6F5')
                      .borderRadius(15)
                      .height(120)
                      .padding(10)
                    }
                    .onClick(()=>{
                      router.pushUrl({
                        url:'pages/details',
                        params:{
                          id:item.id.toString()
                        }
                      })
                    })
                  }
                )
              }
              .width('90%')

            }
          }.onClick(()=>{
            this.articles = []
            this.articles= this.searchTheList('8')
          })
          .tabBar('下酒菜')
          TabContent(){
            Column({space:8}){
              List({space:8}){
                ForEach(
                  this.articles,
                  (item:Article)=>{
                    ListItem(){
                      Row({space:10}){
                        Image(item.cover)
                          .width(100)
                        Column({space:4}){
                          Text(item.name)
                            .fontSize(18)
                            .fontWeight(FontWeight.Bold)
                            .width(200)
                          Text(item.desc)
                            .fontSize(15)
                            .width(190)
                            .maxLines(3)
                            .textOverflow({ overflow: TextOverflow.Ellipsis })
                        }
                        .height('100%')
                        .alignItems(HorizontalAlign.Start)
                        .width('90%')
                      }
                      .width('100%')
                      .backgroundColor('#F4F6F5')
                      .borderRadius(15)
                      .height(120)
                      .padding(10)
                    }
                    .onClick(()=>{
                      router.pushUrl({
                        url:'pages/details',
                        params:{
                          id:item.id.toString(),
                          username:current_username
                        }
                      })
                    })
                  }
                )
              }
              .width('90%')

            }
          }.onClick(()=>{
            this.articles = []
            this.articles= this.searchTheList('9')
          })
          .tabBar('小清新')
          TabContent(){
            Column({space:8}){
              List({space:8}){
                ForEach(
                  this.articles,
                  (item:Article)=>{
                    ListItem(){
                      Row({space:10}){
                        Image(item.cover)
                          .width(100)
                        Column({space:4}){
                          Text(item.name)
                            .fontSize(18)
                            .fontWeight(FontWeight.Bold)
                            .width(200)
                          Text(item.desc)
                            .fontSize(15)
                            .width(190)
                            .maxLines(3)
                            .textOverflow({ overflow: TextOverflow.Ellipsis })
                        }
                        .height('100%')
                        .alignItems(HorizontalAlign.Start)
                        .width('90%')
                      }
                      .width('100%')
                      .backgroundColor('#F4F6F5')
                      .borderRadius(15)
                      .height(120)
                      .padding(10)
                    }
                    .onClick(()=>{
                      router.pushUrl({
                        url:'pages/details',
                        params:{
                          id:item.id.toString(),
                          username:current_username
                        }
                      })
                    })
                  }
                )
              }
              .width('90%')

            }
          }.onClick(()=>{
            this.articles = []
            this.articles= this.searchTheList('10')
          })
          .tabBar('创意菜')
        }
        .barMode(BarMode.Scrollable)
        .onChange(()=>{
          this.articles = []
        })
      }
    }
  }
}
//预览信息的组件，封装了一下，好像这个tabBar切换界面的时候不会被释放，时间来不及了 简单复制一下组件试试
@Component
struct list{
  Id:string = '0'
  // category:string = ""
  @State articles:Article[] =[]
  searchTheList(id: string): Article[] {
    let articleList: Article[] = [];

    let httpRequest = http.createHttp();
    httpRequest.request(
      "127.0.0.1:5000/list?id=" + id,
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
          let articleList: Article[] = [];

          // 对数据进行处理
          if (data.result && typeof data.result === 'object' && 'data' in data.result && Array.isArray((data.result as any).data)) {
            // 将 JSON 数据解析为 Article 类型的数组
            articleList = (data.result as any).data.map((item: any) => {
              // 解析每个文章的食材信息
              const ingredients: Ingredient[] = item.ingredient.map((ingredientData: any) => new Ingredient(ingredientData.name));

              // 判断 desc 是否为空，如果为空则设置默认值
              const description = item.desc ? item.desc : "这道菜没有简介哦！";

              // 创建 Article 实例
              return new Article(item.cover, description, item.id, ingredients, item.name);
            });
          }

          // 更新 articles 数组
          this.articles = articleList;
          console.info(articleList.toString())
        }

        else {
          console.info('error:' + JSON.stringify(err));
          // 取消订阅HTTP响应头事件
          httpRequest.off('headersReceive');
          // 当该请求使用完毕时，调用destroy方法主动销毁
          httpRequest.destroy();
        }
      }
    );

    return articleList;
  }
  aboutToAppear(){
    console.info("hello"+this.Id)

    this.articles = this.searchTheList(this.Id)
    console.info(this.articles.toString())
  }
  aboutToHide(){
    console.info("the list has been deactivated")
    delete this.articles
  }
  build(){
    Column({space:8}){
      List({space:8}){
        ForEach(
          this.articles,
          (item:Article)=>{
            ListItem(){
              Row({space:10}){
                Image(item.cover)
                  .width(100)
                Column({space:4}){
                  Text(item.name)
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .width(200)
                  Text(item.desc)
                    .fontSize(15)
                    .width(190)
                    .maxLines(3)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .height('100%')
                .alignItems(HorizontalAlign.Start)
                .width('90%')
              }
              .width('100%')
              .backgroundColor('#F4F6F5')
              .borderRadius(15)
              .height(120)
              .padding(10)
            }
            .onClick(()=>{
              router.pushUrl({
                url:'pages/details',
                params:{
                  id:item.id.toString(),
                  username:current_username
                }
              })
            })
          }
        )
      }
      .width('90%')

    }

  }
}
@Component
struct starlist{
  @State current_username:string = router.getParams()['username']
  @State idlist:string[] = []//id的列表
  // searchTheStar(): string[] {
  //   let result: string[] = [];
  //
  //   let httpRequest = http.createHttp();
  //   httpRequest.request(
  //     "127.0.0.1:5000/getStar?username=" + this.current_username,
  //     {
  //       method: http.RequestMethod.GET,
  //       expectDataType: http.HttpDataType.OBJECT,
  //       usingCache: true,
  //       priority: 1,
  //       connectTimeout: 60000,
  //       readTimeout: 60000,
  //       usingProtocol: http.HttpProtocol.HTTP1_1,
  //     },
  //     (err, data) => {
  //       if (!err) {
  //         // 确保 data.result 存在且为数组类型
  //         if (data.result && Array.isArray((data.result as any).data)) {
  //           // 将 JSON 数据中的数组内容读取到 result 数组中
  //           result = ((data.result as any).data ).map(String);
  //         }
  //         // console.info(result.toString())
  //       } else {
  //         console.info('error:' + JSON.stringify(err));
  //         // 取消订阅HTTP响应头事件
  //         httpRequest.off('headersReceive');
  //         // 当该请求使用完毕时，调用destroy方法主动销毁
  //         httpRequest.destroy();
  //       }
  //     }
  //   );
  //
  //   return result;
  // }
  searchTheStar(result: string[]): void {
    let httpRequest = http.createHttp();
    httpRequest.request(
      "127.0.0.1:5000/getStar?username=" + this.current_username,
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
          // 确保 data.result 存在且为数组类型
          if (data.result && Array.isArray((data.result as any).data)) {
            // 将 JSON 数据中的数组内容读取到 result 数组中
            result.splice(0, result.length, ...((data.result as any).data).map(String));
          }
          // console.info(result.toString())
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
    this.searchTheStar(this.idlist)
    console.info("hhhhh")
    console.info(this.idlist.toString())
  }
  build(){
    Column({space:8}){
      Text("我的收藏")
      .fontSize(28)
      .fontColor(Color.Gray)
      List({space:8}){
        ForEach(
          this.idlist,
          (item:string)=>{
            ListItem(){
              Row({space:10}){
                Image('/entryability/thelogo.jpg')
                  .width(100)
                Column({space:4}){
                  Text(item)
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .width(200)
                }
                .height('100%')
                .alignItems(HorizontalAlign.Start)
                .width('90%')
              }
              .width('100%')
              .backgroundColor('#F4F6F5')
              .borderRadius(15)
              .height(120)
              .padding(10)
            }
            .onClick(()=>{
              router.pushUrl({
                url:'pages/details',
                params:{
                  id:item,
                  username:current_username
                }
              })
            })
          }
        )
      }
      .width('90%')

    }

  }
}