function ec2() {
    # $1 public IP
    # $2 PemKey
    ssh ec2-user@$1 -i ~/.ssh/$2
}