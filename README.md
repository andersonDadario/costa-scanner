### Introduction

CostaScanner is an application to detect changes in your desired Network Ranges, e.g., 192.168.0.0/24, and take action when such changes are spotted. 

Currently 'changes' means that a new server is up. When this server is up, you can run scanners, e.g., Nmap, and send the result directly to your e-mail, to any URL you want (webhook) or just save to a file.

CostaScanner aims to be a no-brainer tool to plug into any data center, start monitoring it and take action when necessary.

### Getting Started

- Please [install Docker](https://docs.docker.com/engine/installation/)
- Run `git clone https://github.com/andersonDadario/costa-scanner.git`
- Edit `docker.env.original` to configure your preferences
- Rename `docker.env.original` to `docker.env`
- Build docker image `docker build -t andersonmvd/costa-scanner .`
- Run `docker run -d --env-file docker.env --name costa-scanner andersonmvd/costa-scanner`
- [Optional] To see the logs, run `docker exec -it costa-scanner tail -f app.log`

### Output Example

```txt
[2017-04-06 22:52:22 +0000] [up?] Testing 192.168.0.3...
[2017-04-06 22:52:25 +0000] [up?] Testing 192.168.0.4...
[2017-04-06 22:52:25 +0000] [up?] Testing 192.168.0.5...
[2017-04-06 22:52:29 +0000] [up?] Testing 192.168.0.6...
[2017-04-06 22:52:32 +0000] [up?] Testing 192.168.0.7...
[2017-04-06 22:52:35 +0000] [New Servers] ["192.168.0.1", "192.168.0.4"]
[2017-04-06 22:52:36 +0000] PrintOperation {"operation"=>"PrintOperation", "data"=>{"servers"=>["192.168.0.1", "192.168.0.4"]}}
[2017-04-06 22:52:36 +0000] [SendEmail] Begin Sending email to some@email.com...
[2017-04-06 22:52:40 +0000] [SendEmail] Ended sending email to some@email.com...
[2017-04-06 22:52:40 +0000] [Nmap] Begin Scanning: 192.168.0.1...
[2017-04-06 22:52:59 +0000] [Nmap] Ended Scanning: 192.168.0.1
[2017-04-06 22:52:59 +0000] [Nmap] Begin Scanning: 192.168.0.4...
```

### To add more scanners
- Install the scanner by updating the `Dockerfile`
- Update `docker.env` to register a new custom operation (see StartPing)
- Voilá!

### Development
```sh
docker rm -f costa-scanner
docker build -t andersonmvd/costa-scanner .
docker run -d --env-file docker.env --name costa-scanner andersonmvd/costa-scanner
docker exec -it costa-scanner tail -f app.log
# [Flush Redis] redis-cli -h <container IP> flushdb
```
