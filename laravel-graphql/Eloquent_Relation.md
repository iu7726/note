# Eloquent Relation

## with
해당 모델에 relation이 설정되어있다면 아래와 같이 사용이 가능합니다.
```
Model::with(
    '{relationName}' => function($query){
        $query->select();
    },
    '{relationName2}'
)->select();
```

결과

```
model{
    a:1,
    b:2
    relation_name{
        c:3
    },
    relation_name2{
        d:4
    }
}
```
해당 query 결과를 object로 얻을 수 있습니다.

## has, whereHas
```
Model::has('{relation}')->select()
```
Model에 설정된 relation이 있는 레코드만 가져옵니다.

```
Model::whereHas(
    '{relation}', function($query){
        $query->where('a','b');
    }
)->select()
```
Model에 설정된 relation 중 조건에 부합하는 relation의 레코드가 있을 경우 Model의 레코드를 반환합니다.
> 주의) 배열이 아닙니다.
