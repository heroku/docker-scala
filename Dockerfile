# Inherit from Heroku's stack
FROM heroku/cedar:14

RUN mkdir -p /app/user
WORKDIR /app/user

ENV HOME /app
ENV PATH /app/bin:/app/.jdk/bin:$PATH
ENV JAVA_HOME /app/.jdk:$PATH
ENV PORT 3000

RUN mkdir -p /app/.jdk
RUN curl -s --retry 3 -L https://lang-jvm.s3.amazonaws.com/jdk/cedar-14/openjdk1.8-latest.tar.gz | tar xz -C /app/.jdk

RUN mkdir -p /app/bin
RUN curl -s -L https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt -o /app/bin/sbt
RUN chmod +x /app/bin/sbt

ONBUILD COPY *.sbt /app/user/
ONBUILD COPY project /app/user/project
ONBUILD RUN sbt clean update

ONBUILD COPY . /app/user/
ONBUILD RUN sbt stage
