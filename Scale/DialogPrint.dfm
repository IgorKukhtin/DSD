inherited DialogPrintForm: TDialogPrintForm
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1077#1095#1072#1090#1080
  ClientHeight = 233
  ClientWidth = 301
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 317
  ExplicitHeight = 272
  PixelsPerInch = 96
  TextHeight = 14
  inherited bbPanel: TPanel
    Top = 192
    Width = 301
    ExplicitTop = 129
    ExplicitWidth = 301
    inherited bbOk: TBitBtn
      Left = 44
      Top = 9
      ExplicitLeft = 44
      ExplicitTop = 9
    end
    inherited bbCancel: TBitBtn
      Left = 167
      Top = 9
      ExplicitLeft = 167
      ExplicitTop = 9
    end
  end
  object PrintPanel: TPanel
    Left = 0
    Top = 113
    Width = 301
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 189
    object PrintCountLabel: TLabel
      Left = 160
      Top = 5
      Width = 85
      Height = 14
      Alignment = taCenter
      Caption = #1050#1086#1083'-'#1074#1086' '#1082#1086#1087#1080#1081' : '
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object PrintCountEdit: TcxCurrencyEdit
      Left = 249
      Top = 1
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.AssignedValues.DisplayFormat = True
      Properties.DecimalPlaces = 0
      TabOrder = 0
      Width = 35
    end
    object cbPrintPreview: TCheckBox
      Left = 21
      Top = 5
      Width = 120
      Height = 17
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1077#1095#1072#1090#1080
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
  end
  object PrintIsValuePanel: TPanel
    Left = 0
    Top = 0
    Width = 301
    Height = 113
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object cbPrintMovement: TCheckBox
      Left = 21
      Top = 5
      Width = 120
      Height = 17
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object cbPrintAccount: TCheckBox
      Left = 161
      Top = 5
      Width = 51
      Height = 17
      Caption = #1057#1095#1077#1090
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = cbPrintAccountClick
    end
    object cbPrintTransport: TCheckBox
      Left = 21
      Top = 30
      Width = 120
      Height = 17
      Caption = #1058#1058#1053
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = cbPrintTransportClick
    end
    object cbPrintQuality: TCheckBox
      Left = 21
      Top = 55
      Width = 120
      Height = 17
      Caption = #1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = cbPrintQualityClick
    end
    object cbPrintPack: TCheckBox
      Left = 161
      Top = 30
      Width = 120
      Height = 17
      Caption = #1059#1087#1072#1082#1086#1074#1086#1095#1085#1099#1081
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = cbPrintPackClick
    end
    object cbPrintSpec: TCheckBox
      Left = 161
      Top = 80
      Width = 120
      Height = 17
      Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = cbPrintSpecClick
    end
    object cbPrintTax: TCheckBox
      Left = 218
      Top = 5
      Width = 79
      Height = 17
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      OnClick = cbPrintTaxClick
    end
    object cbPrintPackGross: TCheckBox
      Left = 161
      Top = 55
      Width = 129
      Height = 17
      Caption = #1059#1087#1072#1082'. '#1076#1083#1103' '#1054#1061#1056#1040#1053#1067
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
    end
    object cbPrintDiffOrder: TCheckBox
      Left = 21
      Top = 80
      Width = 120
      Height = 17
      Caption = '% '#1054#1090#1082#1083' - '#1079#1072#1103#1074#1082#1072
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
    end
  end
  object PanelDateValue: TPanel
    Left = 0
    Top = 142
    Width = 301
    Height = 50
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitWidth = 237
    ExplicitHeight = 49
    object LabelDateValue: TLabel
      Left = 0
      Top = 0
      Width = 101
      Height = 14
      Align = alTop
      Alignment = taCenter
      Caption = #1044#1072#1090#1072' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DateValueEdit: TcxDateEdit
      Left = 102
      Top = 20
      EditValue = 41640d
      Properties.DateButtons = [btnToday]
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 95
    end
  end
end
