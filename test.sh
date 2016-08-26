#!/usr/bin/bash

ES="http://localhost:9200/activities"
Q="тур"

q="
  {
    \"query\": {
      \"nested\": {
        \"path\": \"city\",
        \"query\": {
          \"bool\": {
            \"must\": [
              { \"match\": { \"city.name\": \"$Q\" } }
            ]
          }
        }
      }

    }
  }
"
q="
{
  \"query\": {
    \"bool\": {
      \"must\": [
        { \"match\": { \"title\": \"$Q\" } }
      ]
    }
  }
}
"

curl -XGET "$ES/_search?pretty=true" -d "$q"

{
  "posts": {
    "mappings": {
      "activity": {
        "properties": {
          "categories": {
            "properties": {
              "description": {
                "type": "string",
                "analyzer": "russian"
              },
              "name": {
                "type": "string",
                "analyzer": "russian"
              }
            }
          },
          "tags": {
            "type": "nested",
            "properties": {
              "name": {
                "type": "string",
                "analyzer": "russian"
              }
            }
          },
          "description": {
            "type": "string",
            "analyzer": "russian"
          },
          "title": {
            "type": "string",
            "analyzer": "russian"
          }
        }
      }
    }
  }
}
