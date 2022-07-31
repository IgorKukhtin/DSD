object GoodsAdditionalEditDialogForm: TGoodsAdditionalEditDialogForm
  Left = 0
  Top = 0
  Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
  ClientHeight = 466
  ClientWidth = 479
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
    Left = 92
    Top = 423
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 313
    Top = 423
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cb_MakerName: TcxCheckBox
    Left = 381
    Top = 22
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    Width = 73
  end
  object cb_FormDispensing: TcxCheckBox
    Left = 381
    Top = 98
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Width = 73
  end
  object cb_NumberPlates: TcxCheckBox
    Left = 381
    Top = 135
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    Width = 73
  end
  object cb_QtyPackage: TcxCheckBox
    Left = 381
    Top = 172
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Width = 73
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 3
    Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
  end
  object edMakerName: TcxButtonEdit
    Left = 8
    Top = 22
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 332
  end
  object edNumberPlates: TcxCurrencyEdit
    Left = 7
    Top = 135
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 8
    Width = 109
  end
  object cxLabel3: TcxLabel
    Left = 7
    Top = 118
    Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1089#1090#1080#1085' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077':'
  end
  object cxLabel7: TcxLabel
    Left = 8
    Top = 155
    Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077':'
  end
  object ceQtyPackage: TcxCurrencyEdit
    Left = 8
    Top = 172
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 11
    Width = 109
  end
  object cbIsRecipe: TcxCheckBox
    Left = 8
    Top = 389
    Caption = #1056#1077#1094#1077#1087#1090#1091#1088#1072
    TabOrder = 12
    Width = 96
  end
  object edFormDispensing: TcxButtonEdit
    Left = 8
    Top = 98
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 332
  end
  object cxLabel14: TcxLabel
    Left = 7
    Top = 81
    Caption = #1060#1086#1088#1084#1072' '#1086#1090#1087#1091#1089#1082#1072
  end
  object cb_IsRecipe: TcxCheckBox
    Left = 381
    Top = 389
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 15
    Width = 73
  end
  object edMakerNameUkr: TcxTextEdit
    Left = 8
    Top = 61
    TabOrder = 16
    Width = 332
  end
  object cxLabel1: TcxLabel
    Left = 8
    Top = 43
    Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100' '#1059#1082#1088'. '#1085#1072#1079#1074#1072#1085#1080#1077
  end
  object cb_MakerNameUkr: TcxCheckBox
    Left = 381
    Top = 61
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 18
    Width = 73
  end
  object cb_Dosage: TcxCheckBox
    Left = 381
    Top = 212
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 19
    Width = 73
  end
  object edDosage: TcxTextEdit
    Left = 8
    Top = 212
    TabOrder = 20
    Width = 332
  end
  object cxLabel4: TcxLabel
    Left = 8
    Top = 194
    Caption = #1044#1086#1079#1080#1088#1086#1074#1082#1072
  end
  object cb_Volume: TcxCheckBox
    Left = 381
    Top = 250
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 22
    Width = 73
  end
  object edVolume: TcxTextEdit
    Left = 8
    Top = 250
    TabOrder = 23
    Width = 332
  end
  object cxLabel5: TcxLabel
    Left = 8
    Top = 233
    Caption = #1054#1073#1098#1077#1084
  end
  object cb_GoodsWhoCan: TcxCheckBox
    Left = 381
    Top = 288
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 25
    Width = 73
  end
  object ceGoodsWhoCan: TcxButtonEdit
    Left = 8
    Top = 288
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 26
    Width = 332
  end
  object cxLabel6: TcxLabel
    Left = 8
    Top = 270
    Caption = #1050#1086#1084#1091' '#1084#1086#1078#1085#1086
  end
  object cb_GoodsMethodAppl: TcxCheckBox
    Left = 380
    Top = 326
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 28
    Width = 73
  end
  object edGoodsMethodAppl: TcxButtonEdit
    Left = 7
    Top = 326
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 29
    Width = 332
  end
  object cxLabel8: TcxLabel
    Left = 7
    Top = 308
    Caption = #1057#1087#1086#1089#1086#1073' '#1087#1088#1080#1084#1077#1085#1077#1085#1080#1103
  end
  object cb_GoodsSignOrigin: TcxCheckBox
    Left = 381
    Top = 364
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 31
    Width = 73
  end
  object edGoodsSignOrigin: TcxButtonEdit
    Left = 8
    Top = 364
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 32
    Width = 332
  end
  object cxLabel9: TcxLabel
    Left = 8
    Top = 346
    Caption = #1055#1088#1080#1079#1085#1072#1082' '#1087#1088#1086#1080#1089#1093#1086#1078#1076#1077#1085#1080#1103
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 289
    Top = 165
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
    Left = 216
    Top = 134
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MakerName'
        Value = Null
        Component = edMakerName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MakerNameUkr'
        Value = Null
        Component = edMakerNameUkr
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormDispensingId'
        Value = 0
        Component = FormDispensingGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'NumberPlates'
        Value = Null
        Component = edNumberPlates
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'QtyPackage'
        Value = Null
        Component = ceQtyPackage
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Dosage'
        Value = Null
        Component = edDosage
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Volume'
        Value = Null
        Component = edVolume
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsWhoCanId'
        Value = Null
        Component = GoodsWhoCanGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsMethodApplId'
        Value = Null
        Component = GoodsMethodApplGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsSignOriginId'
        Value = Null
        Component = GoodsSignOriginGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsRecipe'
        Value = Null
        Component = cbIsRecipe
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_MakerName'
        Value = Null
        Component = cb_MakerName
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_MakerNameUkr'
        Value = Null
        Component = cb_MakerNameUkr
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_FormDispensing'
        Value = Null
        Component = cb_FormDispensing
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_NumberPlates'
        Value = Null
        Component = cb_NumberPlates
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_QtyPackage'
        Value = Null
        Component = cb_QtyPackage
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_Dosage'
        Value = Null
        Component = cb_Dosage
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_Volume'
        Value = Null
        Component = cb_Volume
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_GoodsWhoCan'
        Value = Null
        Component = cb_GoodsWhoCan
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_GoodsMethodAppl'
        Value = Null
        Component = cb_GoodsMethodAppl
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_GoodsSignOrigin'
        Value = Null
        Component = cb_GoodsSignOrigin
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_IsRecipe'
        Value = Null
        Component = cb_IsRecipe
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 143
    Top = 134
  end
  object GoodsMakerNameGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMakerName
    FormNameParam.Value = 'TGoodsMakerNameForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsMakerNameForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsMakerNameGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsMakerNameGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsMainId'
        MultiSelectSeparator = ','
      end>
    Left = 231
    Top = 11
  end
  object FormDispensingGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFormDispensing
    Key = '0'
    FormNameParam.Value = 'TFormDispensingForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TFormDispensingForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FormDispensingGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FormDispensingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 95
    Top = 85
  end
  object GoodsWhoCanGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsWhoCan
    Key = '0'
    FormNameParam.Value = 'TGoodsWhoCanForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsWhoCanForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GoodsWhoCanGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsWhoCanGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 135
    Top = 277
  end
  object GoodsMethodApplGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsMethodAppl
    Key = '0'
    FormNameParam.Value = 'TGoodsMethodApplForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsMethodApplForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GoodsMethodApplGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsMethodApplGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 199
    Top = 309
  end
  object GoodsSignOriginGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsSignOrigin
    Key = '0'
    FormNameParam.Value = 'TGoodsSignOriginForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsSignOriginForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GoodsSignOriginGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsSignOriginGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 263
    Top = 349
  end
end
