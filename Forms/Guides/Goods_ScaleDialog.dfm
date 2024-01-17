object Goods_ScaleDialogForm: TGoods_ScaleDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103' Scale'
  ClientHeight = 183
  ClientWidth = 390
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
    Left = 105
    Top = 137
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 216
    Top = 137
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel17: TcxLabel
    Left = 8
    Top = 58
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1088#1086#1083#1080#1078#1077#1085#1080#1103' Scale'
  end
  object edName_Scale: TcxTextEdit
    Left = 8
    Top = 79
    TabOrder = 3
    Width = 362
  end
  object Код: TcxLabel
    Left = 8
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 8
    Top = 21
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 90
  end
  object cxLabel1: TcxLabel
    Left = 104
    Top = 4
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object edName: TcxTextEdit
    Left = 104
    Top = 21
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 266
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 127
    Top = 140
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
    Left = 240
    Top = 58
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inName_Scale'
        Value = 41579d
        Component = edName_Scale
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = Null
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 319
    Top = 116
  end
end
