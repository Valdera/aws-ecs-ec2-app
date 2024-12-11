[
  {
    "name": "${container_name}",
    "image": "${image_uri}:${version}",
    "cpu": ${app_cpu},
    "memory": ${app_memory},
    "essential": true,
    "environment": ${environment},
    "dockerLabels": ${docker_labels},
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group}",
        "awslogs-region": "${aws_region}",
        "awslogs-stream-prefix": "${container_name}/${version}/"
      }
    },
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": ${port},
        "hostPort": ${port}
      }
    ],
    "readonlyRootFilesystem": ${read_only_root_filesystem},
    "mountPoints": [],
    "volumesFrom": [],
    "dependsOn": []
  }
]
