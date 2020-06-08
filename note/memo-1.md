# PHP Version Up에 관하여...

## 머리말
오늘 기존 프로젝트에 Laravel을 추가 install해야되는 상황이 왔는데 현재 사용하고 있는
PHP 버전은 7.0.26으로 Laravel 최소 버전은 7.2.5였습니다.<br>
따라서 PHP Version을 올려야되는 상황에서 있었던 troubleshooting내역입니다.

## 프로젝트 Infra
docker를 사용중이며 php는 Dockerfile, common-fpm.yml로 관리 중이였습니다.

- Dockerfile은 bitname에서 가져오는 image부터 시작하여 여러 초기 세팅이 있는 파일입니다.
- common-fpm.yml은 php.ini같은 환경 설정 파일이 있는 세팅 파일입니다.

## 문제 해결 과정
처음에 Laravel을 사용하게되어 무작정 Dockerfile에 
```
Runcomposer global require laravel/installer
```
입력을 하였지만 나오는 건 Problem 50가지...

그 중 가장 첫번째는 버전이 맞지 않아서 발생하였습니다.

그래서 Docker hub의 bitnami 공식 이미지 tag를 확인하여 PHP Dockerfile의 from을 변경하였습니다.

```
FROM bitnami/php-fpm:7.4
```
Dockerfile을 수정 후 docker build 실행

이번엔 설치가 되었지만 기존에 물려있던 PHP Modules이 안되기 시작했습니다.

error log는
```
~ Mosquitto\Client not found ~
```
처음엔 단순히 namespace문제인지 알고 `composer install, composer dump-autoload`등 쓸데없는 삽질만 계속하고 있었습니다.

그러던 와중 수정한 php.ini이 적용되지 않는다는 걸 확인 후 common-fpm.yml의 파일의 경로를 확인한 결과...

php-fpm의 7.0.26의 php.ini의 경로과 7.4의 php.ini의 경로는 달랐고 해당 경로를 맞추어서 재 빌드 후 실행해 보니 정상 작동 확인했습니다.

### 만약... 프로그램의 버전 업을 고려하고 계신다면 종속되어있는 설정파일의 경로를 꼭 확인해보세요!


