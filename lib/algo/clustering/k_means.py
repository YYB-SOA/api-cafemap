from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
# import sys
import pandas as pd
import subprocess
import re
import json

# subprocess.run("python -m pip install -r lib/requirements.txt", shell=True)

# This method can  only pass string
# citi = sys.argv[1]
# print(f"citi:\n\n {citi}")

# Read the contents of the file into a string
with open('lib/temp/新竹.txt', 'r') as f:
    json_string = f.read()

key_map = {
    ':id=>': '"id":',
    ':infoid=>': '"infoid":',
    ':info_id=>': '"info_id":',    
    ':name=>': '"name":',
    ':city=>': '"city":',
    ':wifi=>': '"wifi":',
    ':seat=>': '"seat":',
    ':quiet=>': '"quiet":',
    ':tasty=>': '"tasty":',    
    ':cheap=>': '"cheap":',
    ':music=>': '"music":',
    ':url=>': '"url":',    
    ':address=>': '"address":',
    ':latitude=>': '"latitude":',    
    ':longitude=>': '"longitude":',
    ':limited_time=>': '"limited_time":',
    ':socket=>': '"socket":',  
    ':standing_desk=>': '"standing_desk":',
    ':mrt=>': '"mrt":',    
    ':open_time=>': '"open_time":',
    ':created_at=>': '"created_at":',
    ':updated_at=>': '"updated_at":',  
    ':place_id=>': '"place_id":',
    ':formatted_address=>': '"formatted_address":',    
    ':business_status=>': '"business_status":',
    ':location_lat=>': '"location_lat":',
    ':location_lng=>': '"location_lng":',  
    ':viewport_ne_lat=>': '"viewport_ne_lat":',
    ':viewport_ne_lng=>': '"viewport_ne_lng":',    
    ':viewport_sw_lat=>': '"viewport_sw_lat":',
    ':viewport_sw_lng=>': '"viewport_sw_lng":',
    ':compound_code=>': '"compound_code":',  
    ':global_code=>': '"global_code":',    
    ':rating=>': '"rating":',
    ':user_ratings_total=>': '"user_ratings_total":',
    ':types=>': '"types":', 
}

s = json_string
for old_key, new_key in key_map.items():
    s = re.sub(old_key, new_key, s)

# Parse the modified string into a Python object using json.loads()
obj = json.loads(s)

# Create a dataframe from the object
df = pd.DataFrame(obj)


def kmeans_cluster(df, n_clusters=4):
    # Select only numeric columns for clustering
    df_numeric = df.select_dtypes(include=['float64', 'int64'])
    
    # Scale the numeric data
    scaler = StandardScaler()
    df_scaled = scaler.fit_transform(df_numeric)
    
    # Fit the k-means model
    kmeans = KMeans(n_clusters=n_clusters)
    kmeans.fit(df_scaled)
    
    # Add the cluster labels to the original dataframe
    df['cluster'] = kmeans.labels_
    return df

result = kmeans_cluster(df, n_clusters=4)
# print(result.head(3))
result.to_csv("lib/temp/新竹.csv")