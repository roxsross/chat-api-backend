FROM node:18-alpine
ARG VCS_REF
ARG BUILD_DATE
ARG GIT_USER
LABEL org.opencontainers.image.source=$VCS_REF \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.authors=$GIT_USER 
RUN apk --no-cache add tzdata
ENV TZ=America/Buenos_Aires
ENV PORT 5000
WORKDIR /app
COPY package*.json /app/
RUN npm install
COPY . /app/
EXPOSE 5000
USER node
CMD ["sh", "-c", "date ; npm start "]
HEALTHCHECK NONE
