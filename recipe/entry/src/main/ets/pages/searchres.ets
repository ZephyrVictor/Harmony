import router from '@ohos.router';
import http from '@ohos.net.http';
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

struct Searchres {
  @State foodName: string = router.getParams()['data']

  build() {
    Column({ space: 8 }) {

        Text("搜索结果：")
          .fontColor(0xFD7600)
          .fontSize(20)
          .textAlign(TextAlign.Start)
          .margin({ top: 10 })
        list({Id:this.foodName})


    }
  }
}
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
                  id:item.id.toString()
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
