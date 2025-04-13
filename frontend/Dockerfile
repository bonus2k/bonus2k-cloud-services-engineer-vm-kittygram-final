FROM node:18
ARG FRONTEND_WORKDIR
WORKDIR /${FRONTEND_WORKDIR}

COPY package.json package.json
COPY package-lock.json package-lock.json

RUN npm ci

COPY . .
RUN npm run build
RUN npm install --global http-server

CMD ["npx", "-y", "http-server", "-p", "8000", "/app/build"]
