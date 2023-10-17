# Используйте официальный образ nginx в качестве базового образа
FROM nginx:latest

# Копируем локальный файл index.html в контейнер
COPY index.html /usr/share/nginx/html

# Опционально можно скопировать свой собственный конфиг nginx, если он отличается от дефолтного
# COPY nginx.conf /etc/nginx/nginx.conf

# EXPOSE необходим для того, чтобы Docker знал, на каком порту запущено приложение
EXPOSE 80

# CMD определяет команду, которая будет выполнена при запуске контейнера
CMD ["nginx", "-g", "daemon off;"]
