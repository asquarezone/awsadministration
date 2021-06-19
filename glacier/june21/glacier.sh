#!/bin/bash

# Create an AWS S3 Glacier vault
aws glacier create-vault --account-id - --vault-name 'docsvault'

#
# {
#    "location": "/678879106782/vaults/docsvault"
# }
#

# Prepare a large file 10 MB
dd if=/dev/urandom of=largefile bs=10485760 count=1

# Split the files into 1 MB 
split -b 1048576 --verbose largefile chunk

# lets upload file directly to the archive
aws glacier upload-archive --account-id - --vault-name 'docsvault' --body awscliv2.zip

# Generally we upload large files where we upload parts of the file

# Lets initiate multipart upload
aws glacier initiate-multipart-upload --account-id - --archive-description "multipart upload demo" --part-size 1048576 --vault-name 'docsvault'

# {
#     "location": "/678879106782/vaults/docsvault/multipart-uploads/l-80k-_0dSzGufEPf0RV69oApsv9gOD5tIdSr44kHFDBURaYy6p0Z6tMzxmV1ZdnLMy_0ke6hd-2fp1UnDh5jt6VOYxm",
#     "uploadId": "l-80k-_0dSzGufEPf0RV69oApsv9gOD5tIdSr44kHFDBURaYy6p0Z6tMzxmV1ZdnLMy_0ke6hd-2fp1UnDh5jt6VOYxm"
# }

UPLOADID='l-80k-_0dSzGufEPf0RV69oApsv9gOD5tIdSr44kHFDBURaYy6p0Z6tMzxmV1ZdnLMy_0ke6hd-2fp1UnDh5jt6VOYxm'

aws glacier upload-multipart-part --upload-id $UPLOADID --account-id - --vault-name 'docsvault' --body chunkaa --range 'bytes 0-1048575/*'
# {
#     "checksum": "67793b16e2bb560d78b31a04ed25c543f40f23c9db2dc07f2bd8152b9281c41a"
# }

aws glacier upload-multipart-part --upload-id $UPLOADID --account-id - --vault-name 'docsvault' --body chunkab --range 'bytes 1048576-2097151/*'
# {
#     "checksum": "9157be17875e70f7c2172fc78ae52f82e27e3b921499ca76527de54e72122253"
# }

aws glacier upload-multipart-part --upload-id $UPLOADID --account-id - --vault-name 'docsvault' --body chunkac --range 'bytes 2097152-3145727/*'

# {
#     "checksum": "4b234d66bbafbe590e2d11f854937a9f2db1d3efc1e97d781bd4b650524fdb76"
# }


aws glacier upload-multipart-part --upload-id $UPLOADID --account-id - --vault-name 'docsvault' --body chunkad --range 'bytes 3145728-4194303/*'
# {
#     "checksum": "389bda6a3bf4e353d7bad29b42458212b5108504620ff4d7f67224c00196e533"
# }

aws glacier upload-multipart-part --upload-id $UPLOADID --account-id - --vault-name 'docsvault' --body chunkae --range 'bytes 4194304-5242879/*'

# {
#     "checksum": "43dc081cce7630950c0df124eb14576ca8c731549ad87bcbf729fa4d458e9927"
# }

aws glacier upload-multipart-part --upload-id $UPLOADID --account-id - --vault-name 'docsvault' --body chunkaf --range 'bytes 5242880-6291455/*'
# {
#     "checksum": "6adaec6095b75dfdbb4b01955e592f5751f8cf3900022dbfe917888456773983"
# }

aws glacier upload-multipart-part --upload-id $UPLOADID --account-id - --vault-name 'docsvault' --body chunkag --range 'bytes 6291456-7340031/*'

# {
#     "checksum": "6f741bf13f6571f14449a68ff9faf72e8d2ee15d38bb87f50674ebb9848dfd61"
# }

aws glacier upload-multipart-part --upload-id $UPLOADID --account-id - --vault-name 'docsvault' --body chunkah --range 'bytes 7340032-8388607/*'

# {
#     "checksum": "c32c2e938d6634fe9a494e1738b04db3c813f7498d9386e61433637223806b02"
# }

aws glacier upload-multipart-part --upload-id $UPLOADID --account-id - --vault-name 'docsvault' --body chunkai --range 'bytes 8388608-9437183/*'

# {
#     "checksum": "f28d377947e57d6e78595d50b1353f16f663832f210c00bf0f82f55dc2a2183d"
# }

aws glacier upload-multipart-part --upload-id $UPLOADID --account-id - --vault-name 'docsvault' --body chunkaj --range 'bytes 9437184-10485759/*'

# {
#     "checksum": "afeafaef8a5a7f15f4fd1a00b36d380a4a80680f4079f2341c851e14fba2cf69"
# }

# Calculate tree hash
openssl dgst -sha256 -binary chunkaa > hash1
openssl dgst -sha256 -binary chunkab > hash2
openssl dgst -sha256 -binary chunkac > hash3
openssl dgst -sha256 -binary chunkad > hash4
openssl dgst -sha256 -binary chunkae > hash5
openssl dgst -sha256 -binary chunkaf > hash6
openssl dgst -sha256 -binary chunkag > hash7
openssl dgst -sha256 -binary chunkah > hash8
openssl dgst -sha256 -binary chunkai > hash9
openssl dgst -sha256 -binary chunkaj > hash10




