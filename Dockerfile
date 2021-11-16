FROM node:14.5.0-alpine3.12

WORKDIR /app
COPY ./ .
RUN adduser --disabled-password david &&\
    npm install
USER david
CMD ["node","index.js"]
EXPOSE 3000 