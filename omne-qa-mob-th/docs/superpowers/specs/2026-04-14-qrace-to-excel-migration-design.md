# Migration Design: Qrace → Excel + JSON

**Date:** 2026-04-14  
**Project:** omne-qa-mob-th (FWD Thailand OMNE Insurance Mobile Automation)  
**Status:** Design Approved  
**Reference Project:** omne-qa-opusauto

---

## 1. Background & Problem Statement

The `omne-qa-mob-th` test suite currently depends entirely on **Qrace** — an internal test management system hosted at `http://10.160.132.200:8082`. Qrace provides:

- Infrastructure configuration (BrowserStack credentials, DB connection, API keys, app versions, system URLs)
- Test case list and test data per case
- Verification point (VP) expected values
- Test result reporting (status, actual result, VP comparison, screenshots)
- Test job orchestration (which jobs to run, session management)

**Qrace is being decommissioned.** The test suite must become fully self-contained without any external dependency on Qrace.

---

## 2. Solution Selected

**Method: JSON for environment config + Excel for test data** (adapted from `omne-qa-opusauto`)

| Qrace Responsibility | Replacement |
|---|---|
| Environment/infrastructure config | `Config/Environment.json` |
| Test case list (which cases to run) | `TestData/TestCasesFile.xlsx` |
| Per-case test data (parameters) | `TestData/TestDataFile_{ENV}.xlsx` (multi-sheet) |
| Verification points (VP expected values) | VP sheet inside `TestDataFile.xlsx` |
| Result reporting | `ExecutionSummary.xlsx` + HTML report |
| Test orchestration (loop) | Robot Framework FOR loop |
| `QraceHelper.py` | `Excel/ExcelHelper.py` (new) |

**Why this approach:**
- Sensitive infrastructure config (BS keys, DB passwords) stays in JSON which is gitignored — not exposed in Excel
- Excel is owned by the QA team for daily maintenance — no developer intervention needed
- Directly reuses patterns and code from `omne-qa-opusauto` (proven, working)
- Pages/ and PageObjects/ directories are **unchanged** — no regression risk there

---

## 3. Architecture

### 3.1 Directory Structure (new/changed files only)

```
omne-qa-mob-th/
├── Config/
│   ├── Environment.json           # Infrastructure config (gitignored)
│   └── Environment.json.template  # Empty-value template committed to repo
├── TestData/
│   ├── TestCasesFile.xlsx         # Test case catalog with ExecutorFlag
│   ├── TestDataFile_UAT.xlsx      # Test data for UAT (multi-sheet)
│   └── TestDataFile_STG.xlsx      # Test data for STG (multi-sheet)
├── Excel/
│   ├── ExcelHelper.py             # Replaces QraceHelper.py
│   └── ReportGenerator.py         # HTML report (from opusauto SetReportPath.py)
├── Executor/
│   └── Insurance/
│       ├── OmneInsuranceExecutor.robot        # Updated: remove Qrace imports/setup
│       └── OmneInsuranceFlowExecutor.resource  # Updated: replace Single Session Loop
├── CustomLibraries/
│   └── common.robot               # Updated: replace all Qrace env keywords
└── log/
    └── ExecutionSummary.xlsx      # Auto-generated output
```

---

### 3.2 Config/Environment.json

Replaces **all** `Get Environment Attribute` calls across the entire project. This file is gitignored — filled in per team/environment. A `.template` version with empty values is committed to the repo.

The `ExcelHelper.py` implements `Get Environment Attribute` as a **compatibility shim** (same keyword name) so that files in Pages/, MailSac/, and API/ that call `Get Environment Attribute` continue to work without modification.

```json
{
  "Environment": {
    "UAT": {
      "Env": "UAT",

      "BS_user": "",
      "BS_accessKey": "",
      "BS_link_iOS": "",
      "BS_link_Android": "",
      "bundleID": "",

      "DB_hostname": "",
      "DB_Username": "",
      "DB_password": "",
      "DB_port": "",
      "DBinstanceTable": "",
      "DBinstanceAddonTable": "",
      "DB_Encrpt_AND_Decrpt_key": "",
      "DB_Encrpt_AND_Decrpt_IVkey": "",

      "host": "",
      "APIKeyname": "",
      "APIKeyValueauth": "",
      "APIKeyvalue": "",
      "mailSacKey": "",
      "TimeZone": "Asia/Bangkok",
      "App_Version": "",
      "listofmobileno": "",

      "OWB_URL": "",
      "OWB_ENV": "",

      "OPUS_URL": "",

      "IL_URL": "",
      "IL_username": "",
      "IL_password": "",

      "LA_USERNAME": "",
      "LA_UPASSWORD": "",
      "LA_Env": "",
      "CATHLA01.TH.INTRANET": "",

      "AppOrg": "",
      "AppCenterAPIToken": "",

      "Release": "1.0_build1"
    },
    "STG": {
      "...": "same keys, different values"
    }
  }
}
```

**`Release` key** replaces Qrace's `Get ReleaseName`. The executor splits it on `_` to derive `${buildversion}` and `${buildid}` — same logic as before.

**`runId`** is no longer needed (it was a Qrace test run identifier). It is dropped. Any `${runId}` references in actual result strings are removed.

---

### 3.3 TestData/TestCasesFile.xlsx

Controls which test cases execute. One row per test case. All routing flags that `Main Executor1` needs are columns here.

| Column | Description | Example |
|---|---|---|
| ExecutorFlag | `Yes` / `No` | Yes |
| TestCaseId | Unique ID | TC_001_Insurance_UpdateName |
| Test_Type | `POSITIVE` / `NEGATIVE` | POSITIVE |
| Flow_Flag | Top-level module | Insurance |
| Insurance_Flow | Specific flow keyword | Update Name |
| OWB_Flag | Trigger OWB verification | Yes / No |
| OPUS_Flag | Trigger OPUS verification | Yes / No |
| OPUS_OR_OWB_App | Which app for backend step | OWB / OPUS |
| CoreSystem_Flag | Trigger LA/IL | Yes / No |
| Core_System | `LA` / `IL` | LA |
| CoreSystem_Flow | Sub-flow within LA or IL | (keyword suffix) |
| Engagement_Module | Engagement keyword name | (empty or keyword name) |
| Platform | `iOS` / `Android` | iOS |
| DeviceName | BrowserStack device name | iPhone 14 |
| Summary | Human-readable description | Update policyholder name |

---

### 3.4 TestData/TestDataFile_{ENV}.xlsx

Multi-sheet Excel. All sheets share `TestCaseId` as the join key. `ExcelHelper` merges all sheets on `TestCaseId` and sets each column as a Robot Framework variable — same variable names as currently used in Pages/ files.

**Sheet structure:**

| Sheet | Purpose | Key Columns (examples) |
|---|---|---|
| Common | Login + shared data | TestCaseId, Email, Password, Policy_No, LoginMethod |
| Insurance_UpdatePolicy | Update policy flows | TestCaseId, NewName, NewAddress, BenefitPayout, MailingPref |
| Insurance_Claims | Claims flows | TestCaseId, ClaimType, HospitalName, DiagnosisName, Amount |
| Insurance_PayPremium | Pay premium / loan repayment | TestCaseId, PaymentMethod, Amount |
| Insurance_ViewDocument | View document flows | TestCaseId, DocumentType |
| Insurance_ViewCareCard | Care card flows | TestCaseId, CardType |
| Insurance_ViewTransaction | Transaction history flows | TestCaseId, TransactionType |
| Insurance_ViewInvestment | Policy investment flows | TestCaseId, FundName |
| OWB | OWB verification data | TestCaseId, OWB_ExpectedStatus |
| OPUS | OPUS verification data | TestCaseId, OPUS_Flow, OPUS_User_ID |
| LA | LA core system data | TestCaseId, LA_PolicyNo, LA_ExpectedField |
| IL | IL core system data | TestCaseId, IL_CaseNo, IL_ExpectedField |
| Engagement | Engagement module data | TestCaseId, BannerName, QuickLinkName |
| VP | Verification points | TestCaseId, FieldName, ExpectedValue, ExpectedSource |

**VP sheet** replaces Qrace's VP system. Multiple rows per `TestCaseId` (one row per field to verify). `ExcelHelper` reads all VP rows for the current test case into a list at the start of each iteration.

---

### 3.5 Excel/ExcelHelper.py

Replaces `QraceHelper.py`. Built by extending `omne-qa-opusauto/Excel/ExcelHelper.py`.

**Keywords provided:**

| Keyword | Replaces | Description |
|---|---|---|
| `Get Details from Environment JSON` | `Get Details from Qrace Environment` / `Before Test Setup` | Reads Environment.json for given env, sets all keys as Robot global variables |
| `Get Environment Attribute` | `Get Environment Attribute` (Qrace) | **Compatibility shim** — looks up key in the in-memory environment dict loaded by the above keyword. Same keyword name, zero changes in callers. |
| `Get Test Cases To Execute` | Qrace test job list | Reads TestCasesFile.xlsx, returns list filtered by ExecutorFlag=Yes |
| `Get TestData From Excel` | `Get TestData From Qrace` | Merges all TestDataFile sheets on TestCaseId, sets Robot variables |
| `Get VPs For TestCase` | `Get VPs From Qrace` | Reads VP sheet rows for given TestCaseId, returns list of dicts |
| `Set Verification Point` | `Set VP` / `Set VP With Actual Source` | Stores one VP result (fieldName, expected, actual, status) in memory |
| `Set Calc Verification Point` | `Set Calc VP With Source And Original Values` and variants | Stores calculated/static VP with source and original values |
| `Set Dynamic Verification Point` | `Set Dynamic VP` / `Set Dynamic VP With Source` | Stores a VP where expected value is determined at runtime |
| `Set Actual Result` | `Set Actual Result` | Appends text to in-memory actual result string |
| `Set TestJob Status` | `Set TestJob Status` | **No-op stub** — logs the status; actual status is determined at teardown from test outcome. Keeps calling code unchanged. |
| `Set Custom Directory` | `Set Custom Directory` (Qrace screenshot upload) | Records screenshot directory path in memory for report generation. No upload to external system. |
| `Write Execution Results` | `Qrace Test TearDown With ScreenShots` | Writes ExecutionSummary.xlsx with execution row + VP rows for current test case |
| `Generate HTML Report` | (new) | Renders HTML report after all test cases complete |

**In-memory state** (class-level, same pattern as QraceHelper):
- `env_config: dict` — loaded from Environment.json
- `vp_list: list` — accumulates VP results for current test case
- `actual_result: str` — accumulates result string for current test case
- `screenshot_dirs: set` — directories to include in report

---

### 3.6 common.robot Changes

Two keywords that fetch from Qrace must be replaced:

1. **`Get Details from Qrace Environment`** → replaced by `Get Details from Environment JSON    ${ENV}`  
   - Reads Environment.json; sets all env vars as globals
   - Derives `${buildversion}` and `${buildid}` by splitting `${Release}` on `_`

2. **`Before Test Setup`** → **deleted** (it duplicates `Get Details from Qrace Environment`; callers switch to `Get Details from Environment JSON`)

3. **`Launch OMNE Application`** — kept as-is; now reads `${BS_user}`, `${BS_accessKey}`, `${BS_link_iOS/Android}`, `${bundleID}` from the globals set by `Get Details from Environment JSON` (same variable names, zero change to the keyword body)

4. **`Set Custom Directory`** — kept as a call to `ExcelHelper.Set Custom Directory` (records path, no Qrace upload)

5. **`Set Executed TestJob`** / `${executionDetailFile}` — **deleted**. This was used for resumption tracking in Qrace. Without Qrace orchestration, it has no purpose.

---

### 3.7 Execution Flow (after migration)

```
OmneInsuranceExecutor.robot
│
├── Test Setup:   Get Details from Environment JSON    ${ENV}
│                 (derives buildversion, buildid from Release key)
│
└── Test Case:    OMNE Executor
    │
    ├── ${testCaseIds} = Get Test Cases To Execute    ${TestCasesFile}
    │
    └── FOR  ${tcid}  IN  @{testCaseIds}
        │
        ├── Get TestData From Excel    ${TestDataFile}    ${tcid}
        │   (sets all variables: ${Email}, ${Policy_No}, ${Flow_Flag},
        │    ${Insurance_Flow}, ${OWB_Flag}, ${OPUS_OR_OWB_App},
        │    ${CoreSystem_Flag}, ${Core_System}, ${CoreSystem_Flow}, ...)
        │
        ├── ${vpExpected} = Get VPs For TestCase    ${TestDataFile}    ${tcid}
        │
        ├── Set Global Variable    ${actualResult}    Env:${env} (${buildversion}_${buildid})
        │
        ├── Launch OMNE Application
        │
        ├── Login With ${LoginMethod}
        │
        ├── IF ${Flow_Flag} == 'Insurance'
        │     Run Keyword    ${Insurance_Flow}
        │     IF ${OWB_Flag} == 'Yes'
        │         OWB Executor
        │     ELSE IF ${OPUS_Flag} == 'Yes'
        │         OPUS Executor
        │     END
        │     IF ${CoreSystem_Flag} == 'Yes'
        │         IF ${Core_System} == 'LA'
        │             LA Executor
        │         ELSE
        │             IL Executor
        │         END
        │     END
        │
        ├── ELSE IF ${Flow_Flag} == 'Engagement'
        │     Run Keyword    ${Engagement_Module}
        │
        ├── Write Execution Results    ${tcid}    ${actualResult}    ${vpList}
        │
        └── Close Application
    END
│
└── Test Teardown:  Generate HTML Report    ${OutputDir}
```

---

### 3.8 Verification Point (VP) System Design

Qrace had 14+ VP keyword variants. The new system consolidates these into three keywords with consistent signatures:

| New Keyword | Maps from Qrace Variants | Arguments |
|---|---|---|
| `Set Verification Point` | `Set VP`, `Set VP With Actual Source` | fieldName, expected, actual, status, expectedSource=Static, actualSource=Actual |
| `Set Calc Verification Point` | `Set Calc VP With Source`, `Set Calc VP With Source And Original Values`, `Set Calc VP Actual Value`, `Set Calc Table *` | fieldName, expected, actual, status, originalExpected, originalActual, expectedSource=Static |
| `Set Dynamic Verification Point` | `Set Dynamic VP`, `Set Dynamic VP With Source`, `Set Dynamic VP With Source And Original Values` | fieldName, actual, status, actualSource=Dynamic |

**All three append to the in-memory `vp_list`.** At teardown, `Write Execution Results` writes the full list to the VerificationPoints sheet.

**Callers that use `Set Calc VP With Source And Original Values` (called ~20 times in executors)** need their calls updated to `Set Calc Verification Point` — same arguments in the same order. This is a search-and-replace in the executor files, not a logic change.

**`Get VP Expected Value` / `Get VPs`** — replaced by `Get VPs For TestCase` which returns the full VP list from the VP sheet. Callers can look up expected values from this list by fieldName.

---

## 4. What Changes vs What Stays the Same

### Unchanged (zero modification needed)
- All `Pages/` resource files — they call `Get Environment Attribute` which is shimmed
- All `PageObjects/` resource files
- `CustomLibraries/Operation.py`
- `CustomLibraries/DateTimeCompare.py`
- `CustomLibraries/UploadAppinBS/` — `AppOrg` and `AppCenterAPIToken` come from the environment shim
- `CustomLibraries/MailSac/` — `mailSacKey` comes from the environment shim
- `CustomLibraries/API/` — `APIKeyname`, `APIKeyValueauth`, `APIKeyvalue` come from the environment shim

### Modified

| File | What Changes |
|---|---|
| `CustomLibraries/common.robot` | Replace `Get Details from Qrace Environment` with `Get Details from Environment JSON`; delete `Before Test Setup`; delete `Set Executed TestJob`; change library import from `QraceHelper` to `ExcelHelper` |
| `Executor/Insurance/OmneInsuranceExecutor.robot` | Replace `Test Setup Get TestRun Metadata` with `Get Details from Environment JSON`; replace `Main Executor1` keyword; update library imports |
| `Executor/Insurance/OmneInsuranceFlowExecutor.resource` | Replace `Single Session Loop` with FOR loop (see Section 3.7) |
| `Executor/OWB/OWBExecutor.robot` | Replace `Qrace Test TearDown` calls with `Write Execution Results`; replace `Set Calc VP*` calls with `Set Calc Verification Point` |
| `Executor/LA/LAExecutor.robot` | Same VP keyword rename + teardown replacement |
| `Executor/IL/IL_Executor.robot` | Same VP keyword rename + teardown replacement |
| `Executor/OPUS/OPUSExecutor.robot` | Same VP keyword rename + teardown replacement |

### New Files

| File | Purpose |
|---|---|
| `Config/Environment.json` | Infrastructure config (gitignored) |
| `Config/Environment.json.template` | Empty-value template committed to repo |
| `TestData/TestCasesFile.xlsx` | Test case catalog |
| `TestData/TestDataFile_UAT.xlsx` | UAT test data |
| `TestData/TestDataFile_STG.xlsx` | STG test data |
| `Excel/ExcelHelper.py` | Core helper replacing QraceHelper |
| `Excel/ReportGenerator.py` | HTML report generator |
| `.gitignore` entry | `Config/Environment.json` |

### Deleted

| File | Reason |
|---|---|
| `Qrace/QraceHelper.py` | Replaced by `Excel/ExcelHelper.py` |
| `Qrace/QraceListner.py` | Robot Framework listener stub — only printed console messages, no functional logic. No replacement needed. |

---

## 5. Migration Risks & Mitigations

| Risk | Mitigation |
|---|---|
| Test data in Qrace has no Excel equivalent yet | QA team exports all test data and VP expected values from Qrace before shutdown and populates TestDataFile sheets |
| BrowserStack session batching (Single Session Loop ran multiple jobs in one session) | Accept one BrowserStack session per test case initially; adds overhead but simplifies the loop significantly. Optimize later if needed. |
| Environment.json contains secrets | Gitignore `Config/Environment.json`; commit `Config/Environment.json.template` with empty values; distribute filled file via secure channel (password manager / shared drive) |
| `Get Environment Attribute` called in ~10 files marked unchanged | Handled by compatibility shim in ExcelHelper — no changes needed in callers |
| VP keyword name changes across 4 executor files | Search-and-replace of keyword names; arguments unchanged. Low risk. |

---

## 6. Implementation Phases

### Phase 1 — Foundation (ExcelHelper + Environment Config)
1. Create `Excel/ExcelHelper.py` — implement all keywords from Section 3.5
   - Priority: `Get Details from Environment JSON`, `Get Environment Attribute` shim, `Get Test Cases To Execute`, `Get TestData From Excel`
2. Create `Config/Environment.json.template` (all keys, empty values)
3. Create `Config/Environment.json` (fill in UAT values; gitignore it)
4. Update `CustomLibraries/common.robot`:
   - Change library import: `QraceHelper` → `ExcelHelper`
   - Replace `Get Details from Qrace Environment` → `Get Details from Environment JSON`
   - Replace `Launch OMNE Application` — update to read from globals (verify variable names match JSON keys)
   - Delete `Before Test Setup`, `Set Executed TestJob`
   - Replace `Set Custom Directory` call to use ExcelHelper stub
5. Dry run: verify environment loads and variables are set correctly

### Phase 2 — Test Data Excel
1. Export all test cases and their data from Qrace (before shutdown)
2. Create `TestData/TestCasesFile.xlsx` with all columns from Section 3.3
3. Create `TestData/TestDataFile_UAT.xlsx` — populate all sheets from Qrace export
4. Populate VP sheet from Qrace VP expected value export
5. Implement `Get TestData From Excel` and `Get VPs For TestCase` in ExcelHelper
6. Verify variables are set correctly for a sample test case (print variables, don't run app yet)

### Phase 3 — Executor Refactor
1. Rename VP keywords across executor files (`Set Calc VP With Source And Original Values` → `Set Calc Verification Point`, etc.)
2. Rewrite `OmneInsuranceFlowExecutor.resource`: replace `Single Session Loop` with FOR loop (Section 3.7)
3. Update `OmneInsuranceExecutor.robot`: replace Test Setup, remove Qrace imports, update Test Case body
4. Update remaining executors (OWB, LA, IL, OPUS): replace TearDown calls, rename VP keywords
5. Run one test case end-to-end; verify execution completes and result string is correct

### Phase 4 — Reporting
1. Implement `Write Execution Results` and `Set Verification Point` / `Set Calc Verification Point` / `Set Dynamic Verification Point` in ExcelHelper
2. Port `SetReportPath.py` from opusauto as `Excel/ReportGenerator.py`
3. Verify `ExecutionSummary.xlsx` generates correctly after a test run
4. Verify HTML report renders correctly with screenshots

### Phase 5 — Full Regression & Cleanup
1. Run full regression (all ExecutorFlag=Yes cases)
2. Compare results against last known-good Qrace run
3. Fix discrepancies
4. Delete `Qrace/` directory
5. Update `requirements.txt` to add `pandas`, `openpyxl`, `jinja2`; remove Qrace-specific packages if any

---

## 7. Dependencies

Add to `requirements.txt`:
```
pandas>=2.0
openpyxl>=3.1
jinja2>=3.0
```

Already present (keep):
```
robotframework
robotframework-appiumlibrary
robotframework-mainframe3270
robotframework-faker
requests
```

---

## 8. Open Questions (resolve before Phase 2)

1. **Qrace data export**: Who owns the export from Qrace? VP expected values and test data must be exported before Qrace is shut down — this is a hard prerequisite for Phase 2.
2. **Environment.json distribution**: Who fills in the production values and how is the file shared securely (password manager, shared drive, CI secret variable)?
3. **BrowserStack session batching**: Is one-session-per-test-case acceptable for the initial rollout, or is there a hard execution time constraint that requires batching?
