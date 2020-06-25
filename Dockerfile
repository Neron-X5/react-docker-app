 # clear && docker build -t react-app .

# clear && docker run --rm -it -p 3000:3000 --name mechan react-app

# clear && docker exec -ti mechan /bin/sh

# Stage 1
# Base image from https://hub.docker.com/_/node/?tab=description
FROM node:12.14.1-alpine3.11 AS builder

# Create project root
RUN mkdir -p /app

# Use the project root as exectution context
WORKDIR /app

# To caching node_modules, copy only package.json, package-lock.json & yarn.lock
COPY package*.json yarn.lock ./

# Install all dependencies from npm
  # RUN npm ci
RUN yarn

# Copy all files from build context and place them in exectution context
COPY . .

# Bundle the app into static files for production
RUN yarn build

# Stage 2
# Copy over the modules from above onto a `slim` image from https://hub.docker.com/_/nginx?tab=description
FROM nginx:mainline-alpine

# Use the project root as exectution context
WORKDIR /app

# Copy the build folder from previous stage
COPY --from=builder /app/build .

# Overwrite this default.conf file with our nginx.conf
# to know details follow here: https://stackoverflow.com/questions/43555282/react-js-application-showing-404-not-found-in-nginx-server
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose ports (for orchestrators and dynamic reverse proxies)
EXPOSE 3000

# Start the app
CMD ["nginx", "-g", "daemon off;"]
