FROM nginx:alpine

RUNN echo "Teste de validação do agent" > /usr/share/nginx/html/index.html

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80
