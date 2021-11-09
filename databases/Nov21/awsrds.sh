aws rds create-db-instance --db-instance-identifier 'qtrdsfromcli' \
    --db-instance-class 'db.t2.micro' --engine 'mysql' \
    --master-username 'root' --master-user-password 'rootroot' \
    --publicly-accessible --db-name 'qtecommerce'  \
    --db-subnet-group-name 'qtsubnetgroup' --allocated-storage 20