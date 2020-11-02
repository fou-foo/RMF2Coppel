echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

sudo apt-get  -y install apt-transport-https ca-certificates gnupg
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get -y install google-cloud-sdk
sudo apt-get -y install google-cloud-sdk-app-engine-python
gcloud config set proxy/type http
gcloud config set proxy/address http://10.43.234.62
gcloud config set proxy/port 8080
sudo apt-get update && sudo apt-get --only-upgrade install google-cloud-sdk-cloud-build-local google-cloud-sdk-datalab google-cloud-sdk-app-engine-java google-cloud-sdk-pubsub-emulator google-cloud-sdk-minikube google-cloud-sdk-cbt google-cloud-sdk-kpt google-cloud-sdk-app-engine-python-extras google-cloud-sdk-bigtable-emulator google-cloud-sdk-spanner-emulator google-cloud-sdk-app-engine-grpc google-cloud-sdk-firestore-emulator google-cloud-sdk-app-engine-go kubectl google-cloud-sdk-kind google-cloud-sdk google-cloud-sdk-anthos-auth google-cloud-sdk-datastore-emulator google-cloud-sdk-app-engine-python google-cloud-sdk-skaffold
sudo apt-get -y install google-cloud-sdk-cbt


