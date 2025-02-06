# Используем базовый образ Python
FROM python:3.9-slim

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    libglib2.0-0 \
    libnss3 \
    libnspr4 \
    fonts-liberation \
    libappindicator3-1 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Скачиваем и распаковываем Chrome и ChromeDriver
RUN wget https://storage.googleapis.com/chrome-for-testing-public/134.0.6998.3/linux64/chrome-linux64.zip && \
    unzip chrome-linux64.zip -d /opt/ && \
    rm chrome-linux64.zip && \
    wget https://storage.googleapis.com/chrome-for-testing-public/134.0.6998.3/linux64/chromedriver-linux64.zip && \
    unzip chromedriver-linux64.zip -d /opt/ && \
    rm chromedriver-linux64.zip

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы проекта
COPY . /app

# Устанавливаем зависимости Python
RUN pip install --no-cache-dir -r requirements.txt

# Открываем порт для uvicorn
EXPOSE 8000

# Команда для запуска API
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
