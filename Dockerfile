#FROM circleci/android:api-29
#FROM openjdk:8-alpine
FROM openjdk:8

ENV flutter_version 1.12.13+hotfix.8-stable
ENV PATH $PATH:/home/android/flutter/bin

ENV android_version 6200805_latest
ENV ANDROID_HOME /home/android/Android/Sdk
ENV PATH $PATH:${ANDROID_HOME}/tools/bin

# Debian

# RUN apt-get install netselect netselect-apt
# RUN netselect -vv ftp.br.debian.org sft.if.usp.br download.unesp.br linorg.usp.br ftp.debian.org ftp.de.debian.org ftp.us.debian.org mirror.rit.edu mirrors.geeks.org mirrors.kernel.org
# ADD sources.list /etc/apt/
# RUN ls /etc/apt
RUN apt-get update
RUN apt-get install -y aria2

# Alpine
#RUN apk add --no-cache aria2

RUN useradd -m android
USER android
WORKDIR /home/android/

RUN aria2c https://dl.google.com/android/repository/commandlinetools-linux-${android_version}.zip
RUN mkdir -p ${ANDROID_HOME}
RUN unzip -d ${ANDROID_HOME} commandlinetools-linux-${android_version}.zip
RUN rm commandlinetools-linux-${android_version}.zip
RUN sdkmanager --sdk_root=${ANDROID_HOME} --update
RUN yes "y" | sdkmanager --sdk_root=${ANDROID_HOME} "platform-tools"
RUN yes "y" | sdkmanager --sdk_root=${ANDROID_HOME} "platforms;android-29"
RUN yes "y" | sdkmanager --sdk_root=${ANDROID_HOME} "build-tools;29.0.3"
RUN yes "y" | sdkmanager --sdk_root=${ANDROID_HOME} "emulator"
RUN yes "y" | sdkmanager --sdk_root=${ANDROID_HOME} "tools"
RUN yes "y" | sdkmanager --sdk_root=${ANDROID_HOME} "system-images;android-29;google_apis;x86_64"
RUN echo no | avdmanager create avd -f -n teste --device "pixel_xl" -c 1G -k "system-images;android-29;google_apis;x86_64"

RUN aria2c https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v${flutter_version}.tar.xz
RUN tar xf flutter_linux_v1.12.13+hotfix.8-stable.tar.xz
RUN rm flutter_linux_v1.12.13+hotfix.8-stable.tar.xz
RUN flutter precache
RUN yes "y" | flutter doctor --android-licenses
RUN flutter doctor


#WORKDIR /opt
#RUN ls /tmp
#RUN tar xf /tmp/flutter_linux_v1.12.13+hotfix.8-stable.tar.xz
#ADD flutter_linux_v1.12.13+hotfix.8-stable.tar.xz /opt/


#RUN apt-get update
#RUN apt-get install -y aria2