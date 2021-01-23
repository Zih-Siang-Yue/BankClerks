# BankClerk

模擬銀行行員接待顧客之行為，顧客會在抽出號碼牌時(按下按鈕)，被系統分配到對應號碼之行員
每個行員之處理速度不同(在創建時會隨機取樣)
若等待人數超過行員人數，會出現在waitings 之欄位，等待行員有空時，系統會在進行任務分配

## Installation

此專案需要使用 CocoaPods 安裝第三方套件
請先確認電腦裡是否已安裝了 CocoaPods
若已安裝請直接參考Usage 步驟即可
若尚未安裝請遵從以下網址步驟進行安裝
https://cocoapods.org/

## Usage

1. 使用終端機切換路徑到該資料夾底下
2. 打開Podfile，確認其內容有以下敘述
```
pod 'RxSwift', '5.0.0'
pod 'RxCocoa', '5.0.0'
```

並使用以下指令安裝第三方套件
```
pod install
```

3. 結束後便可打開.xcworkspace 檔案，開啟Xcode build app


## Note

資料夾底下有附贈 BankClerkUML.pdf檔案
裡面有大致的類別階層關係圖，請參考其內容並搭配程式碼閱讀
若有其餘問題再麻煩來信或致電詢問

