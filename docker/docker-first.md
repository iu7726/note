# Docker Error

## error code

yaml.scanner.ScannerError: while scanning for the next token

found character '\t' that cannot start any token

에러 발생<br>

## 해결법 

에러 원인 YAML은 tab을 허용하지 않기때문입니다.

들여쓰기가 아닌 다른 문자로 인식하여 제대로 실행이 안됬습니다.

## error code
 The Compose file '.\docker-compose.yml' is invalid because:
 
services.proxy.ports is invalid: Invalid port "./proxy/nginx.conf:/etc/nginx/nginx.conf", should be [[remote_ip:]remote_port[-remote_port]:]port[/protocol]
services.web.expose is invalid: should be of the format 'PORT[/PROTOCOL]'

## 해결법

옮겨적다가 expose를 ports로 그대로 사용하고있었고

expose 값이 8080인데 8080:8080이라고 적고있었습니다..
