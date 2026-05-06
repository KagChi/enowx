FROM debian:bookworm-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    python3 \
    python3-pip \
    python3-venv \
    xvfb \
    fonts-liberation \
    libnss3 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libpango-1.0-0 \
    libcairo2 \
    libcups2 \
    libxss1 \
    libgtk-3-0 \
    libdbus-glib-1-2 \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install enowx-ai
RUN curl -sSL https://api.enowxlabs.com/install/enowx-ai | bash

# Expose ports
EXPOSE 1430 1431

# Create volume for persistent data
VOLUME ["/root/.enowxai"]

# Health check
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD curl -sf http://localhost:1430/health || exit 1

# Set entrypoint and default command
ENTRYPOINT ["/root/.local/bin/enowxai"]
CMD ["__daemon"]
