from robot.api.deco import library, keyword
from robot.libraries.BuiltIn import BuiltIn
import datetime
import base64
from selenium import webdriver
from selenium import webdriver
# from webdriver_manager.chrome import ChromeDriverManager
import pytz
from datetime import datetime

from webdriver_manager.chrome import ChromeDriverManager

response_time_list = list()
pages_response_dict = dict()


def get_driver():
    return BuiltIn().get_library_instance('AppiumLibrary')._current_application()


def is_leap_year(year):
    if year % 400 == 0:
        return True
    elif year % 100 == 0:
        return False
    elif year % 4 == 0:
        return True
    else:
        return False


@library
class Operation:
    @keyword('Convert Base64 To File')
    # def convert_base64_to_file(self, content, path, product_id):
    def convert_base64_to_file(self, pdf_name, content, path):
        decoded_pdf = base64.b64decode(content)
        # with open(f'{path}/{product_id}_SI.pdf', 'wb') as file:
        with open(f'{path}/{pdf_name}.pdf', 'wb') as file:
            file.write(decoded_pdf)
            file.close()

    # @keyword("Get Chromedriver Path")
    # def get_chromedriver_path(self):
    #     driver_path = ChromeDriverManager().install()
    #     return driver_path

    # def get_driver():
    #     return BuiltIn().get_library_instance('AppiumLibrary')._current_application()

    def is_leap_year(year):
        if year % 400 == 0:
            return True
        elif year % 100 == 0:
            return False
        elif year % 4 == 0:
            return True
        else:
            return False

    @keyword('Get Country Time')
    def get_country_time(self, TimeZone):
        th_time_list = list()

        country_time_zone = pytz.timezone(TimeZone)
        country_time = datetime.now(country_time_zone)
        th_country_date = country_time.strftime("%b %d %Y")
        th_time_list.append(th_country_date)
        th_country_time = country_time.strftime("%H:%M:%S")
        th_time_list.append(th_country_time)
        return th_time_list

    @keyword("Get Chromedriver Path")
    def get_chromedriver_path(self):
        driver_path = ChromeDriverManager().install()
        print(driver_path)
        return driver_path

    @keyword('Get Country Specific DateTime')
    def get_japan_time(self, TimeZone):
        jp_time_list = list()

        country_time_zone = pytz.timezone(TimeZone)
        country_time = datetime.now(country_time_zone)
        japan_country_date = country_time.strftime("%b %d %Y")
        jp_time_list.append(japan_country_date)
        japan_country_time = country_time.strftime("%H:%M:%S")
        jp_time_list.append(japan_country_time)
        return jp_time_list
