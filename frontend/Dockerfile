FROM ubuntu:18.04

WORKDIR /app

# Prerequisites
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa wget
RUN apt install -y openjdk-11-jdk

# Set up new user
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

# Prepare Android directories and system variables
RUN mkdir -p Android/sdk/cmdline-tools
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk/cmdline-tools
RUN mkdir -p .android && touch .android/repositories.cfg

# Set up Android SDK
RUN wget -O tools.zip https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip
RUN unzip tools.zip && rm tools.zip
RUN mv cmdline-tools tools
RUN mv tools Android/sdk/cmdline-tools
RUN cd Android/sdk/cmdline-tools/tools/bin/ && yes | ./sdkmanager --licenses
RUN cd Android/sdk/cmdline-tools/tools/bin/ && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29" "cmdline-tools;latest"
ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"


# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/developer/flutter/bin"

# Run basic check to download Dark SDK
RUN flutter doctor

# Build APK
COPY . .
USER root
RUN yes | flutter doctor --android-licenses
RUN flutter build apk --release