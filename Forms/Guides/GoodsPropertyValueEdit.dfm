object GoodsPropertyValueEditForm: TGoodsPropertyValueEditForm
  Left = 0
  Top = 0
  Caption = #1047#1085#1072#1095#1077#1085#1080#1103' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1072
  ClientHeight = 361
  ClientWidth = 563
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
    Left = 16
    Top = 31
    TabOrder = 0
    Width = 357
  end
  object cxLabel1: TcxLabel
    Left = 16
    Top = 8
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 167
    Top = 320
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 311
    Top = 320
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 8
  end
  object cxLabel3: TcxLabel
    Left = 18
    Top = 97
    Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1072
  end
  object cxLabel5: TcxLabel
    Left = 17
    Top = 152
    Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076
  end
  object cxLabel6: TcxLabel
    Left = 290
    Top = 154
    Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076' GLN'
  end
  object cxLabel7: TcxLabel
    Left = 16
    Top = 205
    Caption = #1040#1088#1090#1080#1082#1091#1083
  end
  object cxLabel8: TcxLabel
    Left = 290
    Top = 205
    Caption = #1040#1088#1090#1080#1082#1091#1083' GLN'
  end
  object cxLabel9: TcxLabel
    Left = 389
    Top = 15
    Caption = #1050#1086#1083'-'#1074#1086' '#1096#1090#1091#1082' '#1087#1088#1080' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1080
  end
  object ceGoodsProperty: TcxButtonEdit
    Left = 17
    Top = 120
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 10
    Width = 267
  end
  object ceAmount: TcxCurrencyEdit
    Left = 389
    Top = 31
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 11
    Width = 163
  end
  object ceBarCode: TcxTextEdit
    Left = 17
    Top = 175
    TabOrder = 12
    Width = 267
  end
  object ceBarCodeGLN: TcxTextEdit
    Left = 290
    Top = 175
    TabOrder = 13
    Width = 262
  end
  object ceArticle: TcxTextEdit
    Left = 17
    Top = 224
    TabOrder = 14
    Width = 267
  end
  object ceArticleGLN: TcxTextEdit
    Left = 290
    Top = 224
    TabOrder = 15
    Width = 262
  end
  object cxLabel2: TcxLabel
    Left = 290
    Top = 97
    Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
  end
  object ceGoodsKind: TcxButtonEdit
    Left = 290
    Top = 120
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 17
    Width = 262
  end
  object cxLabel4: TcxLabel
    Left = 18
    Top = 58
    Caption = #1058#1086#1074#1072#1088
  end
  object ceGoods: TcxButtonEdit
    Left = 17
    Top = 77
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 19
    Width = 356
  end
  object cxLabel10: TcxLabel
    Left = 18
    Top = 253
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1075#1088#1091#1087#1087#1099
  end
  object ceGroupName: TcxTextEdit
    Left = 18
    Top = 272
    TabOrder = 21
    Width = 267
  end
  object cxLabel11: TcxLabel
    Left = 389
    Top = 58
    Caption = #1050#1086#1083'-'#1074#1086' '#1077#1076#1080#1085#1080#1094' '#1074' '#1103#1097#1080#1082#1077
  end
  object ceBoxCount: TcxCurrencyEdit
    Left = 389
    Top = 77
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 23
    Width = 163
  end
  object ActionList: TActionList
    Left = 432
    Top = 246
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdFormClose1: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
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
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inBoxCount'
        Value = Null
        Component = ceBoxCount
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inBarCode'
        Value = ''
        Component = ceBarCode
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inArticle'
        Value = ''
        Component = ceArticle
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inBarCodeGLN'
        Value = ''
        Component = ceBarCodeGLN
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inArticleGLN'
        Value = ''
        Component = ceArticleGLN
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGroupName'
        Value = Null
        Component = ceGroupName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsPropertyId'
        Value = ''
        Component = dsdGoodsPropertyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Value = ''
        Component = GoodsKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 88
    Top = 317
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end>
    Left = 512
    Top = 246
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_GoodsPropertyValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
      end
      item
        Name = 'Amount'
        Value = 0.000000000000000000
        Component = ceAmount
        DataType = ftFloat
      end
      item
        Name = 'BoxCount'
        Value = Null
        Component = ceBoxCount
        DataType = ftFloat
      end
      item
        Name = 'BarCode'
        Value = ''
        Component = ceBarCode
        DataType = ftString
      end
      item
        Name = 'Article'
        Value = ''
        Component = ceArticle
        DataType = ftString
      end
      item
        Name = 'BarCodeGLN'
        Value = ''
        Component = ceBarCodeGLN
        DataType = ftString
      end
      item
        Name = 'ArticleGLN'
        Value = ''
        Component = ceArticleGLN
        DataType = ftString
      end
      item
        Name = 'GroupName'
        Value = Null
        Component = ceGroupName
        DataType = ftString
      end
      item
        Name = 'GoodsPropertyId'
        Value = ''
        Component = dsdGoodsPropertyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsPropertyName'
        Value = ''
        Component = dsdGoodsPropertyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'GoodsId'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'GoodsKindId'
        Value = ''
        Component = GoodsKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsKindName'
        Value = ''
        Component = GoodsKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    PackSize = 1
    Left = 251
    Top = 318
  end
  object dsdGoodsPropertyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsProperty
    FormNameParam.Value = 'TGoodsPropertyForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsPropertyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdGoodsPropertyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdGoodsPropertyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 108
    Top = 110
  end
  object GoodsKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsKind
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
    Left = 372
    Top = 102
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoods
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
    Left = 180
    Top = 62
  end
end
