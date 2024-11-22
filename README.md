# Mongoreplica
EnterpriseBotTask


# For Task 2
docker build -t zaki/elasticsearch </br>
For persistent volume </br>
docker volume create --name esdata </br> 
docker run -dit -p 9200:9200 -v esdata:/usr/share/elasticsearch/data my-es-image

