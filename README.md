## Image Classification App with SwiftUI and CoreML

### Overview
This app is a simple image classification application built using SwiftUI and CoreML. The app allows users to capture an image and classify it using a pre-trained CoreML model (`MyImageClassifier`). If the classification confidence is high enough, the app navigates to a result page displaying the classified data.

### Features
- Capture and display an image.
- Classify the image using a CoreML model.
- Display the classification confidence.
- Navigate to a result page if the classification confidence is high.
- Handle classification errors gracefully.

### Structure

#### `ContentView`
The main view of the app that handles image capturing, displaying, and classification.

#### `UIImage` Extension
An extension to convert `UIImage` to `CVPixelBuffer`, which is required by the CoreML model for prediction.

### Code Explanation

#### Properties

- `@State private var error: Bool`: State variable to handle errors.
- `@State private var predictedImage: UIImage?`: State variable to store the predicted image.
- `let labels = ["Data Laple"]`: Array of labels for classification.
- `@State private var classificationLabel = ""`: State variable to store the classification label.
- `@State private var selectedData: Data?`: State variable to store the selected data based on classification.
- `@State private var navigateToResultPage = false`: State variable to handle navigation to the result page.
- `var capturedImage: UIImage`: The captured image to be classified.
- `let model: MyImageClassifier`: The CoreML model used for image classification.

#### `body`
The main view layout:
- Displays the captured image.
- A button to initiate the image classification.
- A `NavigationLink` to navigate to the result page if the classification is successful.
- A `Text` view to display the classification label.

#### `classifyImage(capturedImage: UIImage)`
Function to classify the captured image:
1. Converts the `UIImage` to a `CVPixelBuffer`.
2. Uses the CoreML model to predict the classification.
3. Checks the confidence of the prediction.
4. Updates the state variables based on the prediction result.

#### `UIImage` Extension
An extension to convert a `UIImage` to `CVPixelBuffer` which is needed by CoreML for prediction.

### Usage

1. **Capturing an Image**:
   The app captures an image which is displayed in the main view.

2. **Classifying the Image**:
   Press the "Scan" button to classify the image using the CoreML model.

3. **Viewing the Result**:
   If the classification confidence is above a threshold (0.85 in this case), the app navigates to the `ResultPage` showing the classified data and image. If the confidence is below the threshold, a message indicating no match is displayed.

### Error Handling
- If the image conversion or prediction fails, an error message is displayed in the `classificationLabel`.
