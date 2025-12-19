#!/bin/bash
echo "Starting automated deployment..."

# Update system and install required packages
sudo yum update -y
sudo yum install python3 git python3-pip -y
sudo pip3 install -r requirements.txt

# Clone or pull the repo
REPO_NAME="aws-ec2-flask-hello-world"
if [ -d "$REPO_NAME" ]; then
    echo "Pulling latest changes..."
    cd $REPO_NAME
    git pull origin main
else
    echo "Cloning repo..."
    git clone https://github.com/hardikthakar26/aws-ec2-flask-hello-world.git
    cd $REPO_NAME
fi

# Check app exists
if [ ! -f "app.py" ]; then
    echo "Error: app.py not found in repo!"
    exit 1
fi

# Kill any running app on port 80
sudo fuser -k 80/tcp || true

# Run the app in background
nohup python3 app.py > app.log 2>&1 &

echo "Deployment complete! Check your EC2 public IP in browser."
echo "View logs: tail -f app.log"
echo "Current dir: $(pwd)"