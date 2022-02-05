###
# Install latest version of protoc
###
FROM pseudomuto/protoc-gen-doc AS setup

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

# Copy workflow API protobuf
COPY task.proto /protos/task.proto
COPY workflow.proto /protos/workflow.proto

# Create output directory
RUN mkdir -p /out

# Generate documentation
RUN bash entrypoint.sh

###
# Expose gRPC documentation with nginx
###
FROM nginx:latest AS doc-server

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=gen-workflow-api-doc /out/index.html /usr/share/nginx/html/workflow/index.html