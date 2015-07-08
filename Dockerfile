# Inherit from Heroku's stack
FROM heroku/cedar:14

ENV HOME /app
ENV PATH /app/bin:/app/heroku/.jdk/bin:$PATH
ENV JAVA_HOME /app/heroku/.jdk:$PATH
ENV PORT 3000

# `init` is kept out of /app so it won't be duplicated on Heroku
# Heroku already has a mechanism for running .profile.d scripts,
# so this is just for local parity
COPY ./init /usr/bin/init

RUN mkdir -p /app/heroku/.jdk
RUN mkdir -p /app/.profile.d
RUN curl -s -L https://lang-jvm.s3.amazonaws.com/jdk/cedar-14/openjdk1.8-latest.tar.gz | tar xz -C /app/heroku/.jdk

RUN mkdir -p /app/bin
RUN curl -s -L https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt -o /app/bin/sbt
RUN chmod +x /app/bin/sbt

ONBUILD COPY target /app/src/target

ENTRYPOINT ["/usr/bin/init"]
