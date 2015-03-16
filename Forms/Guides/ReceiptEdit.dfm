object ReceiptEditForm: TReceiptEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1056#1077#1094#1077#1087#1090#1091#1088#1091'>'
  ClientHeight = 448
  ClientWidth = 361
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 32
    Top = 57
    Properties.ReadOnly = True
    TabOrder = 0
    Width = 303
  end
  object cxLabel1: TcxLabel
    Left = 32
    Top = 42
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
  end
  object cxButton1: TcxButton
    Left = 58
    Top = 409
    Width = 75
    Height = 25
    Action = InsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 232
    Top = 409
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 32
    Top = 5
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 32
    Top = 19
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 77
  end
  object cxLabel5: TcxLabel
    Left = 32
    Top = 198
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
  end
  object cxLabel7: TcxLabel
    Left = 32
    Top = 281
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1079#1072#1090#1088#1072#1090
  end
  object ceReceiptCost: TcxButtonEdit
    Left = 32
    Top = 296
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 303
  end
  object cxLabel3: TcxLabel
    Left = 32
    Top = 320
    Caption = #1058#1080#1087' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
  end
  object ceReceiptKind: TcxButtonEdit
    Left = 32
    Top = 335
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 303
  end
  object cbIsMain: TcxCheckBox
    Left = 278
    Top = 19
    Caption = #1043#1083#1072#1074#1085#1099#1081
    TabOrder = 11
    Width = 67
  end
  object edComment: TcxTextEdit
    Left = 32
    Top = 374
    TabOrder = 12
    Width = 303
  end
  object ceValue: TcxCurrencyEdit
    Left = 32
    Top = 97
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 13
    Width = 90
  end
  object cxLabel10: TcxLabel
    Left = 32
    Top = 80
    Caption = #1050#1086#1083'-'#1074#1086
  end
  object cxLabel11: TcxLabel
    Left = 140
    Top = 80
    Caption = #1050#1086#1083'-'#1074#1086' ('#1079#1072#1090#1088#1072#1090#1099')'
  end
  object ceValueCost: TcxCurrencyEdit
    Left = 141
    Top = 97
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 16
    Width = 92
  end
  object cePartionValue: TcxCurrencyEdit
    Left = 32
    Top = 135
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 17
    Width = 140
  end
  object cxLabel12: TcxLabel
    Left = 195
    Top = 120
    Caption = #1050#1086#1083'-'#1074#1086' '#1082#1091#1090#1077#1088#1086#1074' (0.5 '#1080#1083#1080' 1)'
  end
  object cePartionCount: TcxCurrencyEdit
    Left = 195
    Top = 135
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 19
    Width = 140
  end
  object cxLabel13: TcxLabel
    Left = 245
    Top = 80
    Caption = '% '#1074#1099#1093#1086#1076#1072
  end
  object ceTaxExit: TcxCurrencyEdit
    Left = 245
    Top = 97
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 21
    Width = 90
  end
  object cxLabel14: TcxLabel
    Left = 32
    Top = 120
    Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1082#1091#1090#1077#1088#1077
  end
  object cxLabel15: TcxLabel
    Left = 32
    Top = 159
    Caption = #1042#1077#1089' '#1091#1087#1072#1082'. ('#1087#1086#1083#1080#1072#1084#1080#1076')'
  end
  object ceWeightPackage: TcxCurrencyEdit
    Left = 32
    Top = 175
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 24
    Width = 111
  end
  object cxLabel16: TcxLabel
    Left = 158
    Top = 159
    Caption = #1053#1072#1095#1072#1083#1100#1085#1072#1103' '#1076#1072#1090#1072
  end
  object cxLabel17: TcxLabel
    Left = 252
    Top = 159
    Caption = #1050#1086#1085#1077#1095#1085#1072#1103' '#1076#1072#1090#1072
  end
  object edStartDate: TcxDateEdit
    Left = 158
    Top = 175
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 27
    Width = 87
  end
  object edEndDate: TcxDateEdit
    Left = 252
    Top = 175
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 28
    Width = 83
  end
  object ceGoods: TcxButtonEdit
    Left = 32
    Top = 214
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 29
    Width = 303
  end
  object cxLabel2: TcxLabel
    Left = 32
    Top = 241
    Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
  end
  object ceGoodsKind: TcxButtonEdit
    Left = 32
    Top = 257
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 31
    Width = 145
  end
  object cxLabel18: TcxLabel
    Left = 190
    Top = 241
    Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1075'.'#1087'.)'
  end
  object ceGoodsKindComplete: TcxButtonEdit
    Left = 190
    Top = 257
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 33
    Width = 145
  end
  object cxLabel4: TcxLabel
    Left = 32
    Top = 357
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edReceiptCode: TcxTextEdit
    Left = 115
    Top = 19
    TabOrder = 35
    Width = 158
  end
  object cxLabel6: TcxLabel
    Left = 115
    Top = 5
    Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
  end
  object ActionList: TActionList
    Left = 65528
    Top = 105
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object InsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      MoveParams = <>
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Receipt'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inMaskId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'inMaskId'
        ParamType = ptInput
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
      end
      item
        Name = 'inReceiptCode'
        Value = ''
        Component = edReceiptCode
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = ''
        Component = edComment
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inValue'
        Value = Null
        Component = ceValue
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inValueCost'
        Value = ''
        Component = ceValueCost
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inTaxExit'
        Value = ''
        Component = ceTaxExit
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPartionValue'
        Value = ''
        Component = cePartionValue
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPartionCount'
        Value = ''
        Component = cePartionCount
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inWeightPackage'
        Value = Null
        Component = ceWeightPackage
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inStartDate'
        Value = Null
        Component = edStartDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = edEndDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inIsMain'
        Value = Null
        Component = cbIsMain
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = GoodsKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindCompleteId'
        Value = Null
        Component = GoodsKindCompleteGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inReceiptCostId'
        Value = Null
        Component = ReceiptCostGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inReceiptKindId'
        Value = Null
        Component = ReceiptKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 320
    Top = 32
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end
      item
        Name = 'inMaskId'
        Value = Null
        ParamType = ptInputOutput
      end>
    Left = 336
    Top = 73
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Receipt'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inMaskId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'inMaskId'
        ParamType = ptInput
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
      end
      item
        Name = 'ReceiptCode'
        Value = Null
        Component = edReceiptCode
        DataType = ftString
      end
      item
        Name = 'Comment'
        Value = ''
        Component = edComment
        DataType = ftString
      end
      item
        Name = 'Value'
        Value = ''
        Component = ceValue
        DataType = ftFloat
      end
      item
        Name = 'ValueCost'
        Value = ''
        Component = ceValueCost
        DataType = ftFloat
      end
      item
        Name = 'TaxExit'
        Value = ''
        Component = ceTaxExit
        DataType = ftFloat
      end
      item
        Name = 'PartionValue'
        Value = ''
        Component = cePartionValue
        DataType = ftFloat
      end
      item
        Name = 'PartionCount'
        Value = ''
        Component = cePartionCount
        DataType = ftFloat
      end
      item
        Name = 'WeightPackage'
        Value = ''
        Component = ceWeightPackage
        DataType = ftFloat
      end
      item
        Name = 'StartDate'
        Value = 0d
        Component = edStartDate
        DataType = ftDateTime
      end
      item
        Name = 'EndDate'
        Value = ''
        Component = edEndDate
        DataType = ftDateTime
      end
      item
        Name = 'IsMain'
        Value = ''
        Component = cbIsMain
        DataType = ftBoolean
      end
      item
        Name = 'GoodsId'
        Value = 'Null'
        Component = GoodsGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
      end
      item
        Name = 'GoodsKindId'
        Value = Null
        Component = GoodsKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsKindName'
        Value = 0
        Component = GoodsKindGuides
        ComponentItem = 'TextValue'
      end
      item
        Name = 'GoodsKindCompleteId'
        Value = Null
        Component = GoodsKindCompleteGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsKindCompleteName'
        Value = Null
        Component = GoodsKindCompleteGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ReceiptCostId'
        Value = Null
        Component = ReceiptCostGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ReceiptCostName'
        Value = Null
        Component = ReceiptCostGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ReceiptKindId'
        Value = Null
        Component = ReceiptKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ReceiptKindName'
        Value = Null
        Component = ReceiptKindGuides
        ComponentItem = 'TextValue'
      end>
    PackSize = 1
    Top = 64
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Top = 8
  end
  object dsdUserSettingsStorageAddOn1: TdsdUserSettingsStorageAddOn
    Left = 296
    Top = 8
  end
  object ReceiptCostGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceReceiptCost
    FormNameParam.Value = 'TReceiptCostForm'
    FormNameParam.DataType = ftString
    FormName = 'TReceiptCostForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ReceiptCostGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ReceiptCostGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 151
    Top = 282
  end
  object ReceiptKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceReceiptKind
    FormNameParam.Value = 'TReceiptKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TReceiptKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ReceiptKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ReceiptKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 223
    Top = 322
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoods
    Key = 'Null'
    FormNameParam.Value = 'TGoods_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoods_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 124
    Top = 206
  end
  object GoodsKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsKind
    Key = '0'
    FormNameParam.Value = 'TGoodsKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 68
    Top = 246
  end
  object GoodsKindCompleteGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsKindComplete
    FormNameParam.Value = 'TGoodsKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsKindCompleteGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsKindCompleteGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 244
    Top = 238
  end
end
