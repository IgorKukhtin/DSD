object PhoneNoSeparatorDialogForm: TPhoneNoSeparatorDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1074#1086#1076' '#1085#1086#1084#1077#1088#1072' '#1090#1077#1083#1077#1092#1086#1085#1072
  ClientHeight = 153
  ClientWidth = 318
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 28
    Top = 107
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 210
    Top = 107
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object edPhone: TcxMaskEdit
    Left = 126
    Top = 45
    Properties.MaskKind = emkRegExpr
    Properties.EditMask = '\d\d\d\d\d\d\d\d\d\d\d\d'
    TabOrder = 2
    Width = 147
  end
  object cxLabel1: TcxLabel
    Left = 28
    Top = 46
    Caption = #1053#1086#1084#1077#1088' '#1090#1077#1083#1077#1092#1086#1085#1072':'
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 215
    Top = 78
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
    Left = 128
    Top = 76
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Phone'
        Value = 41579d
        Component = edPhone
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 39
    Top = 90
  end
end
