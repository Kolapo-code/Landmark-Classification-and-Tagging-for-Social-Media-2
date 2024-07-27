FROM python:3.11-slim

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    gfortran \
    libopenblas-dev \
    liblapack-dev \
    libjpeg-dev \
    zlib1g-dev \
    libpng-dev \
    libfreetype6-dev \
    pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Create a virtual environment
RUN python3 -m venv /opt/venv

# Activate the virtual environment and upgrade pip
RUN /opt/venv/bin/pip install --upgrade pip

# Add and use a non-root user
RUN adduser --disabled-password --gecos '' appuser && chown -R appuser /app
USER appuser

# Copy requirements.txt and install dependencies within the virtual environment
COPY --chown=appuser:appuser requirements.txt .
RUN /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY --chown=appuser:appuser . .

# Ensure the virtual environment's Python is used
ENV PATH="/opt/venv/bin:$PATH"

# Command to run the application
CMD ["python", "app.py"]
