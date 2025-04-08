# PhxChatRoom

### Objective
The objective of this project is to create a simple chat room that works in real time.

### Features as of now
- [x] User authentication
- [x] Users can send messages in real time through chatrooms
- [x] Users can create different chatrooms
- [x] Allow to delete chatrooms
- [ ] Create private chatrooms (Only allowed to selected users)

### Instructions to run the project

#### Set up you ```.env``` file
``` env
POSTGRES_USER=
POSTGRES_DB=
POSTGRES_PASSWORD=
```

#### Create/Run Db
```
make up (docker compose up -d)
make down (docker compose down)
```

#### Run Elixir
``` elixir
mix deps.get
mix ecto.migrate
mix iex -S phx.server
```
