# Mongoreplica
EnterpriseBotTask


# For Task 2
**docker build -t zaki/elasticsearch**
For persistent volume 
docker volume create --name esdata
docker run -dit -p 9200:9200 -v esdata:/usr/share/elasticsearch/data my-es-image

