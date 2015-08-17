#!/bin/bash

export DATABASE_URL=$(echo "${DATABASE_URL}" | sed -e 's/postgres:@/postgres:no@/')

exec "$@"
