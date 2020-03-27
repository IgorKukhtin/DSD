object PromoCodeSignPercentDialogForm: TPromoCodeSignPercentDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1074#1086#1076' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 131
  ClientWidth = 304
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
    Top = 75
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 197
    Top = 75
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel14: TcxLabel
    Left = 23
    Top = 25
    Caption = #1055#1088#1086#1094#1077#1085#1090' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1087#1088#1086#1084#1086' '#1082#1086#1076#1086#1091
  end
  object ceChangePercent: TcxCurrencyEdit
    Left = 197
    Top = 24
    Properties.DisplayFormat = ',0.00'
    TabOrder = 3
    Width = 89
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
        Name = 'inChangePercent_GUID'
        Value = Null
        Component = ceChangePercent
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
