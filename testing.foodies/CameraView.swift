//
//  CameraView.swift
//  testing.foodies
//
//  Created by William Peter Lu on 2025/11/19.
//

import SwiftUI
import UIKit

// UIImagePickerController 的 SwiftUI 包裝器
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss
    var sourceType: UIImagePickerController.SourceType = .camera
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = true // 允許編輯（裁剪）
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage = originalImage
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// 相機視圖
struct CameraView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var capturedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                // 標題
                HStack {
                    Button("取消") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    
                    Spacer()
                    
                    Text("拍攝餐點")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // 佔位符，讓標題置中
                    Button("取消") {
                        dismiss()
                    }
                    .foregroundColor(.clear)
                    .font(.system(size: 18))
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
                
                // 說明文字
                VStack(spacing: 15) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("對準你的餐點")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("確保食物清晰可見，AI 將為你分析營養成分")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // 拍照按鈕
                Button(action: {
                    // 檢查相機是否可用
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        sourceType = .camera
                        showingImagePicker = true
                    } else {
                        // 如果相機不可用，使用相簿
                        sourceType = .photoLibrary
                        showingImagePicker = true
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70, height: 70)
                        
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "camera.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $capturedImage, sourceType: sourceType)
        }
        .onChange(of: capturedImage) { newImage in
            // 當圖片被選中時，自動關閉相機視圖
            if newImage != nil {
                dismiss()
            }
        }
    }
}

#Preview {
    CameraView(capturedImage: .constant(nil))
}

