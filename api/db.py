from dotenv import load_dotenv
import os
from pymongo import MongoClient

load_dotenv()

MONGO_URI = os.getenv('MONGO_URI')
DB_NAME = 'FASILA_Guide'

mongo_client = MongoClient(MONGO_URI)
mongo_db = mongo_client[DB_NAME]

print('Connected to MongoDB')
print('Database Name:', mongo_db.list_collection_names())