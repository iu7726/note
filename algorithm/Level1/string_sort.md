# 문자열 내림차순으로 정렬하기

## 문제

문자열 s에 나타나는 문자를 큰것부터 작은 순으로 정렬해 새로운 문자열을 리턴하는 함수, solution을 완성해주세요.

s는 영문 대소문자로만 구성되어 있으며, 대문자는 소문자보다 작은 것으로 간주합니다.

제한 사항

str은 길이 1 이상인 문자열입니다.

```
입출력 예
s	    return
Zbcdefg	gfedcbZ
```

[문제링크](https://programmers.co.kr/learn/courses/30/lessons/12917)

## 제출한 답

```javascript
function solution(s) {
    return s.split('').sort((a,b) => a > b ? -1 : a < b ? 1 : 0).join('');
}
```

split으로 문자열을 배열로 만든 후 sort로 object 정렬에서 사용하는 방식으로 정렬한 다음 join으로 다시 문자열로 만듭니다.