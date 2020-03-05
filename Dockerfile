FROM openjdk:8

ENV flutter_version 1.12.13+hotfix.8-stable
ENV PATH $PATH:/home/android/flutter/bin

ENV android_version 6200805_latest
ENV ANDROID_HOME /home/android/Android/Sdk
ENV PATH $PATH:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools/

RUN apt-get update \
&& apt-get install -y aria2 \
&& useradd -m android

USER android
WORKDIR /home/android/

RUN aria2c https://dl.google.com/android/repository/commandlinetools-linux-${android_version}.zip \
&& mkdir -p ${ANDROID_HOME} \
&& unzip -d ${ANDROID_HOME} commandlinetools-linux-${android_version}.zip \
&& rm commandlinetools-linux-${android_version}.zip \
&& sdkmanager --sdk_root=${ANDROID_HOME} --update \
&& yes "y" | sdkmanager --sdk_root=${ANDROID_HOME} "platform-tools" \
&& yes "y" | sdkmanager --sdk_root=${ANDROID_HOME} "platforms;android-29" \
&& yes "y" | sdkmanager --sdk_root=${ANDROID_HOME} "build-tools;29.0.3" \
&& yes "y" | sdkmanager --sdk_root=${ANDROID_HOME} "emulator" \
&& yes "y" | sdkmanager --sdk_root=${ANDROID_HOME} "tools" \
&& yes "y" | sdkmanager --sdk_root=${ANDROID_HOME} "system-images;android-29;google_apis;x86_64" \
&& echo no | avdmanager create avd -f -n teste --device "pixel_xl" -c 1G -k "system-images;android-29;google_apis;x86_64" \
&& aria2c https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v${flutter_version}.tar.xz \
&& tar xf flutter_linux_v1.12.13+hotfix.8-stable.tar.xz \
&& rm flutter_linux_v1.12.13+hotfix.8-stable.tar.xz \
&& flutter precache \
&& yes "y" | flutter doctor --android-licenses \
&& flutter doctor
