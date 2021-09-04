# Dockerfile contains specifications for creating an image

ARG NODE_VERSION=14.15.2

# This tells Docker to install an OS (Alpine) with Node
FROM node:${NODE_VERSION}-alpine

EXPOSE 3000 9229
# EXPOSE is not publishing any ports, it is just a form of a documentation

#  Creates a folder in the docker container called 'src'
WORKDIR /src

RUN apk add	postgresql-client redis

ARG environment

# required for docker:test:watch
RUN if [ "${environment}" = "development" ]; then apk add git; fi

# Copy the dependencies file into our container folder
ADD package.json yarn.lock ./

# This downloads and installs all the dependencies we need for our app
RUN yarn install --frozen-lockfile --link-duplicates

# Copy everything from our current directory to the WORKDIR. This moves all of our source code
ADD . .

RUN yarn build

CMD ["yarn", "start"]
