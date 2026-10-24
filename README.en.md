# Gemini in Chrome Launcher (macOS)

Creates a standalone launcher on macOS that starts Google Chrome with Chromium flags verified to restore the Gemini button. The project is based on hands-on testing: after launching Chrome through the launcher, the Gemini button appears in the top-right corner and conversation works. This is an unofficial, personal troubleshooting method — it is not provided or supported by Google.

> 中文版：[README.md](./README.md)

## Quick Install

1. Download the project ZIP from GitHub and extract it, or clone the repository.
2. Double-click `Install.command` in the project root.
3. If macOS warns that the file is from an unidentified developer, Control-click the file, choose "Open", and confirm.
4. The installer checks macOS, Chrome, the AppleScript compiler, and target-app conflicts, creates the launcher, and reports the Chrome version. If Chrome is not running, it opens the new launcher automatically; if Chrome is running, the installer does not force-quit it — save your work, fully quit Chrome (`⌘Q`), then open the launcher.

You can also run `./Install.command` in a terminal. To invoke the underlying script manually, run `bash scripts/install.sh`.

## Use Cases

For users with Google Chrome installed on macOS: you want to try enabling the Gemini entry after a fresh Chrome install, or the Gemini toolbar entry disappeared after a Chrome update; the entry is not visible with a normal Chrome launch but is restored when Chrome is launched with this project's flags. A fresh Chrome profile still requires you to sign in and complete the first-time enablement.

If the Gemini button already works for you, you do not need this launcher. It only addresses local feature toggles and country filtering at Chrome launch time; it does not fix network connectivity, account bans, server-side rejections, enterprise policy, or Gemini service outages.

## Prerequisites

- Google Chrome installed on a Mac; this project does not support Windows, Linux, Chromium, Brave, or other browsers.
- The macOS user account running the installer can create apps in its own `~/Applications`.
- Fully quit Chrome (`⌘Q`) before using the launcher; merely closing the window can leave Chrome running in the background so the flags never apply.
- The Gemini service must still accept your Google account and network environment. Google officially requires users to meet the region's minimum age, be in a supported region, use a supported language, be signed in to Chrome, and use the latest Chrome; Incognito mode is not supported. Work or school accounts may also need admin approval. The exact conditions and supported scope change over time — see the [official Google support scope](https://support.google.com/gemini/answer/17140089).

As of 2026-10-24, Google's officially published desktop supported-region list does not include mainland China. This project disables Chrome's client-side country filter; that cannot be taken as evidence that the server side allows access or that it will work in mainland China. Earlier testing only proved that a specific account and network environment could converse normally at that time.

## Install

The recommended way is to double-click `Install.command` in the project root. You can also run it from a terminal inside the project directory:

```bash
./Install.command
```

The installer creates the launcher at `~/Applications/Gemini in Chrome Launcher.app` and attempts to show the Chrome version. If Chrome is not running, it opens the new launcher automatically; if Chrome is running, the installer does not interrupt it — fully quit Chrome (`⌘Q`) first, then open the launcher. You can drag the launcher to the Dock and use it to start Chrome from then on.

If the target app already exists, the install script stops to avoid overwriting it. Move or rename the existing app first, then reinstall.

## Flags

The launcher executes:

```bash
open -a 'Google Chrome' --args \
  --enable-features=Glic,GlicRollout \
  --disable-features=GlicCountryFiltering
```

These flags were verified in practice on Chrome 152.0.7977.83 for macOS. They bypass Chrome's local Gemini country filter and enable the relevant feature toggles; Google may still adjust availability based on account, region, or service policy. The flags may change after Chrome updates. Other versions are unverified.

## Diagnostics

```bash
./scripts/diagnose.sh
```

The script checks whether Chrome and the launcher exist, shows the Chrome version and launch flags, and attempts to confirm whether the running Chrome process carries these flags. After launching Chrome you can also visit `chrome://glic/internals` to check eligibility status. When normal Gemini conversation works, sub-features such as page actions may still be gated by other eligibility conditions.

If the button still does not appear, first confirm Chrome is fully quit, then launch from the launcher; then check the eligibility status at `chrome://glic/internals`. If the eligibility check shows region, account, consent, or policy failures, the launch flags cannot guarantee lifting server-side or account-level restrictions. The diagnostics page shows account eligibility and other information — redact personal data before publishing any report.

## Uninstall

```bash
./scripts/uninstall.sh
```

The uninstall script removes only the launcher created by this project. It does not delete Chrome, browser profiles, or other apps.

## Safety & Scope

- macOS and desktop Google Chrome only.
- The install script builds an AppleScript app locally; it downloads and executes no remote code.
- It does not modify Chrome's `Local State`, and does not read or upload browser data.
- Gemini conversations still connect to Google services; when page context is enabled, Gemini uses relevant page content per the product's interaction model. Follow Google's Terms of Service and your organization's data requirements.
- This project is not maintained by Google, does not guarantee continued support for these toggles by Chrome or the Gemini service, and does not guarantee that your account, region, network, or enterprise policy allows use.
- This is a temporary compatibility workaround that depends on Chrome's internal experimental toggles; it is not an official configuration. It may stop working after Chrome updates and needs re-diagnosis and re-verification.

## Files

- `scripts/install.sh`: creates the launcher.
- `scripts/uninstall.sh`: removes the launcher.
- `scripts/diagnose.sh`: checks installation status and flags.
- `Install.command`: double-click installation entry point.
- `LICENSE`: MIT License.
