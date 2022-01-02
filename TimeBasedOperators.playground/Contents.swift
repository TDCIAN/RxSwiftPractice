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
//let maxObervableCount = 5
//let timeToMake = RxTimeInterval.seconds(2)
//
//let window = PublishSubject<String>()
//
//var windowCount = 0
//let windowTimerSource = DispatchSource.makeTimerSource()
//windowTimerSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
//windowTimerSource.setEventHandler {
//    windowCount += 1
//    window.onNext("\(windowCount)")
//}
//windowTimerSource.resume()
//
//window
//    .window(
//        timeSpan: timeToMake,
//        count: maxObervableCount,
//        scheduler: MainScheduler.instance
//    )
//    .flatMap { windowObservable -> Observable<(index: Int, element: String)> in
//        return windowObservable.enumerated()
//    }
//    .subscribe(onNext: {
//        print("\($0.index)번째 Observable의 요소 \($0.element)")
//    })
//    .disposed(by: disposeBag)

