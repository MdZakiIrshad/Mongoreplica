#!/bin/bash

# Function to install docker
Install_docker()
{
   echo "Installing docker"
   sudo apt install docker.io
   sudo systemctl enable docker.service

}
cleanup_containers() {
    echo "Cleaning up existing MongoDB containers..."
    docker rm -f mongo1 mongo2 mongo3 > /dev/null 2>&1
}

# Function to create MongoDB containers
create_containers() {
    echo "Creating MongoDB containers..."
    docker network create mongo-replica-net > /dev/null 2>&1

    # MongoDB member 1
    docker run -d --name mongo1 --net mongo-replica-net \
        -p 27017:27017 \
        -v mongo1_data:/data/db \
        mongo:5.0 --replSet rs0 --wiredTigerCacheSizeGB 1 --noscripting

    # MongoDB member 2
    docker run -d --name mongo2 --net mongo-replica-net \
        -p 27018:27017 \
        -v mongo2_data:/data/db \
        mongo:5.0 --replSet rs0 --wiredTigerCacheSizeGB 1 --noscripting

    # MongoDB member 3 (arbiter)
    docker run -d --name mongo3 --net mongo-replica-net \
        -p 27019:27017 \
        -v mongo3_data:/data/db \
        mongo:5.0 --replSet rs0 --wiredTigerCacheSizeGB 1 --noscripting
}

# Function to initialize the replica set
initialize_replica_set() {
    echo "Initializing the replica set..."
    sleep 5 # Wait for MongoDB containers to start

    docker exec -it mongo1 mongo --eval "
        rs.initiate({
            _id: 'rs0',
            members: [
                { _id: 0, host: 'mongo1:27017' },
                { _id: 1, host: 'mongo2:27017' },
                { _id: 2, host: 'mongo3:27017', arbiterOnly: true }
            ]
        });
    "
}

# Main script execution
echo "Starting MongoDB replica set setup..."
Install_docker
cleanup_containers
create_containers
initialize_replica_set
echo "MongoDB replica set setup completed!"

