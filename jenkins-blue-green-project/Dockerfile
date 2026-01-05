# Use the official Nginx Alpine image for a lightweight, secure base
FROM nginx:alpine

# Add metadata labels for traceability and compliance (industry best practice)
LABEL maintainer="nk9910922101@gmail.com" \
      version="1.0.0" \
      description="Static web app served via Nginx"

# Copy the HTML file into the Nginx web directory
# Use a .dockerignore file in your project root to exclude unnecessary files (e.g., .git, README.md, node_modules)
# This reduces image size and build time
COPY index.html /usr/share/nginx/html/index.html

# Add a health check to ensure the container is running properly
# This checks if Nginx is responding on port 80; adjust as needed for your app
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Expose port 80 for the web server
EXPOSE 80