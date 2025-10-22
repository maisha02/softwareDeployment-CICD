FROM python:3.12-slim
WORKDIR /app

# Install runtime dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy app sources
COPY . /app

EXPOSE 5000

# Run the simple Flask app using the builtin server (suitable for dev/small apps)
CMD ["python", "app.py"]
