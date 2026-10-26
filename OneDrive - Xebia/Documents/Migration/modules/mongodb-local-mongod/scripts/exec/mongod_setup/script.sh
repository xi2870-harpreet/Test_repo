#!/bin/bash
# Wait for mongod to be ready
until mongosh --quiet --eval "db.runCommand({ ping: 1 })" > /dev/null 2>&1; do
  echo "Waiting for mongod..."
  sleep 2
done

echo "mongod is ready."

# Create admin user
mongosh admin --quiet --eval "
  db.createUser({
    user: 'mdb_admin',
    pwd: 'Password1!',
    roles: [{ role: 'root', db: 'admin' }]
  })
"

echo "Admin user created."
