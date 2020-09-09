# n 진수 게임

## 문제

[문제링크](https://programmers.co.kr/learn/courses/30/lessons/17687)

## 제출한 풀이

```javascript
function solution(n, t, m, p) {
    var answer = '';
    let num = "";
    let numAry = [];
    
    let i = 0
    while(num.length <= t*m){
        num += i.toString(n).toUpperCase()
        i++;
    }
    
    for(let i = 0; i < num.length; i+=m){
        numAry.push(num.substr(i,m))
    }

    for(let i in numAry){
        answer += numAry[i].split('')[p-1]
        if(answer.length == t) break;
    }
    
    return answer
}
```