inherited DialogNumberValueForm: TDialogNumberValueForm
  Caption = #1042#1074#1086#1076' '#1079#1085#1072#1095#1077#1085#1080#1103
  ClientHeight = 90
  ClientWidth = 237
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 253
  ExplicitHeight = 125
  PixelsPerInch = 96
  TextHeight = 14
  inherited BottomPanel: TPanel
    Top = 49
    Width = 237
  end
  object NumberValuePanel: TPanel
    Left = 0
    Top = 0
    Width = 237
    Height = 49
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 292
    ExplicitHeight = 96
    object NumberValueLabel: TLabel
      Left = 0
      Top = 0
      Width = 237
      Height = 14
      Align = alTop
      Alignment = taCenter
      Caption = #1064#1090#1088#1080#1093' '#1082#1086#1076
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 59
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
