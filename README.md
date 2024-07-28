# ECS EC2 Application Stack Module

> Module to create an ECS EC2 Application Stack

## Requirements & Providers

| Name                                                                                                                  | Version     |
|-----------------------------------------------------------------------------------------------------------------------|-------------|
| <a name="requirement_terraform"></a> [terraform](https://github.com/hashicorp/terraform/releases)                     | `>= 1.0`    |
| <a name="requirement_aws"></a> [hashicorp/aws](https://registry.terraform.io/providers/hashicorp/aws/latest)          | `>= 5.30.0` |
| <a name="requirement_random"></a> [hashicorp/random](https://registry.terraform.io/providers/hashicorp/random/latest) | `~> 3.4.0`  |


## Configurations

### ECS

#### Terminology and Components

> Full Explanation: [AWS Docs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html)

There are three layers in Amazon ECS:

- **Capacity** - The infrastructure where your containers run
- **Controller** - Deploy and manage your applications that run on the containers
- **Provisioning** - The tools that you can use to interface with the scheduler to deploy and manage your applications and containers


#### ECS Service

`deployment_ciruit_breaker`
- The **deployment circuit breaker** determines whether a service deployment will fail if the service can't reach a steady state. If it is turned on, a service deployment will transition to a failed state and stop launching new tasks.
- Reference: [AWS Docs](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ecs-service-deploymentcircuitbreaker.html)


`deployment_controller`
- The deployment controller type to use
  - `ECS` 
  
    The rolling update deployment type involves replacing the current running version of the container with the latest version. The number of containers Amazon ECS adds or removes from the service during a rolling update is controlled by adjusting the minimum and maximum number of healthy tasks allowed during a service deployment.

  - `CODE_DEPLOY`

    The blue/green deployment type uses the blue/green deployment model powered by AWS CodeDeploy, which allows you to verify a new deployment of a service before sending production traffic to it.

  - `EXTERNAL`
  
    The external (EXTERNAL) deployment type enables you to use any third-party deployment controller for full control over the deployment process for an Amazon ECS service.

- Reference: [AWS Docs](https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_DeploymentController.html)

`ordered_placement_strategy`

- For tasks that use the EC2 launch type, Amazon ECS must determine where to place the task based on the requirements specified in the task definition, such as CPU and memory. Similarly, when you scale down the task count, Amazon ECS must determine which tasks to terminate.
- Reference: [AWS Docs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-placement-strategies.html)
