object Goods_Name_BUHDialogForm: TGoods_Name_BUHDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1041#1091#1093#1075#1072#1083#1090#1077#1088#1080#1080
  ClientHeight = 207
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
    Left = 97
    Top = 153
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 208
    Top = 153
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel17: TcxLabel
    Left = 8
    Top = 58
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1073#1091#1093#1075'.)'
  end
  object edName_BUH: TcxTextEdit
    Left = 8
    Top = 75
    TabOrder = 3
    Width = 260
  end
  object cxLabel18: TcxLabel
    Left = 281
    Top = 58
    Caption = #1044#1072#1090#1072' '#1076#1086' ('#1073#1091#1093#1075'.) :'
  end
  object edDate_BUH: TcxDateEdit
    Left = 274
    Top = 75
    EditValue = 42005d
    Properties.ReadOnly = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 5
    Width = 91
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
    TabOrder = 7
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
    TabOrder = 9
    Width = 266
  end
  object cbisNameOrig: TcxCheckBox
    Left = 8
    Top = 113
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1088#1077#1072#1083#1100#1085#1086#1077' '#1085#1072#1079#1074'.'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    Width = 172
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 119
    Top = 156
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
        Name = 'inName_BUH'
        Value = 41579d
        Component = edName_BUH
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDate_BUH'
        Value = Null
        Component = edDate_BUH
        DataType = ftDateTime
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
      end
      item
        Name = 'inisNameOrig'
        Value = Null
        Component = cbisNameOrig
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 319
    Top = 116
  end
end
