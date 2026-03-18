from fastapi import FastAPI
import anthropic
import psycopg2
from dotenv import load_dotenv
import os
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware

#load .env file into memory
load_dotenv("../.env")

#initialize fastAPI app - "brain of backend"
app = FastAPI()

#allows request from any origin
#allows frontend to "talk" to backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"]
)

#access key from .env
api_key = os.environ.get("ANTHROPIC_API_KEY")
db_password = os.environ.get("DB_PASSWORD")

#access llm_context.sql
with open("../llm_context.sql", "r") as f:
    schema_context = f.read()


#connects to postgres db
conn = psycopg2.connect(
    host="localhost",
    port=5432,
    database="hmda",
    user="postgres",
    password=db_password
)

#@receive user question
#takes user query and unpacks it into a python string object
class QueryRequest(BaseModel):
    question: str

#create client - object used to send requests to Claude
client = anthropic.Anthropic(api_key=api_key)
    
#path between the frontend and backend
@app.post("/query")
def handle_query(request: QueryRequest):

    #prompt for client
    #converts question into SQL query using database
    query_prompt = f"You are a text-to-SQL expert.\n\nSchema:\n{schema_context}\n\nQuestion: {request.question}\n\nReturn only the SQL query, no explanation. If you cannot find a valid SQL translation, return 'Unable to find relevant answer.'"
    
    message = client.messages.create(
        model="claude-sonnet-4-20250514",
        max_tokens=1024,
        messages=[
            {"role": "user", "content": query_prompt}
        ]
    )

    #extracts the text from LLM
    sql_query = message.content[0].text
    sql_query = sql_query.strip()
    sql_query = sql_query.replace("```sql", "").replace("```", "").strip()
    print("Generated SQL:", sql_query)

    #runs SQl against postgres
    #cursor will execute queries onto db connection
    #will return error message if invalid SQL or any other issues
    try:
        cursor = conn.cursor()
        cursor.execute(sql_query)
        results = cursor.fetchall()
    except Exception as e:
        return {"error": "Sorry, I couldn't process your question. Please try again."}
    

    #converts SQL response to plain English
    response_prompt = f"You are a SQL-to-text expert.\n\nQuestion: {request.question}\n\n Given the answer {results} to the question, convert the SQL output into plain English. Answer the question directly and concisely. Don't start response with unnecessary text like 'Based on the SQL...'."

    response = client.messages.create(
        model="claude-sonnet-4-20250514",
        max_tokens=1024,
        messages=[
            {"role": "user", "content": response_prompt}
        ]
    )

    final_response = response.content[0].text
    cursor.close()

    #returns final response to frontend
    return {"answer": final_response}





