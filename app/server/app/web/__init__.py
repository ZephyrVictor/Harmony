# encoding=utf-8
__author__ = 'Zephyr369'
from flask import Blueprint, jsonify

web = Blueprint("web",__name__)

@web.app_errorhandler(404)
def not_fount(e):
    return jsonify({"result":"page not found"})

from app.web import search
