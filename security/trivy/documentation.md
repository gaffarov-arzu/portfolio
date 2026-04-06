# pipelineya asagidaki hisseni elave edirk
 - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
          format: table
          exit-code: 0
          severity: 'CRITICAL,HIGH'
# exit-code 0 error tapsa pipeline davam edir
# exit-code 1 error tapsa pipeline qirilir
