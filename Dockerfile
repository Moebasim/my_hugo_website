# Build Hugo from source
FROM golang:1.20 AS builder
WORKDIR /app
RUN git clone --depth=1 https://github.com/gohugoio/hugo.git && \
    cd hugo && go build -o hugo main.go

# Clone and build the Hugo site
FROM builder AS site-builder
WORKDIR /site
RUN git clone --depth=1 https://github.com/your-username/your-hugo-repo.git website
WORKDIR /site/website
RUN /app/hugo -D

# Serve the site with nginx
FROM nginxinc/nginx-unprivileged:latest
COPY --from=site-builder /site/website/public /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]

