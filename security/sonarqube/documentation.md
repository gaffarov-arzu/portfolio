# uida project yaradiriq(local project)
# Follows the instance’s default
#  generate token
#  github actionsda secret elave edirik 
## SONAR_TOKEN = <kopyaladığın token>
## SONAR_HOST_URL = https://sonar.musluck.com
# uida proyektin dilini secirik
# repoda asagidaki fayli yaradiriq
sonar-project.properties
## icince asagidakini elave edirik
sonar.projectKey=api-gateway
# docker buildden once asagidaki stepi elave edirik
```yaml
- name: SonarQube Analysis
        uses: SonarSource/sonarqube-scan-action@v5
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
          SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
```
