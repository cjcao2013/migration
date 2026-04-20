import pandas as pd
import pytest
import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from unittest.mock import MagicMock, patch
import types

robot_mock = types.ModuleType("robot")
robot_mock.libraries = types.ModuleType("robot.libraries")
robot_mock.libraries.BuiltIn = types.ModuleType("robot.libraries.BuiltIn")
robot_mock.libraries.BuiltIn.BuiltIn = MagicMock()
robot_mock.api = types.ModuleType("robot.api")
robot_mock.api.deco = types.ModuleType("robot.api.deco")
robot_mock.api.deco.library = lambda *a, **k: (lambda cls: cls)
robot_mock.api.deco.keyword = lambda *a, **k: (lambda fn: fn)
sys.modules.setdefault("robot", robot_mock)
sys.modules.setdefault("robot.libraries", robot_mock.libraries)
sys.modules.setdefault("robot.libraries.BuiltIn", robot_mock.libraries.BuiltIn)
sys.modules.setdefault("robot.api", robot_mock.api)
sys.modules.setdefault("robot.api.deco", robot_mock.api.deco)

from Qrace.QraceHelper import QraceHelper


# ---------------------------------------------------------------------------
# Task 3: _load_env_excel
# ---------------------------------------------------------------------------

def test_load_env_excel_stg(tmp_path):
    env_file = tmp_path / "Environment.xlsx"
    df = pd.DataFrame({"Key": ["Env", "BS_user", "bundleID"],
                       "Value": ["staging", "test_user", "com.fwd.test"]})
    with pd.ExcelWriter(env_file, engine="openpyxl") as w:
        df.to_excel(w, sheet_name="STG", index=False)
    helper = QraceHelper()
    with patch("Qrace.QraceHelper._ENV_XLSX", str(env_file)):
        helper._load_env_excel("STG")
    assert QraceHelper._env_config["BS_user"] == "test_user"
    assert QraceHelper.env_name == "staging"


# ---------------------------------------------------------------------------
# Task 4: _build_testjob_ids returns row indices
# ---------------------------------------------------------------------------

def test_build_testjob_ids_returns_indices(tmp_path):
    tc_file = tmp_path / "TestCasesFile.xlsx"
    pd.DataFrame({
        "Test Case Id": ["TC_01", "TC_02", "TC_03"],
        "ExecutorFlag": ["Yes", "No", "Yes"],
        "TestDataId": ["", "", ""],
        "Workflow": ["Flow1", "Flow2", "Flow3"],
    }).to_excel(tc_file, index=False)
    helper = QraceHelper()
    with patch("Qrace.QraceHelper._TESTCASES_EXCEL", str(tc_file)):
        result = helper._build_testjob_ids()
    assert result == "0_1"
    assert len(QraceHelper._test_cases) == 2
    assert QraceHelper._test_cases[0]["Test Case Id"] == "TC_01"
    assert QraceHelper._test_cases[1]["Test Case Id"] == "TC_03"


# ---------------------------------------------------------------------------
# Task 5: _load_test_data_for_case — direct Test Case Id join
# ---------------------------------------------------------------------------

def test_load_test_data_for_case(tmp_path):
    tc_file = tmp_path / "TestCasesFile.xlsx"
    pd.DataFrame({
        "Test Case Id": ["TC_ViewPolicy_001"],
        "ExecutorFlag": ["Yes"],
        "TestDataId": [""],
        "Workflow": ["Insurance"],
    }).to_excel(tc_file, index=False)
    td_file = tmp_path / "TestDataFile.xlsx"
    with pd.ExcelWriter(td_file, engine="openpyxl") as w:
        pd.DataFrame({
            "Testcaseid": ["TC_ViewPolicy_001", "TC_Other"],
            "Flow_Flag": ["Insurance", "Engagement"],
            "Policy_No": ["P001", "P002"],
        }).to_excel(w, sheet_name="CommonData", index=False)
    helper = QraceHelper()
    with patch("Qrace.QraceHelper._TESTCASES_EXCEL", str(tc_file)), \
         patch("Qrace.QraceHelper._TESTDATA_EXCEL", str(td_file)):
        helper._build_testjob_ids()
        helper._load_test_data_for_case("0")
    assert QraceHelper.testData.get("Flow_Flag") == "Insurance"
    assert QraceHelper.testData.get("Policy_No") == "P001"
    assert QraceHelper.workflow == "Insurance"


# ---------------------------------------------------------------------------
# Task 6: qrace_test_setup/teardown column names and Test Case Id in summary
# ---------------------------------------------------------------------------

def test_qrace_teardown_summary_has_test_case_id(tmp_path):
    tc_file = tmp_path / "TestCasesFile.xlsx"
    pd.DataFrame({
        "Test Case Id": ["TC_ViewPolicy_001"],
        "ExecutorFlag": ["Yes"],
        "TestDataId": [""],
        "Test Type": ["POSITIVE"],
        "Workflow": ["Insurance"],
    }).to_excel(tc_file, index=False)
    td_file = tmp_path / "TestDataFile.xlsx"
    with pd.ExcelWriter(td_file, engine="openpyxl") as w:
        pd.DataFrame({"Testcaseid": ["TC_ViewPolicy_001"],
                      "Flow_Flag": ["Insurance"]}).to_excel(
            w, sheet_name="CommonData", index=False)
    log_dir = tmp_path / "log"
    log_dir.mkdir()
    helper = QraceHelper()
    with patch("Qrace.QraceHelper._TESTCASES_EXCEL", str(tc_file)), \
         patch("Qrace.QraceHelper._TESTDATA_EXCEL", str(td_file)), \
         patch("Qrace.QraceHelper._OUTPUT_DIR", str(log_dir)):
        helper._build_testjob_ids()
        helper.qrace_test_setup("0", 1)
        helper.qrace_test_teardown("0", "PASS", "")
    summary = pd.read_excel(log_dir / "ExecutionSummary.xlsx",
                            sheet_name="ExecutionSummary", dtype=str)
    assert summary.iloc[0]["TestCaseId"] == "TC_ViewPolicy_001"
    assert summary.iloc[0]["Execution_Status"] == "PASS"


# ---------------------------------------------------------------------------
# Task 7: End-to-end smoke test — full call chain
# ---------------------------------------------------------------------------

def test_full_call_chain(tmp_path):
    """get_testrun_metadata → qrace_test_setup → qrace_test_teardown end-to-end."""
    env_file = tmp_path / "Environment.xlsx"
    pd.DataFrame({"Key": ["Env", "BS_user"], "Value": ["staging", "u1"]}).to_excel(
        env_file, sheet_name="STG", index=False)

    tc_file = tmp_path / "TestCasesFile.xlsx"
    pd.DataFrame({
        "Test Case Id": ["TC_001"], "ExecutorFlag": ["Yes"],
        "TestDataId": [""], "Test Type": ["POSITIVE"], "Workflow": ["Insurance"],
    }).to_excel(tc_file, index=False)

    td_file = tmp_path / "TestDataFile.xlsx"
    with pd.ExcelWriter(td_file, engine="openpyxl") as w:
        pd.DataFrame({"Testcaseid": ["TC_001"], "Flow_Flag": ["Insurance"],
                      "Policy_No": ["P001"]}).to_excel(w, sheet_name="CommonData", index=False)

    log_dir = tmp_path / "log"
    log_dir.mkdir()

    # Reset class-level accumulators so prior test runs don't bleed in
    QraceHelper._execution_results = []
    QraceHelper._verification_points = []

    helper = QraceHelper()
    with patch("Qrace.QraceHelper._ENV_XLSX", str(env_file)), \
         patch("Qrace.QraceHelper._TESTCASES_EXCEL", str(tc_file)), \
         patch("Qrace.QraceHelper._TESTDATA_EXCEL", str(td_file)), \
         patch("Qrace.QraceHelper._OUTPUT_DIR", str(log_dir)):
        helper.get_testrun_metadata("STG")
        assert QraceHelper.env_name == "staging"
        assert QraceHelper._env_config["BS_user"] == "u1"

        helper.qrace_test_setup("0", 1)
        assert QraceHelper.testData.get("Flow_Flag") == "Insurance"
        assert QraceHelper.workflow == "Insurance"

        helper.qrace_test_teardown("0", "PASS", "")

    summary = pd.read_excel(log_dir / "ExecutionSummary.xlsx",
                            sheet_name="ExecutionSummary", dtype=str)
    assert summary.iloc[0]["TestCaseId"] == "TC_001"
    assert summary.iloc[0]["Execution_Status"] == "PASS"
