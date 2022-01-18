###               ###
# Build application #
###               ###
FROM node:16.10.0 as builder

# Retrieve sources
WORKDIR /app
COPY . /app

# Install dependencies
RUN yarn install

# Buil application
RUN yarn build

###                ###
# Create application #
###                ###
FROM node:16.10.0 as application

RUN npm i -g @nestjs/cli

# Retrieves sources
WORKDIR /app
COPY prisma/ /app/prisma
COPY package.json /app/package.json
COPY yarn.lock /app/yarn.lock
COPY util/ /app/util

# Install production dependancies
RUN yarn install --production

# Get application build
COPY --from=builder /app/dist /app/dist

# Expose PORT
EXPOSE $API_PORT

# Declare entrypoint
ENTRYPOINT ["yarn"]
CMD ["start:prod"]
