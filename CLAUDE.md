# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Robot Framework** mobile automation test suite for the FWD Thailand OMNE insurance app. Tests run on **BrowserStack** via **AppiumLibrary** and are orchestrated by a custom test management system called **Qrace** (hosted at `http://10.160.132.200:8082`).

## Running Tests

Tests are triggered via Qrace pipelines, not run directly from this repo. The CI pipeline in `.gitlab-ci.yml` calls the Qrace API to execute the `TH_Regression` pipeline:

```bash
curl -d "projectName=FWD_Thailand_OMNE_Insurance_New" -d "pipelineName=TH_Regression" \
  -H "Authorization: Basic <token>" -X POST http://10.160.132.200:8082/api/executePipelineFWD
```

To run a single executor directly (requires Appium/BrowserStack config):
```bash
robot --variable testRunId:<id> Executor/Insurance/OmneInsuranceExecutor.robot
robot --variable testRunId:<id> Executor/LA/LAExecutor.robot
robot --variable testRunId:<id> Executor/OWB/OWBExecutor.robot
robot --variable testRunId:<id> Executor/OPUS/OPUSExecutor.robot
robot --variable testRunId:<id> Executor/IL/IL_Executor.robot
```

## Architecture

### Layer Structure

```
Executor/        → Test entry points (one per system: Insurance, LA, OWB, OPUS, IL)
Pages/           → Page interaction keywords (what to do on each screen)
PageObjects/     → Element locators (XPath/accessibility IDs for UI elements)
CustomLibraries/ → Shared Robot keywords and Python utilities
Qrace/           → Qrace test management API integration (QraceHelper.py)
```

### Execution Flow

1. Qrace triggers the pipeline and provides `testRunId`
2. Executor fetches environment config and test job metadata from Qrace (`Get Details from Qrace Environment`)
3. App is launched on BrowserStack (`Launch OMNE Application` in `CustomLibraries/common.robot`)
4. For each test job, the executor routes to the appropriate flow (Insurance, LA, OWB, OPUS, IL, Engagement)
5. Results and VP (verification point) statuses are reported back to Qrace

### Qrace Integration

`Qrace/QraceHelper.py` is the core Python library that communicates with Qrace:
- `Get TestRun Metadata` / `Get Details from Qrace Environment` — fetches env variables (BrowserStack credentials, DB connection, app version, etc.)
- `Set TestJob Status` — reports PASS/FAIL per test job
- `Set Calc VP With Source And Original Values` — reports verification point results
- `Set Actual Result` — sends the final result string to Qrace

### Pages vs PageObjects

- **PageObjects/** (`*Objects.resource`) — element locator definitions only
- **Pages/** (`*.resource`) — keywords that use those locators to perform actions

Both must be updated when UI changes occur. PageObjects define the locator variables; Pages use them.

### BrowserStack Configuration

Device capabilities are pulled at runtime from Qrace environment attributes:
- `BS_link_iOS` / `BS_link_Android` — app build URLs on BrowserStack
- `BS_user` / `BS_accessKey` — BrowserStack credentials
- `bundleID` — app bundle/package ID

The `common.robot` `Launch OMNE Application` keyword handles both BrowserStack (`udid == 'NA'`) and local device execution.

### Error Handling Pattern

All keywords use Robot Framework `TRY/EXCEPT` blocks that call `Set Failed Actual Result and VP` on failure, which:
1. Sets VP status to `Flow_Failed`
2. Appends the failure reason to `${actualResult}`
3. Calls `Fail` to propagate the failure

### Flow Flags

The executor routes test cases via variables set by Qrace:
- `${Flow_Flag}` — top-level module selector (`Insurance`, `Engagement`, etc.)
- `${Insurance_Flow}` — specific flow within Insurance module
- `${OWB_Flag}`, `${OPUS_Flag}`, `${CoreSystem_Flag}` — controls whether backend system verification runs after app flow
- `${Core_System}` — selects `LA` or `IL` as the core system to verify against

## Key Libraries

- `AppiumLibrary` — mobile app interaction
- `Mainframe3270` — AS400/mainframe interaction for LA core system
- `FakerLibrary` — test data generation
- `Qrace/QraceHelper.py` — Qrace API client
- `CustomLibraries/Operation.py` — utility keywords (base64, date calculations)
- `CustomLibraries/DateTimeCompare.py` — date/time comparison utilities
