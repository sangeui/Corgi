## Entities (Enterprise Business Rules)

## Use Cases (Application Business Rules)

Corgi의 아키텍쳐는 다음과 같은 유스 케이스를 지원해야 한다.

- **북마크**
  - 북마크를 저장할 수 있어야 한다
  - 북마크를 가져올 수 있어야 한다
  - 북마크를 갱신할 수 있어야 한다
  - 북마크르 삭제하 수 있어야 한다
- **그룹**
  - 그룹을 가져올 수 있어야 한다
  - 그룹을 갱신할 수 있어야 한다
  - 그룹을 삭제할 수 있어야 한다
- **화면 표현 방식**
  - 화면 표현 방식을 가져올 수 있어야 한다
  - 화면 표현 방식을 갱신할 수 있어야 한다

## Data Access

- Use Cases에서 Data Access Interface르 정의하고, 데이터베이스에 대한 선택을 미룬다.

## Interface Adapters

- MVVM (Model·View·ViewModel)

UI를 분리하기 위해 MVVM을 선택했지만 뾰족한 이점으로 선택한 것은 아니다. 주로 View와 일대일 대응이 되도록 ViewModel을 작성했는데, MVP와 유사하다느 생각으 하게 됐다.
지금 당장은 UI와 비 UI를 나눴다는 것에 초점을 둔다.

## Diagrams

### 고수준 다이어그램
![1](https://user-images.githubusercontent.com/34618339/139712318-a8a39256-8ed3-49b1-99a8-e0008d345326.png)

### Use Cases 다이어그램 
![2](https://user-images.githubusercontent.com/34618339/139712538-62b049d4-8785-4807-b997-61dc6806e7ed.png)

### Interface Adapters 다이어그램
![3](https://user-images.githubusercontent.com/34618339/139712633-677322e1-76da-476e-a009-3416e16e0477.png)


