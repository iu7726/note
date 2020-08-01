# vscode + spring boot + docker

## 개요
이클립스는 너무 무겁고 요즘 사용하는 vscode를 이용하여 Java를 개발할 수 없을까 생각해서 찾아본 결과를 정리합니다.

## 필요 상항
 - vscode
 - Spring 관련 Extensions Install
   - Spring Boot Tools
   - Spring Initializr Java Support
   - Spring Boot Dashboard
   - Java Extension Pack
 - Gradle을 사용했습니다.
   - Ctrl(Command Palette) + p
   - `>Spring Initializr: Generate a Gradle Project`
   - Java
   - 프로젝트 패키지명
   - 프로젝트 명
   - boot 버전
   - Web, Thyemleaf
     - Web : Tomcat 기반의 서블릿 API 사용가능한 프로젝트
     - Thyemleaf : 템플릿 엔진

## 디렉토리 구조

Controller
```
package hello.world.mh.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HelloController{

    @GetMapping("hello")
    public String Hello(Model model){
        model.addAttribute("data","hello!!");
        return "hello";
    }

}
```

build.gradle
```
buildscript {
  dependencies {
    classpath('se.transmode.gradle:gradle-docker:1.2')
  }
}

plugins {
  id 'org.springframework.boot' version '2.1.3.RELEASE'
  id 'java'
}

apply plugin: 'io.spring.dependency-management'

group = 'com.example.test'
version = '0.0.1-SNAPSHOT'
sourceCompatibility = '1.8'

repositories {
  mavenCentral()
}

dependencies {
  implementation 'org.springframework.boot:spring-boot-starter-web'
  runtimeOnly 'org.springframework.boot:spring-boot-devtools'
  testImplementation 'org.springframework.boot:spring-boot-starter-test'
}

apply plugin: 'docker'

task buildDocker(type: Docker, dependsOn: build) {
  // push = true
  applicationName = jar.baseName
  dockerfile = file('src/main/docker/Dockerfile')
  doFirst {
    copy {
      from jar
      into stageDir
    }
  }
}
```

Dockerfile
```
FROM openjdk:11-jdk
# jdk 버전 설정 / 공식이미지 사용
MAINTAINER minhyeok <iu7726@naver.com>
# 관리자
RUN mkdir -p /app/
# 도커 이미지 생성시 실행
ADD mh-0.0.1-SNAPSHOT.jar /app/app.jar
# 빌드된 jar 복사
EXPOSE 8080
# 포트 설정
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
# jar 실행
```

Commend
```
$ ./gradlew clean
$ ./gradlew build buildDocker

# 이미지 확인(이미지아이디, 리파지토리명, 태그 확인)
$ docker images -a

# 컨테이너 실행
# docker run -p 로컬포트:톰캣포트 --name 컨테이너명 -t 리파지토리명:태그
$ docker run -p 80:8080 --name demo -t com.example.test/demo:0.0.1-SNAPSHOT

# 컨테이너 연결 종료
control(⌃) + z

# 컨테이너 아이디 확인
$ docker ps -a

# 컨테이너 정지 및 삭제
$ docker stop 컨테이너아이디
$ docker rm 컨테이너아이디
```

docker 이미지로 docker를 실행 합니다.

이미지를 만들어서 실행시키기 때문에 만약 수정이 되었다면 컨테이너를 삭제 후 다시 올려야됩니다.

### 참고

https://blog.pickth.com/start-docker/

https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-%EC%9E%85%EB%AC%B8-%EC%8A%A4%ED%94%84%EB%A7%81%EB%B6%80%ED%8A%B8/lecture/49574?tab=curriculum