FROM mcr.microsoft.com/playwright:v1.52.0-noble

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install ALL dependencies (including playwright)
RUN npm ci

# Install Chromium browser using the installed playwright
RUN npx playwright install chromium

# Copy application files
COPY cli.js ./
COPY index.js ./
COPY index.d.ts ./
COPY config.d.ts ./

# Set environment variables
ENV NODE_ENV=production
ENV PLAYWRIGHT_MCP_OUTPUT_DIR=/tmp/playwright-output
ENV PORT=8080

EXPOSE 8080

# Run as non-root user for security
USER pwuser

# Start MCP server with HTTP transport
ENTRYPOINT ["node", "cli.js", "--headless", "--browser", "chromium", "--no-sandbox", "--port", "8080", "--host", "0.0.0.0", "--allowed-hosts", "*"]
