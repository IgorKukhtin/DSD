inherited DialogMessageForm: TDialogMessageForm
  Left = 20
  Top = 101
  Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077
  ClientHeight = 172
  ClientWidth = 614
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 630
  ExplicitHeight = 207
  PixelsPerInch = 96
  TextHeight = 14
  inherited bbPanel: TPanel
    Top = 131
    Width = 614
    ExplicitTop = 131
    ExplicitWidth = 614
  end
  object MemoMessage: TMemo
    Left = 0
    Top = 31
    Width = 614
    Height = 100
    Align = alClient
    Alignment = taCenter
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Lines.Strings = (
      #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1074#1077#1088#1096#1080#1090#1100' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' '#1080' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090'?')
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
  end
  object PanelTime: TPanel
    Left = 0
    Top = 0
    Width = 614
    Height = 31
    Align = alTop
    BevelOuter = bvNone
    Caption = 'PanelTime'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 216
    Top = 32
  end
end
