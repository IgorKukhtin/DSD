object GoodsTopDialogForm: TGoodsTopDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1074#1086#1076' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 191
  ClientWidth = 321
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
    Top = 141
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 197
    Top = 141
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cePercentMarkup: TcxCurrencyEdit
    Left = 41
    Top = 37
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.0000'
    TabOrder = 2
    Width = 249
  end
  object cxLabel6: TcxLabel
    Left = 41
    Top = 14
    Caption = '% '#1085#1072#1094#1077#1085#1082#1080
  end
  object cePrice: TcxCurrencyEdit
    Left = 41
    Top = 93
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 4
    Width = 249
  end
  object cxLabel1: TcxLabel
    Left = 41
    Top = 70
    Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
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
        Name = 'PercentMarkup'
        Value = Null
        Component = cePercentMarkup
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Price'
        Value = Null
        Component = cePrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 93
    Top = 66
  end
  object PeriodChoice: TPeriodChoice
    Left = 136
    Top = 68
  end
end
