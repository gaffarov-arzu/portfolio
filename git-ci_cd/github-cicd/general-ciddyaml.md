```yaml
name: Build, Push & Deploy
on: 
  push: 
   branches:
     - main
env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}
  
jobs:
  build-push-deploy:
    name: Build, Push & Deploy
    runs-on: org-runner
    steps:
    #Repodaki kodu runner serverine clonlayir
      - name: Checkout code
        uses: actions/checkout@v4
    # docker config file yarat
      - name: create docker config dir
        run: mkdir -p /home/azureuser/.docker
    # docker buildx qurmaq(actions5 oldugu ucun)
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
     # ghcr.io ya token ile login olur
      - name: Log in to Github Container Registry
        uses: docker/login-action@v3
        with: 
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.CR_PAT }}
     # Dockerfiledan image build edib ghcr.io a push edir
      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: |
            ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest
            ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
      # kohne containeri stop et ve silmek 
      - name: Stop and remove old container
        run: |
          docker stop backend-auth-service || true
          docker rm backend-auth-service || true
    
      # yeni containeri start etmek
      - name: Run new container
        run: | 
          docker pull ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest
          docker run -d --name backend-auth-service --restart unless-stopped -p 4001:4001 -e PORT=4001   --network host   ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest
```
