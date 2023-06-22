#!/bin/bash
mkdir -p ./steampipe/db/14.2.0/data;

echo "sudo to alter steampipe ownership"
sudo chown 9193:0 steampipe -R

mkdir -p ./postgres;
