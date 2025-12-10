FROM mcr.microsoft.com/playwright:v1.52.0-noble

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci --omit=dev

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

# Start MCP server with HTTP transport - ALLOW ALL HOSTS
ENTRYPOINT ["node", "cli.js", "--headless", "--browser", "chromium", "--no-sandbox", "--port", "8080", "--host", "0.0.0.0", "--allowed-hosts", "*"]
