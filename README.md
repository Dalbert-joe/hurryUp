# 🚌 HURRY UP — Chennai MTC Optimizer
### SIH 2025 Finalist | Real-time Bus Route Optimizer

---

## ⚡ Run Locally in 5 Minutes

### Prerequisites
- Node.js v20+ → https://nodejs.org
- Git (optional)

---

## 📁 Final Folder Structure

```
hurry-up/
├── backend/
│   ├── server.js          ← Express API
│   ├── package.json       ← Backend deps
│   ├── .env               ← API keys (copy from .env.example)
│   ├── firebase-config.json  ← Optional (skip for demo mode)
│   └── logs/              ← Auto-created by Winston
│
└── frontend/
    ├── index.html
    ├── package.json       ← Frontend deps
    ├── vite.config.js     ← Vite + proxy config
    └── src/
        ├── main.jsx       ← React entry point
        └── App.jsx        ← HurryUp.jsx content goes here
```

---

## 🔧 Step-by-Step Setup

### STEP 1 — Create folder structure
```bash
mkdir hurry-up
cd hurry-up
mkdir backend frontend
mkdir frontend/src
```

### STEP 2 — Backend setup
```bash
cd backend

# Paste server.js here
# Paste package.json here
# Create .env file (see below)

npm install
```

### STEP 3 — Create .env file in /backend
```env
PORT=3000
LOG_LEVEL=info
REDIS_URL=redis://localhost:6379
FIREBASE_DB_URL=https://your-project.firebaseio.com
GOOGLE_API_KEY=your_key_here
NEWS_API_KEY=your_newsapi_key_here
```
> ⚠️ App works WITHOUT any keys — Redis, Firebase, Google, NewsAPI all have
> graceful fallbacks. Just create .env with PORT=3000 and it runs fine.

### STEP 4 — Frontend setup
```bash
cd ../frontend

# Paste package.json here (frontend-package.json)
# Paste index.html here
# Paste vite.config.js here
# In src/ → paste main.jsx and App.jsx (HurryUp.jsx content)

npm install
```

### STEP 5 — Run both servers

**Terminal 1 (Backend):**
```bash
cd backend
npm run dev
# ✅ Server running on http://localhost:3000
```

**Terminal 2 (Frontend):**
```bash
cd frontend
npm run dev
# ✅ App running on http://localhost:5173
```

### STEP 6 — Open in browser
```
http://localhost:5173
```

---

## 🧪 Test the API directly

```bash
# Health check
curl http://localhost:3000/ping

# Main endpoint
curl -X POST http://localhost:3000/hurryup/optimize \
  -H "Content-Type: application/json" \
  -d '{"from":"OMR","to":"Central","date":"today"}'

# With bigBusOnly
curl -X POST http://localhost:3000/hurryup/optimize \
  -H "Content-Type: application/json" \
  -d '{"from":"Tambaram","to":"Central","date":"today","bigBusOnly":true}'
```

---

## 🔑 API Keys (All Optional for Demo)

| Service | Free? | Key Needed? | Get it at |
|---|---|---|---|
| OSRM | ✅ Free forever | ❌ No key | Built-in |
| Open-Meteo | ✅ Free forever | ❌ No key | Built-in |
| GTFS Static | ✅ Free | ❌ No key | Built-in |
| NewsAPI | ✅ 100 req/day free | ✅ Yes (server only) | newsapi.org |
| Redis | ✅ Free | ❌ No key | Install locally |
| Firebase | Freemium | ✅ JSON file | console.firebase.google.com |
| Google Maps | Pay-per-use | ✅ Yes | console.cloud.google.com |

> **Demo mode:** Without any keys, OSRM + Open-Meteo still work (real data).
> NewsAPI falls back to peak-hour heuristic. Redis/Firebase use in-memory mock.

---

## 🐳 Docker (Optional — One Command Deploy)

```bash
cd hurry-up
docker-compose up
# Backend: http://localhost:3000
```

---

## 📡 Socket.io Events

| Event | Direction | Payload |
|---|---|---|
| `subscribe_route` | Client → Server | `"21G"` |
| `seat_update` | Server → Client | `{routeId, seatsAvailable, timestamp}` |
| `checkin` | Client → Server | `{routeId, action: "board"/"alight"}` |
| `route_update` | Server → All | `{from, to, routeCount}` |

---

## 🎯 Supported Routes (Quick Test)

| From | To |
|---|---|
| OMR | Central |
| Tambaram | Central |
| Adyar | CMBT |
| Velachery | CMBT |
| Guindy | Central |
| T.Nagar | Central |
| Adyar | Central |
| Porur | CMBT |
| Chromepet | Central |

---

## ✅ Success Checklist

- [ ] `http://localhost:3000/ping` → returns `{"status":"ok"}`
- [ ] `http://localhost:5173` → Hurry Up dashboard loads
- [ ] Search "OMR → Central" → 4 routes appear
- [ ] Seat counts tick every 4 seconds (live simulation)
- [ ] OSRM pill turns green (real road distance shown)
- [ ] Open-Meteo pill turns green (live Chennai temp shown)
- [ ] Filter tabs (AC / METRO / BIG) work

---

Built with ❤️ for Chennai's 10M daily commuters.
