object Goods_WeightTareDialogForm: TGoods_WeightTareDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1077#1089' '#1074#1090#1091#1083#1082#1080
  ClientHeight = 124
  ClientWidth = 244
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
    Left = 33
    Top = 79
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 144
    Top = 79
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel6: TcxLabel
    Left = 15
    Top = 30
    Caption = #1042#1077#1089' '#1074#1090#1091#1083#1082#1080':'
  end
  object edWeightTare: TcxCurrencyEdit
    Left = 84
    Top = 29
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 3
    Width = 141
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 135
    Top = 86
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
    Left = 248
    Top = 20
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inWeightTare'
        Value = 41579d
        Component = edWeightTare
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 111
    Top = 46
  end
end
