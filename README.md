# Android SDK container images

Docker base images for Flutter and Android CI pipelines, providing the Android SDK layer that Flutter builds require. Three-layered images are built and tagged independently; each layer adds one SDK component on top of the previous one. Images are published to GHCR, Docker Hub, and Quay.io.

## Images and tags

### `tools`: Android command-line tools

**Dockerfile:** `Dockerfile.tools`  
**Base:** `debian:stable-slim`

Installs OpenJDK 21, the Android SDK command-line tools (`sdkmanager`, `adb`, etc.), and supporting system packages (Ruby, `build-essential`, `curl`, `git`, etc.). Provides the `android-wait-for-emulator` helper script. All subsequent images build on top of this one.

| Tag | Example | Meaning |
|-----|---------|---------|
| `tools-<version>` | `tools-14742923` | Exact command-line tools build |
| `tools` | `tools` | Latest released command-line tools |

---

### `build-tools`: Android build tools

**Dockerfile:** `Dockerfile.build-tools`  
**Base:** `tools`

Adds the Android build tools package (`aapt`, `d8`, `zipalign`, etc.) via `sdkmanager`.

| Tag | Example | Meaning |
|-----|---------|---------|
| `build-tools-<version>` | `build-tools-37.0.0` | Exact build-tools version |
| `build-tools-<major>` | `build-tools-37` | Latest stable for a major version |
| `build-tools-<major>-rc<n>` | `build-tools-37-rc1` | Latest RC for a major version |
| `build-tools` | `build-tools` | Latest released build tools |

---

### `<version>`: Android platform SDK

**Dockerfile:** `Dockerfile`  
**Base:** `build-tools`

Adds the Android platform SDK for a specific API level via `sdkmanager`.

| Tag | Example | Meaning |
|-----|---------|---------|
| `<version>` | `37.0` | Exact platform version |
| `<version>-ext<n>` | `35-ext14` | Extension release for a platform version |
| `latest` | `latest` | Latest stable platform (not applied to extension releases) |

Platform versions follow the upstream scheme: plain integers or decimals (`35`, `36.1`, `37.0`) for standard releases, and `<version>-ext<n>` for extension releases.

---

## Usage

These images provide the Android SDK layer that Flutter (or plain Android) builds need. Use them as a base image and add Flutter on top:

```dockerfile
FROM ghcr.io/its-me/android-sdk:latest
RUN wget -qO /tmp/flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_<version>-stable.tar.xz \
    && tar xf /tmp/flutter.tar.xz -C /opt \
    && rm /tmp/flutter.tar.xz
ENV PATH="/opt/flutter/bin:$PATH"
```

Or reference the image directly in CI when Flutter is already installed in the runner:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container: ghcr.io/its-me/android-sdk:latest
```

Pin to a specific platform version for reproducible builds:

```yaml
container: ghcr.io/its-me/android-sdk:37.0
```

If you only need build tools without the platform SDK, use the `build-tools` image; for just `sdkmanager` and platform tools, use `tools`.

---

## Registries

Images are mirrored to three registries under the same tag names:

- [ghcr.io/its-me/android-sdk](https://ghcr.io/its-me/android-sdk)
- [itsme/android-sdk](https://hub.docker.com/r/itsme/android-sdk)
- [quay.io/itsme/android-sdk](https://quay.io/repository/itsme/android-sdk)

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
