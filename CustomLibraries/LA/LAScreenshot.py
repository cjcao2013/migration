import logging

import pyautogui
import win32gui
# from win32 import win32gui
from robot.api.deco import library, keyword
from robot.api import logger


@library
class LAScreenshot:
    sc_count = 0

    @keyword("la screenshot")
    def la_screenshot(self,window_title=None,filepath=None,filename=None):

        logger.console(window_title)
        # Presses the tab key once
        # pyautogui.FAILSAFE=False
        pyautogui.press("NUMLOCK")
        print(window_title)
        if window_title:
            hwnd = win32gui.FindWindow(None, window_title)
            if hwnd:
                win32gui.SetForegroundWindow(hwnd)
                x, y, x1, y1 = win32gui.GetClientRect(hwnd)
                x, y = win32gui.ClientToScreen(hwnd, (x, y))
                x1, y1 = win32gui.ClientToScreen(hwnd, (x1 - x, y1 - y))
                # win32gui.SetForegroundWindow(hwnd)
                im = pyautogui.screenshot(region=(x, y, x1, y1))
                # filename =  filename
                logger.console(filename)
                # filename = r + filename
              #  self.sc_count = self.sc_count + 1
                filename = filepath + '\\' + filename + '.png'
                logger.console(filename)
                im.save(filename)
                # "C:\QK_Automation\LARF\venv\sc3.png")
                # return im
            else:
                print('Window not found!')
        else:
            im = pyautogui.screenshot()
            im.save(r"C:\QK\Life_Plan_Qrace\sc1.png")
            # return im


