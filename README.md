The example project for StringBoot service

<div align="center">
    <img src="./assets/images/spring_boot_icon.png"/>
</div>

## Getting Started

## Project structure
```
.
├── hello-world
│   ├── src
|   ├── pom.xml
│   ...
├── terraform
|
└── README.md
```

## Prerequisites
- Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)

Make sure that you have a [Amazon Account](https://aws.amazon.com/account/) and configurate aws account in ~/.aws/credentials
```
[default]
aws_access_key_id=<your-key>
aws_secret_access_key=<your-key>
```

- Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

- Install [Docker](https://docs.docker.com/engine/install/)
    
## Build and deploy

First, you need add your aws account id

Add ```export AWS_ACCOUNT_ID=<your acccount id>``` in file ~/.bash_profile then 
```shell script
$ source ~/.bash_profile
```

Test by command
```shell script
$ echo $AWS_ACCOUNT_ID
<your account id>
```


### Initiative resource

```shell script
$ make init
````

### Build spring-boot application

```shell script
$ make build
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  15.346 s
[INFO] Finished at: 2022-10-20T10:04:11+07:00
[INFO] ------------------------------------------------------------------------
```

### Build docker image & push to ECR

```shell script
$  make push
```

### Deploy resource on AWS

```shell script
$ make deploy
Apply complete! Resources: 35 added, 0 changed, 0 destroyed.

Outputs:

alb_hostname = "<your alb_hostname>"
```

### Destroy resource 

```shell script
$ make destroys

```

## Test request

Send request to your AWS LoadBalancer

```shell script
$ curl http://<alb_hostname>/greet?name=World
Hello World!
```

## Contributing

The code is open sourced. I encourage fellow developers to contribute and help improve it!

- Fork it
- Create your feature branch (git checkout -b new-feature)
- Ensure all tests are passing
- Commit your changes (git commit -am 'Add some feature')
- Push to the branch (git push origin my-new-feature)
- Create new Pull Request

## Reference
- https://github.com/bradford-hamilton/terraform-ecs-fargate
- https://docs.aws.amazon.com/AmazonECR/latest/userguide/getting-started-cli.html
- https://medium.com/@bradford_hamilton/deploying-containers-on-amazons-ecs-using-fargate-and-terraform-part-2-2e6f6a3a957f

## License
This project is licensed under the Apache License v2.0. Please see LICENSE located at the project's root for more details.