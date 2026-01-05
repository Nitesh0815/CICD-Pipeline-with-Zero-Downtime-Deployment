# Use the official Nginx Alpine image
FROM nginx:alpine

# Metadata
LABEL maintainer="nk9910922101@gmail.com" \
      version="1.0.0" \
      description="Static web app served via Nginx"

# Remove default nginx page to avoid "Welcome to nginx"
RUN rm -rf /usr/share/nginx/html/*

# Copy your custom index.html
COPY index.html /usr/share/nginx/html/index.html

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Expose port 80
EXPOSE 80
