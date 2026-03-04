#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# HURRY UP — Chennai MTC Optimizer
# One-command project setup + Git init script
# Run: bash setup.sh
# ═══════════════════════════════════════════════════════════════

set -e  # Exit on any error

REPO_NAME="hurry-up"
GITHUB_USERNAME=""  # ← FILL THIS IN before running

echo ""
echo "🚌 HURRY UP — Project Setup Starting..."
echo "════════════════════════════════════════"

# ── 1. Create folder structure ─────────────────────────────────
mkdir -p $REPO_NAME/backend/logs
mkdir -p $REPO_NAME/frontend/src
cd $REPO_NAME

echo "✅ Folder structure created"

# ── 2. Write backend/package.json ──────────────────────────────
cat > backend/package.json << 'EOF'
{
  "name": "hurry-up-chennai-mtc",
  "version": "1.0.0",
  "description": "Chennai MTC Bus Optimizer API — Hackathon Edition",
  "main": "server.js",
  "scripts": {
    "dev": "nodemon server.js",
    "start": "node server.js"
  },
  "engines": { "node": ">=20.0.0" },
  "dependencies": {
    "express": "^4.19.2",
    "socket.io": "^4.7.5",
    "cors": "^2.8.5",
    "express-rate-limit": "^7.3.1",
    "joi": "^17.13.1",
    "winston": "^3.13.0",
    "redis": "^4.6.14",
    "axios": "^1.7.2",
    "firebase-admin": "^12.1.1",
    "dotenv": "^16.4.5"
  },
  "devDependencies": {
    "nodemon": "^3.1.3"
  }
}
EOF

# ── 3. Write backend/.env ───────────────────────────────────────
cat > backend/.env << 'EOF'
PORT=3000
LOG_LEVEL=info
REDIS_URL=redis://localhost:6379
FIREBASE_DB_URL=https://your-project.firebaseio.com
GOOGLE_API_KEY=your_google_maps_api_key_here
NEWS_API_KEY=your_newsapi_key_here
EOF

# ── 4. Write frontend/package.json ─────────────────────────────
cat > frontend/package.json << 'EOF'
{
  "name": "hurry-up-frontend",
  "version": "1.0.0",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.3.1",
    "vite": "^5.3.1"
  }
}
EOF

# ── 5. Write frontend/vite.config.js ───────────────────────────
cat > frontend/vite.config.js << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    proxy: {
      '/hurryup': {
        target: 'http://localhost:3000',
        changeOrigin: true,
      }
    }
  }
})
EOF

# ── 6. Write frontend/index.html ───────────────────────────────
cat > frontend/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Hurry Up — Chennai MTC Optimizer</title>
    <style>body { margin: 0; background: #020817; }</style>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
EOF

# ── 7. Write frontend/src/main.jsx ─────────────────────────────
cat > frontend/src/main.jsx << 'EOF'
import React from 'react'
import ReactDOM from 'react-dom/client'
import HurryUp from './App'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <HurryUp />
  </React.StrictMode>
)
EOF

echo "✅ All config files written"

# ── 8. Write .gitignore ────────────────────────────────────────
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
backend/node_modules/
frontend/node_modules/

# Logs
backend/logs/
*.log

# Environment — NEVER commit real keys
backend/.env
backend/firebase-config.json

# Build output
frontend/dist/
frontend/.vite/

# OS files
.DS_Store
Thumbs.db

# Editor
.vscode/settings.json
.idea/
EOF

# ── 9. Write docker-compose.yml ────────────────────────────────
cat > docker-compose.yml << 'EOF'
version: "3.9"
services:
  api:
    build: ./backend
    ports:
      - "3000:3000"
    env_file: ./backend/.env
    depends_on:
      - redis
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    restart: unless-stopped
EOF

# ── 10. Write Dockerfile for backend ───────────────────────────
cat > backend/Dockerfile << 'EOF'
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
EOF

echo "✅ Docker files written"

# ── 11. NOTE: Copy your downloaded files ───────────────────────
echo ""
echo "════════════════════════════════════════"
echo "📋 MANUAL STEP REQUIRED:"
echo "   Copy these 2 files from your downloads:"
echo ""
echo "   server.js   → $REPO_NAME/backend/server.js"
echo "   HurryUp.jsx → $REPO_NAME/frontend/src/App.jsx"
echo ""
echo "   Then press ENTER to continue with Git setup..."
read -r

# ── 12. Git init ───────────────────────────────────────────────
git init
git add .
git commit -m "🚌 Initial commit — Hurry Up Chennai MTC Optimizer

Features:
- POST /hurryup/optimize — returns next 12hr MTC+Metro routes
- Live seat counts via Socket.io + Firebase
- Real routing via OSRM (free, no key)
- Live weather delay via Open-Meteo (free, no key)
- GTFS static MTC route data (8 route corridors)
- NewsAPI traffic sentiment via server proxy
- Redis caching (5min TTL)
- Joi validation + rate limiting (100 req/min)
- Winston production logging
- React dashboard with live seat ticker"

echo "✅ Git repository initialized with first commit"

# ── 13. Push to GitHub (if username provided) ──────────────────
if [ -n "$GITHUB_USERNAME" ]; then
  echo ""
  echo "🔗 Pushing to GitHub..."
  echo "   Make sure you've created the repo on github.com first:"
  echo "   https://github.com/new → name it: hurry-up"
  echo ""
  echo "   Press ENTER when repo is created on GitHub..."
  read -r

  git remote add origin "https://github.com/$GITHUB_USERNAME/hurry-up.git"
  git branch -M main
  git push -u origin main

  echo ""
  echo "════════════════════════════════════════"
  echo "🎉 PUSHED TO GITHUB!"
  echo "   https://github.com/$GITHUB_USERNAME/hurry-up"
  echo "════════════════════════════════════════"
else
  echo ""
  echo "════════════════════════════════════════"
  echo "⚠️  GITHUB_USERNAME not set in script."
  echo "   To push manually after running:"
  echo ""
  echo "   1. Go to https://github.com/new"
  echo "   2. Create repo named: hurry-up"
  echo "   3. Run these commands:"
  echo ""
  echo "   cd hurry-up"
  echo "   git remote add origin https://github.com/YOUR_USERNAME/hurry-up.git"
  echo "   git branch -M main"
  echo "   git push -u origin main"
  echo "════════════════════════════════════════"
fi

# ── 14. Install dependencies ───────────────────────────────────
echo ""
echo "📦 Installing backend dependencies..."
cd backend && npm install
cd ..

echo ""
echo "📦 Installing frontend dependencies..."
cd frontend && npm install
cd ..

echo ""
echo "════════════════════════════════════════"
echo "✅ ALL DONE! Run the project:"
echo ""
echo "   Terminal 1 → cd $REPO_NAME/backend && npm run dev"
echo "   Terminal 2 → cd $REPO_NAME/frontend && npm run dev"
echo ""
echo "   Open: http://localhost:5173"
echo "════════════════════════════════════════"
