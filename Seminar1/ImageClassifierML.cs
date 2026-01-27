using System;
using System.IO;
using Microsoft.ML;
using Microsoft.ML.Data;
using System.Collections.Generic;
using System.Linq;

namespace Seminar1
{
    public class ImageClassifierML
    {
        private static readonly string modelsFolder = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "AppData", "Models");
        private static readonly string modelPath = Path.Combine(modelsFolder, "squeezenet1.0-12.onnx");
        private static readonly string labelsPath = Path.Combine(modelsFolder, "imagenet_classes.txt");

        private static readonly MLContext mlContext = new MLContext(seed: 1);
        private static PredictionEngine<InputData, OutputPrediction> predictionEngine;
        private static string[] labels;

        static ImageClassifierML()
        {
            try
            {
                if (!File.Exists(modelPath))
                    throw new FileNotFoundException($"Modelul ONNX nu a fost găsit la: {modelPath}");

                if (!File.Exists(labelsPath))
                    throw new FileNotFoundException($"Fișierul cu clase nu a fost găsit la: {labelsPath}");

                labels = File.ReadAllLines(labelsPath);

                var pipeline = mlContext.Transforms
                    .LoadImages(outputColumnName: "image", imageFolder: "", inputColumnName: nameof(InputData.ImagePath))
                    .Append(mlContext.Transforms.ResizeImages("image_resized", 224, 224, "image"))
                    .Append(mlContext.Transforms.ExtractPixels("data", "image_resized"))
                    .Append(mlContext.Transforms.ApplyOnnxModel(
                        modelFile: modelPath,
                        outputColumnNames: new[] { "softmaxout_1" },
                        inputColumnNames: new[] { "data" }));

                var emptyData = mlContext.Data.LoadFromEnumerable(new List<InputData>());
                var model = pipeline.Fit(emptyData);

                predictionEngine = mlContext.Model.CreatePredictionEngine<InputData, OutputPrediction>(model);
            }
            catch (Exception ex)
            {
                var logPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "ml_error.log");
                File.WriteAllText(logPath, DateTime.Now + " ❌ Eroare ML: " + ex.ToString());
                predictionEngine = null;
            }
        }


        public static string Classify(byte[] imageBytes)
        {
            if (predictionEngine == null)
            {
                return "❌ Modelul ML nu este inițializat.";
            }

            string tempPath = null;
            try
            {
                // Salvează imaginea temporar
                tempPath = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString() + ".jpg");
                File.WriteAllBytes(tempPath, imageBytes);

                // Verifică dacă fișierul există
                if (!File.Exists(tempPath))
                {
                    return "❌ Nu s-a putut salva imaginea temporar.";
                }

                // Face predicția
                var input = new InputData { ImagePath = tempPath };
                var prediction = predictionEngine.Predict(input);

                // Găsește cele mai bune 3 predicții
                var topPredictions = GetTopPredictions(prediction.PredictedLabels, 3);

                // Formatează rezultatul
                var result = "🎯 Top predicții:\n";
                for (int i = 0; i < topPredictions.Count; i++)
                {
                    var (label, confidence) = topPredictions[i];
                    result += $"{i + 1}. {label}: {confidence:P1}\n";
                }

                return result;
            }
            catch (Exception ex)
            {
                return $"❌ Eroare la clasificare: {ex.Message}";
            }
            finally
            {
                // Șterge fișierul temporar
                if (tempPath != null && File.Exists(tempPath))
                {
                    try
                    {
                        File.Delete(tempPath);
                    }
                    catch { /* Ignoră eroarea de ștergere */ }
                }
            }
        }

        private static List<(string Label, float Confidence)> GetTopPredictions(float[] scores, int topK)
        {
            var predictions = new List<(string Label, float Score)>();

            for (int i = 0; i < scores.Length && i < labels.Length; i++)
            {
                predictions.Add((labels[i], scores[i]));
            }

            return predictions
                .OrderByDescending(p => p.Score)
                .Take(topK)
                .Select(p => (CleanLabel(p.Label), p.Score))
                .ToList();
        }

        private static string CleanLabel(string label)
        {
            // Curăță label-ul (elimină ID-ul de la început dacă există)
            if (label.Contains(':'))
            {
                return label.Substring(label.IndexOf(':') + 1).Trim();
            }
            return label;
        }

        // Clase pentru ML.NET
        public class InputData
        {
            [LoadColumn(0)]
            public string ImagePath { get; set; }
        }

        public class OutputPrediction
        {
            [ColumnName("softmaxout_1")]
            [VectorType(1000)]
            public float[] PredictedLabels { get; set; }
        }
    }
}