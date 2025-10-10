#!/bin/bash

################################################################################
# KERNEL SHADOWS: Episode 15 — CI/CD Pipelines
# Berlin, Germany (Day 29-30)
# Hans Müller, Chaos Computer Club (returns)
#
# Mission: Setup CI/CD pipeline with GitHub Actions,
#          automated testing, deployment, rollback strategy
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
PROJECT_DIR="$HOME/operation-shadow-cicd"

################################################################################
# Task 1: Create GitHub Actions Workflow
################################################################################
task1_create_workflow() {
    echo -e "${BLUE}[Task 1]${NC} Creating GitHub Actions workflow..."

    # TODO: Create workflow directory
    # Hint: mkdir -p "$PROJECT_DIR/.github/workflows"

    # TODO: Create basic CI workflow
    # Hint: See README.md Task 1 for complete workflow
    # Must include:
    # - on: push, pull_request
    # - jobs: test, build, deploy-staging
    # - steps: checkout, run tests, build Docker, push image

    echo -e "${GREEN}✓${NC} Workflow template created"
}

################################################################################
# Task 2: Automated Testing
################################################################################
task2_automated_testing() {
    echo -e "${BLUE}[Task 2]${NC} Setting up automated tests..."

    # TODO: Create tests directory
    # Hint: mkdir -p "$PROJECT_DIR/tests"

    # TODO: Create test script
    # Hint: tests/test.sh should check:
    # - Dockerfile exists
    # - Dockerfile builds successfully
    # - Application starts and responds

    echo -e "${GREEN}✓${NC} Tests configured"
}

################################################################################
# Task 3: Docker Registry Integration
################################################################################
task3_docker_registry() {
    echo -e "${BLUE}[Task 3]${NC} Setting up Docker registry integration..."

    echo -e "${YELLOW}NOTE:${NC} This requires GitHub secrets:"
    echo "  - DOCKER_USERNAME"
    echo "  - DOCKER_PASSWORD"
    echo "  Setup in: GitHub repo → Settings → Secrets"

    # TODO: Update workflow with docker/login-action
    # Hint: See README.md Task 3

    echo -e "${GREEN}✓${NC} Registry integration template ready"
}

################################################################################
# Task 4: Deploy to Staging
################################################################################
task4_deploy_staging() {
    echo -e "${BLUE}[Task 4]${NC} Configuring staging deployment..."

    echo -e "${YELLOW}NOTE:${NC} Requires staging server secrets:"
    echo "  - STAGING_HOST"
    echo "  - STAGING_USER"
    echo "  - STAGING_SSH_KEY"

    # TODO: Add deploy-staging job to workflow
    # Hint: Use appleboy/ssh-action for SSH deployment

    echo -e "${GREEN}✓${NC} Staging deployment configured"
}

################################################################################
# Task 5: Production Deployment with Approval
################################################################################
task5_production_deployment() {
    echo -e "${BLUE}[Task 5]${NC} Configuring production deployment..."

    echo -e "${YELLOW}NOTE:${NC} Setup environment protection:"
    echo "  1. GitHub → Settings → Environments → production"
    echo "  2. Enable 'Required reviewers'"
    echo "  3. Add Max, Dmitry, Hans as reviewers"

    # TODO: Add deploy-production job with manual approval
    # Hint: environment: production (triggers approval gate)

    echo -e "${GREEN}✓${NC} Production deployment with approval configured"
}

################################################################################
# Task 6: Rollback Strategy
################################################################################
task6_rollback_strategy() {
    echo -e "${BLUE}[Task 6]${NC} Creating rollback workflow..."

    # TODO: Create .github/workflows/rollback.yml
    # Hint: workflow_dispatch with version input
    # Hint: SSH to production, pull specific version, restart

    echo -e "${GREEN}✓${NC} Rollback workflow created"
}

################################################################################
# Task 7: Blue-Green Deployment (Advanced)
################################################################################
task7_blue_green() {
    echo -e "${BLUE}[Task 7]${NC} Blue-green deployment setup..."

    echo -e "${YELLOW}⚠${NC}  Advanced task - see README.md Task 7"
    echo "    Blue-green deployment requires nginx load balancer"

    # This is an advanced pattern - manual implementation
}

################################################################################
# Task 8: Monitoring & Alerts
################################################################################
task8_monitoring() {
    echo -e "${BLUE}[Task 8]${NC} Adding monitoring checks..."

    # TODO: Add post-deployment monitoring job
    # Hint: Check Prometheus metrics (error rate, latency)
    # Hint: Alert on Slack if metrics exceed threshold

    echo -e "${GREEN}✓${NC} Monitoring configured"
}

################################################################################
# Task 9: INCIDENT - Emergency Rollback (Manual)
################################################################################
task9_incident_rollback() {
    echo -e "${YELLOW}[Task 9 — INCIDENT]${NC} Emergency rollback procedure..."

    echo -e "${YELLOW}⚠${NC}  This is an incident response simulation"
    echo "    See README.md Task 9 for complete scenario"
    echo ""
    echo "Scenario: Production is DOWN! HTTP 500 errors!"
    echo "Your task: Rollback in under 5 minutes"
    echo ""
    echo "Steps:"
    echo "  1. Identify broken deployment (git log)"
    echo "  2. Trigger rollback workflow"
    echo "  3. Verify health checks"
    echo "  4. Document post-mortem"
}

################################################################################
# Main execution
################################################################################
main() {
    echo ""
    echo "================================================================"
    echo "  KERNEL SHADOWS: Episode 15 — CI/CD Pipelines"
    echo "  Berlin, Germany (Chaos Computer Club)"
    echo "  Hans Müller: 'Automate carefully.'"
    echo "================================================================"
    echo ""

    echo -e "${YELLOW}NOTE:${NC} This episode requires:"
    echo "  - GitHub repository with Actions enabled"
    echo "  - Docker Hub account (for registry)"
    echo "  - Staging/production servers (or local simulation)"
    echo ""
    echo -e "${YELLOW}TIP:${NC} Can simulate locally with:"
    echo "  - act (run GitHub Actions locally)"
    echo "  - Docker containers as 'servers'"
    echo ""

    # Uncomment tasks as you complete them
    task1_create_workflow
    # task2_automated_testing
    # task3_docker_registry
    # task4_deploy_staging
    # task5_production_deployment
    # task6_rollback_strategy
    # task7_blue_green      # Advanced
    # task8_monitoring
    # task9_incident_rollback  # Manual exercise

    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Episode 15 starter tasks initialized!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Project directory: $PROJECT_DIR"
    echo ""
    echo "Next steps:"
    echo "  1. Complete workflow files in $PROJECT_DIR/.github/workflows/"
    echo "  2. Setup GitHub secrets (Docker, SSH keys)"
    echo "  3. Push to GitHub and watch Actions run"
    echo "  4. Practice rollback procedure"
    echo ""
    echo "Run tests:"
    echo "  cd ~/kernel-shadows/season-4-devops-automation/episode-15-cicd-pipelines"
    echo "  ./tests/test.sh"
    echo ""
}

# Run main function
main "$@"


