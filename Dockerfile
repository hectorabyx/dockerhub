FROM ubuntu AS build
WORKDIR /src

# Clone the latest source 
RUN git -c http.sslVerify=false clone --branch developer https://github.com/hectorabyx/dockerhub.git
WORKDIR /src/app

RUN npm install
RUN npm run build-test

# stage: 2 — the production environment
FROM nginx:alpine
COPY --from=build /src/app/default.conf /etc/nginx/conf.d
COPY --from=build /src/app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]