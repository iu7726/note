# 크레인 인형 뽑기

## 문제

[문제보기](https://programmers.co.kr/learn/courses/30/lessons/64061)


## 제출한 답

```javascript
function solution(board, moves) {
    var answer = 0;
    
    let basket = [];
    
    let last = 0;
    let pick = 0;
    
    moves.map(move => {
        
        for(let i = 0; i < board.length ; i ++){
            
            let line = board[i];
            
            pick = line[(move-1)];
            
            if(pick == 0) continue;

            last = basket.pop();

            if(last == pick){
                
                answer+=2;
                
            }else if(last){
                
                basket.push(last);
                basket.push(pick);
                
            }else{
                
                basket.push(pick)
                
            }

            line[(move-1)] = 0;
            
            break;
            
        }
            
    })

    return answer;
}
```

5X5부터 100X100까지의 2차원 배열로 이루어져있으며 크레인이 내려갈 때 해당 index의 배열의 값이 있는지 확인합니다.

만약 0이라면 인형이 없다는 뜻으로 `continue`을 이용하여 다음으로 넘어갑니다.

> if로 감싸는 것보다 continue로 넘어가는게 속도가 훨씬 빨랐습니다.

만약 인형을 집었다면 바구니의 마지막 인형과 비교를 합니다.

비교 후 같은 인형이라면 count를 +2합니다.

아니라면 바구니에 마지막인형, 집은 인형을 순서대로 다시 배열에 집어 넣습니다.

그리고 인형을 집은 배열의 값은 0으로 바꿔줍니다.

마지막으로 `break`를 사용하여 불필요한 반복문에서 탈출합니다.




