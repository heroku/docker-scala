# Inherit from Heroku's stack
FROM heroku/cedar:14

RUN mkdir -p /app/user
WORKDIR /app/user

ENV STACK "cedar-14"
ENV HOME /app

# `init` is kept out of /app so it won't be duplicated on Heroku
# Heroku already has a mechanism for running .profile.d scripts,
# so this is just for local parity
COPY ./init /usr/bin/init

RUN mkdir -p /app/.jdk
RUN curl -s --retry 3 -L https://lang-jvm.s3.amazonaws.com/jdk/openjdk1.8.0_40-cedar14.tar.gz | tar xz -C /app/.jdk
ENV JAVA_HOME /app/.jdk:$PATH
ENV PATH /app/.jdk/bin:$PATH

RUN mkdir -p /app/bin
RUN curl -s -L https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt -o /app/bin/sbt
RUN chmod +x /app/bin/sbt
ENV PATH /app/bin:$PATH

# Run sbt-extras to make sure the sbt version is downloaded and cached
ONBUILD COPY project/build.properties /app/user/project/
ONBUILD RUN sbt about

# Run sbt update to make sure the dependencies are downloaded and cached
ONBUILD COPY ["*.sbt", "*.scala", "/app/user/"]
ONBUILD COPY ["project/*.sbt", "project/*.scala", "/app/user/project/"]
ONBUILD RUN sbt clean update

ONBUILD COPY . /app/user/
ONBUILD RUN sbt stage

ENTRYPOINT ["/usr/bin/init"]
