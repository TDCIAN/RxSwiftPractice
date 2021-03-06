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

sleepMode.onNext("π½")
sleepMode.onNext("π½")
sleepMode.onNext("π½")

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
    .onNext("π€£")
wakeUpWithTwoAlarm
    .onNext("π€£")
wakeUpWithTwoAlarm
    .onNext("π€ͺ")
wakeUpWithTwoAlarm
    .onNext("π‘")

print("---- filter ----")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8) // [1, 2, 3, 4, 5, 6, 7, 8]
    .filter { $0 % 2 == 0 }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---- skip ----")
Observable.of("κ°", "λ", "λ€", "λΌ", "λ§", "λ°", "μ¬")
    .skip(5)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---- skipWhile ----")
Observable.of("κ°", "λ", "λ€", "λΌ", "λ§", "λ°", "μ¬")
    .skip(while: {
        $0 != "λ€"
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---- skipUntil ----")
let guest = PublishSubject<String>()
let openTime = PublishSubject<String>()

guest
    .skip(until: openTime)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

guest.onNext("μ²«μλ")
guest.onNext("λμ§Έμλ")
guest.onNext("μμ§Έμλ")
openTime.onNext("λ‘!")
guest.onNext("λ·μ§Έμλ")
guest.onNext("λ€μ―μ§Έμλ")


print("---- take ----")
Observable.of("κΈ", "μ", "λ", "μ² ", "κ΅¬λ¦¬")
    .take(2)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---- takeWhile ----")
Observable.of("κΈ", "μ", "λ", "μ² ", "κ΅¬λ¦¬")
    .take(while: {
        $0 != "μ² "
    })
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

print("---- enumerated ----")
Observable.of("κΈ", "μ", "λ", "μ² ", "κ΅¬λ¦¬")
    .enumerated()
    .takeWhile {
        $0.index < 3
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---- takeUntil ----")
let checkOne = PublishSubject<String>()
let checkTwo = PublishSubject<String>()

checkOne
    .take(until: checkTwo)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

checkOne.onNext("μ¬")
checkOne.onNext("λ¨")

checkTwo.onNext("λ")
checkOne.onNext("λ€λ₯Έλ¨")

print("---- distincUntilChanged ----")
Observable.of("μ λ", "μ λ", "μ΅λ¬΄μ", "μ΅λ¬΄μ", "μ΅λ¬΄μ", "μ΅λ¬΄μ", "μλλ€", "μλλ€")
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
