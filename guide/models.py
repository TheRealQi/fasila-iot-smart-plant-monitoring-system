from guide.db import mongo_db
from django.db import models

diseases_collection = mongo_db['Diseases']
plants_collection = mongo_db['Plants']
