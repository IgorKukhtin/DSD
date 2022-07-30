object GoodsPropertyValueEditForm: TGoodsPropertyValueEditForm
  Left = 0
  Top = 0
  Caption = #1047#1085#1072#1095#1077#1085#1080#1103' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1072
  ClientHeight = 401
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
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
  end
  object cxButton1: TcxButton
    Left = 167
    Top = 364
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 311
    Top = 364
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
    Top = 155
    Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1072
  end
  object cxLabel5: TcxLabel
    Left = 17
    Top = 208
    Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076
  end
  object cxLabel6: TcxLabel
    Left = 290
    Top = 210
    Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076' GLN'
  end
  object cxLabel7: TcxLabel
    Left = 16
    Top = 261
    Caption = #1040#1088#1090#1080#1082#1091#1083
  end
  object cxLabel8: TcxLabel
    Left = 290
    Top = 261
    Caption = #1040#1088#1090#1080#1082#1091#1083' GLN'
  end
  object cxLabel9: TcxLabel
    Left = 389
    Top = 15
    Caption = #1050#1086#1083'-'#1074#1086' '#1096#1090#1091#1082' '#1087#1088#1080' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1080
  end
  object ceGoodsProperty: TcxButtonEdit
    Left = 16
    Top = 176
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
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
    Left = 16
    Top = 231
    TabOrder = 12
    Width = 267
  end
  object ceBarCodeGLN: TcxTextEdit
    Left = 290
    Top = 231
    TabOrder = 13
    Width = 262
  end
  object ceArticle: TcxTextEdit
    Left = 16
    Top = 280
    TabOrder = 14
    Width = 267
  end
  object ceArticleGLN: TcxTextEdit
    Left = 290
    Top = 280
    TabOrder = 15
    Width = 262
  end
  object cxLabel2: TcxLabel
    Left = 290
    Top = 155
    Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
  end
  object ceGoodsKind: TcxButtonEdit
    Left = 290
    Top = 176
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 262
  end
  object cxLabel4: TcxLabel
    Left = 18
    Top = 58
    Caption = #1058#1086#1074#1072#1088
  end
  object ceGoods: TcxButtonEdit
    Left = 16
    Top = 77
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 357
  end
  object cxLabel10: TcxLabel
    Left = 18
    Top = 309
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1075#1088#1091#1087#1087#1099
  end
  object ceGroupName: TcxTextEdit
    Left = 16
    Top = 328
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
  object cxLabel12: TcxLabel
    Left = 291
    Top = 309
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1074#1083#1086#1078#1077#1085#1080#1077
  end
  object ceAmountDoc: TcxCurrencyEdit
    Left = 290
    Top = 328
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 25
    Width = 262
  end
  object cxLabel13: TcxLabel
    Left = 18
    Top = 104
    Caption = #1058#1086#1074#1072#1088' ('#1075#1086#1092#1088#1086#1103#1097#1080#1082')'
  end
  object edGoodsBox: TcxButtonEdit
    Left = 16
    Top = 123
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 27
    Width = 267
  end
  object cxLabel14: TcxLabel
    Left = 293
    Top = 104
    Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1092#1072#1082#1090' '#1088#1072#1089#1093'.)'
  end
  object edGoodsKindSub: TcxButtonEdit
    Left = 293
    Top = 123
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 29
    Width = 129
  end
  object cbisGoodsKind: TcxCheckBox
    Left = 428
    Top = 123
    Hint = #1056#1072#1079#1088#1077#1096#1077#1085#1072' '#1086#1090#1075#1088#1091#1079#1082#1072' '#1089' '#1090#1072#1082#1080#1084' '#1074#1080#1076#1086#1084' '#1090#1086#1074'.'
    Caption = #1054#1090#1075#1088'. '#1074#1080#1076#1072' '#1090#1086#1074'. '#1088#1072#1079#1088'.'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 30
    Width = 146
  end
  object ActionList: TActionList
    Left = 408
    Top = 362
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxCount'
        Value = Null
        Component = ceBoxCount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCode'
        Value = ''
        Component = ceBarCode
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inArticle'
        Value = ''
        Component = ceArticle
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCodeGLN'
        Value = ''
        Component = ceBarCodeGLN
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inArticleGLN'
        Value = ''
        Component = ceArticleGLN
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGroupName'
        Value = Null
        Component = ceGroupName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsPropertyId'
        Value = ''
        Component = GuidesGoodsProperty
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = ''
        Component = GuidesGoodsKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsBoxId'
        Value = Null
        Component = GuidesGoodsBox
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindSubId'
        Value = Null
        Component = GuidesGoodsKindSub
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsKind'
        Value = Null
        Component = cbisGoodsKind
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 88
    Top = 361
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 488
    Top = 310
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount'
        Value = 0.000000000000000000
        Component = ceAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxCount'
        Value = Null
        Component = ceBoxCount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDoc'
        Value = Null
        Component = ceAmountDoc
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BarCode'
        Value = ''
        Component = ceBarCode
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Article'
        Value = ''
        Component = ceArticle
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BarCodeGLN'
        Value = ''
        Component = ceBarCodeGLN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ArticleGLN'
        Value = ''
        Component = ceArticleGLN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupName'
        Value = Null
        Component = ceGroupName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPropertyId'
        Value = ''
        Component = GuidesGoodsProperty
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPropertyName'
        Value = ''
        Component = GuidesGoodsProperty
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindId'
        Value = ''
        Component = GuidesGoodsKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindName'
        Value = ''
        Component = GuidesGoodsKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsBoxId'
        Value = Null
        Component = GuidesGoodsBox
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsBoxName'
        Value = Null
        Component = GuidesGoodsBox
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindSubId'
        Value = Null
        Component = GuidesGoodsKindSub
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindSubName'
        Value = Null
        Component = GuidesGoodsKindSub
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGoodsKind'
        Value = Null
        Component = cbisGoodsKind
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 251
    Top = 362
  end
  object GuidesGoodsProperty: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsProperty
    FormNameParam.Value = 'TGoodsPropertyForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsPropertyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsProperty
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsProperty
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 108
    Top = 166
  end
  object GuidesGoodsKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsKind
    FormNameParam.Value = 'TGoodsKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 372
    Top = 158
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoods
    FormNameParam.Value = 'TGoods_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoods_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 180
    Top = 62
  end
  object GuidesGoodsBox: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsBox
    FormNameParam.Value = 'TGoods_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoods_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsBox
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsBox
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 117
    Top = 100
  end
  object GuidesGoodsKindSub: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsKindSub
    FormNameParam.Value = 'TGoodsKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsKindSub
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsKindSub
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 335
    Top = 137
  end
end
