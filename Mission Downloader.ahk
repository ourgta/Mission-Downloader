; Created by https://github.com/ourgta
; Repository https://github.com/ourgta/Mission-Downloader

#Requires AutoHotkey v2.0-beta
#SingleInstance Force

;@Ahk2Exe-Obey U_bits, = %A_PtrSize% * 8
;@Ahk2Exe-Obey U_type, = "%A_IsUnicode%" ? "Unicode" : "ANSI"
;@Ahk2Exe-ExeName %A_ScriptName~\.[^\.]+$%_%U_type%_%U_bits%

;@Ahk2Exe-SetMainIcon Icon.ico

if not A_IsCompiled
    TraySetIcon "Icon.ico"

A_LocalAppData := EnvGet("LOCALAPPDATA")

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

my_gui := Gui()
listbox := my_gui.AddListBox("R" missions.Count " W300 0x8")
for filename, url in missions
    listbox.Add([filename])
listbox.Choose(15)

button := my_gui.AddButton("", "Download")
button.OnEvent("Click", ButtonClick)

ButtonClick(*)
{
    download_gui := Gui()
    download_gui.AddText("", "Downloading")
    download_gui.Show
    my_gui.Opt("Disabled")
    for filename in listbox.Text
        Download missions[filename], A_LocalAppData "\Arma 3\MPMissionsCache\" filename

    my_gui.Opt("-Disabled")
    download_gui.Destroy
    MsgBox "Download complete!"
}

my_gui.Show
