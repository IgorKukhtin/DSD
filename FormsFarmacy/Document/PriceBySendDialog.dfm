object PriceBySendDialogForm: TPriceBySendDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1062#1077#1085#1072' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
  ClientHeight = 121
  ClientWidth = 276
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
    Left = 40
    Top = 79
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 176
    Top = 79
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel6: TcxLabel
    Left = 64
    Top = 16
    Caption = #1062#1077#1085#1072':'
  end
  object cePrice: TcxCurrencyEdit
    Left = 104
    Top = 15
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 3
    Width = 89
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 71
    Top = 30
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
    Left = 184
    Top = 44
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inPriceNew'
        Value = 41579d
        Component = cePrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 23
    Top = 62
  end
  object PeriodChoice: TPeriodChoice
    Left = 144
    Top = 64
  end
end
