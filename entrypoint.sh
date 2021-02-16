#!/bin/sh

if [ ! -z ${REPORT_FILE} ]; then
  if [ -f ${REPORT_FILE} ]; then
    echo "WARN: replacing the existing report file at '${REPORT_FILE}'"
  fi
  echo "INFO: Generating the report at ${REPORT_FILE}"
  SPF2IP $@ > ${REPORT_FILE}
 
else
  SPF2IP $@
fi
