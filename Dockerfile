FROM node:16.15.1 as builder

WORKDIR /app
COPY package.json .
RUN npm install
COPY . .

RUN chmod +x ./init_env.sh
RUN ./init_env.sh

RUN npm run build


FROM nginx:stable-alpine

# RUN rm -rf /etc/nginx/conf.d/default.conf
# COPY --from=builder /app/nginx/default.conf /etc/nginx/conf.d/default.conf

RUN rm -rf /usr/share/nginx/html
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]