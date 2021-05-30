FROM node:14-buster

RUN apt-get update && apt-get install -y yarn build-essential vim less git 

RUN npm install --global npm@latest

WORKDIR /zKurrate/app/frontend

EXPOSE 3000/tcp

CMD ["make", "frontend-start"]