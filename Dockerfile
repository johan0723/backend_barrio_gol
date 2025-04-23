FROM python:3.11-slim

# Instalación de dependencias del sistema
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Establecer directorio de trabajo
WORKDIR /app

# Instalar dependencias de Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Instalar dependencias de Node.js si existen
COPY package*.json ./
RUN if [ -f package.json ]; then npm install; fi

# Copiar el resto del código
COPY . .

# Exponer el puerto 8000 (puerto por defecto)
EXPOSE 8000

# Comando de inicio con fallback a puerto 8000
CMD ["sh", "-c", "uvicorn vista:app --host 0.0.0.0 --port ${PORT:-8000}"]
