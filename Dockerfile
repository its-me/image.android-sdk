FROM localhost/android-sdk:tools

# https://developer.android.com/studio/releases/build-tools
ENV ANDROID_PLATFORM_VERSION 34
ENV ANDROID_BUILD_TOOLS_VERSION 33.0.1

RUN yes | sdkmanager \
    "platforms;android-$ANDROID_PLATFORM_VERSION" \
    "build-tools;$ANDROID_BUILD_TOOLS_VERSION"
