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

# Create db snapshot
aws rds create-db-snapshot --db-instance-identifier 'qtrdsfromclimulti' `
    --db-snapshot-identifier 'snapshotfromcli'

# Delete db snapshot
aws rds delete-db-snapshot --db-snapshot-identifier 'snapshotfromcli'

# Promote read replica
aws rds promote-read-replica --db-instance-identifier 'qtrdsreplica'

# Delete the db-instance
aws rds delete-db-instance --db-instance-identifier 'qtrdsreplica'`
    --skip-final-snapshot --delete-automated-backups

# Create a read replica in different region 
# ARN: arn:aws:rds:<region>:<account number>:<resourcetype>:<name>
aws rds create-db-instance-read-replica --db-instance-identifier 'qtrdsreplica' `
    --source-db-instance-identifier 'arn:aws:rds:us-west-2:678879106782:db:qtrdsfromclimulti' `
    --publicly-accessible `
    --source-region 'us-west-2' --region 'ap-south-1'

aws rds delete-db-instance --db-instance-identifier 'qtrdsreplica'`
    --skip-final-snapshot --delete-automated-backups --region 'ap-south-1'

aws rds delete-db-instance --db-instance-identifier 'qtrdsfromclimulti'`
    --skip-final-snapshot --delete-automated-backups 






