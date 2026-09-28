#!/bin/bash
set -e

TARGET="$nnUNet_results/Dataset112_DentalSegmentator"
mkdir -p "$TARGET"

echo "=== Копирую веса в nnUNet_results ==="
cp -r /models/* "$TARGET/"

echo "=== Структура весов ==="
ls -la "$TARGET"
ls -la "$TARGET/nnUNetTrainer__nnUNetPlans__3d_fullres/" || true

echo "=== Запуск nnUNetv2_predict ==="
nnUNetv2_predict \
  -i /input \
  -o /output \
  -d 112 \
  -c 3d_fullres \
  -tr nnUNetTrainer \
  -chk checkpoint_best.pth \
  -f 0 \
  -step_size 0.5

echo "=== Результаты ==="
ls -la /output

echo "=== Готово ==="