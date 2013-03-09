object MainForm: TMainForm
  Left = 0
  Top = 0
  ClientHeight = 390
  ClientWidth = 810
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ActionToolBar1: TActionToolBar
    Left = 0
    Top = 0
    Width = 810
    Height = 23
    ActionManager = ActionManager
    Caption = #1056#1072#1073#1086#1090#1072' '#1089' '#1092#1086#1088#1084#1072#1084#1080
    ColorMap.HighlightColor = 14410210
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = 14410210
    Spacing = 0
    ExplicitWidth = 719
  end
  object MainMenu: TMainMenu
    Left = 304
    Top = 16
    object N1: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      object N2: TMenuItem
        Caption = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
        object N3: TMenuItem
          Caption = #1060#1086#1088#1084#1072' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
          OnClick = N3Click
        end
        object N4: TMenuItem
          Caption = #1060#1086#1088#1084#1072' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103
          OnClick = N4Click
        end
      end
    end
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = actSave
          end>
        ActionBar = ActionToolBar1
      end>
    Left = 440
    Top = 24
    StyleName = 'Platform Default'
    object actSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnExecute = actSaveExecute
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'FormName'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'FormData'
        DataType = ftBlob
        ParamType = ptInput
      end>
    Left = 104
    Top = 24
  end
end
