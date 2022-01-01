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


print("--- combineLatest1 ---")
let lastName = PublishSubject<String>()
let firstName = PublishSubject<String>()

let fullName = Observable
    .combineLatest(lastName, firstName) { lastName, firstName in
        lastName + firstName
    }

fullName
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

lastName.onNext("김")
firstName.onNext("똘똘")
firstName.onNext("명수")
firstName.onNext("은영")
firstName.onNext("재석")
lastName.onNext("이")
lastName.onNext("박")
lastName.onNext("최")


print("--- combineLatest2 ---")
let dateFormat = Observable<DateFormatter.Style>.of(.short, .long)
let currentDate = Observable.of(Date())

let showCurrentDate = Observable
    .combineLatest(
        dateFormat,
        currentDate,
        resultSelector: { dateformat, currentdate -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = dateformat
            return dateFormatter.string(from: currentdate)
        }
    )

showCurrentDate
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--- combineLatest3 ---")
let lastName2 = PublishSubject<String>()
let firstName2 = PublishSubject<String>()

let fullName2 = Observable
    .combineLatest([lastName2, firstName2]) { name in
        name.joined(separator: " ")
    }

fullName2
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

lastName2.onNext("Kim")
firstName2.onNext("Paul")
firstName2.onNext("Stella")
firstName2.onNext("Lily")

print("--- zip ---")
enum Consequence {
    case win
    case lose
}

let result = Observable<Consequence>.of(.win, .win, .lose, .win, .lose)
let player = Observable<String>.of("Korea", "Swiss", "USA", "Brasil", "Japan", "China")

let matchResult = Observable
    .zip(result, player) { result, represent in
        return represent + "선수" + " \(result)"
    }

matchResult
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--- withLatestFrom1 ---")
let bang = PublishSubject<Void>()
let runner = PublishSubject<String>()

bang
    .withLatestFrom(runner)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

runner.onNext("runner1")
runner.onNext("runner1 runner2")
runner.onNext("runner1 runner2 runner3")

bang.onNext(Void())
bang.onNext(Void())

