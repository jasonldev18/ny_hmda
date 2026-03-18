# 2017 NY HMDA Query Bot

## About
This project is a web app that uses a Text-to-SQL pipeline powered by Claude API. It answers natural language questions about 2017 New York Home Mortgage Disclosural Act (HMDA) data, backed by a normalized PostgresSQL database.

## Tech Stack
- Database: PostgreSQL
- Backend: Python, FastAPI
- LLM: Claude API 
- Frontend: HTML, CSS, JavaScript
- Others: Docker, psycopg2, python-dotenv

## Architecture
The user submits a natural language question through the frontend. The question is sent to the backend via FastAPI, where it is combined with the database schema and sent to an LLM powered by the Claude API, which converts it into a SQL query. That query is executed against the PostgreSQL database using a cursor object, returning raw results. The results are sent back to the LLM which converts them into a natural language response, which is then returned to the frontend and displayed to the user.

## Setup

### Pre-Requisites
- Docker
- Anthropic API key — create one at [console.anthropic.com](https://console.anthropic.com)

### Installation

1. **Download the HMDA dataset**
   - Go to [consumerfinance.gov](https://www.consumerfinance.gov)
   - Select NY as geographic area, All Records, Plain Language Labels and HMDA Codes
   - Place the CSV in the project root folder

2. **Create a virtual environment and install dependencies**
```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

3. **Set up environment variables**
   - Create a `.env` file in the project root:
```
ANTHROPIC_API_KEY=your_key_here
DB_PASSWORD=your_password_here
```

4. **Set up PostgreSQL in Docker**
```bash
docker run --name hmda-postgres -e POSTGRES_PASSWORD=yourpassword -p 5432:5432 -d postgres
```

5. **Run the SQL script to build the database**
```bash
docker exec -i hmda-postgres psql -U postgres -d hmda -f hmdaproj.sql
```

### Running the App

1. **Start the Docker container**
```bash
docker start hmda-postgres
```

2. **Start the backend**
```bash
cd backend
uvicorn main:app --reload
```

3. **Open the frontend**
   - Open `frontend/index.html` in your browser or use Live Server in VS Code

## Example Queries

Q: What percentage of loan applications were denied for each race?
A: The percentage of loan applications denied by race is:

- American Indian or Alaska Native: 31.7%
- Native Hawaiian or Other Pacific Islander: 28.9%
- Black or African American: 24.9%
- Information not provided by applicant: 23.5%
- Asian: 15.4%
- White: 14.8%
- Not applicable: 1.4%

American Indian or Alaska Native applicants had the highest denial rate, while those in the "Not applicable" category had the lowest denial rate.

Q:Which county had the highest average loan amount in 2017?
A:New York County had the highest average loan amount in 2017, with an average of $1,370.86.

Q:What was the most common reason for denial among female applicants?
A:The most common reason for denial among female applicants was "Debt-to-income ratio" with 5,237 cases.


