object GoodsEditForm: TGoodsEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
  ClientHeight = 405
  ClientWidth = 643
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
    Left = 40
    Top = 63
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 46
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 213
    Top = 372
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 353
    Top = 372
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 40
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 40
    Top = 21
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 77
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 131
    Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 269
    Caption = #1045#1076'. '#1080#1079#1084#1077#1088#1077#1085#1080#1103
  end
  object cxLabel2: TcxLabel
    Left = 557
    Top = 5
    Caption = #1042#1077#1089
  end
  object ceWeight: TcxCurrencyEdit
    Left = 557
    Top = 23
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 9
    Width = 60
  end
  object ceParentGroup: TcxButtonEdit
    Left = 40
    Top = 149
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 273
  end
  object ceMeasure: TcxButtonEdit
    Left = 40
    Top = 289
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 113
  end
  object сеTradeMark: TcxButtonEdit
    Left = 40
    Top = 242
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 113
  end
  object cxLabel5: TcxLabel
    Left = 40
    Top = 222
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
  end
  object ceInfoMoney: TcxButtonEdit
    Left = 159
    Top = 242
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = False
    TabOrder = 14
    Width = 154
  end
  object cxLabel6: TcxLabel
    Left = 159
    Top = 222
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object cxLabel7: TcxLabel
    Left = 159
    Top = 269
    Caption = #1041#1080#1079#1085#1077#1089
  end
  object ceBusiness: TcxButtonEdit
    Left = 159
    Top = 289
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 154
  end
  object cxLabel8: TcxLabel
    Left = 343
    Top = 5
    Caption = #1042#1080#1076' '#1090#1086#1087#1083#1080#1074#1072
  end
  object edFuel: TcxButtonEdit
    Left = 344
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 207
  end
  object cxLabel9: TcxLabel
    Left = 40
    Top = 176
    Caption = #1043#1088#1091#1087#1087#1072' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080
  end
  object ceGroupStat: TcxButtonEdit
    Left = 40
    Top = 195
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 129
  end
  object cxLabel10: TcxLabel
    Left = 343
    Top = 46
    Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072
  end
  object ceGoodsTag: TcxButtonEdit
    Left = 344
    Top = 63
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 207
  end
  object ceGoodsGroupAnalyst: TcxButtonEdit
    Left = 184
    Top = 195
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 24
    Width = 129
  end
  object cxLabel11: TcxLabel
    Left = 184
    Top = 176
    Caption = #1043#1088#1091#1087#1087#1072' '#1072#1085#1072#1083#1080#1090#1080#1082#1080
  end
  object cxLabel12: TcxLabel
    Left = 344
    Top = 150
    Caption = #1044#1072#1090#1072' '#1089' :'
  end
  object edStartDate: TcxDateEdit
    Left = 391
    Top = 149
    EditValue = 42005d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 27
    Width = 92
  end
  object cxLabel13: TcxLabel
    Left = 344
    Top = 90
    Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090':'
  end
  object edPriceList: TcxButtonEdit
    Left = 344
    Top = 107
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 29
    Width = 186
  end
  object cePrice: TcxCurrencyEdit
    Left = 534
    Top = 149
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 30
    Width = 83
  end
  object cxLabel14: TcxLabel
    Left = 493
    Top = 150
    Caption = #1062#1077#1085#1072' :'
  end
  object cxLabel15: TcxLabel
    Left = 557
    Top = 46
    Caption = #1042#1077#1089' '#1074#1090#1091#1083#1082#1080
  end
  object edWeightTare: TcxCurrencyEdit
    Left = 557
    Top = 63
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 33
    Width = 60
  end
  object cxLabel16: TcxLabel
    Left = 542
    Top = 90
    Caption = #1050#1086#1083'. '#1076#1083#1103' '#1042#1077#1089#1072
  end
  object edCountForWeight: TcxCurrencyEdit
    Left = 542
    Top = 107
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 35
    Width = 75
  end
  object cxLabel17: TcxLabel
    Left = 40
    Top = 90
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1073#1091#1093#1075'.)'
  end
  object edName_BUH: TcxTextEdit
    Left = 40
    Top = 107
    Properties.ReadOnly = True
    TabOrder = 37
    Width = 175
  end
  object cxLabel18: TcxLabel
    Left = 223
    Top = 90
    Caption = #1044#1072#1090#1072' '#1076#1086' ('#1073#1091#1093#1075'.) :'
  end
  object edDate_BUH: TcxDateEdit
    Left = 221
    Top = 107
    EditValue = 42005d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 39
    Width = 91
  end
  object cxLabel19: TcxLabel
    Left = 123
    Top = 4
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1089#1086#1082#1088#1072#1097#1077#1085#1085#1086#1077
  end
  object edShortName: TcxTextEdit
    Left = 123
    Top = 21
    TabOrder = 41
    Width = 190
  end
  object cxLabel20: TcxLabel
    Left = 343
    Top = 222
    Caption = #1040#1085#1072#1083#1080#1090#1080#1095#1077#1089#1082#1080#1081' '#1082#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '
  end
  object edGoodsGroupProperty: TcxButtonEdit
    Left = 343
    Top = 242
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 43
    Width = 274
  end
  object cxLabel21: TcxLabel
    Left = 343
    Top = 176
    Caption = #1043#1088#1091#1087#1087#1072' '#1072#1085#1072#1083#1080#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1082#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088#1072
  end
  object cxButtonEdit1: TcxButtonEdit
    Left = 343
    Top = 195
    Hint = #1040#1085#1072#1083#1080#1090#1080#1082#1072' '#1059#1088#1086#1074#1077#1085#1100' 1'
    ParentShowHint = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 45
    Width = 274
  end
  object cxLabel22: TcxLabel
    Left = 343
    Top = 269
    Caption = #1040#1085#1072#1083#1080#1090#1080#1095#1077#1089#1082#1072#1103' '#1075#1088#1091#1087#1087#1072' '#1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
  end
  object edGoodsGroupDirection: TcxButtonEdit
    Left = 343
    Top = 289
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 47
    Width = 274
  end
  object cxLabel23: TcxLabel
    Left = 343
    Top = 316
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit
    Left = 343
    Top = 335
    TabOrder = 49
    Width = 274
  end
  object cbHeadCount: TcxCheckBox
    Left = 40
    Top = 319
    Hint = #1057#1083#1091#1078#1077#1073#1085#1072#1103' '#1079#1072#1087#1080#1089#1082#1072
    Caption = #1055#1088#1086#1074#1077#1088#1082#1072' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1075#1086#1083#1086#1074'>'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 50
    Width = 194
  end
  object cbisPartionDate: TcxCheckBox
    Left = 40
    Top = 345
    Hint = #1057#1083#1091#1078#1077#1073#1085#1072#1103' '#1079#1072#1087#1080#1089#1082#1072
    Caption = #1059#1095#1077#1090' '#1087#1086' '#1076#1072#1090#1077' '#1087#1072#1088#1090#1080#1080
    ParentShowHint = False
    ShowHint = True
    TabOrder = 51
    Width = 134
  end
  object ActionList: TActionList
    Left = 304
    Top = 120
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
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
    StoredProcName = 'gpInsertUpdate_Object_Goods'
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
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
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
        Name = 'inShortName'
        Value = Null
        Component = edShortName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeight'
        Value = 0.000000000000000000
        Component = ceWeight
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeightTare'
        Value = Null
        Component = edWeightTare
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountForWeight'
        Value = Null
        Component = edCountForWeight
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGroupStatId'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMeasureId'
        Value = ''
        Component = dsdMeasureGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTradeMarkId'
        Value = ''
        Component = TradeMarkGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = dsdInfoMoneyGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBusinessId'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFuelId'
        Value = ''
        Component = FuelGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsTagId'
        Value = ''
        Component = GoodsTagGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupAnalystId'
        Value = Null
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupPropertyId'
        Value = Null
        Component = GuidesGoodsGroupProperty
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupDirectionId'
        Value = Null
        Component = GuidesGoodsGroupDirection
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId'
        Value = '0'
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = Null
        Component = edStartDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValuePrice'
        Value = Null
        Component = cePrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisHeadCount'
        Value = Null
        Component = cbHeadCount
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartionDate'
        Value = Null
        Component = cbisPartionDate
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 8
    Top = 57
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 56
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Goods'
    DataSets = <>
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
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name_BUH'
        Value = Null
        Component = edName_BUH
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Date_BUH'
        Value = Null
        Component = edDate_BUH
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupStatId'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupStatName'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureId'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureName'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TradeMarkId'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TradeMarkName'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsTagId'
        Value = ''
        Component = GoodsTagGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsTagName'
        Value = ''
        Component = GoodsTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = dsdInfoMoneyGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = dsdInfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Weight'
        Value = 0.000000000000000000
        Component = ceWeight
        DataType = ftCurrency
        MultiSelectSeparator = ','
      end
      item
        Name = 'WeightTare'
        Value = Null
        Component = edWeightTare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountForWeight'
        Value = Null
        Component = edCountForWeight
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'FuelId'
        Value = ''
        Component = FuelGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FuelName'
        Value = ''
        Component = FuelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BusinessId'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BusinessName'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupAnalystId'
        Value = Null
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupAnalystName'
        Value = Null
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId'
        Value = Null
        Component = PriceListGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName'
        Value = Null
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate'
        Value = 42005d
        Component = edStartDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'ValuePrice'
        Value = 0.000000000000000000
        Component = cePrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShortName'
        Value = Null
        Component = edShortName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupPropertyId'
        Value = Null
        Component = GuidesGoodsGroupProperty
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupPropertyName'
        Value = Null
        Component = GuidesGoodsGroupProperty
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupPropertyId_Parent'
        Value = Null
        Component = GuidesGoodsGroupPropertyParent
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupPropertyName_Parent'
        Value = Null
        Component = GuidesGoodsGroupPropertyParent
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupDirectionId'
        Value = Null
        Component = GuidesGoodsGroupDirection
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupDirectionName'
        Value = Null
        Component = GuidesGoodsGroupDirection
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isHeadCount'
        Value = Null
        Component = cbHeadCount
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPartionDate'
        Value = Null
        Component = cbisPartionDate
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 8
    Top = 112
  end
  object dsdMeasureGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMeasure
    FormNameParam.Value = 'TMeasureForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMeasureForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 264
  end
  object TradeMarkGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = сеTradeMark
    FormNameParam.Value = 'TTradeMarkForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TTradeMarkForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 64
    Top = 210
  end
  object dsdInfoMoneyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdInfoMoneyGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdInfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 232
    Top = 235
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
    Left = 464
    Top = 22
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 16
    Top = 8
  end
  object BusinessGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBusiness
    FormNameParam.Value = 'TBusiness_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBusiness_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 288
  end
  object FuelGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFuel
    FormNameParam.Value = 'TFuelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TFuelForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FuelGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FuelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 400
    Top = 59
  end
  object GoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParentGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 112
  end
  object GoodsGroupStatGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGroupStat
    FormNameParam.Value = 'TGoodsGroupStatForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroupStatForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 152
  end
  object GoodsTagGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsTag
    FormNameParam.Value = 'TGoodsTagForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsTagForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsTagGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupAnalystId'
        Value = Null
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupAnalystName'
        Value = Null
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 408
    Top = 13
  end
  object GoodsGroupAnalystGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsGroupAnalyst
    FormNameParam.Value = 'TGoodsGroupAnalystForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroupAnalystForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 224
    Top = 184
  end
  object PriceListGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList
    Key = '0'
    FormNameParam.Value = 'TPriceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 448
    Top = 99
  end
  object GuidesGoodsGroupProperty: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroupProperty
    FormNameParam.Value = 'TGoodsGroupPropertyForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroupPropertyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsGroupProperty
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsGroupProperty
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParentId'
        Value = Null
        Component = GuidesGoodsGroupPropertyParent
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParentName'
        Value = Null
        Component = GuidesGoodsGroupPropertyParent
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 494
    Top = 174
  end
  object GuidesGoodsGroupPropertyParent: TdsdGuides
    KeyField = 'Id'
    LookupControl = cxButtonEdit1
    DisableGuidesOpen = True
    FormNameParam.Value = 'TGoodsGroupProperty_ObjecForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroupProperty_ObjecForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsGroupPropertyParent
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsGroupPropertyParent
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 502
    Top = 216
  end
  object GuidesGoodsGroupDirection: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroupDirection
    FormNameParam.Value = 'TGoodsGroupDirectionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroupDirectionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsGroupDirection
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsGroupDirection
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 478
    Top = 288
  end
end
