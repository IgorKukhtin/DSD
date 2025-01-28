inherited DialogDateValueForm: TDialogDateValueForm
  Caption = #1042#1074#1086#1076' '#1079#1085#1072#1095#1077#1085#1080#1103
  ClientHeight = 112
  ClientWidth = 237
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 253
  ExplicitHeight = 151
  PixelsPerInch = 96
  TextHeight = 14
  inherited bbPanel: TPanel
    Top = 71
    Width = 237
    ExplicitTop = 71
    ExplicitWidth = 237
  end
  object PanelDateValue: TPanel
    Left = 0
    Top = 0
    Width = 237
    Height = 71
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object LabelDateValue: TLabel
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
      ExplicitWidth = 103
    end
    object DateValueEdit: TcxDateEdit
      Left = 70
      Top = 25
      EditValue = 41640d
      Properties.DateButtons = [btnToday]
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 95
    end
    object cbPartionDate_save: TCheckBox
      Left = 70
      Top = 53
      Width = 124
      Height = 17
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1055#1072#1088#1090#1080#1102
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      Visible = False
    end
  end
end
