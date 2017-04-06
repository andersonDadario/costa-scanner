### Getting Started

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

### Development
```sh
docker rm -f costa-scanner
docker build -t andersonmvd/costa-scanner .
docker run -d --env-file docker.env --name costa-scanner andersonmvd/costa-scanner
docker exec -it costa-scanner tail -f app.log
# [Flush Redis] redis-cli -h <container IP> flushdb
```
