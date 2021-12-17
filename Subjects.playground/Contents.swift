import RxSwift

let disposeBag = DisposeBag()
print("--- publishSubject ---")
let publishSubject = PublishSubject<String>()

publishSubject.onNext("여러분 안녕하세요?")

let 구독자1 = publishSubject
    .subscribe(onNext: {
        print($0)
    })

publishSubject.onNext("들리세요?")
publishSubject.on(.next("안들리시나요?"))

구독자1.dispose()

let 구독자2 = publishSubject
    .subscribe(onNext: {
        print($0)
    })

publishSubject.onNext("4. 여보세요")
publishSubject.onCompleted()

publishSubject.onNext("5. 끝났나요")

