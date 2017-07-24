#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Transparent image script from "noname" in this thread: https://autohotkey.com/board/topic/102706-how-can-i-get-a-perfect-transparent-image/
; Microphone picture from https://thenounproject.com/term/muted-microphone/390515/ (https://d30y9cdsu7xlg0.cloudfront.net/png/390515-200.png)

; Script by Savasfreeman
; Version 0.0.1 / 24th of July, 2017

; MUST DO: Edit "MuteHotkey=xxxx" to whatever your hotkey is to mute your microphone or edit in discord to be CTRL+F9 then also change F11 down below if you prefer to mute with a different hotkey.

url=https://d30y9cdsu7xlg0.cloudfront.net/png/390515-200.png
ifnotexist, %a_scriptdir%\390515-200.png
URLDownloadToFile, %url%,%a_scriptdir%\390515-200.png

#include Gdip_All.ahk

If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}

MuteHotkey={LControl Down}{F9}{LControl UP}

Gui, 1: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +hwndhwnd +alwaysontop
Gui, 1: Show, NA ,dialog
Send %MuteHotkey%

sFile=%a_scriptdir%\390515-200.png
pBitmap:=Gdip_CreateBitmapFromFile(sFile)
Gdip_GetImageDimensions(pBitmap,w,h)

hbm := CreateDIBSection(w,h)
hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm)
pGraphics:=Gdip_GraphicsFromHDC(hdc)

Gdip_DrawImage(pGraphics, pBitmap, 0,0,w,h)
UpdateLayeredWindow(hwnd, hdc,(a_screenwidth-w)//25,(a_screenheight-h)//15,w,h)
Gdip_DisposeImage(pBitmap)


OnMessage(0x201, "WM_LBUTTONDOWN")

Return

WM_LBUTTONDOWN()
{
	PostMessage, 0xA1, 2
}

F11::
Toggle := !Toggle
If Toggle
{
	Gui, 1: Hide
	Send %MuteHotkey%
}
Else
{
	Gui, 1: Show
	Send %MuteHotkey%
}
return

esc::
SelectObject(hdc, obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeleteGraphics(pGraphics)

Gdip_Shutdown(pToken)
exitapp