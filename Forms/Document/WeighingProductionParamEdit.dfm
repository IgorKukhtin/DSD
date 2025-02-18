object WeighingProductionParamEditForm: TWeighingProductionParamEditForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
  ClientHeight = 172
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
    Left = 37
    Top = 132
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 203
    Top = 132
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel12: TcxLabel
    Left = 28
    Top = 62
    Caption = #1064'/'#1050' '#1076#1083#1103' '#1103#1097#1080#1082#1086#1074
  end
  object edBarCodeBox: TcxButtonEdit
    Left = 28
    Top = 81
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 250
  end
  object cxLabel1: TcxLabel
    Left = 28
    Top = 12
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1090#1086#1074#1072#1088#1072
  end
  object edGoodsTypeKind: TcxButtonEdit
    Left = 28
    Top = 31
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 250
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 281
    Top = 106
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
    Left = 200
    Top = 65533
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inBarCodeBoxId'
        Value = Null
        Component = GuidesBarCodeBox
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCodeBoxName'
        Value = Null
        Component = GuidesBarCodeBox
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsTypeKindId'
        Value = Null
        Component = GuidesGoodsTypeKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsTypeKindName'
        Value = Null
        Component = GuidesGoodsTypeKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 31
    Top = 50
  end
  object GuidesBarCodeBox: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBarCodeBox
    FormNameParam.Value = 'TBarCodeBoxForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBarCodeBoxForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBarCodeBox
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBarCodeBox
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MedicSPId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MedicSPName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'MasterOperDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MasterUnitId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitName'
        Value = Null
        Component = FormParams
        ComponentItem = 'MasterUnitName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterSPKindId'
        Value = Null
        Component = GuidesGoodsTypeKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterSPKindName'
        Value = Null
        Component = GuidesGoodsTypeKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 138
    Top = 65
  end
  object GuidesGoodsTypeKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsTypeKind
    FormNameParam.Value = 'TGoodsTypeKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsTypeKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsTypeKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsTypeKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 138
    Top = 25
  end
end
