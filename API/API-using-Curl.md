# API Example Using Curl
## Keystone
### Tokens
- Unscope
```
curl -i -H "Content-Type: application/json" -d '
{ "auth": {
    "identity": {
      "methods": ["password"],
      "password": {
        "user": {
          "name": "admin",
          "domain": { "id": "default" },
          "password": "vccloud123"
        }
      }
    }
  }
}'   "http://10.10.10.2:5000/v3/auth/tokens" ; echo
```

- Project scope
```
curl -i \
  -H "Content-Type: application/json" \
  -d '
{ "auth": {
    "identity": {
      "methods": ["password"],
      "password": {
        "user": {
          "name": "admin",
          "domain": { "id": "default" },
          "password": "vccloud123"
        }
      }
    },
    "scope": {
      "project": {
        "name": "admin",
        "domain": { "id": "default" }
      }
    }
  }
}' \
  "http://10.10.10.3:5000/v3/auth/tokens" ; echo
```

### Domains
```
curl -s -H "X-Auth-Token: $OS_TOKEN" "http://10.10.10.2:5000/v3/domains" | python3 -mjson.tool
```

## Glance
### Images
- List images
```
curl -s -H "X-Auth-Token: $OS_TOKEN" "http://10.10.10.2:929
2/v2/images" | python3 -mjson.tool```
```


__Docs__
- https://docs.openstack.org/keystone/wallaby/api_curl_examples.html