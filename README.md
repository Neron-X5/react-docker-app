# React-Docker App


> A basic demo [React](https://reactjs.org/) app using [Docker](https://www.docker.com/) container to serve the production version of the app.


The Docker image follows 2-step build process to bundle the optimised production build.

It utilises [serve](https://www.npmjs.com/package/serve) to run a static server.

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## Commands:

- Development:

  1. Install dependencies

  ```sh
  yarn
  ```

  2. Starts the development server

  ```sh
  yarn start
  ```

  3. Starts the test runner

  ```sh
  yarn test
  ```

- Production:

  1. Build image from Docker file

  ```sh
  docker build -t react-docker-app .
  ```

  2. Create container from image

  ```sh
  docker run --rm -it -p 3000:3000 --name react-container react-docker-app
  ```

  3. **[Optional]** To run a command in a running container, run in new terminal

  ```sh
  docker exec -ti react-container /bin/sh
  ```
