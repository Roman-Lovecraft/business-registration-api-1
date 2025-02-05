# Используем официальный базовый образ Python
FROM python:3.9-slim

# Устанавливаем зависимости для работы Chrome
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    libnss3 \
    libgconf-2-4 \
    gnupg \
    curl \
    libfontconfig1 \
    && rm -rf /var/lib/apt/lists/*

# Установка Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable

# Удаляем старую версию ChromeDriver, если она существует
RUN rm -f /usr/local/bin/chromedriver

# Установка ChromeDriver
RUN CHROMEDRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
rm /tmp/chromedriver.zip


# Устанавливаем рабочую директорию
WORKDIR /business-registration-api-1

# Копируем файлы проекта
COPY . .


# Устанавливаем зависимости Python
RUN pip install --no-cache-dir -r requirements.txt

# Открываем порт для uvicorn
EXPOSE 8000

# Команда для запуска API
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]

