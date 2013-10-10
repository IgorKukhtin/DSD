inherited GoodsPropertyValueEditForm: TGoodsPropertyValueEditForm
  Caption = #1047#1085#1072#1095#1077#1085#1080#1103' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1072
  ClientHeight = 277
  ClientWidth = 560
  ExplicitWidth = 568
  ExplicitHeight = 304
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 16
    Top = 31
    TabOrder = 0
    Width = 322
  end
  object cxLabel1: TcxLabel
    Left = 16
    Top = 8
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 167
    Top = 244
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 10
  end
  object cxButton2: TcxButton
    Left = 311
    Top = 240
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 17
  end
  object cxLabel3: TcxLabel
    Left = 355
    Top = 8
    Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1072
  end
  object ceGoodsProperty: TcxLookupComboBox
    Left = 355
    Top = 31
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = GoodsPropertyDS
    TabOrder = 2
    Width = 197
  end
  object cxLabel2: TcxLabel
    Left = 16
    Top = 63
    Caption = #1041#1072#1085#1082#1080
  end
  object ceGoods: TcxLookupComboBox
    Left = 16
    Top = 86
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = GoodsDS
    TabOrder = 3
    Width = 322
  end
  object cxLabel4: TcxLabel
    Left = 355
    Top = 63
    Caption = #1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074
  end
  object ceGoodsKind: TcxLookupComboBox
    Left = 355
    Top = 86
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = GoodsKindDS
    TabOrder = 4
    Width = 197
  end
  object cxLabel5: TcxLabel
    Left = 16
    Top = 120
    Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076
  end
  object edBarCode: TcxTextEdit
    Left = 16
    Top = 143
    TabOrder = 5
    Width = 261
  end
  object cxLabel6: TcxLabel
    Left = 290
    Top = 120
    Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076' GLN'
  end
  object edBarCodeGLN: TcxTextEdit
    Left = 290
    Top = 143
    TabOrder = 6
    Width = 261
  end
  object cxLabel7: TcxLabel
    Left = 16
    Top = 176
    Caption = #1040#1088#1090#1080#1082#1091#1083
  end
  object edArticle: TcxTextEdit
    Left = 16
    Top = 199
    TabOrder = 7
    Width = 189
  end
  object edArticleGLN: TcxTextEdit
    Left = 221
    Top = 199
    TabOrder = 8
    Width = 189
  end
  object cxLabel8: TcxLabel
    Left = 221
    Top = 176
    Caption = #1040#1088#1090#1080#1082#1091#1083' GLN'
  end
  object ceAmount: TcxCurrencyEdit
    Left = 431
    Top = 199
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 18
    Width = 121
  end
  object cxLabel9: TcxLabel
    Left = 431
    Top = 176
    Caption = #1064#1090#1091#1082' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077
  end
  object ActionList: TActionList
    Left = 456
    Top = 214
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetGoodsProperty
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
    end
    object dsdFormClose1: TdsdFormClose
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = #1054#1082
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsPropertyValue'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inName'
        Component = edName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inBarCode'
        Component = edBarCode
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inArticle'
        Component = edArticle
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inBarCodeGLN'
        Component = edBarCodeGLN
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inArticleGLN'
        Component = edArticleGLN
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsPropertyId'
        Component = dsdGoodsPropertyGuides
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Component = dsdGoodsGuides
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Component = dsdGoodsKindGuides
        ParamType = ptInput
      end>
    Left = 16
    Top = 214
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        ParamType = ptInputOutput
      end>
    Left = 504
    Top = 214
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_GoodsPropertyValue'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'Name'
        Component = edName
        DataType = ftString
      end
      item
        Name = 'Amount'
        Component = ceAmount
      end
      item
        Name = 'BarCode'
        Component = edBarCode
      end
      item
        Name = 'Article'
        Component = edArticle
      end
      item
        Name = 'BarCodeGLN'
        Component = edBarCodeGLN
      end
      item
        Name = 'ArticleGLN'
        Component = edArticleGLN
      end
      item
        Name = 'GoodsPropertyId'
        Component = dsdGoodsPropertyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsPropertyName'
        Component = dsdGoodsPropertyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'GoodsId'
        Component = dsdGoodsGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsName'
        Component = dsdGoodsGuides
        ComponentItem = 'TextValue'
      end
      item
        Name = 'GoodsKindId'
        Component = dsdGoodsKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsKindName'
        Component = dsdGoodsKindGuides
        ComponentItem = 'TextValue'
        ParamType = ptInput
      end>
    Left = 83
    Top = 214
  end
  object GoodsPropertyDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 403
    Top = 21
  end
  object spGetGoodsProperty: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsProperty'
    DataSet = GoodsPropertyDataSet
    DataSets = <
      item
        DataSet = GoodsPropertyDataSet
      end>
    Params = <>
    Left = 443
    Top = 21
  end
  object GoodsPropertyDS: TDataSource
    DataSet = GoodsPropertyDataSet
    Left = 483
    Top = 21
  end
  object dsdGoodsPropertyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsProperty
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 523
    Top = 21
  end
  object GoodsDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 155
    Top = 69
  end
  object spGetGoods: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods'
    DataSet = GoodsDataSet
    DataSets = <
      item
        DataSet = GoodsDataSet
      end>
    Params = <>
    Left = 195
    Top = 69
  end
  object GoodsDS: TDataSource
    DataSet = GoodsDataSet
    Left = 235
    Top = 69
  end
  object dsdGoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoods
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 267
    Top = 69
  end
  object GoodsKindDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 363
    Top = 93
  end
  object spGetGoodsKind: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsPropertyValue'
    DataSet = GoodsKindDataSet
    DataSets = <
      item
        DataSet = GoodsKindDataSet
      end>
    Params = <>
    Left = 403
    Top = 93
  end
  object GoodsKindDS: TDataSource
    DataSet = GoodsKindDataSet
    Left = 443
    Top = 93
  end
  object dsdGoodsKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsKind
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 499
    Top = 101
  end
end
