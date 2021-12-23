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
