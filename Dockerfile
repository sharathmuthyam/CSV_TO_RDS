FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Professional SE touch: The Entrypoint is the Log Parser engine
ENTRYPOINT ["python", "app.py"]

# Default arguments: It looks for 'production.log' and searches for 'ERROR'
CMD ["CS_101", "canvas_grades.csv"]