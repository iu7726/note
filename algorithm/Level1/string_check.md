# 문자열 다루기 기본

## 문제

문자열 s의 길이가 4 혹은 6이고, 숫자로만 구성돼있는지 확인해주는 함수, solution을 완성하세요. 

예를 들어 s가 a234이면 False를 리턴하고 1234라면 True를 리턴하면 됩니다.

제한 사항

s는 길이 1 이상, 길이 8 이하인 문자열입니다.

```
입출력      예
s	        return
a234	    false
```

[문제링크](https://programmers.co.kr/learn/courses/30/lessons/12918)

## 제출한 풀이

```javascript
function solution(s) {
    return /^\d{6}$|^\d{4}$/.test(s) ;
}
```

처음에는 isNaN과 length로 검사해서 반환했지만 테스트 11에서 실패가 되었습니다.

이유를 찾아보니 테스트 케이스 11은 "1e22"의 지수형식을 가지고 있었습니다.

그래서 정규표현식으로 반환하였습니다.
