
# Usa una imagen base de Python
FROM python:3.11-slim

# Instala Node.js (ajusta la versión si lo necesitas)
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Crea el directorio de trabajo
WORKDIR /app

# Copia los requirements y los instala
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia archivos de Node.js y los instala si existen
COPY package*.json ./
RUN if [ -f package.json ]; then npm install; fi

# Copia el resto del código
COPY . .

# Expone el puerto (Railway usará la variable $PORT)
EXPOSE 8000

# Comando de inicio (ahora usando shell para expandir $PORT)
CMD uvicorn vista:app --host 0.0.0.0 --port $PORT
