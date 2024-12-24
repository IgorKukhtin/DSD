inherited DialogDateReportForm: TDialogDateReportForm
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
  ClientHeight = 130
  ClientWidth = 237
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 253
  ExplicitHeight = 169
  PixelsPerInch = 96
  TextHeight = 14
  object LabelValue: TLabel [0]
    Left = 0
    Top = 0
    Width = 237
    Height = 14
    Align = alTop
    Alignment = taCenter
    Caption = #1082#1072#1082#1086#1077'-'#1090#1086' '#1079#1085#1072#1095#1077#1085#1080#1077
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitTop = -2
  end
  inherited bbPanel: TPanel
    Top = 89
    Width = 237
    ExplicitTop = 89
    ExplicitWidth = 237
  end
  object PanelDateValue: TPanel
    Left = 0
    Top = 14
    Width = 237
    Height = 75
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object deStart: TcxDateEdit
      Left = 9
      Top = 23
      EditValue = 41640d
      Properties.DateButtons = [btnToday]
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 83
    end
    object cbGoodsKind: TcxCheckBox
      Left = 122
      Top = 50
      Caption = #1087#1086' '#1042#1080#1076#1072#1084' '#1090#1086#1074#1072#1088#1072
      Properties.ReadOnly = False
      TabOrder = 1
      Width = 114
    end
    object cbPartionGoods: TcxCheckBox
      Left = 9
      Top = 50
      Caption = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      Properties.ReadOnly = False
      TabOrder = 2
      Width = 88
    end
    object cxLabel5: TcxLabel
      Left = 9
      Top = 4
      Caption = #1044#1072#1090#1072' '#1089' :'
    end
    object cxLabel6: TcxLabel
      Left = 122
      Top = 4
      Caption = #1044#1072#1090#1072' '#1087#1086' :'
    end
    object deEnd: TcxDateEdit
      Left = 122
      Top = 23
      EditValue = 41640d
      Properties.DateButtons = [btnToday]
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 5
      Width = 83
    end
  end
end
