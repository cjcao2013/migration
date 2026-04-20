# Qrace → Excel Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the Qrace HTTP backend in `QraceHelper.py` with Excel/JSON reads so the Robot Framework test suite runs without a Qrace server, with zero changes to any `.robot` or `.resource` files.

**Architecture:** `QraceHelper.py` is rewritten in-place — all keyword names and signatures stay identical. Environment config moves from `Config/Environment.json` to `Config/Environment.xlsx`. Test case metadata lives in `TestData/TestCasesFile.xlsx` (derived from Qrace export + two new columns). Test data lives in `TestData/TestDataFile.xlsx` (copy of `TH Test Data.xlsx`). The `testjobId` is repurposed as a **row index** (integer string) into `TestCasesFile`, which sidesteps the `_`-split constraint in `OmneInsuranceFlowExecutor.resource`.

**Tech Stack:** Python 3, pandas ≥ 2.0, openpyxl ≥ 3.1, Robot Framework

---

## Key Design Decisions

### Why row index as `testjobId`

`OmneInsuranceFlowExecutor.resource` joins `${testjobIds}` by splitting on `_`:
```
${jobIds}=   Split String     ${testjobIds}    _
```
All real Test Case IDs (`TC_03_Ins_TH_IOS_ViewPolicy_001`) and Test Data IDs (`TD_STG`) contain underscores — they cannot be used directly. Using integer row index (0, 1, 2 …) as `testjobId` is the only option that requires zero `.resource` changes.

**Important:** The row index is into the **post-filter (eligible-only) list** stored in `QraceHelper._test_cases`, not the raw Excel row number. `_test_cases` only contains rows where `ExecutorFlag == "Yes"`. Index 0 = first eligible row, index 1 = second eligible row, etc.

### TC → TD mapping problem

In Qrace, the database linked each test case to its test data record. That link is now gone. The Excel file `TH Test Data.xlsx` uses `Testcaseid` (e.g. `TD1`, `TD_STG`) while `Qrace Test Cases-Mobile.xlsx` uses `Test Case Id` (e.g. `TC_03_…`). They do not share a common key.

**Solution:** `TestCasesFile.xlsx` gets a new `TestDataId` column (QA fills this in) that stores the matching `Testcaseid` value from `TestDataFile.xlsx`.

### Single TestDataFile, no env suffix

The Qrace artifact is one file per region (`TH Test Data.xlsx`). The code will read `TestData/TestDataFile.xlsx` (no env suffix). Env-specific values come from `Config/Environment.xlsx`.

---

## Actual Column Names (from Qrace Artifacts)

| File | Column used as ID | Example value |
|------|-------------------|---------------|
| `Qrace Test Cases-Mobile.xlsx` TH | `Test Case Id` | `TC_03_Ins_TH_IOS_ViewPolicy_001` |
| `TH Test Data.xlsx` all sheets | `Testcaseid` | `TD1`, `TD_STG`, `TD_LA` |
| `Enviroment Details.xlsx` TH | Col 1 = Key, Col 2 = Value | `Env` / `staging` |

---

## Files Modified / Created

| File | Action | Purpose |
|------|--------|---------|
| `Qrace/QraceHelper.py` | Modify | Fix all column names, swap JSON→Excel env loader, fix testjobId to row-index scheme |
| `Config/Environment.xlsx` | Create | UAT + STG sheets, Key/Value rows, from Qrace artifact |
| `TestData/TestCasesFile.xlsx` | Create | From Qrace TH sheet + `ExecutorFlag` + `TestDataId` columns |
| `TestData/TestDataFile.xlsx` | Create | Copy of `TH Test Data.xlsx` — no changes |
| `tests/test_qrace_helper.py` | Create | Standalone Python unit tests for all helper methods |

---

## Task 1: Create `Config/Environment.xlsx`

**Files:**
- Create: `Config/Environment.xlsx`

The file has two sheets: `UAT` and `STG`. Each sheet has two columns: `Key` and `Value`. Populate from `Qrace Artifacts/Environment Confiig/Enviroment Details.xlsx` TH sheet (col 1 = Key, col 2 = Value).

- [ ] **Step 1: Create the Excel file with Python**

```python
# run once: python3 scripts/create_env_xlsx.py
import pandas as pd

artifact = pd.read_excel(
    "Qrace Artifacts/Environment Confiig/Enviroment Details.xlsx",
    sheet_name="TH", header=None, dtype=str
).fillna("")

# col index 1 = Key, col index 2 = Value (col 0 is blank)
rows = artifact[[1, 2]].rename(columns={1: "Key", 2: "Value"})
rows = rows[rows["Key"].str.strip() != ""]

with pd.ExcelWriter("Config/Environment.xlsx", engine="openpyxl") as w:
    rows.to_excel(w, sheet_name="STG", index=False)   # artifact is staging
    rows.to_excel(w, sheet_name="UAT", index=False)   # QA edits UAT values later
```

- [ ] **Step 2: Verify file exists with correct sheets**

```bash
python3 -c "
import pandas as pd
xl = pd.ExcelFile('Config/Environment.xlsx')
print('Sheets:', xl.sheet_names)
df = xl.parse('STG')
print(df.head(10).to_string())
"
```
Expected: `Sheets: ['STG', 'UAT']` and 32 rows with keys like `Env`, `bundleID`, `BS_user`.

- [ ] **Step 3: Commit**

```bash
git add Config/Environment.xlsx
git commit -m "feat: add Config/Environment.xlsx from Qrace artifact (STG/UAT sheets)"
```

---

## Task 2: Create `TestData/TestCasesFile.xlsx`

**Files:**
- Create: `TestData/TestCasesFile.xlsx`

Derived from `Qrace Artifacts/Test Cases/Qrace Test Cases-Mobile.xlsx` TH sheet, with two columns appended:
- `ExecutorFlag` — default `Yes` for all rows; QA sets to `No` to skip a test
- `TestDataId` — must be filled by QA; this is the matching `Testcaseid` value from `TestDataFile.xlsx` (e.g. `TD1`)

- [ ] **Step 1: Create the template Excel file**

```python
# python3 scripts/create_testcases_xlsx.py
import pandas as pd

df = pd.read_excel(
    "Qrace Artifacts/Test Cases/Qrace Test Cases-Mobile.xlsx",
    sheet_name="TH", dtype=str
).fillna("")

df["ExecutorFlag"] = "Yes"   # QA changes to No to skip
df["TestDataId"] = ""        # QA must fill: matching Testcaseid from TestDataFile

df.to_excel("TestData/TestCasesFile.xlsx", index=False)
print(f"Created TestCasesFile.xlsx with {len(df)} rows")
print("Columns:", df.columns.tolist())
```

- [ ] **Step 2: Verify columns**

```bash
python3 -c "
import pandas as pd
df = pd.read_excel('TestData/TestCasesFile.xlsx', dtype=str)
print('Columns:', df.columns.tolist())
print('Row count:', len(df))
print(df[['Test Case Id','ExecutorFlag','TestDataId']].head(5).to_string())
"
```
Expected: columns include `Test Case Id`, `ExecutorFlag` (all `Yes`), `TestDataId` (all empty).

- [ ] **Step 3: Copy TestDataFile**

```bash
cp "Qrace Artifacts/Test Data/TH Test Data.xlsx" "TestData/TestDataFile.xlsx"
```

- [ ] **Step 4: Verify TestDataFile sheets and join key**

```bash
python3 -c "
import pandas as pd
xl = pd.ExcelFile('TestData/TestDataFile.xlsx')
print('Sheets:', xl.sheet_names)
cd = xl.parse('CommonData', dtype=str)
print('CommonData columns:', cd.columns.tolist()[:10])
print('Sample Testcaseid values:', cd['Testcaseid'].head(5).tolist())
"
```
Expected: 27 sheets, `Testcaseid` column present, values like `TD1`, `TD_STG`.

- [ ] **Step 5: Commit**

```bash
git add TestData/TestCasesFile.xlsx TestData/TestDataFile.xlsx
git commit -m "feat: add TestCasesFile and TestDataFile from Qrace artifacts"
```

---

## Task 3: Rewrite `_load_env_excel()` in QraceHelper.py

**Files:**
- Modify: `Qrace/QraceHelper.py`

Replace `_load_env_json()` with `_load_env_excel()`. The new method reads `Config/Environment.xlsx`, finds the sheet matching `env_name` (case-insensitive), and loads Key/Value rows into `_env_config`.

- [ ] **Step 1: Write the failing test**

```python
# tests/test_qrace_helper.py
import pandas as pd
import pytest
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

# Minimal Robot mock so QraceHelper imports without Robot installed
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

ENV_XLSX = "Config/Environment.xlsx"

def test_load_env_excel_stg(tmp_path):
    """_load_env_excel reads STG sheet and populates _env_config."""
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
```

- [ ] **Step 2: Run test — expect FAIL**

```bash
cd /Users/cj/code/migration/omne-qa-mob-th
python3 -m pytest tests/test_qrace_helper.py::test_load_env_excel_stg -v
```
Expected: `FAILED` — `_load_env_excel` doesn't exist yet.

- [ ] **Step 3: Implement `_load_env_excel()` in QraceHelper.py**

`_load_env_json` already exists at around line 66. **Delete it entirely** and replace with `_load_env_excel`. Also remove the `_ENV_JSON` constant at the top of the file and add `_ENV_XLSX`. Update the path constant at top of file:

```python
# Change this constant at top of file:
_ENV_XLSX = os.path.join(_PROJECT_ROOT, "Config", "Environment.xlsx")
# Remove: _ENV_JSON = ...

def _load_env_excel(self, env_name):
    """Load Config/Environment.xlsx sheet matching env_name."""
    try:
        xl = pd.ExcelFile(_ENV_XLSX)
        # case-insensitive sheet match
        sheet = next(
            (s for s in xl.sheet_names if s.strip().upper() == env_name.strip().upper()),
            xl.sheet_names[0]
        )
        df = xl.parse(sheet, dtype=str).fillna("")
        env_data = dict(zip(df["Key"].str.strip(), df["Value"].str.strip()))
        QraceHelper._env_config = env_data
        QraceHelper.envAttributes = dict(env_data)
        QraceHelper.env_name = env_data.get("Env", env_name)
        QraceHelper.release_name = env_data.get("Release", "")
        BuiltIn().log_to_console(f"[QraceHelper] Loaded env: {env_name} (sheet: {sheet})")
    except Exception as err:
        BuiltIn().log_to_console(f"[QraceHelper] Failed to load Environment.xlsx: {err}")
```

Update the two internal callers of `_load_env_json` to call `_load_env_excel`:

- In `get_testrun_metadata` (~line 742): change `QraceHelper._load_env_json(self, testRunId)` → `QraceHelper._load_env_excel(self, testRunId)`
- In `get_environment_config_by_testrun` (~line 731): change `QraceHelper._load_env_json(self, testRunId)` → `QraceHelper._load_env_excel(self, testRunId)`

- [ ] **Step 4: Run test — expect PASS**

```bash
python3 -m pytest tests/test_qrace_helper.py::test_load_env_excel_stg -v
```
Expected: `PASSED`

- [ ] **Step 5: Commit**

```bash
git add Qrace/QraceHelper.py tests/test_qrace_helper.py
git commit -m "feat: replace _load_env_json with _load_env_excel reading Config/Environment.xlsx"
```

---

## Task 4: Fix `_build_testjob_ids()` — row-index scheme

**Files:**
- Modify: `Qrace/QraceHelper.py`

`testjobId` becomes the row index (as string: `"0"`, `"1"`, …) of the eligible row in `TestCasesFile.xlsx`. This avoids the `_` split problem in the executor.

Column names to fix:
- `"ExecutorFlag"` → `"ExecutorFlag"` ✓ (we add this column in Task 2)
- `"TestCaseId"` → `"Test Case Id"` (actual Qrace column name)

- [ ] **Step 1: Write the failing test**

```python
# add to tests/test_qrace_helper.py

def test_build_testjob_ids_returns_indices(tmp_path):
    """_build_testjob_ids returns '_'-joined row indices for ExecutorFlag=Yes rows."""
    tc_file = tmp_path / "TestCasesFile.xlsx"
    df = pd.DataFrame({
        "Test Case Id": ["TC_01", "TC_02", "TC_03"],
        "ExecutorFlag": ["Yes", "No", "Yes"],
        "TestDataId": ["TD1", "TD2", "TD3"],
        "Workflow": ["Flow1", "Flow2", "Flow3"],
    })
    df.to_excel(tc_file, index=False)

    helper = QraceHelper()
    with patch("Qrace.QraceHelper._TESTCASES_EXCEL", str(tc_file)):
        result = helper._build_testjob_ids()

    assert result == "0_1"           # row 0 (TC_01) and row 1 (TC_03, index in eligible list)
    assert len(QraceHelper._test_cases) == 2
    assert QraceHelper._test_cases[0]["Test Case Id"] == "TC_01"
    assert QraceHelper._test_cases[1]["Test Case Id"] == "TC_03"
```

- [ ] **Step 2: Run test — expect FAIL**

```bash
python3 -m pytest tests/test_qrace_helper.py::test_build_testjob_ids_returns_indices -v
```

- [ ] **Step 3: Rewrite `_build_testjob_ids()` in QraceHelper.py**

`_build_testjob_ids` already exists at around line 97 and `_get_testcase_row` at around line 165. **Delete both method bodies entirely** and replace with the implementations below.

```python
def _build_testjob_ids(self):
    """
    Read TestCasesFile.xlsx, return '_'-joined row indices for ExecutorFlag=Yes rows.
    testjobId = str(index into _test_cases list), not the actual Test Case Id.
    This avoids underscore-split collision since indices have no underscores.
    """
    try:
        if not EXCEL_AVAILABLE:
            BuiltIn().log_to_console("[QraceHelper] pandas/openpyxl not installed")
            return ""
        df = pd.read_excel(_TESTCASES_EXCEL, dtype=str).fillna("")
        eligible = df[df["ExecutorFlag"].str.strip().str.lower() == "yes"]
        # reset_index(drop=True) is required: makes indices 0-based and contiguous
        # regardless of which rows had ExecutorFlag=No. Without it, integer lookup returns wrong rows.
        QraceHelper._test_cases = eligible.reset_index(drop=True).to_dict(orient="records")
        indices = [str(i) for i in range(len(QraceHelper._test_cases))]
        BuiltIn().log_to_console(f"[QraceHelper] {len(indices)} test cases to run")
        return "_".join(indices)
    except Exception as err:
        BuiltIn().log_to_console(f"[QraceHelper] Failed to read TestCasesFile: {err}")
        return ""
```

Also fix `_get_testcase_row()` to look up by integer index:

```python
def _get_testcase_row(self, test_job_id):
    """Return TestCasesFile row dict for the given row index (str or int)."""
    try:
        idx = int(str(test_job_id).strip())
        if 0 <= idx < len(QraceHelper._test_cases):
            return QraceHelper._test_cases[idx]
    except (ValueError, TypeError):
        pass
    return {}
```

- [ ] **Step 4: Run test — expect PASS**

```bash
python3 -m pytest tests/test_qrace_helper.py::test_build_testjob_ids_returns_indices -v
```

- [ ] **Step 5: Commit**

```bash
git add Qrace/QraceHelper.py tests/test_qrace_helper.py
git commit -m "feat: testjobId is now row index — fixes underscore-split collision"
```

---

## Task 5: Fix `_load_test_data_for_case()` — correct join key and file path

**Files:**
- Modify: `Qrace/QraceHelper.py`

Issues to fix:
1. File path: `_TESTDATA_EXCEL_TEMPLATE.format(env=env)` → single constant `_TESTDATA_EXCEL`
2. Join key: `"TestCaseId"` → `"Testcaseid"` (exact case from TH Test Data.xlsx)
3. Lookup logic: input is row index → get `TestDataId` from `_test_cases[idx]` → look up `Testcaseid == TestDataId` in TestDataFile

- [ ] **Step 1: Write the failing test**

```python
# add to tests/test_qrace_helper.py

def test_load_test_data_for_case(tmp_path):
    """_load_test_data_for_case loads correct row from TestDataFile by TestDataId."""
    # Set up TestCasesFile
    tc_file = tmp_path / "TestCasesFile.xlsx"
    pd.DataFrame({
        "Test Case Id": ["TC_01"],
        "ExecutorFlag": ["Yes"],
        "TestDataId": ["TD1"],
        "Workflow": ["Flow1"],
    }).to_excel(tc_file, index=False)

    # Set up TestDataFile with CommonData sheet
    td_file = tmp_path / "TestDataFile.xlsx"
    with pd.ExcelWriter(td_file, engine="openpyxl") as w:
        pd.DataFrame({
            "Testcaseid": ["TD1", "TD2"],
            "Flow_Flag": ["Insurance", "Engagement"],
            "Policy_No": ["P001", "P002"],
        }).to_excel(w, sheet_name="CommonData", index=False)

    helper = QraceHelper()
    with patch("Qrace.QraceHelper._TESTCASES_EXCEL", str(tc_file)), \
         patch("Qrace.QraceHelper._TESTDATA_EXCEL", str(td_file)):
        helper._build_testjob_ids()       # populate _test_cases
        helper._load_test_data_for_case("0")  # index 0 → TestDataId="TD1"

    assert QraceHelper.testData.get("Flow_Flag") == "Insurance"
    assert QraceHelper.testData.get("Policy_No") == "P001"
```

- [ ] **Step 2: Run test — expect FAIL**

```bash
python3 -m pytest tests/test_qrace_helper.py::test_load_test_data_for_case -v
```

- [ ] **Step 3: Rewrite `_load_test_data_for_case()` in QraceHelper.py and fix `get_vps_from_qrace`**

Update the path constant at top of file:
```python
_TESTDATA_EXCEL = os.path.join(_PROJECT_ROOT, "TestData", "TestDataFile.xlsx")
# Remove: _TESTDATA_EXCEL_TEMPLATE = ...
```

`_load_test_data_for_case` already exists at around line 113 and currently reads `"TestCaseId"` as the join key. **Delete its entire body and replace** with the implementation below.

Also update `get_vps_from_qrace` (around line 227) to remove the old `_TESTDATA_EXCEL_TEMPLATE` usage — TH Test Data.xlsx has no VP sheet so this becomes a no-op. **Delete its body and replace**:

Also delete these two lines from `_load_test_data_for_case` (currently around line 156) that read `Test_Type` and `Workflow` from testData — after the rewrite these come from `tc_row` instead:
```python
# DELETE these lines from the old implementation:
if "Workflow" in QraceHelper.testData:
    QraceHelper.workflow = QraceHelper.testData.get("Workflow", "")
if "Test_Type" in QraceHelper.testData:
    QraceHelper.test_type = QraceHelper.testData.get("Test_Type", "POSITIVE")
```

Update `get_vps_from_qrace` to use the new constant and remove the `VP` sheet lookup (TH Test Data.xlsx has no VP sheet — `Get VPs From Qrace` is commented out in executors, so this becomes a no-op):

```python
@keyword("Get VPs From Qrace")
def get_vps_from_qrace(self, testjobId):
    # No VP sheet in TestDataFile — VP expected values are passed inline by test steps
    BuiltIn().log_to_console("[QraceHelper] Get VPs From Qrace: no VP sheet (no-op)")
```

Rewrite `_load_test_data_for_case`:
```python
def _load_test_data_for_case(self, test_job_id):
    """
    test_job_id is a row index into _test_cases.
    Look up TestDataId from that row, then find the matching Testcaseid
    row across all sheets in TestDataFile.xlsx.
    """
    try:
        if not EXCEL_AVAILABLE:
            return
        tc_row = QraceHelper._get_testcase_row(self, test_job_id)
        test_data_id = tc_row.get("TestDataId", "").strip()
        if not test_data_id:
            BuiltIn().log_to_console(
                f"[QraceHelper] No TestDataId for job index {test_job_id}")
            return

        sheets = pd.read_excel(_TESTDATA_EXCEL, sheet_name=None, dtype=str)
        merged = pd.DataFrame()
        for sheet_df in sheets.values():
            if "Testcaseid" not in sheet_df.columns:
                continue
            sheet_df = sheet_df.fillna("")
            if merged.empty:
                merged = sheet_df
            else:
                merged = pd.merge(merged, sheet_df, on="Testcaseid", how="outer",
                                  suffixes=("", "_dup"))
                # drop duplicate columns introduced by suffix
                merged = merged[[c for c in merged.columns if not c.endswith("_dup")]]

        if merged.empty:
            BuiltIn().log_to_console(f"[QraceHelper] TestDataFile has no Testcaseid columns")
            return

        result = merged[merged["Testcaseid"].str.strip() == test_data_id].fillna("")
        if result.empty:
            BuiltIn().log_to_console(
                f"[QraceHelper] TestDataId not found: {test_data_id}")
            return

        row = result.iloc[0]
        QraceHelper.testData = {}
        for col in result.columns:
            val = str(row[col]).strip()
            if val in ("nan", ""):
                val = ""
            QraceHelper.testData[col] = val
            BuiltIn().set_test_variable("${" + col + "}", val)

        # Workflow comes from TestCasesFile (tc_row), not TestDataFile
        QraceHelper.workflow = tc_row.get("Workflow", "")

        BuiltIn().log_to_console(
            f"[QraceHelper] Loaded test data: job={test_job_id} td={test_data_id}")
    except Exception as err:
        BuiltIn().log_to_console(f"[QraceHelper] Failed to load test data: {err}")
```

- [ ] **Step 4: Run test — expect PASS**

```bash
python3 -m pytest tests/test_qrace_helper.py::test_load_test_data_for_case -v
```

- [ ] **Step 5: Commit**

```bash
git add Qrace/QraceHelper.py tests/test_qrace_helper.py
git commit -m "feat: fix _load_test_data_for_case to use row-index→TestDataId→Testcaseid join"
```

---

## Task 6: Fix remaining column-name references and `qrace_test_teardown`

**Files:**
- Modify: `Qrace/QraceHelper.py`

Remaining issues:
1. `qrace_test_setup()`: `tc_row.get("Test_Type", ...)` → `"Test Type"` (actual column from Qrace export, has space)
2. `qrace_test_setup()`: `tc_row.get("Workflow", ...)` ✓ already correct
3. `qrace_test_teardown()`: the summary row uses `testjobId` as the ID in `ExecutionSummary.xlsx`. Since `testjobId` is now a row index, add the real `Test Case Id` to the summary for readability.

- [ ] **Step 1: Write the failing test**

```python
# add to tests/test_qrace_helper.py

def test_qrace_teardown_summary_has_test_case_id(tmp_path):
    """Teardown writes actual Test Case Id (not index) to ExecutionSummary."""
    tc_file = tmp_path / "TestCasesFile.xlsx"
    pd.DataFrame({
        "Test Case Id": ["TC_ViewPolicy_001"],
        "ExecutorFlag": ["Yes"],
        "TestDataId": ["TD1"],
        "Test Type": ["POSITIVE"],
        "Workflow": ["Insurance"],
    }).to_excel(tc_file, index=False)

    td_file = tmp_path / "TestDataFile.xlsx"
    with pd.ExcelWriter(td_file, engine="openpyxl") as w:
        pd.DataFrame({"Testcaseid": ["TD1"], "Flow_Flag": ["Insurance"]}).to_excel(
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
```

- [ ] **Step 2: Run test — expect FAIL**

```bash
python3 -m pytest tests/test_qrace_helper.py::test_qrace_teardown_summary_has_test_case_id -v
```

- [ ] **Step 3: Fix `qrace_test_setup` column reference and `qrace_test_teardown` summary**

In `qrace_test_setup()`, fix the test type column:
```python
# Change:
QraceHelper.test_type = tc_row.get("Test_Type", "POSITIVE")
# To:
QraceHelper.test_type = tc_row.get("Test Type", "POSITIVE")
```

In `qrace_test_teardown()`, resolve the display test case ID from the row:
```python
# At top of the try block, add:
tc_row = QraceHelper._get_testcase_row(self, testjobId)
display_tc_id = tc_row.get("Test Case Id", str(testjobId))

# Then in exec_row dict, change:
#   "TestCaseId": testjobId,
# To:
    "TestCaseId": display_tc_id,
```

And the VP rows similarly:
```python
# In the VP accumulation loop, change:
#   "TestCaseId": testjobId,
# To:
    "TestCaseId": display_tc_id,
```

- [ ] **Step 4: Run test — expect PASS**

```bash
python3 -m pytest tests/test_qrace_helper.py::test_qrace_teardown_summary_has_test_case_id -v
```

- [ ] **Step 5: Run all tests**

```bash
python3 -m pytest tests/test_qrace_helper.py -v
```
Expected: all tests PASS.

- [ ] **Step 6: Commit**

```bash
git add Qrace/QraceHelper.py tests/test_qrace_helper.py
git commit -m "fix: column names Test Type, Test Case Id in setup/teardown; display TC id in summary"
```

---

## Task 7: Push to GitHub and notify QA

- [ ] **Step 1: Write end-to-end smoke test**

Add this test to `tests/test_qrace_helper.py` — it exercises the full call chain in one shot:

```python
def test_full_call_chain(tmp_path):
    """get_testrun_metadata → qrace_test_setup → qrace_test_teardown end-to-end."""
    # Environment
    env_file = tmp_path / "Environment.xlsx"
    pd.DataFrame({"Key": ["Env", "BS_user"], "Value": ["staging", "u1"]}).to_excel(
        env_file, sheet_name="STG", index=False)

    # TestCasesFile
    tc_file = tmp_path / "TestCasesFile.xlsx"
    pd.DataFrame({
        "Test Case Id": ["TC_001"], "ExecutorFlag": ["Yes"],
        "TestDataId": ["TD1"], "Test Type": ["POSITIVE"], "Workflow": ["Insurance"],
    }).to_excel(tc_file, index=False)

    # TestDataFile
    td_file = tmp_path / "TestDataFile.xlsx"
    with pd.ExcelWriter(td_file, engine="openpyxl") as w:
        pd.DataFrame({"Testcaseid": ["TD1"], "Flow_Flag": ["Insurance"],
                      "Policy_No": ["P001"]}).to_excel(w, sheet_name="CommonData", index=False)

    log_dir = tmp_path / "log"
    log_dir.mkdir()

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
```

- [ ] **Step 2: Run smoke test — expect PASS**

```bash
python3 -m pytest tests/test_qrace_helper.py::test_full_call_chain -v
```

- [ ] **Step 3: Run all tests**

```bash
python3 -m pytest tests/test_qrace_helper.py -v
git status
```

- [ ] **Step 4: Push**

```bash
git push origin TH_Automation_Script
```

- [ ] **Step 5: QA handoff checklist**

After pushing, QA must:

1. **Fill `TestDataId` column** in `TestData/TestCasesFile.xlsx`:
   - Open `TestData/TestCasesFile.xlsx`
   - For each test case row, find the matching row in `TestData/TestDataFile.xlsx` → CommonData sheet
   - Copy the `Testcaseid` value (e.g. `TD1`) into the `TestDataId` column

2. **Review `Config/Environment.xlsx`**:
   - `STG` sheet is pre-populated from Qrace artifact
   - Fill in `UAT` sheet with UAT environment values (BS URLs, credentials, etc.)

3. **Set `ExecutorFlag`** in `TestData/TestCasesFile.xlsx`:
   - Default is `Yes` for all rows
   - Change to `No` for any test cases to skip

---

## Summary of Column Name Changes in QraceHelper.py

| Location | Old | New |
|----------|-----|-----|
| `_build_testjob_ids` | `"TestCaseId"` | `"Test Case Id"` (read only) |
| `_build_testjob_ids` | returns TC IDs | returns row indices |
| `_get_testcase_row` | matches by TestCaseId string | matches by integer index |
| `_load_test_data_for_case` | joins on `"TestCaseId"` | joins on `"Testcaseid"` via TestDataId lookup |
| `_load_test_data_for_case` | `_TESTDATA_EXCEL_TEMPLATE.format(env=)` | `_TESTDATA_EXCEL` (single file) |
| `qrace_test_setup` | `"Test_Type"` | `"Test Type"` |
| `qrace_test_teardown` | `testjobId` as summary key | `tc_row["Test Case Id"]` as summary key |
| `_load_env_json` | reads JSON | replaced by `_load_env_excel` reading xlsx |
