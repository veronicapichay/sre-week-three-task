#TODO Implement a "big red button" for UpCommerce by creating a bash script to monitor the Kubernetes deployment dedicated to the Swype microservice
 #!/bin/bash

# Define Variables
NAMESPACE="sre"
DEPLOYMENT_NAME="swype-app"
MAX_RESTARTS=3

# Start Infinite Loop
while true; do
    # Check Pod Restarts
    GET_RESTART_COUNT=$(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT_NAME -o jsonpath='{.items[0].status.containerStatuses[0].restartCount}')
    
    # Display Restart Count
    echo "Current restart count: $GET_RESTART_COUNT"
    
    # Check Restart Limit
    if ((GET_RESTART_COUNT > MAX_RESTARTS )); then
        echo "Number of restarts exceeded maximum limit. Scaling down deployment..."
        # Scale Down Deployment
        kubectl scale --replicas=0 deployment/$DEPLOYMENT_NAME -n $NAMESPACE
        break
    else
        # Pause for 60 seconds
        sleep 60
    fi
done