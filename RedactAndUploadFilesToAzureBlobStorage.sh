#!/bin/bash

# This script was used to push Minecraft logs from a Linux host to Azure Blob Storage to be served on a website.
# IP Addresses are redacted for privacy.

# Copy original logs to archival folder.
copy /home/minecraft/*.gz /home/minecraft/logs/originals/

# Copy working logs to working folder.
copy /home/minecraft/*.gz /home/minecraft/logs/parsed/

# Extract logs from GZip files.
gunzip /home/minecraft/logs/parsed/*.gz

# Remove IP addresses.
sed -r 's/(\b[-1-9]{1,3}\.){3}[0-9]{1,3}\b'/REDACTED/ /home/minecraft/logs/parsed/*.log -i

# Upload new logs to Azure Storage.
azcopy --source /home/minecraft/logs/parsed/ --destination https://account.blob.core.windows.net/blobcontainer -dest-sas "<SASURI>" --recursive --quiet
