object PromoCodeSignUnitNameDialogForm: TPromoCodeSignUnitNameDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1074#1086#1076' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 186
  ClientWidth = 354
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
    Left = 38
    Top = 140
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 221
    Top = 140
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel14: TcxLabel
    Left = 23
    Top = 8
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1085#1072' '#1089#1090#1080#1082#1077#1088#1077
  end
  object ceUnitName: TcxMemo
    Left = 8
    Top = 31
    TabOrder = 3
    Height = 98
    Width = 329
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 255
    Top = 98
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
    Left = 264
    Top = 45
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UnitName'
        Value = Null
        Component = ceUnitName
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 101
    Top = 42
  end
  object PeriodChoice: TPeriodChoice
    Left = 136
    Top = 68
  end
end
