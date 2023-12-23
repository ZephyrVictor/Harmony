# encoding=utf-8
__author__ = 'Zephyr369'

from flask import request

from flask import jsonify

from app.models.user import User, db, UserFavoriteDish
from app.spider.recipe import recipe
from app.web import web


#关键字搜索
@web.route('/search')
def search():
    keywords = request.args.get('keywords')  # 获取请求中的keywords参数
    page = request.args.get('page', 1)  # 获取请求中的page参数，默认为1
    print("server got the keywords: + " + str(keywords))
    rec = recipe()  # 实例化我的recipe业务核心类
    if keywords:
        result = jsonify(rec.search_by_keywords(keywords, page))
    else:
        result = jsonify({"msg":"noKeywords"})  # 表示木有输入关键字
    return result
#展示详情
@web.route('/getDetails')
def getDetails():
    id = request.args.get('id')
    print("server got the id:" + str(id))
    rec = recipe()
    if id:
        result = jsonify(rec.getDetails(id))
    else:
        result = jsonify({"msg": "noId"})
    return result
#注册
@web.route('/register',methods=['POST'])
def register():
    data = request.get_json()
    username = data.get('userid')
    password = data.get('password')

    # 用户已经存在
    if User.query.filter_by(username=username).first():
        return jsonify({"msg": "userExist"})

    # 创建一个新用户
    new_user = User(username=username, password=password)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({"msg": "success","username":new_user.username})
from flask import jsonify

@web.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('userid')
    password = data.get('password')

    # 用户不存在
    user = User.query.filter_by(username=username).first()
    if not user:
        return jsonify({"msg": "userNotExist"})

    # 用户密码错误
    if not user.check_password(password):
        return jsonify({"msg": "incorrectPassword"})

    # Login successful
    return jsonify({"msg": "success", "username":user.username})

@web.route('/category',methods=['GET'])
def category():
    id = request.args.get('id')
    print("server got the id:" + str(id))
    rec = recipe()
    if id:
        result = jsonify({"data":rec.get_categories(id)})
    else:
        result = jsonify({"msg":"noId"})
    return result

@web.route('/list')
def list():
    id = request.args.get('id')

    print("server got the id:" + str(id))
    rec = recipe()
    if id:
        result = jsonify(rec.search_by_id(id))

    else:
        result = jsonify({"msg": "noId"})
    return result
@web.route('/star', methods=['POST'])
def star():
    data = request.get_json()
    dish_id = data['id']
    username = data['username']

    user = User.query.filter_by(username=username).first()

    if user:
        # 检查是否已经收藏
        existing_favorite = UserFavoriteDish.query.filter_by(user_id=user.id, dish_id=dish_id).first()
        if existing_favorite:
            return jsonify({"msg": "already favorited"})

        # 添加收藏
        favorite_dish = UserFavoriteDish(user_id=user.id, dish_id=dish_id)
        db.session.add(favorite_dish)
        db.session.commit()
        return jsonify({"msg": "success"})
    else:
        return jsonify({"msg": "user not found"})


@web.route('/getStar',methods=['GET'])
def getStar():
    username = request.args.get('username')

    user = User.query.filter_by(username=username).first()

    if user:
        favorite_dish_ids = UserFavoriteDish.query.filter_by(user_id=user.id).with_entities(
            UserFavoriteDish.dish_id).all()
        favorite_dish_ids = [dish_id[0] for dish_id in favorite_dish_ids]
        return jsonify({"data": favorite_dish_ids})
    else:
        return jsonify({"msg": "error"})
