#!/usr/bin/python
# -*- coding: utf-8 -*-

import traceback
import argparse
import json
from envparse import env
from bottle import route, run, request, response, hook, HTTPResponse
from libs.watcher import get_smi_record
from libs.encoder import MyEncoder

# -----------

env.read_envfile()
PORT = env.int("PORT", default=8080)

hasInternalError = False

# -----------

@hook('after_request')
def after_request():
    # CORS settings
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'GET, POST'
    response.headers['Access-Control-Allow-Headers'] = 'Origin, Accept, Content-Type, X-Requested-With, X-CSRF-Token'


# -----------
# request hundler

@route('/api/v1/health', method='GET')
def api_health_check():
    r = None
    if not hasInternalError:
        r = HTTPResponse(status=200)
        # TODO: 何らかの動作テスト
    else:
        r = HTTPResponse(status=500)
    return r

@route('/api/v1/status', method='GET')
def api_status():
    """REST API : status
    """
    response.content_type = 'application/json'

    records = []
    try:
        for record in get_smi_record():
            records.append(record)
    except Exception as ex:
        print(ex)
        print(traceback.format_exc())
        return  HTTPResponse(status=500)

    # build responce
    result_content = {
        "results": records
    }
    print(json.dumps(result_content, indent=2, cls=MyEncoder)) # debugprint
    return json.dumps(
        result_content,
        sort_keys=True,
        ensure_ascii=False,
        indent=2,
        cls=MyEncoder
    ) # FIXME: ensure_ascii

# -----------
# bootstrap

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Bottle Server')
    parser.add_argument('--port', dest='port', type=int, default=PORT, help='port number (default: 58080')
    args = parser.parse_args()
    run(host='0.0.0.0', port=args.port, debug=True)
