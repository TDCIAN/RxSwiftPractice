import RxSwift

let disposeBag = DisposeBag()
print("--- ignoreElements")
let sleepMode = PublishSubject<String>()

sleepMode
    .ignoreElements()
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)

sleepMode.onNext("😽")
sleepMode.onNext("😽")
sleepMode.onNext("😽")

sleepMode.onCompleted()

print("----- elementAt -----")
let wakeUpWithTwoAlarm = PublishSubject<String>()

wakeUpWithTwoAlarm
    .element(at: 4)
    .subscribe(onNext: {
       print($0)
    })
    .disposed(by: disposeBag)

wakeUpWithTwoAlarm
    .onNext("🤣")
wakeUpWithTwoAlarm
    .onNext("🤣")
wakeUpWithTwoAlarm
    .onNext("🤪")
wakeUpWithTwoAlarm
    .onNext("😡")
