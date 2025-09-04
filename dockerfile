# =================================================================
# Stage 1: Build the Docusaurus Application
# NOTE: This is a simplified Dockerfile for a fresh, unmodified project.
# =================================================================
FROM node:18-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy ALL project source code and configuration files.
# This assumes no files have been deleted or modified.
COPY . .

# Increase Node.js memory limit to prevent "heap out of memory" errors.
ENV NODE_OPTIONS="--max-old-space-size=4096"

# Run the installation.
RUN yarn install --frozen-lockfile

# In a pristine project, the build command should work directly.
# However, this will likely fail if the changelog plugin files are missing.
# Finally, run the build command for ONLY the English locale.
# This prevents resource exhaustion and is sufficient for the assignment.
RUN yarn workspace website build --locale en

# =================================================================
# Stage 2: Serve the Static Files with Nginx
# =================================================================
FROM nginx:stable-alpine

# Copy the built static files from the 'builder' stage
COPY --from=builder /app/website/build /usr/share/nginx/html

# Expose port 80 (the default HTTP port that Nginx listens on)
EXPOSE 80

# The default command for the nginx image will start the server.
CMD ["nginx", "-g", "daemon off;"]


