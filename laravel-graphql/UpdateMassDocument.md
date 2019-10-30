# UpdateMass Document

## 개요
@update directive가 여러개가 되지 않아 제작했습니다.

## 사용용도
mutation의 update를 한번에 여러번 실행시켜야 할 때 사용합니다.
> ex) id가 1인 row의 name, phone 컬럼의 값을 변경
>     id가 1인 row의 name, id = 2인 row의 phone 컬럼의 값을 변경
> 등등....

## 사용방법

### schema
쿼리이름(조건): 반환값 @updateMass

```graphql
updatesUserList(input:[UpdateUserListInput]): [UserList] @updateMass
```

1. 쿼리이름 : 일반 schema 작성하는 것 처럼 작성하면됩니다.
2. 조건 : input type을 이용하여 작성하는 것을 추천합니다.
3. 반환값 : 반환할 객체를 선언합니다.

<hr>

### 지시어 구현

```php
function ($root, array $param): array {

    ...
    $param = array_shift($param);
    foreach($param as $args){
        ...
    }
    return $ret;
}
```

1. 기존에 있던 update directive에 for문을 추가해 여러번 작동되게 했습니다.

<hr>

### query

```graphql
mutation{
    updatesUserList(
        input:[
            {id:1,name:"php"},
            {id:2,name:"java"}
        ]
    ){
        id
    }
}
```

<hr>

#### 참고자료

[Laravel Korea](https://laravel.kr/docs/6.x)<br>
[Lighthouse](https://lighthouse-php.com/master/getting-started/installation.html)
