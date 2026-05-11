ARG BASE_IMAGE=ghcr.io/its-me/android-sdk:build-tools
FROM ${BASE_IMAGE}

# https://developer.android.com/studio/releases/platforms
ARG ANDROID_PLATFORM_VERSION=37

ENV ANDROID_PLATFORM_VERSION=${ANDROID_PLATFORM_VERSION}

RUN yes | sdkmanager "platforms;android-${ANDROID_PLATFORM_VERSION}"
