object PromoCodeSignDialogForm: TPromoCodeSignDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1074#1086#1076' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 129
  ClientWidth = 313
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
    Left = 14
    Top = 76
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 175
    Top = 76
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel14: TcxLabel
    Left = 23
    Top = 25
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1088#1086#1084#1086' '#1082#1086#1076#1086#1074
  end
  object edCount_GUID: TcxTextEdit
    Left = 160
    Top = 24
    TabOrder = 3
    Width = 90
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
        Name = 'inCount_GUID'
        Value = Null
        Component = edCount_GUID
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 79
    Top = 58
  end
  object PeriodChoice: TPeriodChoice
    Left = 136
    Top = 68
  end
end
