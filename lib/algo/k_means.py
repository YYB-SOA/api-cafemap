from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
from sys import argv
import sys

store_name = sys.argv[1]
print(f"store_name: {store_name}")


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
