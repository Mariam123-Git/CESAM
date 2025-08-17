# =========================
# Dockerfile pour le backend Node.js
# =========================

# Étape 1 : Image Node.js officielle
FROM node:18-alpine

# Étape 2 : Dossier de travail dans le conteneur
WORKDIR /usr/src/app

# Étape 3 : Copier uniquement les fichiers de dépendances
COPY package*.json ./

# Étape 4 : Installer les dépendances
RUN npm install

# Étape 5 : Copier tout le code backend dans le conteneur
COPY . .

# Étape 6 : Exposer les ports (API + HTTPS)
EXPOSE 3000 443

# Étape 7 : Commande par défaut (on peut la surcharger dans docker-compose)
CMD ["npm", "start"]
