###
# Install latest version of protoc
###
FROM pseudomuto/protoc-gen-doc:1.5.0 AS setup

# Update protoc version to use optional in protobuf
ADD https://github.com/google/protobuf/releases/download/v3.18.1/protoc-3.18.1-linux-x86_64.zip ./
RUN apt-get -q -y update && apt-get -q -y install unzip
RUN unzip -o protoc-3.18.1-linux-x86_64.zip -d ./usr/local && \
  rm protoc-3.18.1-linux-x86_64.zip && \
  apt-get remove --purge -y unzip && \
  apt-get -y autoremove && \
  rm -rf /var/lib/apt/lists/*

###
# Generation WorkflowAPI documentation
###
FROM setup AS gen-workflow-api-doc

RUN chmod -R a+r /usr/local/include

# Copy workflow API protobuf
COPY task.proto /protos/task.proto
COPY workflow.proto /protos/workflow.proto

# Generate documentation
RUN protoc -Iprotos --doc_out=/ protos/*.proto

###
# Generation CredentialAPI documentation
###
FROM setup AS gen-credential-api-doc

RUN chmod -R a+r /usr/local/include

# Copy workflow API protobuf
COPY credential.proto /protos/credential.proto

# Generate documentation
RUN protoc -Iprotos --doc_out=/ protos/*.proto

###
# Expose gRPC documentation with nginx
###
FROM nginx:latest AS doc-server

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=gen-workflow-api-doc /index.html /usr/share/nginx/html/workflow/index.html
COPY --from=gen-credential-api-doc /index.html /usr/share/nginx/html/credential/index.html