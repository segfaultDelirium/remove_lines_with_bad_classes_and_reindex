defmodule ReindexLabels do
  @moduledoc """
  Documentation for `ReindexLabels`.

    First from label files we remove the lines that contain class not in classes19. Then we reindex remainning lines so that the indexes are from 0 to 19
  """

  @doc """
  Hello world.

  ## Examples

      iex> ReindexLabels.hello()
      :world
  combined        - COCO            - VOC               - Objects365
  0: person       - 0: person       - 14: person        - 0: Person
  1: bicycle      - 1: bicycle      - 1: bicycle        - 46: Bicycle
  2: car          - 2: car          - 6: car            - 5: Car
  3: motorcycle   - 3: motorcycle   - 13: motorbike     - 58: Motorcycle
  4: airplane     - 4: airplane     - 0: aeroplane      - 114: Airplane
  5: bus          -  5: bus          - 5: bus -          - 55: Bus
  6: train        - 6: train        - 18: train         - 116: Train
  7: boat         - 8: boat         - 3: boat           - 21: Boat
  8: bird         - 14: bird        - 2: bird           - 56: Wild Bird
  9: cat          - 15: cat         - 7: cat            - 139: Cat
  10: dog         - 16: dog         - 11: dog           - 92: Dog
  11: horse       - 17: horse       - 12: horse         - 78: Horse
  12: cow         - 19: cow         - 9: cow            - 96: Cow
  13: bottle      - 39: bottle      - 4: bottle         - 8: Bottle
  14: chair       - 56: chair       - 8: chair          - 2: Chair
  15: couch       - 57: couch       - 17: sofa          - 50: Couch
  16: potted plant- 58: potted plant- 15: pottedplant   - 25: Potted Plant
  17: dining table- 60: dining table- 10: diningtable   - 98: Dinning Table
  18: sheep       - 18: sheep       - 16: sheep         - 99: Sheep
  19: tv          - 62: tv          - 19: tvmonitor     - 37: Monitor/TV

  """

  def hello do
    :world
  end

  def main() do

    reindex_mapping = get_reindex_mapping()
    classes19 = get_classes19()
    train_label_filenames = Path.wildcard("input/labels/train2017/*.txt")
    val_label_filenames = Path.wildcard("input/labels/val2017/*.txt")

    process_filenames(train_label_filenames, classes19, reindex_mapping)
    process_filenames(val_label_filenames, classes19, reindex_mapping)
  end

  def process_filenames(filenames, classes19, reindex_mapping) do
    filenames
    |> Enum.map(fn filename ->
      new_file_content = filename |> File.read!() |> process_label_file(classes19, reindex_mapping)
      new_filename = filename |> String.replace("input", "output")
      File.write(new_filename, new_file_content)
    end)
  end

  def process_label_file(file_content, classes19, reindex_mapping) do
    file_content
    |> String.split("\n", trim: true)
    |> Enum.filter(fn line ->
      [class | _remaining_splits] = line |> String.split(" ", parts: 2)
      classes19 |> Enum.find(&(&1 == class)) != nil
    end)
    |> Enum.map(fn line ->
      [class | remaining_line] = line |> String.split(" ", parts: 2)
      new_class = reindex_mapping |> Map.get(class)
      new_class <> " " <> List.first(remaining_line)
    end)
    |> Enum.join("\n")
  end


  def get_reindex_mapping() do
     %{
      "0" => "0",
      "1" => "1",
      "2" => "2",
      "3" => "3",
      "4" => "4",
      "5" => "5",
      "6" => "6",
      "8" => "7",
      "14" => "8",
      "15" => "9",
      "16" => "10",
      "17" => "11",
      "19" => "12",
      "39" => "13",
      "56" => "14",
      "57" => "15",
      "58" => "16",
      "60" => "17",
      "18" => "18",
      "62" => "19"
    }

  end
  
  def get_classes19() do
     [
      "0",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "8",
      "14",
      "15",
      "16",
      "17",
      "19",
      "39",
      "56",
      "57",
      "58",
      "60",
      "18",
      "62"
    ]
  end
end
