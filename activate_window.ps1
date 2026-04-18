# 激活 GoH Mod Manager 窗口
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WindowActivator {
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
    
    public static void ActivateWindow(string title) {
        var processes = System.Diagnostics.Process.GetProcesses();
        foreach (var process in processes) {
            if (process.MainWindowTitle.Contains(title)) {
                IntPtr hWnd = process.MainWindowHandle;
                ShowWindow(hWnd, 9); // SW_RESTORE
                SetForegroundWindow(hWnd);
                Console.WriteLine($"Activated: {process.MainWindowTitle}");
                return;
            }
        }
        Console.WriteLine("Window not found!");
    }
}
"@

[WindowActivator]::ActivateWindow("GoH Mod Manager")
