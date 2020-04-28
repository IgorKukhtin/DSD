object BarCodeBoxDialogForm: TBarCodeBoxDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1103#1097#1080#1082#1080' '#1089' '#1096'/'#1082
  ClientHeight = 184
  ClientWidth = 342
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
    Left = 53
    Top = 145
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 208
    Top = 145
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel2: TcxLabel
    Left = 113
    Top = 18
    Caption = #1053#1072#1095'. '#1079#1085#1072#1095#1077#1085#1080#1077
  end
  object cxLabel1: TcxLabel
    Left = 21
    Top = 18
    Caption = #1055#1088#1077#1092#1080#1082#1089
  end
  object edBarCodePref: TcxTextEdit
    Left = 21
    Top = 41
    TabOrder = 4
    Width = 76
  end
  object cxLabel5: TcxLabel
    Left = 21
    Top = 78
    Caption = #1071#1097#1080#1082
  end
  object edBox: TcxButtonEdit
    Left = 21
    Top = 101
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 296
  end
  object cxLabel3: TcxLabel
    Left = 224
    Top = 18
    Caption = #1050#1086#1085#1077#1095#1085'. '#1079#1085#1072#1095#1077#1085#1080#1077
  end
  object edBarCode1: TcxCurrencyEdit
    Left = 113
    Top = 41
    EditValue = '0'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 8
    Width = 100
  end
  object edBarCode2: TcxCurrencyEdit
    Left = 224
    Top = 41
    EditValue = '0'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 9
    Width = 100
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
    Left = 301
    Top = 133
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inBoxId'
        Value = Null
        Component = GuidesBox
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxName'
        Value = Null
        Component = GuidesBox
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCode1'
        Value = Null
        Component = edBarCode1
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCode2'
        Value = Null
        Component = edBarCode2
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCodePref'
        Value = Null
        Component = edBarCodePref
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName'
        Value = Null
        Component = GuidesBox
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxId'
        Value = Null
        Component = GuidesBox
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end>
    Left = 303
    Top = 63
  end
  object GuidesBox: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBox
    FormNameParam.Value = 'TBoxForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBoxForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBox
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBox
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 97
    Top = 75
  end
end
