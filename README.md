# 🚀 Tuna-Onboarding

![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS-blue.svg)
![Deployment Target](https://img.shields.io/badge/iOS-15.0+-lightgrey.svg)
![SwiftUI/UIKit](https://img.shields.io/badge/UI-SwiftUI%20%2F%20UIKit-brightgreen.svg)

**Tuna-Onboarding**, iOS geliştirme ekibine yeni katılan geliştiricilerin projeye, kod standartlarına ve teknoloji yığınına hızlıca adapte olabilmesi için tasarlanmış kapsamlı bir başlangıç (onboarding) projesidir.

## 📌 Projenin Amacı

Bu depo, bir iOS geliştiricisinin proje ortamını kurmasını, mimari yapıyı anlamasını ve projedeki temel akışları (Network, Storage, UI vb.) kavrayabilmesini sağlamak amacıyla oluşturulmuştur.

## 🛠 Kullanılan Teknolojiler & Kütüphaneler

Bu projede modern iOS geliştirme standartları takip edilmiştir:

- **Dil:** Swift
- **Mimari:** MVVM (Model-View-ViewModel) / Clean Architecture (Tercihinize göre düzenleyin)
- **UI:** SwiftUI veya UIKit (Programmatic/Storyboard)
- **Network:** URLSession / Alamofire
- **Bağımlılık Yönetimi:** Swift Package Manager (SPM) / CocoaPods
- **Diğer:** Combine / Swift Concurrency (Async-Await)

## 🚀 Kurulum (Setup)

Projeyi yerel makinenizde çalıştırmak için şu adımları izleyin:

1. **Repoyu klonlayın:**
   ```bash
   git clone [https://github.com/tunaarikaya/Tuna-Onboarding.git](https://github.com/tunaarikaya/Tuna-Onboarding.git)

```

2. **Proje dizinine gidin:**
```bash
cd Tuna-Onboarding

```


3. **Bağımlılıkları yükleyin (Eğer CocoaPods kullanıyorsanız):**
```bash
pod install

```


4. **Xcode ile projeyi açın:**
```bash
open TunaOnboarding.xcworkspace # veya .xcodeproj

```



## 🏗 Mimari Yapı

Proje, sürdürülebilir ve test edilebilir bir yapı için aşağıdaki klasörleme düzenini takip eder:

* `Source/`
* `Scenes/`: Ekran bazlı klasörleme (View, ViewModel)
* `Network/`: API servisleri ve Request/Response modelleri
* `Core/`: Ortak bileşenler, Extension'lar ve Utils
* `Resources/`: Asset'ler, Fontlar ve Yerelleştirme dosyaları



## 📝 Kod Standartları

* [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) takip edilmektedir.
* Kod stilini korumak için (varsa) **SwiftLint** kullanılmaktadır.
* Değişken ve fonksiyon isimlendirmelerinde *camelCase* tercih edilir.

## 🎯 Onboarding Görevleri

Yeni katılan arkadaşların tamamlaması beklenen örnek görevler:

* [ ] Bir API endpoint'inden veri çekip listeleme.
* [ ] Mevcut bir ekrana yeni bir UI bileşeni ekleme.
* [ ] Birim test (Unit Test) yazma süreci.

## 🤝 Katkıda Bulunma

1. Bu projeyi çatallayın (Fork).
2. Yeni bir özellik dalı (Branch) oluşturun (`git checkout -b feature/YeniOzellik`).
3. Değişikliklerinizi kaydedin (`git commit -m 'Yeni özellik eklendi'`).
4. Dalınızı gönderin (`git push origin feature/YeniOzellik`).
5. Bir Çekme İsteği (Pull Request) oluşturun.

## ✉️ İletişim

**Mehmet Tuna Arıkaya** - GitHub: [@tunaarikaya](https://www.google.com/search?q=https://github.com/tunaarikaya)

* LinkedIn: [Tuna Arıkaya](https://www.google.com/search?q=https://www.linkedin.com/in/tunaarikaya)

---

⭐️ Bu proje size yardımcı olduysa bir yıldız bırakmayı unutmayın!
