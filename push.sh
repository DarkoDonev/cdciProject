docker buildx create --name mp --driver docker-container --bootstrap --use;
docker buildx build --platform linux/amd64,linux/arm64 -f Dockerfile-frontend -t darkodonev/kiii-frontend:latest --push .;
docker buildx build --platform linux/amd64,linux/arm64 -f Dockerfile-backend -t darkodonev/kiii-backend:latest --push .;
