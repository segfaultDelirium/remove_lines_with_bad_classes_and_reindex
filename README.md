This program was created to process COCO dataset for purpose of using it with YOLOv5 model.
We have selected 19 classes that we want the dataset to contain and discard other classes.
This program will read the label files, remove lines which class is not one of the 19 classes and then
reindex the classes so that class indexes are from 0 to 19.
