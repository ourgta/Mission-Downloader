; Created by https://github.com/ourgta
; Repository https://github.com/ourgta/Mission-Downloader

#Requires AutoHotkey v2.0-beta
#SingleInstance Force

;@Ahk2Exe-Obey U_bits, = %A_PtrSize% * 8
;@Ahk2Exe-Obey U_type, = "%A_IsUnicode%" ? "Unicode" : "ANSI"
;@Ahk2Exe-ExeName %A_ScriptName~\.[^\.]+$%_%U_type%_%U_bits%

;@Ahk2Exe-SetMainIcon Icon.ico

if not A_IsCompiled
    TraySetIcon("Icon.ico")

A_LocalAppData := EnvGet("LOCALAPPDATA")
A_ScriptPid := DllCall("GetCurrentProcessId")

missions := Map(
    "events.grandtheftarma.Conflict.Altis.pbo", "https://drive.google.com/uc?export=download&id=1U9dMSqgc6eqnYuoQR-pVNLh1Eq8bY-rF",
    "events.grandtheftarma.Conflict.Chernarus_Summer.pbo", "https://drive.google.com/uc?export=download&id=1b0WgjAN1AqyoinYuGAqon0toyuX3F3CL",
    "events.grandtheftarma.Conflict.Chernarus_Winter.pbo", "https://drive.google.com/uc?export=download&id=1R2VIqPb6o0eiqDSS7sppY_QBJK15V92n",
    "events.grandtheftarma.Conflict.Chernarus.pbo", "https://drive.google.com/uc?export=download&id=1IjVjigq4v5YXZmZ6OdnFTrqyAw8uftbO",
    "events.grandtheftarma.Conflict.Enoch.pbo", "https://drive.google.com/uc?export=download&id=1VkI3TeOo3aGqqNR_E1K3izLxRDK99d_r",
    "events.grandtheftarma.Conflict.Fapovo.pbo", "https://drive.google.com/uc?export=download&id=1aA3A6EKQMn5jO6xsVVU_quWJqmODDaa8",
    "events.grandtheftarma.Conflict.Lingor3.pbo", "https://drive.google.com/uc?export=download&id=1-z9eYiTcZFikwf0tWFEnT95vbddF8-1r",
    "events.grandtheftarma.Conflict.Malden.pbo", "https://drive.google.com/uc?export=download&id=1T2ZS7hbMHk-xt3RE2hursDX8GyPc_-YA",
    "events.grandtheftarma.Conflict.Sara_DBE1.pbo", "https://drive.google.com/uc?export=download&id=1u5XwRguzzn1X26r0Fp0636jspJlYUZe2",
    "events.grandtheftarma.Conflict.Stratis.pbo", "https://drive.google.com/uc?export=download&id=13BA76oxc2cqnAAI_vE-w_cXQNMMnSmgn",
    "events.grandtheftarma.Conflict.Takistan.pbo", "https://drive.google.com/uc?export=download&id=15F6m390gPPYXLcneTHUEd1HW7GPP7Sto",
    "events.grandtheftarma.Conflict.Tanoa.pbo", "https://drive.google.com/uc?export=download&id=11wAH3OqkTaC7DVy6NBEUqyss7X-RrRwm",
    "events.grandtheftarma.Conflict.WL_Rosche.pbo", "https://drive.google.com/uc?export=download&id=15dd_3-ed7fcPvfxPYnaZ1Y1RKoth_z7x",
    "events.grandtheftarma.Conflict.Zargabad.pbo", "https://drive.google.com/uc?export=download&id=10emY65C1DzNNcn3QvzcFStJwYABTZeQa",
    "s1.grandtheftarma.Life.Altis.pbo", "https://drive.google.com/uc?export=download&id=1HTxI3nyOST_9Q9GbifReFbN78rHRSkBl",
)

my_gui := Gui(, "Mission Downloader")
listbox := my_gui.AddListBox("R" missions.Count " W300 0x8")
for filename, url in missions
    listbox.Add([filename])
listbox.Choose(15)

select_all_button := my_gui.AddButton("W147", "Select all")
select_all_button.OnEvent("Click", SelectAllButtonClick)
select_none_button := my_gui.AddButton("yp W147", "Select none")
select_none_button.OnEvent("Click", SelectNoneButtonClick)

download_button := my_gui.AddButton("xm W300", "Download")
download_button.OnEvent("Click", DownloadButtonClick)

SelectAllButtonClick(*)
{
    Loop missions.Count
        listbox.Choose(A_Index)
}

SelectNoneButtonClick(*)
{
    listbox.Choose(0)
}

DownloadButtonClick(*)
{
    download_gui := Gui("-Caption +Owner" my_gui.Hwnd)
    download_gui.AddText("", "Downloading")
    download_gui.Show("NA")

    my_gui.GetPos(&my_gui_x, &my_gui_y, &my_gui_width, &my_gui_height)
    download_gui.GetPos(,, &download_gui_width, &download_gui_height)
    download_gui.Move(my_gui_x + ((my_gui_width - download_gui_width) // 2), my_gui_y + ((my_gui_height - download_gui_height) // 2))

    my_gui.Opt("Disabled")
    for filename in listbox.Text
        Download(missions[filename], A_LocalAppData "\Arma 3\MPMissionsCache\" filename)

    complete_gui := Gui("-Caption +Owner" my_gui.Hwnd)
    complete_gui.AddText("", "Download complete!")
    continue_button := complete_gui.AddButton("", "Continue")
    continue_button.OnEvent("Click", Destroy)

    complete_gui.Show("NA")
    download_gui.Destroy()

    complete_gui.GetPos(,, &complete_gui_width, &complete_gui_height)
    complete_gui.Move(my_gui_x + ((my_gui_width - complete_gui_width) // 2), my_gui_y + ((my_gui_height - complete_gui_height) // 2))

    Destroy(*)
    {
        my_gui.Opt("-Disabled")
        complete_gui.Destroy()
    }
}

my_gui.Show()
