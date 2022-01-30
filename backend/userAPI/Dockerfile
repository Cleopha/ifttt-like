###               ###
# Build application #
###               ###
FROM node:17 as builder

WORKDIR /app

# Copy dependency manager
COPY userAPI/package.json .
COPY userAPI/yarn.lock .

# Install dependencies
RUN yarn install --prod

# Copy sources
COPY userAPI/src src
COPY userAPI/nest-cli.json .
COPY userAPI/tsconfig.json .
COPY userAPI/tsconfig.build.json .
COPY userAPI/prisma prisma

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
