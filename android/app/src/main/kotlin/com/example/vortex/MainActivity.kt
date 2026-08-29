package com.example.vortex

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Enable OS-level anti-screenshot and screen recording protection
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }
}
