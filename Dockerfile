# Inherit from Heroku's stack
FROM jkutner/jvm

# Install sbt-extras
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
