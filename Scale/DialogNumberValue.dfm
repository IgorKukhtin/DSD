inherited DialogNumberValueForm: TDialogNumberValueForm
  Caption = #1042#1074#1086#1076' '#1079#1085#1072#1095#1077#1085#1080#1103
  ClientHeight = 87
  ClientWidth = 216
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 232
  ExplicitHeight = 126
  PixelsPerInch = 96
  TextHeight = 14
  inherited bbPanel: TPanel
    Top = 46
    Width = 216
    ExplicitTop = 49
    ExplicitWidth = 237
  end
  object PanelNumberValue: TPanel
    Left = 0
    Top = 0
    Width = 216
    Height = 46
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 237
    ExplicitHeight = 49
    object LabelNumberValue: TLabel
      Left = 0
      Top = 0
      Width = 216
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
    object NumberValueEdit: TcxCurrencyEdit
      Left = 49
      Top = 25
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.AssignedValues.DisplayFormat = True
      Properties.DecimalPlaces = 0
      TabOrder = 0
      Width = 135
    end
  end
end
