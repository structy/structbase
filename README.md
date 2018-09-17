# structBase

**Free REST API Data Storage** with audit logging, all updated *key/node* is generated historical in **Audit Table** (automatically).

Proposal to be **firebase** Open Source, using **Postgres** as data structure.

## Data architecture

- key/node: Unique key (*unique together*) to manage future access on data
- object: JSON data types are for storing JSON (JavaScript Object Notation) data ([read more...](https://www.postgresql.org/docs/9.4/static/datatype-json.html)), with the possibility of creating **index** in fields within JSON

## Auth

``` shell
curl -X POST -i -H "Content-Type: application/json" -d '{"key": "<YOUR-KEY>", "secret": "<YOUR-SECRET>"}' http://.../auth
```

## Objects

### GET

``` shell
curl -X GET -i -H "Content-Type: application/json" -H "Authorization:Bearer <YOU-TOKEN>" http://.../<DATABASE-NAME>/public/objects
```

### POST

``` shell
curl -X POST -i -H "Content-Type: application/json" -H "Authorization:Bearer <YOU-TOKEN>" http://.../<DATABASE-NAME>/public/objects \
	-d '{"key": "<DATA-KEY>", "node": "<DATA-NODE>", "object": "{\"field1\": \"value1\", \"field2\": \"value2\"}"}'
```

### PUT/PATH

``` shell
curl -X POST -i -H "Content-Type: application/json" -H "Authorization:Bearer <YOU-TOKEN>" http://.../<DATABASE-NAME>/public/objects?key=<DATA-KEY>&node=<DATA-NODE> \
	-d '{"object": "{\"field1\": \"value1\", \"field2\": \"value2\"}"}'
```
