# 체육복

## 문제

[문제 링크](https://programmers.co.kr/learn/courses/30/lessons/42862)

## 제출한 답

```javascript
function solution(n, lost, reserve) {
    var count = 0;
    var have = 0;
    
    reserve = reserve.filter(i => {
        if(lost.includes(i)){
            
            delete lost[lost.indexOf(i)]
            have++;
            return false;
            
        }else{
            return i;    
        }
    
    });
    
    count = lost.length;

    lost.map(l => {

        for(var i in reserve){
            
            if(reserve[i] != (l-1) && reserve[i] != (l+1)) continue;
            
            delete reserve[i];
            
            if(count > 0){
                count--;    
            }

            break;
            
        }
        
    })
    
    return n - count + have;
}
```

먼저 체육복을 여벌로 가져왔지만 도둑맞은 학생들을 구합니다.

이런 학생들은 체육복을 도둑 맞았지만 자기가 입을 체육복이 있기때문에 수업에 참가하는 사람 수에 더하고 도둑맞은 학생 리스트, 여벌로 가져온 학생의 리스트에서 제거합니다.

도둑맞은 학생들을 반복문으로 여벌의 체육복을 가져온 학생들과 비교를 합니다.

비교하여 자신보다 ±1인 경우 도둑맞은 학생 수에서 차감합니다.

### 주의사항

이번 문제는 제약 사항을 잘 봐야됩니다.

여벌로 가져온 학생도 도둑을 맞을 수 있으며 이러한 경우 자기 자신의 체육복을 입는다고 되어있습니다.

이 부분을 조심해서 코드를 작성하면 되겠습니다.

