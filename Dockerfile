FROM debian:bookworm-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    python3 \
    python3-pip \
    python3-venv \
    xvfb \
    xauth \
    fonts-liberation \
    libnss3 \
    libnspr4 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libdrm2 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libxext6 \
    libxfixes3 \
    libxtst6 \
    libx11-6 \
    libgbm1 \
    libasound2 \
    libpango-1.0-0 \
    libcairo2 \
    libcups2 \
    libxss1 \
    libgtk-3-0 \
    libdbus-glib-1-2 \
    at-spi2-core \
    mesa-utils \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install enowx-ai
RUN curl -sSL https://api.enowxlabs.com/install/enowx-ai | bash

# Setup Python venv and Camoufox browser
RUN /root/.local/bin/enowxai setup || true

# Fetch Camoufox browser binary
RUN python3 -m pip install --break-system-packages camoufox && python3 -m camoufox fetch || true

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set environment variables
ENV DISPLAY=:99
ENV ENOWXAI_PROXY_HOST=0.0.0.0
ENV ENOWXAI_DASHBOARD_HOST=0.0.0.0

# Create volumes for persistent data
VOLUME ["/root/.enowxai", "/root/.local/lib/enowxai/auth/.venv"]

# Set entrypoint and default command
ENTRYPOINT ["/entrypoint.sh"]
CMD ["__daemon"]
