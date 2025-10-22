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
