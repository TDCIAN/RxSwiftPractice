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

print("---- filter ----")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8) // [1, 2, 3, 4, 5, 6, 7, 8]
    .filter { $0 % 2 == 0 }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---- skip ----")
Observable.of("가", "나", "다", "라", "마", "바", "사")
    .skip(5)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---- skipWhile ----")
Observable.of("가", "나", "다", "라", "마", "바", "사")
    .skip(while: {
        $0 != "다"
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

guest.onNext("첫손님")
guest.onNext("둘째손님")
guest.onNext("셋째손님")
openTime.onNext("땡!")
guest.onNext("넷째손님")
guest.onNext("다섯째손님")


print("---- take ----")
Observable.of("금", "은", "동", "철", "구리")
    .take(2)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---- takeWhile ----")
Observable.of("금", "은", "동", "철", "구리")
    .take(while: {
        $0 != "철"
    })
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

print("---- enumerated ----")
Observable.of("금", "은", "동", "철", "구리")
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

checkOne.onNext("여")
checkOne.onNext("남")

checkTwo.onNext("끝")
checkOne.onNext("다른남")

print("---- distincUntilChanged ----")
Observable.of("저는", "저는", "앵무새", "앵무새", "앵무새", "앵무새", "입니다", "입니다")
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
