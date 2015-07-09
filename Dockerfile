# Inherit from Heroku's stack
FROM heroku/cedar:14

RUN mkdir -p /app/user
WORKDIR /app/user

ENV STACK "cedar-14"
ENV HOME /app

RUN mkdir -p /app/.jdk
RUN curl -s --retry 3 -L https://lang-jvm.s3.amazonaws.com/jdk/cedar-14/openjdk1.8-latest.tar.gz | tar xz -C /app/.jdk
ENV JAVA_HOME /app/.jdk:$PATH
ENV PATH /app/.jdk/bin:$PATH

RUN mkdir -p /app/bin
RUN curl -s -L https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt -o /app/bin/sbt
RUN chmod +x /app/bin/sbt
ENV PATH /app/bin:$PATH

ONBUILD COPY project/build.properties /app/user/project/
ONBUILD RUN sbt about

ONBUILD COPY ["*.sbt", "*.scala", "/app/user/"]
ONBUILD COPY ["project/*.sbt", "project/*.scala", "/app/user/project/"]
ONBUILD RUN sbt clean update

ONBUILD COPY . /app/user/
ONBUILD RUN sbt stage
