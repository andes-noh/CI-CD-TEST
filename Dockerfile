FROM --platform=$TARGETPLATFORM node:16-alpine AS build

# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /build
COPY . .
RUN yarn --frozen-lockfile --ignore-scripts --network-timeout 600000
RUN yarn build

FROM --platform=$TARGETPLATFORM node:16-alpine AS deps

# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /build
COPY package.json .
COPY yarn.lock .
RUN yarn --production --frozen-lockfile --ignore-scripts --network-timeout 600000

# Production image, copy all the files and run next
FROM --platform=$TARGETPLATFORM node:16-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001

USER nodejs

COPY --from=build --chown=nodejs:nodejs /build/lib ./lib
COPY --from=deps --chown=nodejs:nodejs /build/node_modules ./node_modules
COPY --chown=nodejs:nodejs package.json ./package.json

EXPOSE 3000

ENTRYPOINT ["node", "."]
