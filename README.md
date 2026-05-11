# Android SDK container images

Docker images for Android SDK tooling, published to GHCR, Docker Hub, and Quay.io. Three-layered images are built and tagged independently; each layer adds one SDK component on top of the previous one.

## Images and tags

### `tools` — Android command-line tools

**Dockerfile:** `Dockerfile.tools`  
**Base:** `debian:stable-slim`

Installs OpenJDK 21, the Android SDK command-line tools (`sdkmanager`, `adb`, etc.), and supporting system packages (Ruby, `build-essential`, `curl`, `git`, etc.). Provides the `android-wait-for-emulator` helper script. All subsequent images build on top of this one.

| Tag | Meaning |
|-----|---------|
| `tools-<version>` | Exact command-line tools build (e.g. `tools-14742923`) |
| `tools` | Latest released command-line tools |

---

### `build-tools` — Android build tools

**Dockerfile:** `Dockerfile.build-tools`  
**Base:** `tools`

Adds the Android build tools package (`aapt`, `d8`, `zipalign`, etc.) via `sdkmanager`.

| Tag | Meaning |
|-----|---------|
| `build-tools-<version>` | Exact build-tools version (e.g. `build-tools-37.0.0`) |
| `build-tools-<major>` | Latest stable for a major version (e.g. `build-tools-37`) |
| `build-tools-<major>-rc<n>` | Latest RC for a major version (e.g. `build-tools-37-rc1`) |
| `build-tools` | Latest released build tools |

---

### `<platform>` — Android platform SDK

**Dockerfile:** `Dockerfile`  
**Base:** `build-tools`

Adds the Android platform SDK for a specific API level via `sdkmanager`.

| Tag | Meaning |
|-----|---------|
| `<version>` | Exact platform version (e.g. `37.0`, `35-ext14`) |
| `latest` | Latest stable platform (not applied to extension releases) |

Platform versions follow the upstream scheme: plain integers or decimals (`35`, `36.1`, `37.0`) for standard releases and `<level>-ext<n>` for extension releases (e.g. `35-ext14`).

---

## Registries

Images are mirrored to three registries under the same tag names:

- `ghcr.io/its-me/android-sdk:<tag>`
- `1tsme/android-sdk:<tag>`
- `quay.io/<quay-user>/android-sdk:<tag>`

## Automated releases

Each image family has a daily check workflow that queries the [Android SDK repository XML](https://dl.google.com/android/repository/repository2-3.xml) for new versions. When a version is found that has no corresponding git tag, the matching release workflow is triggered automatically.

| Workflow | Schedule (UTC) | Watches |
|----------|---------------|---------|
| `tools: check release` | 00:00 daily | `commandlinetools-linux-*` |
| `build-tools: check release` | 01:00 daily | `build-tools;<version>` |
| `platform: check release` | 02:00 daily | `platforms;android-*` |

Release workflows can also be triggered manually via `workflow_dispatch` with an explicit version input.

## License

MIT
