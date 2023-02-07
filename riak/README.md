## Riak

A distributed key-value database

### Composition
- 1 coordinator, 1 member as default

#### Manual clustering on the same network
1. add node

  ```sh
docker-compose -f docker-compose-another-member.yml up -d
docker exec riak-another-member-1 riak-admin cluster join riak@192.168.96.2
```

2. check cluster

  ```sh
docker exec riak-coordinator-1 riak-admin status | grep ring_members
```

* `192.168.96.2` is coordinator's HOST
