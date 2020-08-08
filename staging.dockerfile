FROM node:14.7.0-alpine3.10

RUN mkdir /tyazhko

COPY . /tyazhko/

WORKDIR /tyazhko/

RUN npm install yarn
RUN yarn install
RUN yarn build
