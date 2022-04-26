# genomics_test
All instructions are for Ubuntu 20.04 using BASH in a terminal

## Install NVM, Node & Serverless
```
sudo apt install curl 
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 
source ~/.profile  
nvm install 14
npm install -g serverless
```

## Please ensure you have exported your aws credentials into your shell
An Optional method to get a great bash experience via https://github.com/meatware/sys_bashrc

```
cd
git clone https://github.com/meatware/sys_bashrc.git
mv .bashrc .your_old_bashrc
ln -fs ~/sys_bashrc/_bashrc ~/.bashrc
source ~/.bashrc
```

# use awskeys command to easily export aws key as env variables
awskeys help
awskeys list
awskeys export default

## Serverless deploy
```

cd serverless/exif-ripper
serverless plugin install -n serverless-python-requirements
serverless plugin install -n serverless-stack-output
serverless deploy --stage dev --region eu-west-1
```
