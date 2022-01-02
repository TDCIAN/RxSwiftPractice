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
