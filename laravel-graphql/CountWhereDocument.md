# @countWhere Document

## 개요
 @count directive는 조건이 걸리않아 custom directive를 제작했습니다.


## 사용용도
 count에 조건을 걸고 싶을 때 사용합니다.
> ex) 상품을 구매한 차트 중 검색할 조건(id, 예약 날짜 등)에 해당하는 차트를 검색합니다.

## 사용방법

### schema
쿼리 이름(조건): 반환값 @countWhere(relation:관계이름)
```graphql
rrCnt(id:Int @where(operator:"=",key:"id")): Int @countWhere(relation:reserveReserveCntRelation)
rrCnt2(reserve_date:DateRange @whereBetween): Int @countWhere(relation:reserveReserveBetweenRelation)
```
1. 쿼리이름 : 일반 schema작성하는 것 처럼 작성합니다.
2. 조건 : @eq, @where사용 가능합니다.
2-1. id, reserve_date등과 같이 변수명은 DB colum명으로 사용됩니다.
2-2. input type도 사용가능합니다. input field가 여러개일 경우에는 model에서 추가 작업을 해줘야합니다.
3. 반환값 : 개수를 세는 지시어이므로 반환값은 Int 고정입니다.
4. 관계이름 : 모델에서 작성한 relation 이름을 걸어주시면됩니다.

<hr>

### model
laravel query biluer를 이용하여 추가 작업을 진행합니다.

```php
public function relation-name($colum, $operator, $param){
    return $this->hasMany(...)->where($colum, $operator, $param);
}
```

```php
public function reserveReserveCntRelation($colum, $operator,$param){
    return $this->hasMany(
        'App\Models\ReserveReserve',
        'hope_title_id',
        'id'
    )->where($colum, $operator, array_shift($param));
}

public function reserveReserveBetweenRelation($colum, $operator,$param){
    $redate = array_shift($param);
    return $this->hasMany(
        'App\Models\ReserveReserve',
        'hope_title_id',
        'id'
    )->where($colum, ">=", array_shift($redate))->where($colum, "<=", array_shift($redate));
}
```

1. $colum -> schema에서 조건절에서 입력한 변수명입니다.
2. $operator -> schema에서 입력한 operator입니다.
3. $param -> schema에서 입력한 변수입니다.
3-1. $param를 사용하실 때 보낸 array 형식에 맞게 array_shift()등으로 하나씩 사용하면 됩니다.
4. laravel에서 relation 거는 방식과 동일합니다.
4-1. hasMany, hasOne 동일
5. 마지막에 arrow function으로 where을 호출하고 인자들을 삽입합니다.
6. 순서대로 where(컬럼명, 연산자, 값)입니다.
> 주의사항 똑같이 hasMany, hasOne 객체를 반환해야되서 마지막에 get()하면 안됩니다. 


<hr>

### 지시어 구현
```php
function (?Model $model, array $param) use($value){

    //연산자 구함
    $args = $value->getField()->arguments[0]->directives[0];

    $operator = "=";

    if($args->name->value != "eq"){
        foreach($args->arguments as $arg){
            if($arg->name->value == "operator"){
                $operator = $arg->value->value;
                break;
            }
        }
    }

    //컬럼명 구함
    $colum = $value->getField()->arguments[0]->name->value;

    // Fetch the count by relation
    $relation = $this->directiveArgValue('relation');
    if (! is_null($relation)) {
        return $model->{$relation}($colum,$operator,$param)->count();
    }
}
```

1. Closure class를 이용하여 $value를 사용하여 값을 가져옵니다.
2. FieldValue에서 getField() 함수가 있고 이 함수의 return 값은 json입니다.
 2-1. return json 예시
 ```json
{
  "kind": "FieldDefinition",
  "name": {
    "kind": "Name",
    "value": "rrCnt"
  },
  "arguments": [
    {
      "kind": "InputValueDefinition",
      "name": {
        "kind": "Name",
        "value": "id1"
      },
      "type": {
        "kind": "NamedType",
        "name": {
          "kind": "Name",
          "value": "Int"
        }
      },
      "directives": [
        {
          "kind": "Directive",
          "name": {
            "kind": "Name",
            "value": "where"
          },
          "arguments": [
            {
              "kind": "Argument",
              "value": {
                "kind": "StringValue",
                "value": ">=",
                "block": false
              },
              "name": {
                "kind": "Name",
                "value": "operator"
              }
            },
            {
              "kind": "Argument",
              "value": {
                "kind": "StringValue",
                "value": "id",
                "block": false
              },
              "name": {
                "kind": "Name",
                "value": "key"
              }
            }
          ]
        }
      ]
    }
  ],
  "type": {
    "kind": "NamedType",
    "name": {
      "kind": "Name",
      "value": "Int"
    }
  },
  "directives": [
    {
      "kind": "Directive",
      "name": {
        "kind": "Name",
        "value": "countWhere"
      },
      "arguments": [
        {
          "kind": "Argument",
          "value": {
            "kind": "EnumValue",
            "value": "reserveReserveRelation"
          },
          "name": {
            "kind": "Name",
            "value": "relation"
          }
        }
      ]
    }
  ]
}
```
3. 관계를 불러오는 함수 인자에 작업한 변수들을 넘겨줍니다.


 <hr>

 ### query
 실제 사용 query 예제입니다.

 ```graphql
query
{
  priceTitle(first:1){
    data{
    	id
      rrCnt(id:3)
      rrCnt2(reserve_date:{from:"2019-05-23 00:00:00",to:"2019-05-23 23:59:59"})
    }
  }
}
 ```

<hr>
 #### 참고 자료
[Laravel Korea](https://laravel.kr/docs/6.x)
[Lighthouse](https://lighthouse-php.com/master/getting-started/installation.html)


