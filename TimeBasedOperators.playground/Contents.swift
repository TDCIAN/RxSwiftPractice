import RxSwift

let disposeBag = DisposeBag()

print("--- replay ---")
let hello = PublishSubject<String>()
let parrot = hello.replay(1)
parrot.connect()

hello.onNext("1. hello")
hello.onNext("2. hi")

parrot
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

hello.onNext("3. 안녕하세요")

print("--- replayAll ---")
let doctorStrange = PublishSubject<String>()
let timeStone = doctorStrange.replayAll()
timeStone.connect()

doctorStrange.onNext("도르마무")
doctorStrange.onNext("거래를 하러왔다")

timeStone
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--- buffer ---")
let source = PublishSubject<String>()

var count = 0
let timer = DispatchSource.makeTimerSource()

timer.schedule(deadline: .now() + 2, repeating: .seconds(1))
timer.setEventHandler {
    count += 1
    source.onNext("\(count)")
}
timer.resume()

source
    .buffer(
        timeSpan: .seconds(2),
        count: 2,
        scheduler: MainScheduler.instance
    )
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--- window ---")
let maxObervableCount = 1
let timeToMake = RxTimeInterval.seconds(2)

let window = PublishSubject<String>()

let windowCount = 0

