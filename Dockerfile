FROM node:16

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

# Obtain AWS access key and secret key from Parameter Store
RUN AWS_ACCESS_KEY_ID=$(aws ssm get-parameters --names /MyApp/AWSAccessKey --with-decryption --query "Parameters[0].Value" --output text) && \
    AWS_SECRET_ACCESS_KEY=$(aws ssm get-parameters --names /MyApp/AWSSecretKey --with-decryption --query "Parameters[0].Value" --output text) && \
    sed -i "s/AWS_ACCESS_KEY_ID/$AWS_ACCESS_KEY_ID/g" package.json && \
    sed -i "s/AWS_SECRET_ACCESS_KEY/$AWS_SECRET_ACCESS_KEY/g" package.json && \
    npm install

# Bundle app source
COPY . .

EXPOSE 8080
CMD [ "npm", "start" ]

# This is dummy change for git demo
