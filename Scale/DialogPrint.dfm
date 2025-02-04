inherited DialogPrintForm: TDialogPrintForm
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1077#1095#1072#1090#1080
  ClientHeight = 425
  ClientWidth = 301
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 317
  ExplicitHeight = 464
  PixelsPerInch = 96
  TextHeight = 14
  inherited bbPanel: TPanel
    Top = 384
    Width = 301
    ExplicitTop = 384
    ExplicitWidth = 301
    inherited bbOk: TBitBtn
      Left = 12
      Top = 9
      Width = 74
      Height = 27
      ExplicitLeft = 12
      ExplicitTop = 9
      ExplicitWidth = 74
      ExplicitHeight = 27
    end
    inherited bbCancel: TBitBtn
      Left = 217
      Top = 9
      Width = 74
      Height = 27
      ExplicitLeft = 217
      ExplicitTop = 9
      ExplicitWidth = 74
      ExplicitHeight = 27
    end
    object btnSaveAll: TBitBtn
      Left = 92
      Top = 9
      Width = 118
      Height = 27
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1042#1057#1045
      Default = True
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        88888888488884088888848C88884870888884C888848C4708888C448848CCC4
        70888888888CCCCC470888888888CCCCC488888108888CCCCC888818708888CC
        C88881891708888C888818999170888888888999991708811188889999918888
        9188888999998889818888889998889888888888898888888888}
      TabOrder = 2
      OnClick = btnSaveAllClick
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
    Height = 54
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object LabelDateValue: TLabel
      Left = 0
      Top = 0
      Width = 301
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
      ExplicitWidth = 101
    end
    object DateValueEdit: TcxDateEdit
      Left = 102
      Top = 20
      EditValue = 41640d
      Properties.DateButtons = [btnToday]
      Properties.SaveTime = False
      Properties.ShowTime = False
      Properties.OnChange = DateValueEditPropertiesChange
      TabOrder = 0
      Width = 95
    end
  end
  object PanelComment: TPanel
    Left = 0
    Top = 250
    Width = 301
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    object Label1: TLabel
      Left = 4
      Top = 2
      Width = 73
      Height = 14
      Alignment = taCenter
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077':'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object CommentEdit: TEdit
      Left = 4
      Top = 20
      Width = 280
      Height = 22
      TabOrder = 0
      Text = 'CommentEdit'
    end
  end
  object PanelInvNumberPartner: TPanel
    Left = 0
    Top = 196
    Width = 301
    Height = 54
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    object Label4: TLabel
      Left = 2
      Top = 2
      Width = 139
      Height = 14
      Alignment = taCenter
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#8470
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object InvNumberPartnerEdit: TEdit
      Left = 4
      Top = 22
      Width = 280
      Height = 22
      TabOrder = 0
      Text = 'InvNumberPartnerEdit'
    end
  end
  object PanelDiscountAmountPartner: TPanel
    Left = 0
    Top = 298
    Width = 301
    Height = 79
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 6
    object Label2: TLabel
      Left = 69
      Top = 59
      Width = 56
      Height = 14
      Alignment = taCenter
      Caption = '% '#1057#1082#1080#1076#1082#1080':'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object rgDiscountAmountPartner: TRadioGroup
      Left = 0
      Top = 0
      Width = 301
      Height = 46
      Align = alTop
      Caption = #1042#1080#1076' '#1089#1082#1080#1076#1082#1080
      Columns = 2
      Items.Strings = (
        #1079#1072' '#1082#1072#1095#1077#1089#1090#1074#1086
        #1079#1072' '#1090#1077#1084#1087#1077#1088#1072#1090#1091#1088#1091)
      TabOrder = 0
    end
    object DiscountAmountPartnerEdit: TcxCurrencyEdit
      Left = 131
      Top = 56
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.'
      Properties.Nullable = False
      TabOrder = 1
      OnExit = DiscountAmountPartnerEditExit
      Width = 76
    end
  end
end
