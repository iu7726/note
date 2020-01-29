# Class명을 변수에 담긴 값으로 지정하고싶을 때

## 개요
component의 class명이 변수에 담긴 값이여야할 때 <br>
*공식 문서를 잘 읽자...*

## 방법

<br>
```html
<btn cls="className" :class="`class_{argVal}`">
```
<br>

## 설명<br>
btn - button 컴포넌트<br>
cls - pros<br>
class_ - String<br>
{argVal} - 변수입력<br>

## 주의<br>
:class에 입력할때는 억음(backticks, `)로 감싸줘야합니다.<br>
