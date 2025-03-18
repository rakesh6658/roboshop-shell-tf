

servers=$@
instance_type=""
imageid="ami-09c813fb71547fc4f" 
securityid="sg-0dc7448f0fa6926f1"
domain_name=joindevops.store
hostedzoneid=Z0391488M5DNTAYOTVFM


for i in $@
do
if [[ $i == "mongodb" || $i == "mysql" ]]
then
instance_type="t3.micro"
else
instance_type="t2.micro"
fi

privateip=$(aws ec2 run-instances --image-id $imageid --instance-type $instance_type --security-group-ids $securityid --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value="$i"}]"  | jq -r ".Instances[0].PrivateIpAddress")
echo "$i private ip address $privateip"
aws route53 change-resource-record-sets --hosted-zone-id $hostedzoneid --change-batch '
    {
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                            "Name": "'$i.$domain_name'",
                            "Type": "A",
                            "TTL": 300,
                            "ResourceRecords": [{ "Value": "'$privateip'"}]
                        }}]
    }
'
done