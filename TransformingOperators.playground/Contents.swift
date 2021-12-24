import RxSwift

let disposeBag = DisposeBag()

print("--- toArray ---")
Observable.of("A", "B", "C")
    .toArray()
    .subscribe(onSuccess: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--- map ---")
Observable.of(Date())
    .map { date -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--- flatMap ---")
protocol Player {
    var score: BehaviorSubject<Int> { get }
}

struct Archer: Player {
    var score: BehaviorSubject<Int>
}

let korean = Archer(score: BehaviorSubject<Int>(value: 10))
let american = Archer(score: BehaviorSubject<Int>(value: 8))

let match = PublishSubject<Player>()

match
    .flatMap { player in
        player.score
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

match.onNext(korean)
korean.score.onNext(10)

match.onNext(american)
korean.score.onNext(10)
american.score.onNext(9)

print("--- flatMapLatest ---")
struct HighJumpPlayer: Player {
    var score: BehaviorSubject<Int>
}

let seoul = HighJumpPlayer(score: BehaviorSubject<Int>(value: 7))
let jeju = HighJumpPlayer(score: BehaviorSubject<Int>(value: 6))

let nationalMatch = PublishSubject<Player>()

nationalMatch
    .flatMapLatest { player in
        player.score
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

nationalMatch.onNext(seoul)
seoul.score.onNext(9)

nationalMatch.onNext(jeju)
seoul.score.onNext(10)
jeju.score.onNext(8)

print("--- materialize and dematerialize ---")
enum Foul: Error {
    case invalidStart
}

struct Runner: Player {
    var score: BehaviorSubject<Int>
}

let kimRabbit = Runner(score: BehaviorSubject<Int>(value: 0))
let parkCheeta = Runner(score: BehaviorSubject<Int>(value: 1))

let run100M = BehaviorSubject<Player>(value: kimRabbit)

run100M
    .flatMapLatest { player in
        player.score
            .materialize()
    }
    .filter {
        guard let error = $0.error else {
            return true
        }
        print(error)
        return false
    }
    .dematerialize()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

kimRabbit.score.onNext(1)
kimRabbit.score.onError(Foul.invalidStart)
kimRabbit.score.onNext(2)

run100M.onNext(parkCheeta)

print("--- 전화번호 11자리 ---")
let input = PublishSubject<Int?>()

let list: [Int] = [1]

input
    .flatMap {
        $0 == nil ? Observable.empty() : Observable.just($0)
    }
    .map { $0! }
    .skip(while:  { $0 != 0 }) // 핸드폰번호는 0으로 시작하니까
    .take(11) // 11자리
    .toArray()
    .asObservable()
    .map {
        $0.map {"\($0)"}
    }
    .map { numbers in
        var numberList = numbers
        numberList.insert("-", at: 3)
        numberList.insert("-", at: 8)
        let number = numberList.reduce(" ", +)
        return number
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

input.onNext(10)
input.onNext(0)
input.onNext(nil)
input.onNext(1)
input.onNext(0)
input.onNext(9)
input.onNext(2)
input.onNext(1)
input.onNext(2)
input.onNext(9)
input.onNext(9)
input.onNext(0)
input.onNext(4)
