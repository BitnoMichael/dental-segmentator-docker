#!/bin/bash
set -e

TARGET="$nnUNet_results/Dataset112_DentalSegmentator"
mkdir -p "$TARGET"

echo "=== Копирую веса в nnUNet_results ==="
cp -r /models/* "$TARGET/"

echo "=== Структура весов ==="
ls -la "$TARGET"
ls -la "$TARGET/nnUNetTrainer__nnUNetPlans__3d_fullres/" || true
ls -la "$TARGET/nnUNetTrainer__nnUNetPlans__3d_fullres/fold_0/" || true

# Автоматически определяем имя чекпоинта
CKPT_DIR="$TARGET/nnUNetTrainer__nnUNetPlans__3d_fullres/fold_0"
if [ -f "$CKPT_DIR/checkpoint_best.pth" ]; then
    CKPT="checkpoint_best.pth"
elif [ -f "$CKPT_DIR/checkpoint_final.pth" ]; then
    CKPT="checkpoint_final.pth"
else
    echo "!!! Ни checkpoint_best.pth, ни checkpoint_final.pth не найдены в $CKPT_DIR"
    echo "!!! Содержимое папки:"
    ls -la "$CKPT_DIR"
    exit 1
fi

echo "=== Использую чекпоинт: $CKPT ==="

echo "=== Запуск nnUNetv2_predict ==="
nnUNetv2_predict \
  -i /input \
  -o /output \
  -d 112 \
  -c 3d_fullres \
  -tr nnUNetTrainer \
  -chk "$CKPT" \
  -f 0 \
  -step_size 0.5

echo "=== Результаты ==="
ls -la /output

echo "=== Готово ==="
