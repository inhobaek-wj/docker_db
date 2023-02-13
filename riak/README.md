## Riak

A distributed key-value database

### Composition
- 1 coordinator, 1 member as default
- riak explorer (http://localhost:8098/admin/.)

### Test data
  ```
  gem install riak-client json
  ruby hotel.rb
  ```

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

- url format: `http://address:port/riak/[bucket]/[key]`

- insert
  ```
  curl -i -X POST http://localhost:8098/riak/animals \
    -H "Content-Type: application/json" \
    -d '{"nickname" : "Sergeant Stubby", "breed" : "Terrier"}'
  ```

  it will give you location like this `/riak/animals/YKhSkvEtwhvqX7CzsFYo2sU0RKN`


- insert or update
  ```
  curl -v -X PUT http://localhost:8098/riak/animals/ace \
    -H "Content-Type: application/json" \
    -d '{"nickname" : "The Wonder Dog", "breed" : "German Shepherd"}'

  curl -v -X PUT http://localhost:8098/riak/animals/polly?returnbody=true \
    -H "Content-Type: application/json" \
    -d '{"nickname" : "Sweet Polly Purebred", "breed" : "Purebred"}'
  ```

  then you can check http://localhost:8098/riak/animals/ace


- select

  ```
  curl -X GET http://localhost:8098/riak?buckets=true

  curl http://localhost:8098/riak/animals?keys=true
  ```

- insert with link
  ```
  curl -X PUT http://localhost:8098/riak/cages/1 \
    -H "Content-Type: application/json" \
    -H "Link: </riak/animals/polly>; riaktag=\"contains\"" \
    -d '{"room" : 101}'

  curl -X PUT http://localhost:8098/riak/cages/2 \
    -H "Content-Type: application/json" \
    -H "Link:</riak/animals/ace>;riaktag=\"contains\",
      </riak/cages/1>;riaktag=\"next_to\"" \
    -d '{"room" : 102}'
  ```

- link walking
  ```
  curl http://localhost:8098/riak/cages/1/_,_,_

  curl http://localhost:8098/riak/cages/2/animals,_,_

  curl http://localhost:8098/riak/cages/2/_,next_to,_

  curl http://localhost:8098/riak/cages/2/_,next_to,0/animals,_,_

  curl http://localhost:8098/riak/cages/2/_,next_to,1/_,_,_
  ```

- arbitrary metadata
  ```
  curl -X PUT http://localhost:8098/riak/cages/1 \
    -H "Content-Type: application/json" \
    -H "X-Riak-Meta-Color: Pink" \
    -H "Link: </riak/animals/polly>; riaktag=\"contains\"" \
    -d '{"room" : 101}'

  curl -i http://localhost:8098/riak/cages/1
  ```

- image file
  ```
  curl -X PUT http://localhost:8098/riak/photos/polly.jpg \
    -H "Content-type: image/jpeg" \
    -H "Link: </riak/animals/polly>; riaktag=\"photo\"" \
    --data-binary @images/polly.jpg
  ```

- mapreduce
  ```
  curl -X POST http://localhost:8098/mapred \
    -H "Content-type: application/json; charset=utf-8" \
    --data-raw '
  {
    "inputs":[
      ["rooms","101"],["rooms","102"],["rooms","103"]
    ],
    "query":[
      {
        "map": {
          "language":"javascript",
          "source":
            "function(v) {
              var parsed_data = JSON.parse(v.values[0].data);
              var data = {};
              data[parsed_data.style] = parsed_data.capacity;
              return [data];
           }"
        }
      }
    ]
  }'
  ```

- register function
  ```
  curl -X PUT http://localhost:8098/riak/my_functions/map_capacity \
    -H "Content-type: application/json; charset=utf-8" \
    --data-raw '
    function(v) {
      var parsed_data = JSON.parse(v.values[0].data);
      var data = {};
      data[parsed_data.style] = parsed_data.capacity;
      return [data];
    }'
  ```
