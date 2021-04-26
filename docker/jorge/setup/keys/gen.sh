cd /etc/sawtooth/keys
mkdir all

for i in {1..20}; do
    sawadm keygen
    mv validator.priv ./all/validator-${i}.priv
    mv validator.pub ./all/validator-${i}.pub
done