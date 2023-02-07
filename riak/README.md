## Riak

A distributed key-value database

### Composition
- 1 coordinator, 1 member as default
- riak explorer (http://localhost:8098/admin/.)

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

3. example

- insert
  ```
  curl -i -X POST http://localhost:8098/riak/animals \
    -H "Content-Type: application/json" \
    -d '{"nickname" : "Sergeant Stubby", "breed" : "Terrier"}'
  ```

  it will give you location like this `/riak/animals/YKhSkvEtwhvqX7CzsFYo2sU0RKN`
