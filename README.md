# PhxTalk

PhxTalk is a web chat application built with Elixir and Phoenix LiveView. Users can sign up to participate in various chatrooms, send messages, and interact in real time

### Features
- [x] User Authentication
- [x] Users can send messages through chatrooms
- [x] Messages get updated on chatrooms
- [x] ChatRooms
  - [x] Create 
  - [x] Edit
  - [x] Delete
- [ ] Create private chatrooms (Only allowed to selected users)

### Instructions to run the project

#### 1) Set up you `.env` file
```env
POSTGRES_USER=
POSTGRES_DB=
POSTGRES_PASSWORD=
```

#### 2) Create/Run Db
```bash
make up # docker compose up -d
make down # docker compose down
```

#### 3) Run Elixir App
```elixir
mix deps.get
mix ecto.migrate
mix iex -S phx.server
```

---

<p align="center">
  <img src="https://github.com/Axl-91/phxTalk/blob/main/PhxTalk.png", width="400", height="400", alt="PhxTalk" /> 
</p>

