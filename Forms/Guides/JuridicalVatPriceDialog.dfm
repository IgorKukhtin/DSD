object JuridicalVatPriceDialogForm: TJuridicalVatPriceDialogForm
  Left = 0
  Top = 0
  Hint = #1057' '#1082#1072#1082#1086#1081' '#1076#1072#1090#1099' '#1089#1093#1077#1084#1072' '#1088#1072#1089#1095#1077#1090#1072' '#1094#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1087#1086#1089#1090#1088#1086#1095#1085#1086')'
  BorderStyle = bsDialog
  Caption = #1057#1093#1077#1084#1072' '#1088#1072#1089#1095#1077#1090#1072' '#1094#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1087#1086#1089#1090#1088#1086#1095#1085#1086')'
  ClientHeight = 184
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  ShowHint = True
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 8
    Top = 137
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 136
    Top = 137
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cbisVatPrice: TcxCheckBox
    Left = 24
    Top = 27
    Caption = #1057#1093'. '#1088#1072#1089#1095'. '#1094#1077#1085#1099' '#1089' '#1053#1044#1057' '#1089#1090#1088'. ('#1044#1072'/'#1053#1077#1090')'
    TabOrder = 2
    Width = 209
  end
  object cxLabel16: TcxLabel
    Left = 26
    Top = 71
    Caption = #1053#1072#1095'. '#1089#1093'. '#1088#1072#1089#1095'. '#1094#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1089#1090#1088'.)'
  end
  object edVatPriceDate: TcxDateEdit
    Left = 26
    Top = 94
    EditValue = 43952d
    Properties.SaveTime = False
    Properties.ShowTime = False
    Properties.ValidateOnEnter = False
    TabOrder = 4
    Width = 169
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 180
    Top = 95
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Left'
          'Top')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 261
    Top = 117
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inisVatPrice'
        Value = Null
        Component = cbisVatPrice
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inVatPriceDate'
        Value = 'NULL'
        Component = edVatPriceDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 255
    Top = 55
  end
end
