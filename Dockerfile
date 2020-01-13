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
# Copy over the modules from above onto a `slim` image from https://hub.docker.com/r/mhart/alpine-node
FROM mhart/alpine-node:slim-12.14.1

# Install global npm or yarn
RUN apk --update --no-cache add yarn --repository="http://dl-cdn.alpinelinux.org/alpine/edge/community"

# Install serve static server to run the app
RUN yarn global add serve

# Use the project root as exectution context
WORKDIR /app

# Copy the build folder from previous stage
COPY --from=builder /app/build .

# Expose ports (for orchestrators and dynamic reverse proxies)
EXPOSE 3000

# Start the app
  # CMD ["npm", "start"]
CMD ["serve", "-s", "-n", "-p", "3000", "."]
