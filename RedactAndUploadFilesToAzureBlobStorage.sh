#!/bin/bash

# This script was used to push Minecraft logs from a Linux host to Azure Blob Storage to be served on a website.
# IP Addresses are redacted for privacy reasons.
# Requires AzCopy: https://aka.ms/AzCopyLinux

# Copy original logs to archival folder.
cp /home/minecraft/logs/*.gz /home/minecraft/logs/originals/
cp /home/minecraft/logs/latest.log /home/minecraft/logs/originals/

# Copy working logs to working folder.
cp /home/minecraft/logs/*.gz /home/minecraft/logs/parsed/
cp /home/minecraft/logs/latest.log /home/minecraft/logs/parsed/

# Extract logs from GZip files.
gunzip -f /home/minecraft/logs/parsed/*.gz

# Remove IP addresses.
sed -i -e 's/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/REDACTED/g' /home/minecraft/logs/parsed/*.log

# Upload new logs to Azure Storage.
azcopy --source /home/minecraft/logs/parsed/ --destination https://account.blob.core.windows.net/blobcontainer -dest-sas "<SASURI>" --recursive --quiet