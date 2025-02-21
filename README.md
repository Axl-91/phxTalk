# PhxChatRoom

### Objective
This project recreates a Chat Room, where you can leave message in real time with other users and create new Chat Rooms


### Set up you ```.env``` file
``` env
POSTGRES_USER=
POSTGRES_DB=
POSTGRES_PASSWORD=
```

### Run project

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
