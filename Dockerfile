# Use Node.js official image
FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Copy dependencies and install
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Expose port
EXPOSE 8080

# Start the app
CMD ["npm", "start"]
