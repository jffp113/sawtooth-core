#!/bin/bash
SERVERS=(51.83.75.29 51.83.75.29 51.83.75.29 51.83.75.29 51.83.75.29 51.83.75.29)

options=''
ID=1


keysPath="./../keys/all"

#"\\['\"'$$(cat /all/validator-1.pub)'\"','\"'$$(cat /all/validator-2.pub)'\"','\"'$$(cat /all/validator-3.pub)'\"','\"'$$(cat /all/validator-4.pub)'\"','\"'$$(cat /all/validator-5.pub)'\"'\\]"
#

#["024a0c28c9a95b3db5e6a16c9f2981e03d81e97447170d4738f0880aa3d44c751c",

keys="["
for index in ${!SERVERS[@]}
do
  keys="${keys} \"$(cat "${keysPath}/validator-$((ID + index)).pub")\""
  if [ ${#SERVERS[@]} -gt $((ID + index)) ]
  then
    keys="${keys} , "
  fi
done
keys="${keys} ]"

echo ${keys}