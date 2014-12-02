inherited GoodsEditForm: TGoodsEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
  ClientHeight = 307
  ClientWidth = 349
  ExplicitWidth = 355
  ExplicitHeight = 332
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    TabOrder = 8
  end
  inherited bbCancel: TcxButton
    TabOrder = 9
  end
  object edName: TcxTextEdit [2]
    Left = 9
    Top = 78
    TabOrder = 1
    Width = 332
  end
  object cxLabel1: TcxLabel [3]
    Left = 8
    Top = 55
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxLabel2: TcxLabel [4]
    Left = 8
    Top = 100
    Caption = #1043#1088#1091#1087#1087#1072' '#1088#1086#1076#1080#1090#1077#1083#1100
  end
  object ceCode: TcxCurrencyEdit [5]
    Left = 9
    Top = 28
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 0
    Width = 332
  end
  object Код: TcxLabel [6]
    Left = 8
    Top = 5
    Caption = #1050#1086#1076
  end
  object ceParentGroup: TcxButtonEdit [7]
    Left = 9
    Top = 123
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 2
    Width = 332
  end
  object cxLabel4: TcxLabel [8]
    Left = 128
    Top = 160
    Caption = #1045#1076'. '#1080#1079#1084#1077#1088#1077#1085#1080#1103':'
  end
  object ceMeasure: TcxButtonEdit [9]
    Left = 128
    Top = 183
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 81
  end
  object cxLabel6: TcxLabel [10]
    Left = 227
    Top = 160
    Caption = #1042#1080#1076' '#1053#1044#1057':'
  end
  object ceNDSKind: TcxButtonEdit [11]
    Left = 227
    Top = 183
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 114
  end
  object edMinimumLot: TcxCurrencyEdit [12]
    Left = 9
    Top = 183
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 3
    Width = 109
  end
  object cxLabel3: TcxLabel [13]
    Left = 8
    Top = 160
    Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100':'
  end
  object cxLabel5: TcxLabel [14]
    Left = 169
    Top = 210
    Caption = #1062#1077#1085#1072' '#1057#1055':'
  end
  object ceReferPrice: TcxCurrencyEdit [15]
    Left = 170
    Top = 233
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 7
    Width = 109
  end
  object cxLabel7: TcxLabel [16]
    Left = 53
    Top = 210
    Caption = #1050#1086#1076' '#1057#1055':'
  end
  object ceReferCode: TcxCurrencyEdit [17]
    Left = 54
    Top = 233
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 6
    Width = 109
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 155
    Top = 48
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 104
    Top = 48
  end
  inherited ActionList: TActionList
    Left = 207
    Top = 55
  end
  inherited FormParams: TdsdFormParams
    Left = 296
    Top = 16
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Goods'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inMeasureId'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inNDSKindId'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inMinimumLot'
        Value = Null
        Component = edMinimumLot
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inReferCode'
        Value = Null
        Component = ceReferCode
        ParamType = ptInput
      end
      item
        Name = 'inReferPrice'
        Value = Null
        Component = ceReferPrice
        DataType = ftFloat
        ParamType = ptInput
      end>
    Left = 280
    Top = 8
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Goods'
    Params = <
      item
        Name = 'Id'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
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
        Name = 'GoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsGroupName'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'MeasureId'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'MeasureName'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'NDSKindId'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'NDSKindName'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'MinimumLot'
        Value = Null
        Component = edMinimumLot
        DataType = ftFloat
      end
      item
        Name = 'ReferCode'
        Value = Null
        Component = ceReferCode
      end
      item
        Name = 'ReferPrice'
        Value = Null
        Component = ceReferPrice
      end>
    Left = 304
    Top = 216
  end
  object GoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParentGroup
    FormNameParam.Value = 'TGoodsGroupForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 208
    Top = 112
  end
  object dsdMeasureGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMeasure
    FormNameParam.Value = 'TMeasureForm'
    FormNameParam.DataType = ftString
    FormName = 'TMeasureForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 48
    Top = 176
  end
  object NDSKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceNDSKind
    FormNameParam.Value = 'TNDSKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TNDSKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 232
    Top = 176
  end
end
