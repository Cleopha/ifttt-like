###               ###
# Build application #
###               ###
FROM node:17 as builder

WORKDIR /app

# Copy dependency manager
COPY package.json .
COPY yarn.lock .

# Install dependencies
RUN yarn install --prod

# Copy sources
COPY . .

# Buil application
RUN yarn build

###                ###
# Create application #
###                ###
FROM node:17 as application

# Retrieves sources
WORKDIR /app

COPY package.json .

COPY prisma/ prisma
COPY util/ util

# Get application build
COPY --from=builder /app/dist dist
COPY --from=builder /app/node_modules node_modules

# Expose PORT
EXPOSE $API_PORT

# Declare entrypoint
ENTRYPOINT ["yarn"]
CMD ["start:prod"]
