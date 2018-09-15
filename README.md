# mds
Mining Data Store

## REST

### Auth

``` shell
curl -X POST -i -H "Content-Type: application/json" -d '{"key": "<YOUR-KEY>", "secret": "<YOUR-SECRET>"}' http://.../auth
```

### Objects

``` shell
curl -X GET -i -H "Content-Type: application/json" -H "Authorization:Bearer <YOU-TOKEN>" http://.../<DATABASE-NAME>/public/objects
```
