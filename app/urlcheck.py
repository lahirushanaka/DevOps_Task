#!/usr/bin/python3

ScriptDesc = """

Purpose : Check HTTP Status of URL's
Description : Script will check the URL Status every 10 minutes
Return Status : Script will return 0 if success
                Script will return non Zero for an Errornous event

Version : 1.0.0.1

"""

import logging, os
import sys
from datetime import datetime, timedelta
import argparse
import time
import configparser
import csv
import requests
from multiprocessing import Pool
from http.server import BaseHTTPRequestHandler, HTTPServer
from apscheduler.schedulers.background import BackgroundScheduler
import json
from concurrent.futures import ThreadPoolExecutor, as_completed



app_name = 'URLChecker'
home_location = './'
script_location = './'
system_logs = './'
hostName = "0.0.0.0"
serverPort = 10000

# offsets of colour codes
BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE = range(8)

LEVEL_COLORS = {  # sets colours for log levels
    'WARNING': YELLOW,
    'INFO': GREEN,
    'DEBUG': BLUE,
    'CRITICAL': MAGENTA,
    'ERROR': RED
}


class ColouredFormatter(logging.Formatter):
    """

    Overrides the 'format' method of the 'logging.Formatter' class to set colours in the log output.

    """

    def __init__(self, log_format, date_format, use_color=True):
        logging.Formatter.__init__(self, log_format, date_format)

        self.use_color = use_color

    def format(self, record):
        level_name = record.levelname

        if self.use_color and level_name in LEVEL_COLORS:
            record.levelname = '\033[1;%d;%dm' % (30 + WHITE, 40 + LEVEL_COLORS[level_name]) + level_name + '\033[0m'

            record.msg = '\033[0;%dm' % (30 + LEVEL_COLORS[level_name]) + record.msg + '\033[0m'

        return logging.Formatter.format(self, record)


date_fmt = '%Y%m%d-%H:%M:%S'
logger = logging.getLogger(app_name)
parser = argparse.ArgumentParser(description=ScriptDesc, formatter_class=argparse.RawTextHelpFormatter)
config_parser = configparser.ConfigParser()


def initLogger():
    try:

        log_name = system_logs + '/' + app_name + '.log'

        # if os.path.isfile(log_name):
        #         timeStamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        #         os.rename(log_name, log_name + "_" + timeStamp)

        logger.setLevel(logging.DEBUG)
        handler = logging.FileHandler(log_name)
        handler.setLevel(logging.DEBUG)
        log_fmt = '%(asctime)s | %(funcName)s | PID:%(process)d | %(levelname)s | %(message)s'
        formatter = logging.Formatter(log_fmt, datefmt=date_fmt)
        handler.setFormatter(formatter)
        logger.addHandler(handler)
#        consoleHandler = logging.StreamHandler()
#        consoleHandler.setFormatter(ColouredFormatter(log_fmt, date_fmt))
#        consoleHandler.setLevel(logging.INFO)
#        logger.addHandler(consoleHandler)

    except Exception as e:
        print(e)
        print("Failed to initialize logger")
        exit(1)
# ================================================== Setup Logger ====================================================


class MyServer(BaseHTTPRequestHandler):

    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        response = json.dumps(allSites)
        response = bytes(response, 'utf-8')
        self.wfile.write(response)


def csvParser(filename):
    global allSites
    allSites = []

    with open(filename, "r") as csvfile:
        csvOut = csv.DictReader(csvfile)
        for row in csvOut:
            #logger.debug("{} \t {}".format(row['name'], row['url']))
            row['status'] = []

            #checkSiteStatus(row)
            allSites.append(row)


def checkAllSites():
    with ThreadPoolExecutor(max_workers=500) as executor:
        executor.map(checkSiteStatus, allSites)
        executor.shutdown(wait=True)


def checkSiteStatus(urlInfo):
    #print('process id:', os.getpid())
    url = urlInfo['url']
    code = ""

    try:
        with requests.get(url, timeout=5) as response:
            try:
                response.raise_for_status()
            except (requests.exceptions.RequestException, requests.exceptions.ConnectionError, requests.Timeout):
                code = "DOWN"
            except (requests.exceptions.HTTPError):
                code = "ERROR"
            else:
                code = "WORK"

            urlInfo['status'].append([datetime.now().strftime(date_fmt), code])
            #logger.info("{} {} \t {}".format(urlInfo['status'][-1][0], url, code))

            if len(urlInfo['status']) > 6:
                urlInfo['status'].pop(0)
    except:
        logger.info("invalid URL - {} ".format(url))


def initConfigParser():
    config_name = script_location + '/' + app_name + '.cfg'
    dataset = config_parser.read(config_name)
    if (len(dataset) == 0):
        logger.error("Config File not Found - " + config_name)
        exit(1)
    return 0


def initArgParser():
    group = parser.add_argument_group(app_name)
    group.add_argument("--config_file", help="Specifies the location of the urls", required=True)
    args = parser.parse_args()
    return args


def main():
    args = initArgParser()
    initLogger()
    try:
        logger.info('Config File - {}'.format(args.config_file))
        csvParser(args.config_file)
        webServer = HTTPServer((hostName, serverPort), MyServer)
        logger.info("Server started http://%s:%s" % (hostName, serverPort))


        checkAllSites()
        scheduler = BackgroundScheduler()
        scheduler.add_job(checkAllSites, 'interval', minutes=10)
        scheduler.start()

        print("Going to Server loop")
        try:
            webServer.serve_forever()
        except KeyboardInterrupt:
            pass

        webServer.server_close()
    except Exception as e:
        logger.error(str(e))
        exit(1)


if __name__ == "__main__":
    main()