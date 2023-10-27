run "instance type test" {
  command = plan
  assert {
    condition = aws_instance.ec2.instance_type == "t2.micro" # テストする内容
    error_message = "インスタンスタイプが違うよ！" # 失敗したときのメッセージ
  }
}

run "instance ip test" {
  command = apply
  assert {
    condition = substr(aws_instance.ec2.private_ip, 0, 7) == "10.0.1." # テストする内容
    error_message = "IPアドレスが想定と違うよ！" # 失敗したときのメッセージ
  }
}
