{
  inputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: 
let
  pythonEnv = pkgs.python313.withPackages (ps: with ps; [
    requests
    urllib3
    numpy
    pandas
    scipy
    matplotlib
    seaborn
    polars
    scikit-learn
    python-dotenv
    fastapi
    flask
    gradio
    openai
    pillow
    opencv-python
    moviepy
    tqdm
    rich
    black
    pytest
    pendulum
    cryptography
    openpyxl
    neo4j
  ]);
in
{
  imports = [
    ./..
  ];

  environment.systemPackages = with pkgs; [
    pythonEnv
  ];
}
