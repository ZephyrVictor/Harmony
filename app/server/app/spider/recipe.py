# encoding=utf-8
__author__ = 'Zephyr369'

from app.libs.httper import HTTP


# 之所以叫spider 是因为这个向api发送请求的样子有点像爬虫取数据

class recipe:
    # the params of api
    app_id = "mejkrpn9odkpduwk"
    app_secret = "Kn15RUduAQkN2FjSKq2NkYGm9NLL5tWO"
    # 一些网址的属性
    # 关键字搜索
    keywords_url = ("https://www.mxnzp.com/api/cookbook/search?keyword={keywords}&"
                    "app_id={app_id}&app_secret={app_secret}&page={page}")
    # 分类选择
    category_url = "https://www.mxnzp.com/api/cookbook/category?category_id={category_id}&app_id={app_id}&app_secret={app_secret}"
    # 根据id选择菜品
    category_list_url = "https://www.mxnzp.com/api/cookbook/list/category?category_id={category_id}&app_id={app_id}&app_secret={app_secret}&page={page}"
    # 菜谱详情信息
    details_url = "https://www.mxnzp.com/api/cookbook/details?id={id}&app_id={app_id}&app_secret={app_secret}"

    #利用关键字搜索
    def search_by_keywords(self, keywords, page=1):
        url = self.keywords_url.format(keywords=keywords, app_id=self.app_id, app_secret=self.app_secret, page=page)
        result = HTTP.get(url)

        data = result.get("data", {})
        total_count = data.get("totalCount", 0)

        if total_count == 0:
            # 如果totalCount为0，返回一个空的字典
            return {"msg":"noRecipe"}
        else:
            # 如果totalCount不为0，返回data键值下的list
            return {"data": data.get("list", []),"totalCount": total_count}
    #用id找一堆菜名
    def search_by_id(self, id, page=1):
        url = self.category_list_url.format(category_id=id, app_id=self.app_id, app_secret=self.app_secret, page=page)
        result = HTTP.get(url)

        inner_data_list = result.get("data", {}).get("list", [])  # 获取内层的data中的list，如果不存在则返回空列表
        return {"data": inner_data_list}

    #找分类（一共三级，最大级-1）
    def get_categories(self,id=-1):
        url = self.category_url.format(category_id=id,app_id=self.app_id,app_secret=self.app_secret)
        result = HTTP.get(url)

        data = result.get("data",[])
        return data


    def getDetails(self,id):
        url = self.details_url.format(id=id, app_id=self.app_id, app_secret=self.app_secret)
        result = HTTP.get(url)
        data = result.get("data", {})
        if (bool(data) == False):
            #还是做一下鲁棒性检查，按理说点进来的id查找一般都有效 但是万一api自己本身的问题呢
            return {"msg":"noRecipe"}
        else:
            return data

    def get_favorite_dish_ids(self):
        return [dish.id for dish in self.favorite_dishes]
