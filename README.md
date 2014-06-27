# Lossless JPEG Compression Comparison

This script will losslessly compress JPEG files using several different tools and report back the amount of compression and time taken for each file.

## Tools Used
* jpegoptim - https://github.com/tjko/jpegoptim
* jpegtran - http://jpegclub.org/jpegtran/
* jpegrescan - https://github.com/kud/jpegrescan
* mozjpeg - https://github.com/mozilla/mozjpeg

Each tool will need to be installed on the system for the script to run.

## How to Use
1. Install each tool listed above
2. Create a `files` directory in the same location as the script and put any number of JPEG files in it
3. Make `run.sh` executable and run it `./run.sh`

## License
MIT License - fork, modify and use however you want.
