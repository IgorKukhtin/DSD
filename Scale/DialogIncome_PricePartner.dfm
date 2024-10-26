inherited DialogIncome_PricePartnerForm: TDialogIncome_PricePartnerForm
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100
  ClientHeight = 161
  ClientWidth = 460
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 476
  ExplicitHeight = 200
  PixelsPerInch = 96
  TextHeight = 14
  inherited bbPanel: TPanel
    Top = 120
    Width = 460
    ExplicitTop = 223
    ExplicitWidth = 256
    inherited bbOk: TBitBtn
      Left = 51
      Top = 9
      ExplicitLeft = 51
      ExplicitTop = 9
    end
    inherited bbCancel: TBitBtn
      Left = 135
      Top = 9
      ExplicitLeft = 135
      ExplicitTop = 9
    end
  end
  object PanelValue: TPanel
    Left = 0
    Top = 0
    Width = 460
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 530
    object gbGoodsCode: TGroupBox
      Left = 0
      Top = 0
      Width = 130
      Height = 49
      Align = alLeft
      Caption = #1050#1086#1076
      TabOrder = 0
      ExplicitHeight = 97
      object EditGoodsCode: TEdit
        Left = 4
        Top = 17
        Width = 120
        Height = 22
        ReadOnly = True
        TabOrder = 0
        Text = 'EditGoodsCode'
      end
    end
    object gbGoodsName: TGroupBox
      Left = 130
      Top = 0
      Width = 330
      Height = 49
      Align = alClient
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077
      TabOrder = 1
      ExplicitLeft = 0
      ExplicitTop = 41
      ExplicitWidth = 135
      ExplicitHeight = 41
      object EditGoodsName: TEdit
        Left = 5
        Top = 17
        Width = 316
        Height = 22
        ReadOnly = True
        TabOrder = 0
        Text = 'EditGoodsName'
      end
    end
  end
  object gbAmountPartner: TGroupBox
    Left = 0
    Top = 49
    Width = 130
    Height = 71
    Align = alLeft
    Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082
    TabOrder = 2
    ExplicitHeight = 174
    object EditAmountPartner: TcxCurrencyEdit
      Left = 4
      Top = 15
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.AssignedValues.DisplayFormat = True
      Properties.DecimalPlaces = 4
      TabOrder = 0
      Width = 120
    end
    object cbAmountPartnerSecond: TCheckBox
      Left = 16
      Top = 42
      Width = 82
      Height = 17
      Caption = #1073#1077#1079' '#1086#1087#1083#1072#1090#1099
      TabOrder = 1
    end
  end
  object gbPrice: TGroupBox
    Left = 130
    Top = 49
    Width = 154
    Height = 71
    Align = alLeft
    Caption = #1042#1074#1086#1076' '#1062#1045#1053#1040
    TabOrder = 3
    ExplicitTop = 52
    object EditPrice: TcxCurrencyEdit
      Left = 5
      Top = 15
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.AssignedValues.DisplayFormat = True
      Properties.DecimalPlaces = 4
      TabOrder = 0
      Width = 125
    end
    object cbPriceWithVAT: TCheckBox
      Left = 16
      Top = 42
      Width = 82
      Height = 17
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057
      TabOrder = 1
    end
  end
  object gbOperDate: TGroupBox
    Left = 284
    Top = 49
    Width = 132
    Height = 71
    Align = alLeft
    Caption = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076
    TabOrder = 4
    ExplicitTop = 45
    object OperDateEdit: TcxDateEdit
      Left = 3
      Top = 15
      EditValue = 41640d
      ParentFont = False
      Properties.DateButtons = [btnToday]
      Properties.SaveTime = False
      Properties.ShowTime = False
      Style.Font.Charset = RUSSIAN_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = 'Arial'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 0
      Width = 120
    end
  end
end
