# Simple Flask app

This is a minimal Flask application with two routes:

- GET / -> returns a greeting JSON
- GET /health -> returns service health

How to run:

1. Create a virtual environment and install dependencies:

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

2. Run the app:

```bash
python app.py
```

3. Run tests:

```bash
pytest -q
```

Jenkins CI
----------

This repository contains a `Jenkinsfile` that runs tests in a Docker-based Jenkins agent.

Key points:
- The pipeline uses the `python:3.12-slim` Docker image, creates a virtualenv, installs dependencies from `requirements.txt`, runs `pytest` and produces a JUnit XML report (`junit-results.xml`).
- Jenkins must be configured to run Docker agents or have Docker available on the node.
- The pipeline archives the JUnit test results using the `junit` step and cleans the workspace afterwards.

If your Jenkins environment doesn't support Docker agents, replace the `agent { docker { ... } }` block with an appropriate non-Docker agent and ensure Python and pip are available on that node.

