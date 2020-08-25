# axios parameter

## 개요

기본적으로 axios는 JavaScript 객체를 'JSON'으로 직렬화(serialize) 합니다. 

application/x-www-form-urlencoded 포멧 대신 데이터를 보내려면 다음과 같이 해야합니다.

```javascript
const qs = require('qs');
axios.post('/api/test', qs.stringify({ 'name': "이름" }));
```

Node.js의 querystring 메소드도 직렬화가 가능하지만

querystring은 중첩된 객체를 문자열화 하는데 어려움이 있습니다. 

중첩된 객체를 문자열화 해야할 경우가 잦을 경우 qs 라이브러리 사용이 권장됩니다.

qs 라이브러리도 무한정 중첩이 되진 않고 최대 5 개의 하위 항목만 파싱합니다.

depth옵션을 전달하여 재정의 할 수 있습니다.

 `qs.parse(string, [options])`

```javascript
var deep = qs.parse('a[b][c][d][e][f][g][h][i]=j', { depth: 1 });
assert.deepEqual(deep, { a: { b: { '[c][d][e][f][g][h][i]': 'j' } } });
 ```

## 직렬화

직렬화(直列化) 또는 시리얼라이제이션(serialization)은 컴퓨터 과학의 데이터 스토리지 문맥에서 데이터 구조나 오브젝트 상태를 동일하거나 다른 컴퓨터 환경에 저장(이를테면 파일이나 메모리 버퍼에서, 또는 네트워크 연결 링크 간 전송)하고 나중에 재구성할 수 있는 포맷으로 변환하는 과정입니다.

오브젝트를 직렬화하는 과정은 오브젝트를 마샬링한다고도 합니다. 반대로, 일련의 바이트로부터 데이터 구조를 추출하는 일은 역직렬화 또는 디시리얼라이제이션(deserialization)이라고 합니다.

자바 I/O의 처리는 정수, 문자열 바이트 단위의 처리만 지원했었는데 점점 복잡한 데이터인 객체를 일정한 형식으로 만들어 전송해야 했고 자바 I/O가 자동적으로 바이트 단위로 변화하여, 저장/복원하거나 네트워크로 전송하기 위한 기능입니다.

## 참고

[axios가이드](https://github.com/axios/axios#using-applicationx-www-form-urlencoded-format)

[ljharb/qs](https://github.com/ljharb/qs)

[위키백과-직렬화](https://ko.wikipedia.org/wiki/%EC%A7%81%EB%A0%AC%ED%99%94)