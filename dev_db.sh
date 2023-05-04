docker run -d \
  --name arcane_depths_db \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=arcane_depths_dev \
  -p 5432:5432 \
  postgres:latest