FQBN := espressif:esp32:esp32da
# TODO: change this for other OS users
SKETCH_FOLDER_NAME ?= ${CURDIR} # the folder where your sketch is located, defaults to the current directory
SKETCH_FILE_NAME := $(CURDIR)/${SKETCH_FOLDER_NAME}/${SKETCH_FOLDER_NAME}.ino # the .ino file that matches the folder name
MONITOR_BAUD_RATE := $(shell sed -nE 's/.*Serial.begin\(([0-9]+)\).*/\1/p' ${SKETCH_FILE_NAME})
BUILD_PATH := ${SKETCH_FOLDER_NAME}/build
COMPILE_TIMESTAMP := ${BUILD_PATH}/.timestamp # use a timestamp folder to prevent re-compilation
DELAY_TIME_MS ?= 50

# change the port name based on what the OS is
ifeq ($(OS),Windows_NT) 
 PORT := $(shell ls /dev/ttyS* | head -n 1)
else
 PORT := $(shell ls /dev/cu.usb* | head -n 1)
endif

# do some checks to make sure everything you want exists
ifndef PORT
$(error No usb serial port connected, please try again)
endif

ifndef SKETCH_FOLDER_NAME
$(error No sketch folder name provided)
endif

ifndef SKETCH_FILE_NAME
$(error No sketch file can be found)
endif

# some scripts do not need a baud rate, so my solution to this would be to set a default baud rate
ifndef MONITOR_BAUD_RATE
MONITOR_BAUD_RATE = 115200
endif

compile.sh : display_config ${COMPILE_TIMESTAMP} 

upload : display_config ${COMPILE_TIMESTAMP}
	arduino-cli upload -p ${PORT} --fqbn ${FQBN} --input-dir ${BUILD_PATH}

${COMPILE_TIMESTAMP} : ${SKETCH_FILE_NAME}
	arduino-cli compile --fqbn ${FQBN} --build-path "${BUILD_PATH}" ${SKETCH_FOLDER_NAME} --build-properties build.extra_flags="-DDELAY_TIME_MS=${DELAY_TIME_MS}" -v
	touch ${COMPILE_TIMESTAMP}

monitor:
	arduino-cli monitor -p ${PORT} -b ${FQBN} --config ${MONITOR_BAUD_RATE}

display_config:
	@echo "BOARD: ${FQBN}"
	@echo "PORT: ${PORT}"
	@echo "MONITOR BAUD RATE: ${MONITOR_BAUD_RATE}"
	@echo "SKETCH_FOLDER_NAME: ${SKETCH_FOLDER_NAME}"
	@echo "SKETCH FILE: ${SKETCH_FILE_NAME}"
	@echo "BUILD PATH: ${BUILD_PATH}" 
	@echo ""
	@echo "---------------------------------------"
	@echo ""

