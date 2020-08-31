# 124 나라의 숫자

## 문제

124 나라가 있습니다. 

124 나라에서는 10진법이 아닌 다음과 같은 자신들만의 규칙으로 수를 표현합니다.

124 나라에는 자연수만 존재합니다.

124 나라에는 모든 수를 표현할 때 1, 2, 4만 사용합니다.

예를 들어서 124 나라에서 사용하는 숫자는 다음과 같이 변환됩니다.

```
10진법	124 나라	10진법	124 나라
1	    1	        6	   14
2	    2	        7	    21
3	    4	        8	    22
4	    11	        9	    24
5	    12	        10	    41
```

자연수 n이 매개변수로 주어질 때, n을 124 나라에서 사용하는 숫자로 바꾼 값을 return 하도록 solution 함수를 완성해 주세요.

제한사항

n은 500,000,000이하의 자연수 입니다.

입출력 예

```
n	result
1	1
2	2
3	4
4	11
```

[문제링크](https://programmers.co.kr/learn/courses/30/lessons/12899)

## 제출한 풀이

```javascript
function solution(n) {
    
    let answer = "";
    let rule = ["4","1","2"]
    
    while(n > 0){
        
        let tmp = n % 3;
        n = Math.floor(n / 3);
        
        if(tmp == 0) n -= 1;
        
        answer = rule[tmp] + answer;
        
    }
    
    return answer;
}
```

진법 변환 알고리즘을 적용해야합니다.

> 몫을 진법으로 나눠가면서 notation 보다 작아질 때 까지 반복합니다.<br>
몫이 notation 보다 작아졌다면 반복문을 탈출한 뒤, 몫을 변환 결과 앞에 추가시켜줍니다.<br>
notation : 표기법으로 3개의 진법으로 표기하고 있으므로 3입니다.

다른 사람 코드를 보니 더 좋은 코드가 있어 공유합니다. while문이 아니라 재귀함수를 이용하여 풀으셨습니다.

```javascript
function solution(n) {
  return n === 0 ? '' : solution(parseInt((n - 1) / 3)) + [1, 2, 4][(n - 1) % 3];
}
```