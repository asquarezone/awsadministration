$key_pair = aws ec2 describe-key-pairs --query "KeyPairs[0].KeyName"
Write-Host $key_pair