#!/bin/sh
echo "Entrypoint Started"
sh ./tcp-port-wait $PREST_PG_HOST $PREST_PG_PORT
/go/bin/mds migrate up
echo "Entrypoint End"
exec $@
