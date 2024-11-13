from flask import Flask, request, jsonify
import joblib
import pandas as pd

#ngrok http --url https://summary-currently-chipmunk.ngrok-free.app 5000

# Load data and similarity matrix
data = pd.read_csv("merged4.csv")
similarity_matrix = joblib.load("similarity_matrix.pkl")

app = Flask(__name__)

def get_recommendations(selected_id, df, similarity_matrix):
    # Check if the selected ID exists in the dataset
    if selected_id not in df['id'].values:
        return {"error": "Selected ID not found in the dataset."}
    
    # Get the index of the selected item
    selected_index = df[df['id'] == selected_id].index[0]
    selected_category = df.loc[selected_index, 'masterCategory']
    
    # Define categories based on selected item
    recommendations = {
        "bottomwear": [],
        "topwear": [],
        "accessories": [],
        "footwear": []
    }
    
    # Set target categories based on selection
    target_categories = []
    if selected_category == 'Topwear':
        target_categories = ['Bottomwear', 'Accessories', 'Footwear']
    elif selected_category == 'Bottomwear':
        target_categories = ['Topwear', 'Accessories', 'Footwear']
    else:
        return {"error": "Invalid category. Only 'Topwear' and 'Bottomwear' are allowed."}
    
    # Get recommendations for each target category
    for category in target_categories:
        target_items = df[df['masterCategory'] == category].index.tolist()
        if len(target_items) > 0:
            similarities = similarity_matrix[selected_index, target_items]
            sorted_indices = similarities.argsort()[::-1][:3]
            recommended_indices = [target_items[i] for i in sorted_indices]
            
            # Store only the IDs of the top 3 recommendations in the dictionary
            recommendations[category.lower()] = df.loc[recommended_indices, 'id'].tolist()
    
    return recommendations


# Flask route to get recommendations
@app.route('/recommendations', methods=['GET'])
def recommend():
    selected_id = request.args.get('id', type=int)
    if selected_id is None:
        return jsonify({"error": "ID parameter is required"}), 400
    
    # Get recommendations
    recommendations = get_recommendations(selected_id, data, similarity_matrix)
    return jsonify(recommendations)

if __name__ == '__main__':
    app.run(debug=True)
