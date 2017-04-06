FROM ruby:2.3.3

RUN apt-get update -qq && \
    apt-get install -y \
       build-essential \
       nmap \
       redis-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir /app

WORKDIR /app
VOLUME ["/var/lib/redis","/app/scans"]

# Solve application dependencies
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

# Run bundle
RUN bundle install

# Copy application code to container
ADD . /app

# The main command to run
CMD ["bash","boot.sh"]
