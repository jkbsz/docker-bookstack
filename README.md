# docker-compose for BookStack

Two containers:
	- MySQL
	- Apache + PHP

Project page https://www.bookstackapp.com/

Bring your own HTTPS.

# Start

docker-compose up -d

url: http://127.0.0.1/
login: admin@admin.com
password: password

# Update

Data should persist in docker volumes, I would still backup anyway.

docker-compose down && docker-compose build --no-cache && docker-compose up -d

