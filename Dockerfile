FROM ubuntu:latest

# Install required dependencies
RUN apt update && \
    apt install -y  gpg wget sudo lsb-release && \
    echo "Installing required dependencies..."

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch |  gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

RUN  apt-get install apt-transport-https

RUN echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-8.x.list

RUN  apt-get update &&  apt-get install elasticsearch

# Add a new user to run Elasticsearch
RUN useradd -ms /bin/bash elasticuser && \
    echo "elasticuser ALL=(ALL) NOPASSWD: /usr/share/elasticsearch/bin/elasticsearch" >> /etc/sudoers

# Set up Elasticsearch directories with proper ownership
# Ensure Elasticsearch has access to configuration files
RUN chown elasticsearch:elasticsearch /etc/default/elasticsearch && \
    chmod 644 /etc/default/elasticsearch

RUN mkdir -p /usr/share/elasticsearch/data && \
    chown -R elasticuser:elasticuser /usr/share/elasticsearch /usr/share/elasticsearch/data

# Switch to the new user
USER elasticuser

# Expose necessary Elasticsearch ports
EXPOSE 9200 9300

# Set entrypoint to start Elasticsearch
ENTRYPOINT ["/usr/share/elasticsearch/bin/elasticsearch"]
