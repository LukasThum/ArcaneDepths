# !/bin/bash
docker run -d \
  --name arcane_depths_db \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=arcane_depths_dev \
  -v "$(pwd)/tmp/data:/var/lib/postgresql/data" \
  -p 5432:5432 \
  postgres:latest