# # Use Python 3.11 (compatible with all your dependencies)
# FROM python:3.11-slim

# # Set environment variables
# ENV PYTHONDONTWRITEBYTECODE=1
# ENV PYTHONUNBUFFERED=1
# ENV DJANGO_SETTINGS_MODULE=capstone.settings

# # Set work directory
# WORKDIR /app

# # Install system dependencies
# RUN apt-get update && apt-get install -y \
#     gcc \
#     libffi-dev \
#     libjpeg-dev \
#     zlib1g-dev \
#     libfreetype6-dev \
#     && rm -rf /var/lib/apt/lists/*

# # Install Python dependencies
# COPY requirements.txt /app/
# RUN pip install --upgrade pip
# RUN pip install -r requirements.txt

# # Copy project
# COPY . /app/

# # Create a non-root user
# RUN adduser --disabled-password --gecos '' appuser
# USER appuser

# # Run the application
# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]


# Use Python 3.11 (compatible with all your dependencies)
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=capstone.settings

# Set work directory
WORKDIR /app

# Install system dependencies - INCLUDING Cairo libraries
RUN apt-get update && apt-get install -y \
    gcc \
    libffi-dev \
    libjpeg-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libcairo2 \
    libcairo2-dev \
    pkg-config \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt /app/
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy project
COPY . /app/

# Create a non-root user
RUN adduser --disabled-password --gecos '' appuser
USER appuser

# Run the application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]