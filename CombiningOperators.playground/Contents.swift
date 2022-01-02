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
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

runner.onNext("runner1")
runner.onNext("runner1 runner2")
runner.onNext("runner1 runner2 runner3")

bang.onNext(Void())
bang.onNext(Void())

print("--- sample ---")
let start = PublishSubject<Void>()
let f1Player = PublishSubject<String>()

f1Player
    .sample(start)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

f1Player.onNext("🚗")
f1Player.onNext("🚗  🚙")
f1Player.onNext("🚗  🚙  🚕")
start.onNext(Void())
start.onNext(Void())
start.onNext(Void())

print("--- amb ---") // 모호함을 의미 -> 먼저 온 시퀀스만 방출하고 나머지는 보지 않는다.
let bus1 = PublishSubject<String>()
let bus2 = PublishSubject<String>()

let station = bus1.amb(bus2)

station
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

bus2.onNext("bus2 - passenger 0")
bus1.onNext("bus1 - passenger 0")
bus1.onNext("bus1 - passenger 1")
bus2.onNext("bus2 - passenger 1")
bus1.onNext("bus1 - passenger 2")
bus2.onNext("bus2 - passenger 2")

// bus2가 먼저 onNext 했기 때문에 그 뒤로는 bus2만 본다.

print("--- switchLatest ---")
let student1 = PublishSubject<String>()
let student2 = PublishSubject<String>()
let student3 = PublishSubject<String>()

let handUp = PublishSubject<Observable<String>>()

let handUpClass = handUp.switchLatest()

handUpClass
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

handUp.onNext(student1)
student1.onNext("student1: I'm a studen1")
student2.onNext("student2: Here!")

handUp.onNext(student2)
student2.onNext("student2: I'm a studen2")
student1.onNext("student1: It's my turn!")

handUp.onNext(student3)
student2.onNext("student2: No, it's my turn!")
student1.onNext("student1: What the,,,")
student3.onNext("student3: Hi I'm student3")

print("--- reduce ---")
Observable.from((1...10))
//    .reduce(0, accumulator: { summary, newValue in
//        return summary + newValue
//    })
//    .reduce(0) { summary, newValue in
//        return summary + newValue
//    }
    .reduce(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
