#!/bin/bash
if ! docker buildx inspect mp >/dev/null 2>&1; then
    echo "Creating new builder 'mp'..."
    docker buildx create --name mp --driver docker-container --bootstrap
fi

# Use the builder
docker buildx use mp

# Build and push with multi-platform support
echo "Building and pushing frontend..."
docker buildx build --platform linux/amd64,linux/arm64 -f Dockerfile-frontend -t darkodonev/kiii-frontend:latest --push .

echo "Building and pushing backend..."
docker buildx build --platform linux/amd64,linux/arm64 -f Dockerfile-backend -t darkodonev/kiii-backend:latest --push .
