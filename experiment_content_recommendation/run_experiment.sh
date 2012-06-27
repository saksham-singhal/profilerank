#!/bin/bash

databases_dir='../../data/'
#databases=("fiat" "brasileirao" "elections") 
databases=("fiat") 
train_rate=0.5
min_freq_content=2
min_freq_user=5
num_iterations_profilerank=10
damping_factor=0.85
my_media_lite_methods=("BPRMF" "ItemKNN" "Random" "UserKNN" "WRMF" "MostPopular" "WeightedItemKNN" "WeightedUserKNN" "Zero" "SoftMarginRankingMF" "WeightedBPRMF")

for database in ${databases[@]}
do
	echo "database: $database"
	
	echo "Generating data"
	python generate_data.py -t train-$database.csv -e test-$database.csv -r $train_rate -c $min_freq_content -u $min_freq_user $databases_dir$database\_tweets.csv -s
	
	echo "Running methods"
	python run.py -n $num_iterations_profilerank -d $damping_factor -o $database train-$database.csv test-$database.csv -s
	
	echo "Evaluating profilerank"
	python evaluate.py -o $database-profilerank $database\_profilerank.csv test-$database.csv -s

	for method in ${my_media_lite_methods[@]}
	do
		echo "Evaluating $method"
		python evaluate.py -o $database-$method $database\_$method.csv test-$database.csv -s
	done
	
done