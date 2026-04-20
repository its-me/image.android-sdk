FROM debian:stable

ENV ANDROID_HOME=/opt/android-sdk \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US:en

ENV ANDROID_SDK_ROOT=$ANDROID_HOME \
    PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator

# comes from https://developer.android.com/studio/#command-line-tools-only
ENV ANDROID_SDK_TOOLS_VERSION 13114758

RUN set -o xtrace \
    && cd /opt \
    && apt-get update \
    && apt-get install -y locales \
    && sh -c 'echo "en_US.UTF-8 UTF-8" > /etc/locale.gen' \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 \
    && apt-get install -y jq \
    && apt-get install -y openjdk-21-jdk \
    #&& apt-get install -y sudo wget zip unzip git openssh-client curl bc software-properties-common build-essential ruby-full ruby-bundler libstdc++6 libpulse0 libglu1-mesa lcov libsqlite3-dev --no-install-recommends \
    && apt-get install -y sudo wget zip unzip git openssh-client curl bc build-essential ruby-full ruby-bundler libstdc++6 libpulse0 libglu1-mesa lcov libsqlite3-dev --no-install-recommends \
    # for x86 emulators
    && apt-get install -y libxtst6 libnss3-dev libnspr4 libxss1 libasound2t64 libatk-bridge2.0-0 libgtk-3-0 libgdk-pixbuf-2.0-0 \
    && apt-get install -y -qq xxd \
    && apt-get install -y lftp \
    && apt-get install -qq -y sqlite3 libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/* \
    && wget --no-show-progress -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip -O android-sdk-tools.zip \
    && mkdir -p ${ANDROID_HOME}/cmdline-tools/ \
    && unzip -q android-sdk-tools.zip -d ${ANDROID_HOME}/cmdline-tools/ \
    && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    && chown -R root:root $ANDROID_HOME \
    && rm android-sdk-tools.zip \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && yes | sdkmanager --licenses \
    && wget --no-show-progress -O /usr/local/bin/android-wait-for-emulator https://raw.githubusercontent.com/travis-ci/travis-cookbooks/master/community-cookbooks/android-sdk/files/default/android-wait-for-emulator \
    && chmod +x /usr/local/bin/android-wait-for-emulator \
    && touch /root/.android/repositories.cfg \
    && sdkmanager platform-tools \
    && mkdir -p /root/.android \
    && touch /root/.android/repositories.cfg
