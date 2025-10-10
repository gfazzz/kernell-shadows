#!/bin/bash

################################################################################
# KERNEL SHADOWS: Episode 14 — Docker Basics
# Amsterdam, Netherlands (Day 27-28)
# Sophie van Dijk, Docker Architect
#
# Mission: Containerize infrastructure components,
#          learn Docker security, respond to supply chain attack
################################################################################

# Strict mode
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
PROJECT_DIR="$HOME/operation-shadow-docker"

################################################################################
# Task 1: Install Docker
################################################################################
task1_install_docker() {
    echo -e "${BLUE}[Task 1]${NC} Installing Docker..."

    # TODO: Check if Docker is already installed
    # Hint: docker --version

    # TODO: If not installed, install Docker
    # Hint: See README.md Task 1 for complete installation steps
    # Key steps:
    # 1. sudo apt update
    # 2. Install prerequisites (apt-transport-https, ca-certificates, curl, gnupg)
    # 3. Add Docker GPG key
    # 4. Add Docker repository
    # 5. sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    # 6. sudo usermod -aG docker $USER
    # 7. newgrp docker

    # TODO: Verify installation
    # Hint: docker --version
    # Hint: docker compose version
    # Hint: docker run hello-world

    echo -e "${GREEN}✓${NC} Docker installation check complete"
}

################################################################################
# Task 2: Create Dockerfile for Nginx
################################################################################
task2_create_dockerfile() {
    echo -e "${BLUE}[Task 2]${NC} Creating Dockerfile for nginx..."

    # TODO: Create project directory
    # Hint: mkdir -p "$PROJECT_DIR/web"

    # TODO: Create Dockerfile
    # Hint: See README.md Task 2 for complete Dockerfile
    # Must include:
    # - FROM nginx:alpine
    # - LABEL maintainer, version, description
    # - COPY nginx.conf and html/
    # - EXPOSE 80
    # - HEALTHCHECK
    # - CMD ["nginx", "-g", "daemon off;"]

    # TODO: Create nginx.conf
    # Hint: Basic nginx config with server block on port 80

    # TODO: Create HTML content
    # Hint: mkdir -p html/
    # Hint: Create index.html with "Operation Shadow" theme

    # TODO: Build image
    # Hint: docker build -t operation-shadow/web:latest .

    # TODO: Run container
    # Hint: docker run -d -p 8080:80 --name shadow-web operation-shadow/web:latest

    # TODO: Test
    # Hint: curl http://localhost:8080

    echo -e "${GREEN}✓${NC} Dockerfile created and tested"
}

################################################################################
# Task 3: Docker Networking
################################################################################
task3_docker_networking() {
    echo -e "${BLUE}[Task 3]${NC} Setting up Docker networking..."

    # TODO: List existing networks
    # Hint: docker network ls

    # TODO: Create custom network
    # Hint: docker network create shadow-network

    # TODO: Run containers on custom network
    # Hint: docker run -d --name web1 --network shadow-network operation-shadow/web
    # Hint: docker run -d --name web2 --network shadow-network operation-shadow/web

    # TODO: Test connectivity
    # Hint: docker exec web1 ping -c 3 web2

    echo -e "${GREEN}✓${NC} Docker networking configured"
}

################################################################################
# Task 4: Docker Volumes
################################################################################
task4_docker_volumes() {
    echo -e "${BLUE}[Task 4]${NC} Working with Docker volumes..."

    # TODO: Create volume
    # Hint: docker volume create shadow-data

    # TODO: Run container with volume
    # Hint: docker run -d --name test-volume -v shadow-data:/data alpine sleep 3600

    # TODO: Write data to volume
    # Hint: docker exec test-volume sh -c 'echo "persistent data" > /data/test.txt'

    # TODO: Stop and remove container
    # Hint: docker stop test-volume && docker rm test-volume

    # TODO: Verify data persists
    # Hint: docker run --rm -v shadow-data:/data alpine cat /data/test.txt

    echo -e "${GREEN}✓${NC} Docker volumes tested"
}

################################################################################
# Task 5: Multi-stage Build
################################################################################
task5_multistage_build() {
    echo -e "${BLUE}[Task 5]${NC} Creating multi-stage Dockerfile..."

    # TODO: Create directory for tool
    # Hint: mkdir -p "$PROJECT_DIR/tool"

    # TODO: Create sample C program
    # Hint: Create crypto_tool.c with simple printf()

    # TODO: Create multi-stage Dockerfile
    # Hint: Stage 1 (builder): FROM ubuntu:22.04, install gcc, compile
    # Hint: Stage 2 (runtime): FROM alpine:latest, COPY --from=builder

    # TODO: Build image
    # Hint: docker build -t shadow-tool:multi-stage .

    # TODO: Compare sizes
    # Hint: docker images shadow-tool

    echo -e "${GREEN}✓${NC} Multi-stage build created"
}

################################################################################
# Task 6: Docker Compose
################################################################################
task6_docker_compose() {
    echo -e "${BLUE}[Task 6]${NC} Creating docker-compose.yml..."

    # TODO: Create compose directory
    # Hint: mkdir -p "$PROJECT_DIR/compose"

    # TODO: Create docker-compose.yml
    # Hint: See README.md Task 6 for complete compose file
    # Services: web, api, db (postgres), cache (redis)
    # Networks: shadow-net
    # Volumes: db-data

    # TODO: Start services
    # Hint: docker compose up -d

    # TODO: Check status
    # Hint: docker compose ps

    # TODO: View logs
    # Hint: docker compose logs

    echo -e "${GREEN}✓${NC} Docker Compose configured"
}

################################################################################
# Task 7: Security Scanning with Trivy
################################################################################
task7_security_scanning() {
    echo -e "${BLUE}[Task 7]${NC} Installing and using Trivy..."

    # TODO: Check if Trivy is installed
    # Hint: trivy --version

    # TODO: Install Trivy if not present
    # Hint: See README.md Task 7 for installation
    # Or: sudo apt install trivy

    # TODO: Scan an image
    # Hint: trivy image nginx:latest

    # TODO: Filter by severity
    # Hint: trivy image --severity HIGH,CRITICAL nginx:latest

    # TODO: Generate report
    # Hint: trivy image --format json -o trivy_report.json nginx:latest

    echo -e "${GREEN}✓${NC} Security scanning setup complete"
}

################################################################################
# Task 8: INCIDENT - Detect Compromised Image (Advanced)
################################################################################
task8_incident_response() {
    echo -e "${YELLOW}[Task 8 — INCIDENT]${NC} Supply chain attack response..."

    echo -e "${YELLOW}⚠${NC}  This is an advanced incident response task"
    echo -e "    See README.md Task 8 for complete scenario"
    echo -e "    Simulates detection and response to compromised Docker image"

    # This task is intentionally manual to simulate real incident response
    # Steps from README.md:
    # 1. Stop compromised containers
    # 2. Scan image with Trivy
    # 3. Inspect image history
    # 4. Rebuild from clean source
    # 5. Enable Docker Content Trust
}

################################################################################
# Task 9: Generate Docker Audit Report
################################################################################
task9_audit_report() {
    echo -e "${BLUE}[Task 9]${NC} Generating Docker audit report..."

    # TODO: Create audit script directory
    # Hint: mkdir -p "$PROJECT_DIR/scripts"

    # TODO: Create docker_audit.sh script
    # Hint: See README.md Task 9 for complete script
    # Must include:
    # - Docker version
    # - Running containers
    # - Images list
    # - Volumes
    # - Networks
    # - Disk usage
    # - Security scan (if Trivy available)

    # TODO: Make script executable
    # Hint: chmod +x "$PROJECT_DIR/scripts/docker_audit.sh"

    # TODO: Run audit
    # Hint: "$PROJECT_DIR/scripts/docker_audit.sh"

    echo -e "${GREEN}✓${NC} Docker audit report generated"
}

################################################################################
# Main execution
################################################################################
main() {
    echo ""
    echo "================================================================"
    echo "  KERNEL SHADOWS: Episode 14 — Docker Basics"
    echo "  Amsterdam, Netherlands (Science Park Datacenter)"
    echo "  Sophie van Dijk: 'Containers zijn als LEGO.'"
    echo "================================================================"
    echo ""

    echo -e "${YELLOW}NOTE:${NC} This starter script provides templates."
    echo -e "      Uncomment TODO sections and implement tasks."
    echo -e "      See README.md for detailed instructions."
    echo ""

    # Uncomment tasks as you complete them
    task1_install_docker
    # task2_create_dockerfile
    # task3_docker_networking
    # task4_docker_volumes
    # task5_multistage_build
    # task6_docker_compose
    # task7_security_scanning
    # task8_incident_response  # Advanced: manual task
    # task9_audit_report

    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Episode 14 starter tasks completed!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Project directory: $PROJECT_DIR"
    echo ""
    echo "Next steps:"
    echo "  1. Complete remaining tasks in README.md"
    echo "  2. docker ps                     # View running containers"
    echo "  3. docker images                 # View images"
    echo "  4. trivy image nginx:latest      # Scan for vulnerabilities"
    echo ""
    echo "Run tests:"
    echo "  cd ~/kernel-shadows/season-4-devops-automation/episode-14-docker-basics"
    echo "  ./tests/test.sh"
    echo ""
}

# Run main function
main "$@"


