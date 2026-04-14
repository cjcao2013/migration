# Migration Design: Qrace → Excel + JSON

**Date:** 2026-04-14  
**Project:** omne-qa-mob-th (FWD Thailand OMNE Insurance Mobile Automation)  
**Status:** Design Approved  
**Reference Project:** omne-qa-opusauto  
**Principle:** Minimum code changes. Old project — just get it running. Do not refactor.

---

## 1. Background & Problem Statement

The `omne-qa-mob-th` test suite depends entirely on **Qrace** (test management system at `http://10.160.132.200:8082`) for:

- Infrastructure configuration (BrowserStack credentials, DB, API keys, app URLs)
- Test case list and per-case test data
- Verification point (VP) expected values
- Test result reporting
- Test job orchestration

**Qrace is being decommissioned.** The suite must run without it.

---

## 2. Approach: In-Place Replacement of QraceHelper.py

**One sentence:** Replace the implementation of `Qrace/QraceHelper.py` with Excel/JSON-backed logic. Keep the file path, class name, and all keyword names identical. Nothing else in the project changes.

### What changes

| Item | Change |
|---|---|
| `Qrace/QraceHelper.py` | Rewrite internals — same keyword names, read from Excel/JSON instead of Qrace API |
| `Config/Environment.json` | **New file** — all environment/infrastructure config (gitignored) |
| `Config/Environment.json.template` | **New file** — empty-value template committed to repo |
| `TestData/TestCasesFile.xlsx` | **New file** — controls which test cases run |
| `TestData/TestDataFile_UAT.xlsx` | **New file** — test data (multi-sheet, one per module) |
| `TestData/TestDataFile_STG.xlsx` | **New file** — STG variant |

### What does NOT change

**Everything else.** No `.robot` files, no `.resource` files, no `common.robot`, no Executors, no Pages, no PageObjects. Zero modifications.

---

## 3. Config/Environment.json

Replaces all Qrace `Get Environment Attribute` calls. The new `QraceHelper` loads this file once at startup and returns values from memory when `Get Environment Attribute` is called.

File is **gitignored**. The `.template` version (empty values) is committed.

```json
{
  "Environment": {
    "UAT": {
      "Env": "UAT",
      "Release": "1.0_build1",

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
      "AppCenterAPIToken": ""
    },
    "STG": {
      "...": "same keys, different values"
    }
  }
}
```

---

## 4. TestData/TestCasesFile.xlsx

Replaces Qrace's test job list. `QraceHelper` reads this file to build the `${testjobIds}` string that `Single Session Loop` iterates over. The TestCaseId values become the "job IDs".

| Column | Description | Example |
|---|---|---|
| ExecutorFlag | `Yes` / `No` | Yes |
| TestCaseId | Used as the job ID | TC_001_Insurance_UpdateName |
| Test_Type | `POSITIVE` / `NEGATIVE` | POSITIVE |
| Flow_Flag | Top-level module | Insurance |
| Insurance_Flow | Specific flow keyword | Update Name |
| OWB_Flag | Trigger OWB verification | Yes / No |
| OPUS_Flag | Trigger OPUS verification | Yes / No |
| OPUS_OR_OWB_App | Which backend app | OWB / OPUS |
| CoreSystem_Flag | Trigger LA/IL | Yes / No |
| Core_System | `LA` / `IL` | LA |
| CoreSystem_Flow | Sub-flow within LA/IL | (keyword suffix) |
| Engagement_Module | Engagement keyword name | (empty or keyword name) |
| Platform | `iOS` / `Android` | iOS |
| DeviceName | BrowserStack device name | iPhone 14 |

---

## 5. TestData/TestDataFile_{ENV}.xlsx

Multi-sheet Excel. All sheets share `TestCaseId` as the join key. When `Get TestData From Qrace` (or the new `Qrace Test Setup`) is called for a given TestCaseId, the new QraceHelper merges all sheets and sets Robot Framework variables — same variable names as currently used in Pages/.

**Sheets:**

| Sheet | Key Columns |
|---|---|
| Common | TestCaseId, Email, Password, Policy_No, LoginMethod |
| Insurance_UpdatePolicy | TestCaseId, NewName, NewAddress, BenefitPayout, MailingPref |
| Insurance_Claims | TestCaseId, ClaimType, HospitalName, DiagnosisName, Amount |
| Insurance_PayPremium | TestCaseId, PaymentMethod, Amount |
| Insurance_ViewDocument | TestCaseId, DocumentType |
| Insurance_ViewCareCard | TestCaseId, CardType |
| Insurance_ViewTransaction | TestCaseId, TransactionType |
| Insurance_ViewInvestment | TestCaseId, FundName |
| OWB | TestCaseId, OWB_ExpectedStatus |
| OPUS | TestCaseId, OPUS_Flow, OPUS_User_ID |
| LA | TestCaseId, LA_PolicyNo, LA_ExpectedField |
| IL | TestCaseId, IL_CaseNo, IL_ExpectedField |
| Engagement | TestCaseId, BannerName, QuickLinkName |
| VP | TestCaseId, FieldName, ExpectedValue, ExpectedSource |

---

## 6. QraceHelper.py — Keyword Mapping

All keywords keep their **exact names and signatures**. Only the implementation body changes.

| Keyword | Old behaviour | New behaviour |
|---|---|---|
| `Get TestRun Metadata` | POST to Qrace API, fetch env config | Load `Environment.json` for given env; set all keys as Robot globals; derive `buildversion`/`buildid` by splitting `Release` on `_` |
| `Get Details from Qrace Environment` (alias) | Same as above | Same as above — delegates to `Get TestRun Metadata` |
| `Get Environment Attribute` | GET from Qrace API | Return value from in-memory env dict |
| `Get EnvironmentName` | Returns env name from Qrace | Returns `Env` value from env dict |
| `Get TestRunId` | Returns Qrace run ID | Returns empty string (no longer meaningful) |
| `Get ReleaseName` | Returns Qrace release name | Returns `Release` value from env dict |
| `Get TestType` | Returns Qrace test type | Returns `Test_Type` column for current TestCaseId |
| `Get TestCaseId` | Returns Qrace test case ID | Returns current TestCaseId from loop |
| `Single Session Loop` | Reads `${testjobIds}` from Qrace-set variable | Reads TestCasesFile.xlsx, builds `_`-joined TestCaseId string, then runs same loop logic |
| `Qrace Test Setup` | POST to Qrace; fetch test data + VPs | Read TestDataFile.xlsx for given TestCaseId; set Robot variables; load VP sheet rows into memory |
| `Get TestJob Status` | GET from Qrace API | Always return `SUBMITTED` (we control the list) |
| `Set TestJob Status` | POST to Qrace | No-op (status tracked locally) |
| `Set BrowserStack SessionUrl For TestJob` | POST to Qrace | No-op |
| `Get TestData From Qrace` | GET test data dict from Qrace | Read merged Excel row for TestCaseId; return as dict |
| `Get VPs From Qrace` | GET VP list from Qrace | Read VP sheet rows for TestCaseId; return as list |
| `Get VP Expected Value` | Look up in Qrace VP | Look up in in-memory VP list |
| `Set VP` / `Set VP With Actual Source` | POST to Qrace | Append to in-memory VP list |
| `Set Calc VP With Source And Original Values` | POST to Qrace | Append to in-memory VP list |
| `Set Dynamic VP` / variants | POST to Qrace | Append to in-memory VP list |
| `Set Actual Result` | POST to Qrace | Append to in-memory result string |
| `Set Remarks` | POST to Qrace | Append to in-memory remarks string |
| `Set Execution Tag` | POST to Qrace | Append to in-memory tag string |
| `Qrace Test TearDown` / `Qrace Test TearDown With ScreenShots` | POST full result payload to Qrace | Write row to `ExecutionSummary.xlsx`; write VP rows to VerificationPoints sheet |
| `Set Custom Directory` | Register screenshot dir with Qrace | Store path in memory for report |
| `Set Executed TestJob` | Append job ID to tracking file | No-op |
| `Set Failed Actual Result and VP` | Set VP to failed + fail test | Keep logic; just use local VP/result storage |
| `Get Country Specific DateTime` | Qrace utility | Keep existing date/timezone logic unchanged |
| `Post Screenshot And Logs` | Upload to Qrace | No-op (screenshots already on disk) |

---

## 7. Result Output

After all test cases complete:

- **`log/ExecutionSummary.xlsx`** — written by `Qrace Test TearDown`:
  - `ExecutionSummary` sheet: TestCaseId, Platform, Env, BuildVersion, ActualResult, Status, ExecutionTime
  - `VerificationPoints` sheet: TestCaseId, FieldName, ExpectedValue, ActualValue, Status

- **`log/extentReport.html`** — generated after full run (optional, port from opusauto's `SetReportPath.py`)

Screenshots remain in their existing directory structure on disk.

---

## 8. Implementation Phases

### Phase 1 — Environment Config
1. Create `Config/Environment.json.template`
2. Create `Config/Environment.json` (fill in UAT values; add to `.gitignore`)
3. Rewrite `QraceHelper.py` — only the env-related keywords first:
   - `Get TestRun Metadata`, `Get Environment Attribute`, `Get EnvironmentName`, `Get ReleaseName`
4. Run a dry run (no app launch): verify all env variables load correctly

### Phase 2 — Test Data
1. Export test case list and data from Qrace before shutdown
2. Create `TestData/TestCasesFile.xlsx`
3. Create `TestData/TestDataFile_UAT.xlsx` from Qrace export
4. Populate VP sheet from Qrace VP export
5. Rewrite remaining `QraceHelper.py` keywords: `Qrace Test Setup`, `Get TestData From Qrace`, `Get VPs From Qrace`, VP setters, `Single Session Loop`
6. Dry run: verify test data variables load correctly for one test case

### Phase 3 — Execution & Reporting
1. Rewrite teardown keywords: `Qrace Test TearDown`, result/VP writing to Excel
2. Run one test case end-to-end
3. Verify `ExecutionSummary.xlsx` generates correctly

### Phase 4 — Full Regression
1. Run all `ExecutorFlag=Yes` test cases
2. Fix any issues
3. Done

---

## 9. Prerequisites (before Phase 2)

1. **Qrace data export**: All test data and VP expected values must be exported from Qrace **before** shutdown. This is a hard prerequisite — cannot be recovered after Qrace goes offline.
2. **Environment.json values**: Someone must fill in all credential/URL values for UAT and STG.
3. **BrowserStack**: One session per test case (simpler than current batched approach). Execution time will increase slightly.

---

## 10. Excel File Sheet Structure

### TestCasesFile.xlsx — 1 sheet

| Sheet | Purpose |
|---|---|
| `TestCases` | All test case switches and routing parameters (ExecutorFlag, Flow_Flag, Insurance_Flow, etc.) |

### TestDataFile_UAT.xlsx / TestDataFile_STG.xlsx — 16 sheets

All sheets share `TestCaseId` as the join key. A single test case may have rows across multiple sheets; `QraceHelper` merges them all before setting Robot variables.

| # | Sheet Name | Module | Key Data |
|---|---|---|---|
| 1 | `Common` | Login / shared | Email, Password, Policy_No, LoginMethod |
| 2 | `Insurance_UpdatePolicy` | All update policy flows | NewName, NewAddress, Mobile/Email change, PaymentMethod, Beneficiary, SurrenderPolicy, etc. |
| 3 | `Insurance_Claims` | All claim types | ClaimType, HospitalName, DiagnosisName, Amount, Hospitalisation/Outpatient/Disability/CI fields |
| 4 | `Insurance_PayPremium` | Premium payment / loan repayment | PaymentMethod, Amount |
| 5 | `Insurance_ViewDocument` | View document | DocumentType |
| 6 | `Insurance_ViewCareCard` | View care card | CardType |
| 7 | `Insurance_ViewTransaction` | View transaction history | TransactionType |
| 8 | `Insurance_ViewInvestment` | View policy investment | FundName |
| 9 | `Insurance_PayorOnboarding` | Payor onboarding flow | PayorDetails fields |
| 10 | `Insurance_TrueOnboarding` | True onboarding / SignUp flow | SignUp fields |
| 11 | `Engagement` | Banner and Quicklink module | BannerName, QuickLinkName |
| 12 | `OWB` | OWB back-office verification | OWB_ExpectedStatus |
| 13 | `OPUS` | OPUS back-office verification | OPUS_Flow, OPUS_User_ID |
| 14 | `LA` | LA core system (AS400 mainframe) | LA_PolicyNo, LA_ExpectedField |
| 15 | `IL` | IL core system | IL_CaseNo, IL_ExpectedField |
| 16 | `VP` | Verification points (all cases) | FieldName, ExpectedValue, ExpectedSource |

**Note:** If some sheets have very few columns (e.g. ViewDocument + ViewCareCard), they can be merged into one sheet to reduce complexity. The total count is flexible — what matters is that every variable used in Pages/ has a corresponding column somewhere in the file.

### Data Source

All initial data must be exported from **Qrace before it is shut down**:
- Test case parameters → sheets 1–15
- VP expected values → sheet 16 (`VP`)
- Routing flags (Flow_Flag, Insurance_Flow, OWB_Flag, etc.) → `TestCasesFile.xlsx`

This export is a **hard prerequisite** — data cannot be recovered after Qrace goes offline.

---

## 11. Dependencies to Add

```
pandas>=2.0
openpyxl>=3.1
```

Add to `requirements.txt`. Everything else already present.
