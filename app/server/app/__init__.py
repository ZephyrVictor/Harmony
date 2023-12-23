# encoding=utf-8
__author__ = 'Zephyr369'
from flask import Flask

from app.models.user import db


def register_blueprint(app):
    from app.web import web
    app.register_blueprint(web)


def create_app():
    app = Flask(__name__)

    app.config.from_object('app.setting')
    app.config.from_object('app.secure')

    register_blueprint(app)
    db.init_app(app)
    db.create_all(app=app)

    return app



