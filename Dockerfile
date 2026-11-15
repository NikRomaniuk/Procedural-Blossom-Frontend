# Proc-Blossom - Front-End
#
# Commands cheat sheet:
#   Build:                  docker build -t proc-blossom-frontend .
#   Run:                    docker run -d --name proc-blossom-frontend -p 4200:80 proc-blossom-frontend
#   Build & Run:            docker build -t proc-blossom-frontend . ; docker run -d --name proc-blossom-frontend -p 4200:80 proc-blossom-frontend
#
#   Stop:                   docker stop greed-dungeon-frontend
#   Terminate:              docker rm -f greed-dungeon-frontend

# ////////////////////////
# --- BUILD THE BUNDLE ---
# ////////////////////////

FROM node:24-alpine AS build
WORKDIR /workspace

# First: Manifests + lock file
# This layer stays cached until dependencies change
COPY package.json package-lock.json ./
RUN npm ci

# Last: Sources
# They change most often
COPY angular.json tsconfig.json tsconfig.app.json ./
COPY public/ public/
COPY src/ src/
RUN npm run build

# /////////////////////
# --- RUNTIME IMAGE ---
# /////////////////////

# Serve the static bundle
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /workspace/dist/greed-dungeon-frontend/browser /usr/share/nginx/html
EXPOSE 80
