# terraform-ec2-sample
2023/10/30のJAWS-UG東京でLTするための検証用リポジトリ


# terraform testコマンドの実験
terraform v1.6.0で実装されたtestコマンドを実験するためのリソースを格納

## test用ファイルの書き方
基本構成
* `*.tftest.hcl`または`*.tftest.json`に記載する
* runブロックに各テスト項目を記載する
* command句に`plan`か`apply`を指定する
　* plan：リソースをプロビジョニングせずに静的な値をテストする
　* apply：リソースをプロビジョニングして構築後に設定される動的な値をテストする（EC2のIP等）
* assertブロックのconditionに実際にテストする内容、error_messageにエラー時のメッセージを記載する

```例
run "instance type test" {
  command = plan
  assert {
    condition = aws_instance.ec2.instance_type == "t2.micro" # テストする内容
    error_message = "インスタンスタイプが違うよ！" # 失敗したときのメッセージ
  }
}
```

## 01-normal
標準の形式で、すべてのファイルを同一フォルダ内で管理する構成

```
terraform test
```


## 02-split-folder
テスト用ファイルをフォルダを分けて管理する構成

```
terraform test -test-directory='main.tfからテストフォルダへの相対パス'
```

