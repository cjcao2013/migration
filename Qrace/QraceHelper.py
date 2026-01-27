import base64
import json
import os
import time
import datetime

try:
    from robot.libraries.BuiltIn import BuiltIn
    from robot.api.deco import library, keyword

    ROBOT = False
except Exception:
    ROBOT = False
import requests


class QraceHelper:
    script_order = start_time = end_time = 0
    test_job_id = test_run_id = test_case_id = application_name = test_type = created_date = None
    env_id = env_name = workflow = release_name = journey_workflow = None
    vps = dict()
    calculatorTables = list()
    viewTables = list()
    testData = dict()
    envAttributes = dict()
    attributes = dict()
    calcData = dict()
    actualResult = remark = executionTag = ""
    server_url = "http://10.160.132.200:8082"
    client_url = "http://127.0.0.1:8086"
    auth = ('pooja.dhotre', 'Qrace@123P')
    customDir = set()
    sc_count = 0
    executedJourneys = ""
    executionPaused = False

    def __init__(self):
        self = self
        # self.selLib = BuiltIn().get_library_instance("SeleniumLibrary")

    @keyword("Get TestData From Qrace")
    def get_test_data_from_qrace(self, testjobId):
        try:
            url = QraceHelper.server_url + "/api/agent/getTestJobTestDataForScript"
            testJobId = testjobId
            response = requests.post(url=url, data=testJobId, auth=QraceHelper.auth)
            _response = response.json()
            BuiltIn().log_to_console(response)
            if response.status_code == 200:
                if _response is not None:
                    for res in _response:
                        try:
                            QraceHelper.testData[res['Key']] = res['Value']
                            if res['Value'] == '[EMPTY]':
                                res['Value'] = ""
                            var_name = '${' + res['Key'] + '}'
                            # BuiltIn().log_to_console(res['Key'] + ":" + res['Value'])
                            BuiltIn().set_test_variable(var_name, res['Value'])
                        except Exception as err:
                            BuiltIn().log_to_console(err)
        except requests.exceptions.RequestException as err:
            BuiltIn().log_to_console(err)
        BuiltIn().log_to_console(QraceHelper.testData)

    @keyword("Get VPs From Qrace")
    def get_vps_from_qrace(self, testjobId):
        try:
            url = QraceHelper.server_url + "/api/agent/getVPForExecution"
            headers = {'Content-type': 'application/json'}
            param = dict()
            param['testJobId'] = testjobId
            _param = json.dumps(param, default=str)
            BuiltIn().log_to_console(_param)
            response = requests.post(url=url, data=_param, auth=QraceHelper.auth, headers=headers)
            _response = response.json()
            BuiltIn().log_to_console(response)
            if response.status_code == 200:
                if _response is not None:
                    for res in _response:
                        vp = dict()
                        vp['id'] = res['id']
                        vp['fieldName'] = res['fieldName']
                        vp['expectedResult'] = res['expectedResult']
                        vp['originalExpectedValue'] = res['originalExpectedValue']
                        vp['expectedSource'] = res['expectedSource']
                        vp['isCalcField'] = res['calcField']
                        QraceHelper.vps[res['fieldName']] = vp
        except requests.exceptions.RequestException as err:
            BuiltIn().log_to_console(err)
        BuiltIn().log_to_console(QraceHelper.vps)

    @keyword("Get TableVPs From Qrace")
    def get_table_vps_from_qrace(self, testJobId):
        try:
            url = QraceHelper.server_url + "/api/agent/testjobtablevps?testJobId=" + testJobId
            response = requests.get(url=url, auth=QraceHelper.auth)
            _response = response.json()
            BuiltIn().log_to_console(response)
            if response.status_code == 200:
                if _response is not None:
                    if "calculatorTables" in _response:
                        QraceHelper.calculatorTables = _response['calculatorTables']
                    if "viewTables" in _response:
                        QraceHelper.viewTables = _response['viewTables']
        except requests.exceptions.RequestException as err:
            BuiltIn().log_to_console(err)
        BuiltIn().log_to_console(QraceHelper.calculatorTables)
        BuiltIn().log_to_console(QraceHelper.viewTables)

    @keyword("Get Attributes From Qrace")
    def get_attributes_from_qrace(self, testjobId):
        try:
            url = QraceHelper.server_url + "/api/agent/getAttributes"
            testJobId = testjobId
            response = requests.post(url=url, data=testJobId, auth=QraceHelper.auth)
            _response = response.json()
            BuiltIn().log_to_console(response)
            if response.status_code == 200:
                if _response is not None:
                    for res in _response:
                        QraceHelper.attributes[res['Key']] = res['Value']
        except requests.exceptions.RequestException as err:
            BuiltIn().log_to_console(err)
        BuiltIn().log_to_console(QraceHelper.attributes)

    @keyword("Set Actual Result")
    def set_actual_result(self, actualResult):
        if QraceHelper.actualResult == "":
            QraceHelper.actualResult = actualResult
        else:
            QraceHelper.actualResult = QraceHelper.actualResult  + " | " + actualResult

    @keyword("Get Actual Result")
    def get_actual_result(self):
        return QraceHelper.actualResult

    @keyword("Set Remarks")
    def set_remarks(self, remark):
        if QraceHelper.remark == "":
            QraceHelper.remark = remark
        else:
            QraceHelper.remark = QraceHelper.remark + " | " + remark

    @keyword("Get Remarks")
    def get_remarks(self):
        return QraceHelper.remark

    @keyword("Set Execution Tag")
    def set_execution_tag(self, executionTag):
        if QraceHelper.executionTag == "":
            QraceHelper.executionTag = executionTag
        else:
            QraceHelper.executionTag = QraceHelper.executionTag + "," + executionTag

    @keyword("Get Execution Tag")
    def get_execution_tag(self):
        return QraceHelper.executionTag

    @keyword("Get VP Expected Value")
    def get_vp_expected_value(self, fieldName):
        expectedValue = ""
        try:
            vp = QraceHelper.vps.get(fieldName)
            expectedValue = vp.get('expectedResult')
            BuiltIn().log_to_console('Get VP Expected Value :' + vp)
        except Exception as err:
            BuiltIn().log_to_console(err)
        return expectedValue

    @keyword("Get VP Expected Values")
    def get_vp_expected_values(self, fieldName):
        expectedValues = dict()
        try:
            vp = QraceHelper.vps.get(fieldName)
            expectedValues['expectedResult'] = vp.get('expectedResult')
            expectedValues['originalExpectedValue'] = vp.get('originalExpectedValue')
            BuiltIn().log_to_console('Get VP Expected Value :' + vp)
        except Exception as err:
            BuiltIn().log_to_console(err)
        return expectedValues

    @keyword("Get VPs")
    def get_vps(self):
        return QraceHelper.vps

    @keyword("Set VP")
    def set_vp(self, fieldName, actualResult):
        QraceHelper.set_vp_with_actual_source(self, fieldName, actualResult, None)

    @keyword("Set VP With Actual Source")
    def set_vp_with_actual_source(self, fieldName, actualResult, actualSource):
        try:
            vp = QraceHelper.vps.get(fieldName)
            vp['actualResult'] = actualResult
            if actualSource is not None:
                vp['actualSource'] = actualSource
            QraceHelper.script_order = QraceHelper.script_order + 1
            vp['scriptOrder'] = QraceHelper.script_order
            QraceHelper.vps[fieldName] = vp
        except Exception as err:
            BuiltIn().log_to_console(err)

    @keyword("Set VP With Expected Source")
    def set_vp_with_expected_source(self, fieldName, expectedResult, expectedSource):
        try:
            vp = QraceHelper.vps.get(fieldName)
            vp['expectedResult'] = expectedResult
            if expectedSource is not None:
                vp['expectedSource'] = expectedSource
            QraceHelper.script_order = QraceHelper.script_order + 1
            vp['scriptOrder'] = QraceHelper.script_order
            QraceHelper.vps[fieldName] = vp
        except Exception as err:
            BuiltIn().log_to_console(err)

    @keyword("Set Dynamic VP")
    def set_dynamic_vp(self, fieldName, expectedResult, actualResult):
        QraceHelper.set_dynamic_vp_with_vpid(self, None, fieldName, expectedResult, actualResult)

    @keyword("Set Dynamic VP With VpId")
    def set_dynamic_vp_with_vpid(self, vpId, fieldName, expectedResult, actualResult):
        QraceHelper.set_dynamic_vp_with_vpid_and_source(self, vpId, fieldName, expectedResult, actualResult, None, None)

    @keyword("Set Dynamic VP With Source")
    def set_dynamic_vp_with_source(self, fieldName, expectedResult, actualResult,expectedSource, actualSource):
        QraceHelper.set_dynamic_vp_with_vpid_and_source(self, None, fieldName, expectedResult, actualResult, expectedSource, actualSource)

    @keyword("Set Dynamic VP With VpId And Source")
    def set_dynamic_vp_with_vpid_and_source(self, vpId, fieldName, expectedResult, actualResult, expectedSource, actualSource):
        try:
            vp = dict()
            if fieldName in QraceHelper.vps.keys():
                vp = QraceHelper.vps.get(fieldName)
            vp['id'] = -1
            if vpId is not None:
                vp['vpId'] = vpId
            vp['fieldName'] = fieldName
            vp['expectedResult'] = expectedResult
            vp['actualResult'] = actualResult
            if expectedSource is not None:
                vp['expectedSource'] = expectedSource
            if actualSource is not None:
                vp['actualSource'] = actualSource
            QraceHelper.script_order = QraceHelper.script_order + 1
            vp['scriptOrder'] = QraceHelper.script_order
            QraceHelper.vps[fieldName] = vp
            BuiltIn().log_to_console('Dynamic VP set :' + vp)
        except Exception as err:
            BuiltIn().log_to_console(err)

    @keyword("Set Calc VP With Source")
    def set_calc_vp_with_source(self, fieldName, expectedResult, actualResult, expectedSource, actualSource):
        return QraceHelper.set_calc_vp_with_source_and_original_values(self, fieldName, expectedResult, actualResult, expectedSource, actualSource, None, None)

    @keyword("Set Calc VP With Source And Original Values")
    def set_calc_vp_with_source_and_original_values(self, fieldName, expectedResult, actualResult, expectedSource, actualSource, originalExpectedValue, originalActualValue):
        try:
            vp = dict()
            if fieldName in QraceHelper.vps.keys():
                vp = QraceHelper.vps.get(fieldName)
            vp['id'] = -1
            vp['fieldName'] = fieldName
            vp['expectedResult'] = expectedResult
            vp['actualResult'] = actualResult
            if expectedSource is not None:
                vp['expectedSource'] = expectedSource
            if actualSource is not None:
                vp['actualSource'] = actualSource
            if originalExpectedValue is not None:
                vp['originalExpectedValue'] = originalExpectedValue
            if originalActualValue is not None:
                vp['originalActualValue'] = originalActualValue
            vp['isCalcField'] = True
            QraceHelper.script_order = QraceHelper.script_order + 1
            vp['scriptOrder'] = QraceHelper.script_order
            QraceHelper.vps[fieldName] = vp
            BuiltIn().log_to_console('Dynamic VP set :' + vp)
        except Exception as err:
            BuiltIn().log_to_console(err)


    @keyword("Set Dynamic VP With Source And Original Values")
    def set_dynamic_vp_with_source_and_original_values(self, fieldName, expectedResult, actualResult, expectedSource, actualSource, originalExpectedValue, originalActualValue):
        try:
            vp = dict()
            if fieldName in QraceHelper.vps.keys():
                vp = QraceHelper.vps.get(fieldName)
            vp['id'] = -1
            vp['fieldName'] = fieldName
            vp['expectedResult'] = expectedResult
            vp['actualResult'] = actualResult
            if expectedSource is not None:
                vp['expectedSource'] = expectedSource
            if actualSource is not None:
                vp['actualSource'] = actualSource
            if originalExpectedValue is not None:
                vp['originalExpectedValue'] = originalExpectedValue
            if originalActualValue is not None:
                vp['originalActualValue'] = originalActualValue
            QraceHelper.script_order = QraceHelper.script_order + 1
            vp['scriptOrder'] = QraceHelper.script_order
            QraceHelper.vps[fieldName] = vp
            BuiltIn().log_to_console('Dynamic VP set :' + vp)
        except Exception as err:
            BuiltIn().log_to_console(err)

    @keyword("Set Calc VP Actual Value")
    def set_calc_vp_actual_value(self, fieldName, actualResult):
        return QraceHelper.set_calc_vp_actual_result_and_source(self, fieldName, actualResult, None)

    @keyword("Set Calc VP Actual Result And Source")
    def set_calc_vp_actual_result_and_source(self, fieldName, actualResult, actualSource):
        return QraceHelper.set_calc_vp_actual_result_with_original_and_source(self, fieldName, actualResult, None, actualSource)

    @keyword("Set Calc VP Actual Result With Original And Source")
    def set_calc_vp_actual_result_with_original_and_source(self, fieldName, actualResult, originalActualValue, actualSource):
        try:
            vp = dict()
            if fieldName in QraceHelper.vps.keys():
                vp = QraceHelper.vps.get(fieldName)
            vp['id'] = -1
            vp['fieldName'] = fieldName
            vp['actualResult'] = actualResult
            if actualSource is not None:
                vp['actualSource'] = actualSource
            if originalActualValue is not None:
                vp['originalActualValue'] = originalActualValue
            vp['isCalcField'] = True
            QraceHelper.script_order = QraceHelper.script_order + 1
            vp['scriptOrder'] = QraceHelper.script_order
            QraceHelper.vps[fieldName] = vp
            BuiltIn().log_to_console('Dynamic VP set :' + vp)
        except Exception as err:
            BuiltIn().log_to_console(err)

    @keyword("Set Calc VP Expected Value")
    def set_calc_vp_expected_value(self, fieldName, expectedResult):
        return QraceHelper.set_calc_vp_expected_result_and_source(self, fieldName, expectedResult, None)

    @keyword("Set Calc VP Expected Result And Source")
    def set_calc_vp_expected_result_and_source(self, fieldName, expectedResult, expectedSource):
        return QraceHelper.set_calc_vp_expected_result_with_original_and_source(self, fieldName, expectedResult, None, expectedSource)

    @keyword("Set Calc VP Expected Result With Original And Source")
    def set_calc_vp_expected_result_with_original_and_source(self, fieldName, expectedResult, originalExpectedValue, expectedSource):
        try:
            vp = dict()
            if fieldName in QraceHelper.vps.keys():
                vp = QraceHelper.vps.get(fieldName)
            vp['id'] = -1
            vp['fieldName'] = fieldName
            vp['expectedResult'] = expectedResult
            if expectedSource is not None:
                vp['expectedSource'] = expectedSource
            if originalExpectedValue is not None:
                vp['originalExpectedValue'] = originalExpectedValue
            vp['isCalcField'] = True
            QraceHelper.script_order = QraceHelper.script_order + 1
            vp['scriptOrder'] = QraceHelper.script_order
            QraceHelper.vps[fieldName] = vp
            BuiltIn().log_to_console('Dynamic VP set :' + vp)
        except Exception as err:
            BuiltIn().log_to_console(err)

    @keyword("Set Calc Table Actual Value")
    def set_calc_table_actual_value(self, tableName, actualTableJson):
        try:
            if tableName in QraceHelper.viewTables:
                raise Exception("Calculator table VP with name " + tableName + " already exists in capture table VPs")

            vp = dict()
            if tableName in QraceHelper.vps.keys():
                vp = QraceHelper.vps.get(tableName)
            vp['id'] = -1
            vp['fieldName'] = tableName
            vp['actualResult'] = actualTableJson
            vp['isCalcTable'] = True
            QraceHelper.script_order = QraceHelper.script_order + 1
            vp['scriptOrder'] = QraceHelper.script_order
            QraceHelper.vps[tableName] = vp
            BuiltIn().log_to_console('Dynamic VP set :' + vp)
        except Exception as err:
            BuiltIn().log_to_console(err)

    @keyword("Set Calc Table Expected Value")
    def set_calc_table_expected_value(self, tableName, expectedTableJson):
        try:
            if tableName in QraceHelper.viewTables:
                raise Exception("Calculator table VP with name " + tableName + " already exists in capture table VPs")

            vp = dict()
            if tableName in QraceHelper.vps.keys():
                vp = QraceHelper.vps.get(tableName)
            vp['id'] = -1
            vp['fieldName'] = tableName
            vp['expectedResult'] = expectedTableJson
            vp['isCalcTable'] = True
            QraceHelper.script_order = QraceHelper.script_order + 1
            vp['scriptOrder'] = QraceHelper.script_order
            QraceHelper.vps[tableName] = vp
            BuiltIn().log_to_console('Dynamic VP set :' + vp)
        except Exception as err:
            BuiltIn().log_to_console(err)

    @keyword("Add Table")
    def add_table(self, tableName, tableJson):
        try:
            if tableName in QraceHelper.calculatorTables:
                raise Exception("Capture table VP with name " + tableName + " already exists in calculator table VPs")

            vp = dict()
            if tableName in QraceHelper.vps.keys():
                QraceHelper.vp = QraceHelper.vps.get(tableName)
            vp['id'] = -1
            vp['fieldName'] = tableName
            vp['expectedResult'] = tableJson
            vp['isCalcTable'] = True
            vp['isViewTable'] = True
            QraceHelper.script_order = QraceHelper.script_order + 1
            vp['scriptOrder'] = QraceHelper.script_order
            QraceHelper.vps[tableName] = vp
            BuiltIn().log_to_console('Dynamic VP set :' + vp)
        except Exception as err:
            BuiltIn().log_to_console(err)

    @keyword("Get Data")
    def get_data(self, fieldName):
        data = ""
        try:
            data = QraceHelper.testData[fieldName]
            BuiltIn().log_to_console('Data get :' + data)
        except Exception as err:
            BuiltIn().log_to_console(err)
        return data

    @keyword("Set Attribute")
    def set_attribute(self, fieldName, value):
        try:
            QraceHelper.attributes[fieldName] = value
            BuiltIn().log_to_console('Attribute set :' + fieldName + '-' + value)
        except Exception as err:
            BuiltIn().log_to_console(err)

    @keyword("Get Attribute")
    def get_attribute(self, fieldName):
        data = ""
        try:
            data = QraceHelper.attributes[fieldName]
            BuiltIn().log_to_console('Attribute get :' + data)
        except Exception as err:
            BuiltIn().log_to_console(err)
        return data

    @keyword("Get Calculator Data For Table")
    def get_calculator_data_for_table(self, fieldName):
        table = ""
        try:
            table = QraceHelper.calcData.get(fieldName)
            BuiltIn().log_to_console('Calculator table get :' + table)
        except Exception as err:
            BuiltIn().log_to_console(err)
        return table

    # @keyword("Update Testjob Status")
    def update_testjob_status(testjobId, status, message, startTimeMillis, finishTimeMillis, vpMap, executionTime,
                              attributes, actualResult,remark,executionTag):
        try:
            url = QraceHelper.server_url + "/api/agent/updateTestJobStatus"
            headers = {'Content-type': 'application/json'}
            params = dict()
            params['testJobId'] = int(testjobId)
            params['status'] = status
            if status == 6:
                params['errorMessage'] = message
            params['timeInMillis'] = round(time.time() * 1000)
            if startTimeMillis != 0:
                params['startTimeMillis'] = startTimeMillis
            if finishTimeMillis != 0:
                params['finishTimeMillis'] = finishTimeMillis
            if executionTime != 'None':
                params['executionTime'] = executionTime
            if actualResult != 'None':
                params['actualResult'] = actualResult
            if remark != 'None':
                params['remark'] = remark
            if executionTag != 'None':
                params['executionTag'] = executionTag
            if vpMap != 'None':
                vpList = list(vpMap.values())
                params['vpList'] = vpList

            if attributes != 'None':
                attributesList = list()
                for key, value in attributes.items():
                    attribute = dict()
                    curr_time = round(time.time() * 1000)
                    attribute['id'] = -1
                    attribute['field'] = key
                    attribute['value'] = value
                    attribute['createdAt'] = curr_time
                    attribute['updatedAt'] = curr_time
                    attributesList.append(attribute)
                params['attributes'] = attributesList

            _params = json.dumps(params, default=str)

            BuiltIn().log_to_console(round(time.time() * 1000))
            BuiltIn().log_to_console("_param :: " + _params)

            response = requests.post(url=url, data=_params, auth=QraceHelper.auth, headers=headers)
            BuiltIn().log_to_console(response)
            BuiltIn().log_to_console(response.text)
        except requests.exceptions.RequestException as err:
            BuiltIn().log_to_console(err)

    @keyword("Qrace Test Setup")
    def qrace_test_setup(self, testjobId, status):
        try:
            QraceHelper.start_time = round(time.time() * 1000)
            QraceHelper.script_order = 0
            QraceHelper.sc_count = 0
            QraceHelper.get_test_data_from_qrace(self, testjobId)
            QraceHelper.get_vps_from_qrace(self, testjobId)
            QraceHelper.get_table_vps_from_qrace(self, testjobId)
            QraceHelper.get_attributes_from_qrace(self, testjobId)
            QraceHelper.get_testcase_metadata(testjobId)
            QraceHelper.get_testjob_metadata(testjobId)
            QraceHelper.get_calculator_metadata(testjobId)
            QraceHelper.get_environment_config_from_qrace(QraceHelper.env_id)
            previous_execution_time = QraceHelper.get_testjob_execution_time(self, testjobId)
            if previous_execution_time != '':
                executionTime = previous_execution_time
            else:
                executionTime = ''
            QraceHelper.update_testjob_status(testjobId, status, 'None', QraceHelper.start_time, 0, 'None', executionTime, 'None', QraceHelper.actualResult, 'None', 'None')
            QraceHelper.executedJourneys = QraceHelper.get_attribute(self, "executedJourneys")
            QraceHelper.journey_workflow = QraceHelper.journey_workflow.replace(QraceHelper.executedJourneys,'')
        except Exception as err:
            BuiltIn().log_to_console(err)

    @keyword("Qrace Test TearDown")
    def qrace_test_teardown(self, testjobId, status, message):
        try:
            if not QraceHelper.executionPaused:
                _status = 2
                if status == 'PASS':
                    _status = 2
                elif status == 'PAUSED':
                    _status = 5
                else:
                    _status = 6
                QraceHelper.end_time = round(time.time() * 1000)
                executionTime = round((QraceHelper.end_time - QraceHelper.start_time) / 1000)
                BuiltIn().log_to_console(executionTime)
                previous_execution_time = QraceHelper.get_testjob_execution_time(self, testjobId)
                BuiltIn().log_to_console(previous_execution_time)
                if previous_execution_time != '':
                    previous_execution_time = time.strptime(previous_execution_time, '%H:%M:%S')
                    executionTime = executionTime + datetime.timedelta(hours=previous_execution_time.tm_hour,
                                                       minutes=previous_execution_time.tm_min,
                                                       seconds=previous_execution_time.tm_sec).total_seconds()
                _executionTime = str(time.strftime('%H:%M:%S', time.gmtime(executionTime)))
                BuiltIn().log_to_console(_executionTime)
                QraceHelper.update_testjob_status(testjobId, _status, message, 0, QraceHelper.end_time, QraceHelper.vps,
                                                  _executionTime, QraceHelper.attributes, QraceHelper.actualResult,QraceHelper.remark,QraceHelper.executionTag)
                BuiltIn().log_to_console("Custom directories : " + str(QraceHelper.customDir))
                QraceHelper.post_screenshot_and_logs(list(QraceHelper.customDir), testjobId)
                QraceHelper.clear_existing_data(self)
        except Exception as err:
            BuiltIn().log_to_console(err)

    @keyword("Qrace Test TearDown With Screenshots")
    def qrace_test_teardown_with_screenshots(self, testjobId, status, message, screenshotPath):
        QraceHelper.qrace_test_teardown(self, testjobId, status, message)
        screenshotPathList = [screenshotPath]
        QraceHelper.post_screenshot_and_logs(screenshotPathList, testjobId)

    @keyword("Pause Qrace Execution")
    def pause_qrace_execution(self):
        QraceHelper.set_attribute(self, "executedJourneys", QraceHelper.executedJourneys)
        QraceHelper.qrace_test_teardown(self, QraceHelper.test_job_id, 'PAUSED', 'None')
        QraceHelper.executionPaused = True

    @keyword("Add Executed Journey Workflow")
    def add_executed_journey_workflow(self, workflow):
        if QraceHelper.executedJourneys == "":
            QraceHelper.executedJourneys = workflow
        else:
            QraceHelper.executedJourneys = QraceHelper.executedJourneys + "," + workflow

    # @keyword("Read Log")
    def read_log(reportFile):
        content = None
        try:
            with open(reportFile, 'r', encoding='utf-8') as file:
                content = file.read()
                file.close()
        except Exception as err:
            BuiltIn().log_to_console(err)
        return content

    # @keyword("Read Image")
    def read_image(reportFile):
        BuiltIn().log_to_console("reportFile " + reportFile)
        content = None
        try:
            with open(reportFile, 'rb') as file:
                binaryContent = file.read()
                encodedContent = base64.b64encode(binaryContent)
                content = encodedContent.decode('utf-8')
                file.close()
        except IOError:
            BuiltIn().log_to_console('Error While Opening the file!' + reportFile)
        except Exception as err:
            BuiltIn().log_to_console(err)
        return content

    # @keyword("Post ScreenShot And Logs")
    def post_screenshot_and_logs(customDirs, testJobId):
        try:
            url = QraceHelper.client_url + "/api/client/uploadCustomArtifacts"
            headers = {'Content-type': 'application/json'}
            params = dict()
            params['testJobId'] = str(testJobId)
            params['customDirs'] = customDirs
            _params = json.dumps(params, default=str)
            # BuiltIn().log_to_console(_params)

            response = requests.post(url=url, data=_params, headers=headers)
            BuiltIn().log_to_console(response)
            # BuiltIn().log_to_console(response.text)
        except Exception as err:
            BuiltIn().log_to_console(err)

    # @keyword("Get Environment Config From Qrace")
    def get_environment_config_from_qrace(envId):
        try:
            url = QraceHelper.server_url + "/api/agent/listEnvAttribute?envId=" + str(envId)
            response = requests.get(url=url, auth=QraceHelper.auth)
            BuiltIn().log_to_console(response)
            if response.status_code == 200:
                _response = response.json()
                BuiltIn().log_to_console(_response)
                if _response is not None:
                    for res in _response:
                        QraceHelper.envAttributes[res['field']] = res['value']
        except requests.exceptions.RequestException as err:
            BuiltIn().log_to_console(err)
        BuiltIn().log_to_console(QraceHelper.envAttributes)

    # @keyword("Get TestCase Metadata")
    def get_testcase_metadata(testjobId):
        try:
            url = QraceHelper.server_url + "/api/agent/getTestCaseDetailForExecution"
            headers = {'Content-type': 'application/json'}
            params = dict()
            params['testJobId'] = testjobId
            _params = json.dumps(params, default=str)
            response = requests .post(url=url, data=_params, auth=QraceHelper.auth, headers=headers)
            _response = response.json()
            BuiltIn().log_to_console(response)
            BuiltIn().log_to_console(_response)
            if response.status_code == 200:
                if _response is not None:
                    QraceHelper.test_job_id = testjobId
                    if 'testRunId' in _response:
                        QraceHelper.test_run_id = _response['testRunId']
                    if 'testCaseId' in _response:
                        QraceHelper.test_case_id = _response['testCaseId']
                    if 'application' in _response:
                        QraceHelper.application_name = _response['application']
                    if 'testType' in _response:
                        QraceHelper.test_type = _response['testType']
                    if 'envId' in _response:
                        QraceHelper.env_id = _response['envId']
                    if 'envName' in _response:
                        QraceHelper.env_name = _response['envName']
                    if 'workflow' in _response:
                        QraceHelper.workflow = _response['workflow']
                    if 'releaseName' in _response:
                        QraceHelper.release_name = _response['releaseName']
                    if 'journeyWorkflows' in _response:
                        QraceHelper.journey_workflow = _response['journeyWorkflows']
        except requests.exceptions.RequestException as err:
            BuiltIn().log_to_console(err)

    # @keyword("Get TestJob Metadata")
    def get_testjob_metadata(testjobId):
        try:
            url = QraceHelper.server_url + "/api/agent/getTestjobActualResult/" + testjobId
            response = requests.get(url=url, auth=QraceHelper.auth)
            _response = response.json()
            BuiltIn().log_to_console(response)
            BuiltIn().log_to_console(_response)
            if response.status_code == 200:
                if _response is not None:
                    if 'createdDate' in _response:
                        QraceHelper.created_date = _response['createdDate']
                    if 'actualResult' in _response:
                        QraceHelper.actualResult = _response['actualResult']
                        BuiltIn().log_to_console(QraceHelper.actualResult)

        except requests.exceptions.RequestException as err:
            BuiltIn().log_to_console(err)

    # @keyword("Get Calculator Metadata")
    def get_calculator_metadata(testjobId):
        try:
            url = QraceHelper.server_url + "/api/agent/calculatortabledata?testJobId=" + testjobId
            response = requests.get(url=url, auth=QraceHelper.auth)
            BuiltIn().log_to_console(response)
            if response.status_code == 200:
                _response = response.json()
                if _response is not None:
                    QraceHelper.calcData = _response
        except requests.exceptions.RequestException as err:
            BuiltIn().log_to_console(err)

    def clear_existing_data(self):
        QraceHelper.script_order = QraceHelper.start_time = QraceHelper.end_time = 0
        QraceHelper.test_job_id = QraceHelper.test_run_id = QraceHelper.test_case_id = QraceHelper.application_name = QraceHelper.test_type = QraceHelper.created_date = QraceHelper.env_id = QraceHelper.env_name = QraceHelper.workflow = None
        QraceHelper.vps = dict()
        QraceHelper.calculatorTables = list()
        QraceHelper.viewTables = list()
        QraceHelper.testData = dict()
        QraceHelper.envAttributes = dict()
        QraceHelper.attributes = dict()
        QraceHelper.calcData = dict()
        QraceHelper.actualResult = ""
        QraceHelper.customDir = set()

    @keyword("Get Environment Attribute")
    def get_environment_attribute(self, fieldName):
        data = ""
        try:
            data = QraceHelper.envAttributes[fieldName]
            BuiltIn().log_to_console('Environment Attribute get :' + data)
        except Exception as err:
            BuiltIn().log_to_console(err)
        return data

    @keyword("Get TestJobId")
    def get_testjob_id(self):
        return QraceHelper.test_job_id

    @keyword("Get TestRunId")
    def get_testrun_id(self):
        return QraceHelper.test_run_id

    @keyword("Get TestCaseId")
    def get_testcase_id(self):
        return QraceHelper.test_case_id

    @keyword("Get TestType")
    def get_test_type(self):
        return QraceHelper.test_type

    @keyword("Get ApplicationName")
    def get_application_name(self):
        return QraceHelper.application_name

    @keyword("Get CreatedDate")
    def get_created_date(self):
        return QraceHelper.created_date

    @keyword("Get EnvironmentName")
    def get_environment_name(self):
        return QraceHelper.env_name

    @keyword("Get Workflow")
    def get_workflow(self):
        return QraceHelper.workflow

    @keyword("Get ReleaseName")
    def get_release_name(self):
        return QraceHelper.release_name

    @keyword("Get Journey Workflow")
    def get_journey_workflow(self):
        if QraceHelper.journey_workflow == None:
            QraceHelper.journey_workflow = ''
        return QraceHelper.journey_workflow

    @keyword("Get Execution Status")
    def get_execution_status(self):
        return QraceHelper.executionPaused

    @keyword("Download All Artifacts")
    def download_all_artifacts(self, testJobId):
        QraceHelper.download_all_artifacts_to_path(self, testJobId, None)

    @keyword("Download All Artifacts To Path")
    def download_all_artifacts_to_path(self, testJobId, path):
        reportDir = path
        if path is None:
            reportDir = os.path.expanduser('~') + os.sep + "Qrace Reports"
        if not os.path.exists(reportDir):
            os.makedirs(reportDir)

        reportFile = reportDir + os.sep + testJobId + ".zip"
        BuiltIn().log_to_console("File download path : " + reportFile)

        try:
            url = QraceHelper.server_url + "/api/agent/downloadScreenshot?testJobId=" + testJobId
            response = requests.get(url=url, auth=QraceHelper.auth)
            BuiltIn().log_to_console(response)
            if response.status_code == 200:
                _response = response.content
                if _response is not None:
                    with open(reportFile, 'wb') as fd:
                        fd.write(_response)
                        fd.close()

        except requests.exceptions.RequestException as err:
            BuiltIn().log_to_console(err)
        except Exception as ex:
            BuiltIn().log_to_console(ex)

    @keyword("Set Custom Directory")
    def set_custom_directory(self, path):
        BuiltIn().log_to_console("Setting custom directory : " + path)
        QraceHelper.customDir.add(path)

    @keyword("Remove Custom Directory")
    def remove_custom_directory(self, path):
        BuiltIn().log_to_console("Removing custom directory : " + path)
        QraceHelper.customDir.discard(path)

    @keyword("Remove All Custom Directory")
    def remove_all_custom_directory(self):
        BuiltIn().log_to_console("Removing all custom directories!!!")
        QraceHelper.customDir.clear()

    @keyword("Get TestJob Execution Time")
    def get_testjob_execution_time(self, testjobId):
        try:
            url = QraceHelper.server_url + "/api/agent/getTestjobExecutionTime/" + testjobId
            response = requests.get(url=url, auth=QraceHelper.auth)
            BuiltIn().log_to_console(response)
            if response.status_code == 200:
                _response = response.json()
                BuiltIn().log_to_console(_response)
                if _response is not None:
                    if "status" in _response:
                        if _response["status"] == "pass":
                            if "executionTime" in _response:
                                return _response["executionTime"]
                        else:
                            BuiltIn().log_to_console(_response["message"]) 
        except requests.exceptions.RequestException as err:
            BuiltIn().log_to_console(err)
    
    @keyword("Set TestJob Execution Time")
    def set_testjob_execution_time(self, testjobId, executionTime):
        try:
            url = QraceHelper.server_url + "/api/agent/setTestjobExecutionTime"
            headers = {'Content-type': 'application/json'}
            param = dict()
            param['jobId'] = testjobId
            param['executionTime'] = executionTime
            _param = json.dumps(param, default=str)
            BuiltIn().log_to_console(_param)
            response = requests.post(url=url, data=_param, auth=QraceHelper.auth, headers=headers)
            BuiltIn().log_to_console(response)
            if response.status_code == 200:
                _response = response.json()
                BuiltIn().log_to_console(_response)
                if _response is not None:
                    if "message" in _response:
                        BuiltIn().log_to_console(_response["message"])
        except requests.exceptions.RequestException as err:
            BuiltIn().log_to_console(err)

    @keyword("Get Environment Config By TestRun")
    def get_environment_config_by_testrun(self, testRunId):
        try:
            url = QraceHelper.server_url + "/api/agent/getEnvironmentForTestRunId?testRunId=" + testRunId
            response = requests.get(url=url, auth=QraceHelper.auth)
            _response = response.json()
            BuiltIn().log_to_console(response)
            BuiltIn().log_to_console(_response)
            if response.status_code == 200:
                if _response is not None:
                    if 'envAttributes' in _response:
                        attributes = _response['envAttributes']
                        if attributes is not None:
                            for attribute in attributes:
                                QraceHelper.envAttributes[attribute['field']] = attribute['value']
        except requests.exceptions.RequestException as err:
            BuiltIn().log_to_console(err)

    @keyword("Get TestRun Metadata")
    def get_testrun_metadata(self, testRunId):
        QraceHelper.get_environment_config_by_testrun(self, testRunId)
        try:
            url = QraceHelper.server_url + "/api/agent/getTestRunMetadata?testRunId=" + testRunId
            response = requests.get(url=url, auth=QraceHelper.auth)
            _response = response.json()
            BuiltIn().log_to_console(response)
            BuiltIn().log_to_console(_response)
            if response.status_code == 200:
                if _response is not None:
                    if 'testRunId' in _response:
                        QraceHelper.test_run_id = _response['testRunId']
                    if 'envId' in _response:
                        QraceHelper.env_id = _response['envId']
                    if 'envName' in _response:
                        QraceHelper.env_name = _response['envName']
                    if 'releaseName' in _response:
                        QraceHelper.release_name = _response['releaseName']
        except requests.exceptions.RequestException as err:
            BuiltIn().log_to_console(err)

    @keyword("Get TestJob Status")
    def get_testjob_status(self, testJobId):
        testJobStatus = "SKIP"
        try:
            url = QraceHelper.server_url + "/api/agent/getTestJobStatus?testJobId=" + testJobId
            response = requests.get(url=url, auth=QraceHelper.auth)
            _response = response.json()
            BuiltIn().log_to_console(response)
            # BuiltIn().log_to_console(_response)
            if response.status_code == 200:
                if _response is not None:
                    if 'status' in _response:
                        testJobStatus = _response['status']
        except requests.exceptions.RequestException as err:
            BuiltIn().log_to_console(err)
        return testJobStatus

    @keyword("Set BrowserStack SessionUrl For TestJob")
    def set_browserstack_sessionurl_for_testjob(self, testjobId, sessionId):
        try:
            url = QraceHelper.server_url + "/api/agent/setBrowserStackSessionUrlForTestJob"
            headers = {'Content-type': 'application/json'}
            param = dict()
            param['testjobId'] = testjobId
            param['sessionId'] = sessionId
            _param = json.dumps(param, default=str)
            BuiltIn().log_to_console(_param)
            response = requests.post(url=url, data=_param, auth=QraceHelper.auth, headers=headers)
            BuiltIn().log_to_console(response)
            if response.status_code == 200:
                _response = response.json()
                BuiltIn().log_to_console(_response)
        except requests.exceptions.RequestException as err:
            BuiltIn().log_to_console(err)


    @keyword("Set TestJob Status")
    def set_testjob_status(self, testjobId, status):
        message = "Invalid TestJob status : " + status
        try:
            url = QraceHelper.server_url + "/api/agent/setTestJobStatus"
            headers = {'Content-type': 'application/json'}
            param = dict()
            param['testjobId'] = testjobId
            param['status'] = status
            _param = json.dumps(param, default=str)
            BuiltIn().log_to_console(_param)
            response = requests.post(url=url, data=_param, auth=QraceHelper.auth, headers=headers)
            BuiltIn().log_to_console(response)
            if response.status_code == 200:
                _response = response.json()
                BuiltIn().log_to_console(_response)
                if _response is not None:
                    if "message" in _response:
                        BuiltIn().log_to_console(_response["message"])
                        message = _response["message"]
        except requests.exceptions.RequestException as err:
            BuiltIn().log_to_console(err)
        return message
