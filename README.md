1. build image
   ```commandline
   docker compose -f docker-compose.yaml build
   ```
2. run docker container
   ```commanline
   xhost +local:root
   docker compose -f docker-compose.yaml up
   ```
3. iteract with container
   ```commandline
   docker exec -it <container name> bash
   ```
