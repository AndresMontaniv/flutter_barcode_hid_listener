## 1.1.0

**Core Engine Upgrade: Lifecycle & Safety**
* Added `listenForAppLifecycleChanges` property (defaulting to `true`) to `BarcodeKeyboardListener` to automatically pause background hardware scanning when the app enters the background (e.g. `AppLifecycleState.paused`), and resume it when returning to the foreground.
* Changed `enableDebugLogs` default in `BarcodeScannerConfig` from `true` to `false` for better production readiness out of the box.
* Fixed a potential crash in `_onGlobalFocusChanged` where `context` was accessed after the widget was disposed.
* Fixed a stale static reference issue in `BarcodeKeyboardService` where calling `dispose()` on a paused service left the singleton pointer intact.
* Hardened internal stream tearing down to eliminate stale subscription references on widget updates.
* Added documentation regarding `BarcodeFormat.upcE` detection behavior and limitations with raw HID payloads.

## 1.0.1

**Core Engine Upgrade: Exclusive Handler Guard**
* Added static ownership tracking (`_activeInstance`) to `BarcodeKeyboardService`.
* Guarantees that only **one** hardware keyboard handler is active globally at any time, preventing duplicate scan broadcasts across persistent navigation views.

**Declarative UI Upgrade: `autoPauseOnFocus`**
* Added `autoPauseOnFocus` property (defaulting to `true`) to `BarcodeKeyboardListener`.
* Automatically pauses background hardware scanning whenever an input text field (`EditableText`) gains focus.
* Integrated automatic route visibility checks (`ModalRoute.isCurrent`), ensuring hidden routes never steal scanner ownership.

## 1.0.0

Initial stable release of `barcode_hid_listener`!

**Core Engine**
* **Two-Stage Symbology Gatekeeper:** Built-in validation for global retail and logistics formats (`EAN-13`, `UPC-A`, `EAN-8`, `UPC-E`, `EAN-14`, `Code 39`).
* **Temporal Deduplication:** Built-in shielding to ignore accidental double-scans within configurable time windows.
* **GS1 AI Normalizer:** Automatically intercepts and strips the `01` Application Identifier prefix from 16-digit hardware EAN-14 shipping codes to guarantee 14-digit downstream consistency.

**Architecture & Usage**
* **Declarative Widget Wrapper (`BarcodeKeyboardListener`):** Drop-in UI widget with automatic lifecycle management, dynamic pausing (`enabled`), and `FocusNode` gatekeeping.
* **Imperative Service (`BarcodeKeyboardService`):** Headless Dart streams for advanced state management (Riverpod/Bloc).
* **Proactive Global Focus Shield:** Hardware streams safely pause when active text fields gain focus, preventing OS-level HID wedge duplication.
* **Zero Dependencies:** Pure Dart. Runs flawlessly on iOS, Android, Windows, macOS, Linux, and Web.
