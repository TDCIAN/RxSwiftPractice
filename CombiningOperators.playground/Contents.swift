import RxSwift

let disposeBag = DisposeBag()

print("--- startWith ---")
let yellow = Observable<String>.of("학생1", "학생2", "학생3")

yellow
    .enumerated()
    .map { index, element in
        element + "어린이" + "\(index)"
    }
    .startWith("선생님")
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--- concat1 ---")
let yellowClass = Observable<String>.of("학생1", "학생2", "학생3")
let teacher = Observable<String>.of("선생님")

let walkInLine = Observable
    .concat([teacher, yellowClass])

walkInLine
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--- concat2 ---")
teacher
    .concat(yellowClass)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--- concatMap ---")
let kindergarten: [String: Observable<String>] = [
    "노랑반": Observable.of("노랑1", "노랑2", "노랑3"),
    "파랑반": Observable.of("파랑1", "파랑2")
]

Observable.of("노랑반", "파랑반")
    .concatMap { kidsClass in
        kindergarten[kidsClass] ?? .empty()
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--- merge1 ---")
let gangbook = Observable.from(["강북구", "성북구", "동대문구", "종로구"])
let gangnam = Observable.from(["강남구", "강동구", "영등포구", "양천구"])

Observable.of(gangbook, gangnam)
    .merge() // 순서가 보장되진 않는다
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--- merge2 ---")
Observable.of(gangbook, gangnam)
    .merge(maxConcurrent: 1) // Observable을 1개씩만 봐라
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
