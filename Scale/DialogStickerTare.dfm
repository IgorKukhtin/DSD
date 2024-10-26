inherited DialogStickerTareForm: TDialogStickerTareForm
  Caption = #1055#1077#1095#1072#1090#1072#1090#1100' '#1069#1090#1080#1082#1077#1090#1082#1080
  ClientHeight = 264
  ClientWidth = 256
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 272
  ExplicitHeight = 303
  PixelsPerInch = 96
  TextHeight = 14
  inherited bbPanel: TPanel
    Top = 223
    Width = 256
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
    Width = 256
    Height = 223
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object cxLabel3: TcxLabel
      Left = 145
      Top = 11
      Caption = #1044#1072#1090#1072' '#1076#1083#1103' '#1090#1072#1088#1099':'
    end
    object deDateTare: TcxDateEdit
      Left = 145
      Top = 31
      EditValue = 43101d
      Properties.ReadOnly = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 88
    end
    object cbTare: TcxCheckBox
      Left = 5
      Top = 7
      Caption = #1055#1077#1095#1072#1090#1072#1090#1100' '#1076#1083#1103' '#1058#1040#1056#1067
      TabOrder = 2
      Width = 125
    end
    object cbGoodsName: TcxCheckBox
      Left = 5
      Top = 31
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
      State = cbsChecked
      TabOrder = 3
      Width = 125
    end
    object cbPartion: TcxCheckBox
      Left = 5
      Top = 80
      Caption = #1055#1040#1056#1058#1048#1071' '#1076#1083#1103' '#1090#1072#1088#1099
      TabOrder = 4
      Width = 118
    end
    object cxLabel2: TcxLabel
      Left = 27
      Top = 109
      Caption = #1059#1055#1040#1050#1054#1042#1050#1040':'
    end
    object cxLabel4: TcxLabel
      Left = 145
      Top = 108
      Hint = #1044#1072#1090#1072' '#1091#1087#1072#1082#1086#1074#1082#1080
      Caption = #1042#1048#1043#1054#1058#1054#1042#1051#1045#1053#1053#1071':'
    end
    object deDateProduction: TcxDateEdit
      Left = 145
      Top = 126
      EditValue = 43101d
      Properties.ReadOnly = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 7
      Width = 88
    end
    object deDatePack: TcxDateEdit
      Left = 27
      Top = 126
      EditValue = 43101d
      Properties.ReadOnly = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 8
      Width = 88
    end
    object edPartion: TcxLabel
      Left = 31
      Top = 166
      Caption = #8470' '#1087#1072#1088#1090#1080#1080'  '#1091#1087#1072#1082#1086#1074#1082#1080':'
    end
    object cxLabel5: TcxLabel
      Left = 24
      Top = 194
      Caption = #8470' '#1089#1084#1077#1085#1099' '#1090#1077#1093#1085#1086#1083#1086#1075#1086#1074':'
    end
    object ceNumTech: TcxCurrencyEdit
      Left = 145
      Top = 190
      EditValue = 1.000000000000000000
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 11
      Width = 88
    end
    object ceNumPack: TcxCurrencyEdit
      Left = 145
      Top = 162
      EditValue = 1.000000000000000000
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 12
      Width = 88
    end
  end
end
