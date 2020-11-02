sudo apt-get update
sudo apt-get install     apt-transport-https     ca-certificates     curl     gnupg-agent     software-prope
rties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo docker run     --name testneo4j     -p7474:7474 -p7687:7687     -d     -v $HOME/neo4j/data:/data     -v
 $HOME/neo4j/logs:/logs     -v $HOME/neo4j/import:/var/lib/neo4j/import     -v $HOME/neo4j/plugins:/plugins     --e
nv NEO4J_AUTH=neo4j/test     neo4j:latest
gsutil cp gs://recobucket/datostonio/desarrollofast/demograficos_compresos/demograficos_compresos.csv .
gsutil cp gs://recobucket/datostonio/desarrollofast/LoadCLientes.cyp 