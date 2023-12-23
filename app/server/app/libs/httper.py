# encoding=utf-8
__author__ = 'Zephyr369'
import requests
# http请求模块
class HTTP:
    @staticmethod
    def get(url,return_json = True):

        r = requests.get(url)
        if r.status_code != 200:
            return {} if return_json else ""
        else:
            return r.json() if return_json else r.text