aws rds create-db-instance --db-instance-identifier 'qtrdsfromcli' `
    --db-instance-class 'db.t2.micro' --engine 'mysql' `
    --master-username 'root' --master-user-password 'rootroot' `
    --publicly-accessible --db-name 'qtecommerce'  `
    --db-subnet-group-name 'qtsubnetgroup' --allocated-storage 20

aws rds describe-db-instances --db-instance-identifier 'qtrdsfromcli' 

aws rds describe-db-instances --db-instance-identifier 'qtrdsfromcli'`
    --query 'DBInstances[0].DBInstanceStatus'

aws rds describe-db-instances --db-instance-identifier 'qtrdsfromcli' `
    --query 'DBInstances[0].Endpoint'

aws rds delete-db-instance --db-instance-identifier 'qtrdsfromcli'`
    --skip-final-snapshot --delete-automated-backups

aws rds create-db-instance --db-instance-identifier 'qtrdsfromclimulti' `
    --db-instance-class 'db.t2.micro' --engine 'mysql' `
    --master-username 'root' --master-user-password 'rootroot' `
    --publicly-accessible --db-name 'qtecommerce'  `
    --db-subnet-group-name 'qtsubnetgroup' --allocated-storage 20 `
    --multi-az --vpc-security-group-ids 'sg-0c8eee8f2fbefd89e'


aws rds create-db-instance-read-replica --db-instance-identifier 'qtrdsreplica' `
    --source-db-instance-identifier 'qtrdsfromclimulti' --publicly-accessible `
    --source-region 'us-west-2'

    
