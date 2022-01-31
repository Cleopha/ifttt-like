# Generate workflow
mkdir -p workflow
protoc \
  --plugin="./node_modules/.bin/protoc-gen-ts_proto" \
  --ts_proto_out=./workflow workflow.proto task.proto \
  --ts_proto_opt=outputEncodeMethods=false,outputJsonMethods=false,outputClientImpl=false

