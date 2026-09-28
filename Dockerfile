FROM pytorch/pytorch:2.5.1-cuda11.8-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    git wget libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 user
USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH \
    nnUNet_raw=/home/user/nnUNet_raw \
    nnUNet_preprocessed=/home/user/nnUNet_preprocessed \
    nnUNet_results=/home/user/nnUNet_results

WORKDIR $HOME

# Клонируем nnU-Net (движок) и ставим его
RUN git clone https://github.com/MIC-DKFZ/nnUNet.git $HOME/nnUNet
RUN cd $HOME/nnUNet && pip install --no-cache-dir -e . && pip install --no-cache-dir "numpy<2"

# Готовим целевую папку для весов
RUN mkdir -p $nnUNet_results/Dataset112_DentalSegmentator

# Копируем entrypoint
COPY --chown=user:user entrypoint.sh $HOME/entrypoint.sh
RUN chmod +x $HOME/entrypoint.sh

ENTRYPOINT ["/home/user/entrypoint.sh"]