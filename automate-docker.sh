source /host/settings.sh

echo $'\e[31mPlease disable any apache/mysql/tor service running on the host machine!\e[0m'
read -p $'\e[33mThis will delete all Docker images/containers on this machine!!! Continue?\e[0m ' -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then

  echo $'\e[92mChecking if docker exists\e[0m'
  # Check if Docker exists on the machine
  docker 2> /dev/null || exit 1

  echo $'\e[92mDeleting all docker images\e[0m'
  # Delete all Docker containers
  docker rm -f $(docker ps -a -q)
  echo $'\e[92mDone!\e[0m'

  echo $'\e[92mDelete all docker images\e[0m'
  # Delete every Docker image
  docker rmi -f $(docker images -q)
  echo $'\e[92mDone!\e[0m'

  echo $'\e[92mRestarting the Docker daemon\e[0m'
  # Restarting Docker
  service docker restart
  echo $'\e[92mDone!\e[0m'

  echo $'\e[92mBuilding the Docker image...\e[0m'
  echo $'\e[92mLogs can be found at /var/log/\e[0m'
  # Build the Docker image and output logs at /var/log
  docker build -t $MASTER_DOMAIN . > /var/log/$MASTER_DOMAIN
  echo $'\e[92mDone!\e[0m'

  echo $'\e[92mRunning the docker image... This may take up to 20 minutes\e[0m'
  # Run the Docker image using the domain as the host name
  docker run -d --cap-add=SYS_PTRACE --privileged --security-opt=apparmor:unconfined --network host --hostname $MASTER_DOMAIN --name=$MASTER_DOMAIN $MASTER_DOMAIN
  echo $'\e[92mDone!\e[0m'

  echo $'\e[92mGetting shell on the container...\e[0m'
  # Start a shell in the container
  docker exec -it $MASTER_DOMAIN bash

fi
