echo whales | sudo -S apt-get update -y && sudo -S apt-get upgrade -y


# https://medium.com/@RaghavPrabhu/a-simple-tutorial-to-classify-images-using-tensorflow-step-by-step-guide-7e0fad26c22

cd /media/tegwyn/Xavier_SD/dog-breed-identification/

python3 data_processing.py

# Copy inception into /tmp/imagenet/inception-2015-12-05.tgz (85 Mb) or else it will be downloaded:
cp /media/tegwyn/Xavier_SD/dog-breed-identification/imagenet /tmp

cd /media/tegwyn/Xavier_SD/dog-breed-identification/

python3 retrain.py --image_dir=build/dataset/ --bottleneck_dir=build/bottleneck/ --how_many_training_steps=5000 --output_graph=build/trained_model/retrained_graph.pb --output_lables=build/trained_model/retrained_labels.txt --summaries_dir=build/summaries



To run TensorBoard, run this command:
cd /media/tegwyn/Xavier_SD/dog-breed-identification/build/
tensorboard --logdir=summaries/ --host=0.0.0.0 --port=8888
http://0.0.0.0:8888/


cd /media/tegwyn/Xavier_SD/dog-breed-identification/
python3 classify.py

python3 retrain.py --image_dir=build/dataset/ --bottleneck_dir=build/bottleneck/ --how_many_training_steps=5000 --output_graph=build/trained_model/retrained_graph.pb --output_lables=build/trained_model/retrained_labels.txt --summaries_dir=build/summaries --input_width=680 --input_height=680
