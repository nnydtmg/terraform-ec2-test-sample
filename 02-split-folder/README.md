# フォルダを分けたい場合
terraform test -test-directory='テストファイルフォルダパス'

例）以下構成の場合
.
├main.tf
└test/
   └main.tftest.hcl
```
terraform test -test-directory=test/
```