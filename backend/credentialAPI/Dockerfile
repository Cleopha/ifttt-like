###               ###
# Build application #
###               ###
FROM node:17 as builder

WORKDIR /app

# Copy dependency manager
COPY credentialAPI/package.json .
COPY credentialAPI/yarn.lock .

# Install dependencies
RUN yarn install --prod

# Copy sources
COPY credentialAPI/src src
COPY credentialAPI/nest-cli.json .
COPY credentialAPI/tsconfig.json .
COPY credentialAPI/tsconfig.build.json .
COPY credentialAPI/prisma prisma
COPY protos-ts /protos-ts

# Buil application
RUN yarn build

###                ###
# Create application #
###                ###
FROM node:17 as application

# Retrieves sources
WORKDIR /app


COPY util/ util

# Get application build
COPY --from=builder /app/dist dist
COPY --from=builder /app/node_modules node_modules
COPY --from=builder /app/prisma prisma
COPY --from=builder /app/package.json .

# Expose PORT
EXPOSE $API_PORT

# Declare entrypoint
ENTRYPOINT ["yarn"]
CMD ["start:prod"]
