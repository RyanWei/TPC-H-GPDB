#!/bin/bash
set -e

PWD=$(get_pwd ${BASH_SOURCE[0]})

step="compile_tpch"
init_log ${step}
start_log
schema_name=${SCHEMA_NAME}
table_name="compile"

function make_tpc()
{
  #compile the tools
  cd ${PWD}/dbgen
  rm -f ./*.o
  ADDITIONAL_CFLAGS_OPTION="-g -Wno-unused-function -Wno-unused-but-set-variable -Wno-format -fcommon" make
  cd ..
}

function copy_queries()
{
  rm -rf ${TPC_H_DIR}/*_gen_data/queries
  rm -rf ${TPC_H_DIR}/*_multi_user/queries
  cp -R ${PWD}/dbgen/queries ${TPC_H_DIR}/*_gen_data/
  cp -R ${PWD}/dbgen/queries ${TPC_H_DIR}/*_multi_user/
}

function copy_tpc()
{
  cp ${PWD}/dbgen/qgen ${TPC_H_DIR}/*_gen_data/queries/
  cp ${PWD}/dbgen/qgen ${TPC_H_DIR}/*_multi_user/queries/
  cp ${PWD}/dbgen/dists.dss ${TPC_H_DIR}/*_gen_data/queries/
  cp ${PWD}/dbgen/dists.dss ${TPC_H_DIR}/*_multi_user/queries/

  #copy the compiled dbgen program to the segment nodes
  echo "copy tpch binaries to segment hosts"
  for i in $(cat ${TPC_H_DIR}/segment_hosts.txt); do
    scp ${PWD}/dbgen/dbgen ${PWD}/dbgen/dists.dss ${i}:
  done
}

make_tpc
create_hosts_file
copy_queries
copy_tpc
print_log

echo "Finished ${step}"
