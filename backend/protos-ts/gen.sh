# Generate workflow
mkdir -p workflow
protoc \
  --plugin="./node_modules/.bin/protoc-gen-ts_proto" \
  --ts_proto_out=./workflow workflow.proto task.proto \
  --ts_proto_opt=nestJs=true,addGrpcMetadata=true,outputEncodeMethods=false,outputJsonMethods=false,outputClientImpl=false

# Generate credential
mkdir -p credential
protoc \
  --plugin="./node_modules/.bin/protoc-gen-ts_proto" \
  --ts_proto_out=./credential credential.proto \
  --ts_proto_opt=nestJs=true,addGrpcMetadata=true,outputEncodeMethods=false,outputJsonMethods=false,outputClientImpl=false
