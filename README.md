# Microservice-Terraform-AWS
Creating distributed microservice system with Terraform and Ansible on AWS Cloud


<<<<<<< HEAD
=======
![image](https://user-images.githubusercontent.com/109453078/226564015-5afddb6d-ccaa-45a5-9b30-98caa901b3cb.png)


>>>>>>> 181c706ddb17fe1c2002909697a4eab465614ed3

Step1: Git Clone Microservice-Terraform-AWS Repo

Step2: Get inside Microservice-Terraform-AWS/Terraform Folder 
(command - terraform login, get Token from terraform cloud account, 
         - terraform init, 
         - terraform plan, 
         - terraform apply -auto-approve)

Step3: After Infra is prvisioned by Terraform, 4 instances' Public ip address will be there.
       Please, update these 4 ip address in the file named nats-address.env inside Microservice-Terraform-AWS/Ansible Folder and save.

Step4: Start executing Ansible Script 
(command - ansible-playbook -i inventory2.ini configure_instances.yml --ssh-extra-args='-F ssh.cfg')

Step5: Type the public ip address of API Instance with port 3000 in browser url
       (ip_address:3000/api/greeter/hello) -> it will call service1 then random number of service2 with show in browser
       (ip_address:3000/api/greeter/welcome?name=brian) -> it will show "Hello Brian"

Security Considerations:
1.Terraform script include Session Manager to access EC2 instances (to disable ssh port22)

2.Creating a key pair using Terraform is not recommended, as Terraform would store the private key in its state, which might not be secure. It's safer to create the key pair manually using the AWS Management Console or AWS CLI, and then reference the key pair name in your Terraform script.

[![Moleculer](https://badgen.net/badge/Powered%20by/Moleculer/0e83cd)](https://moleculer.services)

# moleculer-demo
This is a [Moleculer](https://moleculer.services/)-based microservices project. Generated with the [Moleculer CLI](https://moleculer.services/docs/0.14/moleculer-cli.html).

## Usage
Start the project with `npm run dev` command. 
After starting, open the http://localhost:3000/ URL in your browser. 
On the welcome page you can test the generated services via API Gateway and check the nodes & services.

In the terminal, try the following commands:
- `nodes` - List all connected nodes.
- `actions` - List all registered service actions.
- `call greeter.hello` - Call the `greeter.hello` action.
- `call greeter.welcome --name John` - Call the `greeter.welcome` action with the `name` parameter.



## Services
- **api**: API Gateway services
- **service1**: Sample service with `hello` and `welcome` actions.
- **service2**: Service which will send random number when service1 is called.


## Useful links

* Moleculer website: https://moleculer.services/
* Moleculer Documentation: https://moleculer.services/docs/0.14/

## NPM scripts

- `npm run dev`: Start development mode (load all services locally with hot-reload & REPL)
- `npm run start`: Start production mode (set `SERVICES` env variable to load certain services)
- `npm run cli`: Start a CLI and connect to production. Don't forget to set production namespace with `--ns` argument in script
- `npm run ci`: Run continuous test mode with watching
- `npm test`: Run tests & generate coverage report
- `npm run dc:up`: Start the stack with Docker Compose
- `npm run dc:down`: Stop the stack with Docker Compose
