# PhxTalk

### Objective
The objective of this project is to create a simple chat room that works in real time.

### Features as of now
- [x] User authentication
- [x] Users can send messages in real time through chatrooms
- [x] Users can create different chatrooms
- [x] Allow to delete chatrooms
- [ ] Create private chatrooms (Only allowed to selected users)

### Instructions to run the project

#### 1) Set up you ```.env``` file
``` env
POSTGRES_USER=
POSTGRES_DB=
POSTGRES_PASSWORD=
```

#### 2) Create/Run Db
```
make up (docker compose up -d)
make down (docker compose down)
```

#### 3) Run Elixir App
``` elixir
mix deps.get
mix ecto.migrate
mix iex -S phx.server
```
![PhxTalk]()

<h1></h1>

<p align="center">
  <img src="https://github.com/user-attachments/assets/919eafac-c29c-46d1-bffa-f9c865f7211b", width="400", height="400", alt="PhxTalk Logo" /> 
</p>

