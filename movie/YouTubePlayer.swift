//
//  YouTubePlayer.swift
//  movie
//
//  Created by aditya on 30/08/26.
//

import Foundation
import SwiftUI
import WebKit


struct YouTubePlayer: UIViewRepresentable {
    let videoId: String
    let youtubebaseUrl = ApiConfig.shared?.youTubeBaseUrl

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        let webview = WKWebView(frame: .zero, configuration: config)
        webview.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard context.coordinator.loadedVideoId != videoId else { return }
        guard let baseUrlString = youtubebaseUrl,
              let baseUrl = URL(string: baseUrlString) else { return }
        context.coordinator.loadedVideoId = videoId
        let embedUrl = baseUrl.appendingPathComponent(videoId).absoluteString + "?playsinline=1"
        let html = """
        <html>
        <head><meta name="viewport" content="width=device-width, initial-scale=1"></head>
        <body style="margin:0;padding:0;background:#000;">
        <iframe width="100%" height="100%" src="\(embedUrl)" frameborder="0" allowfullscreen></iframe>
        </body>
        </html>
        """
        uiView.loadHTMLString(html, baseURL: URL(string: "https://www.youtube-nocookie.com"))
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var loadedVideoId: String?
    }
}
