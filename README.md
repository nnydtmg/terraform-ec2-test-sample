# terraform-ec2-sample
2023/10/30のJAWS-UG東京でLTするための検証用リポジトリ


# terraform testコマンドの実験
terraform v1.6.0で実装されたtestコマンドを実際に実験するためのリソースを格納

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

