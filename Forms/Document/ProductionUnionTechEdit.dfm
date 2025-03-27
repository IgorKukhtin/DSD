inherited ProductionUnionTechEditForm: TProductionUnionTechEditForm
  ActiveControl = ceRealWeight
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1080#1079#1084#1077#1085#1080#1090#1100' <'#1047#1072#1082#1083#1072#1076#1082#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072'>'
  ClientHeight = 332
  ClientWidth = 562
  AddOnFormData.isSingle = False
  ExplicitWidth = 568
  ExplicitHeight = 361
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 168
    Top = 298
    Height = 26
    ExplicitLeft = 168
    ExplicitTop = 298
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 312
    Top = 298
    Height = 26
    ExplicitLeft = 312
    ExplicitTop = 298
    ExplicitHeight = 26
  end
  object cxLabel1: TcxLabel [2]
    Left = 242
    Top = 200
    Caption = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080
    Visible = False
  end
  object ceOperDate: TcxDateEdit [3]
    Left = 242
    Top = 218
    EditValue = 42078d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 108
  end
  object ceRealWeight: TcxCurrencyEdit [4]
    Left = 8
    Top = 125
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 4
    Width = 111
  end
  object cxLabel7: TcxLabel [5]
    Left = 8
    Top = 105
    Caption = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090
  end
  object ceRecipe: TcxButtonEdit [6]
    Left = 8
    Top = 75
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 342
  end
  object cxLabel6: TcxLabel [7]
    Left = 8
    Top = 55
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
  end
  object cxLabel10: TcxLabel [8]
    Left = 8
    Top = 241
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [9]
    Left = 8
    Top = 261
    TabOrder = 5
    Width = 342
  end
  object ceGooods: TcxButtonEdit [10]
    Left = 8
    Top = 25
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 249
  end
  object cxLabel12: TcxLabel [11]
    Left = 8
    Top = 5
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
  end
  object cxLabel3: TcxLabel [12]
    Left = 127
    Top = 105
    Caption = #1050#1086#1083'-'#1074#1086' '#1073#1072#1090#1086#1085#1086#1074
  end
  object ceCount: TcxCurrencyEdit [13]
    Left = 127
    Top = 125
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 13
    Width = 108
  end
  object cxLabel4: TcxLabel [14]
    Left = 242
    Top = 105
    Caption = #1050#1091#1090#1090#1077#1088#1086#1074' '#1092#1072#1082#1090
  end
  object ceСuterCount: TcxCurrencyEdit [15]
    Left = 242
    Top = 125
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 15
    Width = 108
  end
  object cxLabel11: TcxLabel [16]
    Left = 466
    Top = 105
    Caption = #1050#1091#1090#1090#1077#1088#1086#1074' '#1079#1072#1103#1074#1082#1072
  end
  object ceСuterCountOrder: TcxCurrencyEdit [17]
    Left = 466
    Top = 125
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 91
  end
  object cxLabel13: TcxLabel [18]
    Left = 466
    Top = 155
    Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1082#1072
  end
  object ceAmountOrder: TcxCurrencyEdit [19]
    Left = 466
    Top = 175
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 91
  end
  object cxLabel2: TcxLabel [20]
    Left = 270
    Top = 5
    Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
  end
  object cxLabel5: TcxLabel [21]
    Left = 370
    Top = 55
    Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
  end
  object ceGooodsKindGuides: TcxButtonEdit [22]
    Left = 270
    Top = 25
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 22
    Width = 80
  end
  object ceReceiptCode: TcxTextEdit [23]
    Left = 370
    Top = 75
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 187
  end
  object cxLabel8: TcxLabel [24]
    Left = 370
    Top = 5
    Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055
  end
  object ceGooodsKindCompleteGuides: TcxButtonEdit [25]
    Left = 370
    Top = 25
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 25
    Width = 187
  end
  object cxLabel9: TcxLabel [26]
    Left = 8
    Top = 155
    Caption = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090'('#1082#1091#1090#1090#1077#1088')'
  end
  object ceCuterWeight: TcxCurrencyEdit [27]
    Left = 8
    Top = 175
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 27
    Width = 111
  end
  object cxLabel14: TcxLabel [28]
    Left = 8
    Top = 200
    Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object edDocumentKind: TcxButtonEdit [29]
    Left = 8
    Top = 218
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 29
    Width = 227
  end
  object cxLabel15: TcxLabel [30]
    Left = 370
    Top = 105
    Caption = #1050#1086#1083'-'#1074#1086' '#1096#1090'.'#1087#1083#1072#1085
  end
  object ceAmount: TcxCurrencyEdit [31]
    Left = 370
    Top = 125
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 31
    Width = 86
  end
  object cxLabel16: TcxLabel [32]
    Left = 127
    Top = 155
    Caption = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090' ('#1084#1089#1078')'
  end
  object ceRealWeightMsg: TcxCurrencyEdit [33]
    Left = 127
    Top = 175
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 33
    Width = 108
  end
  object ceRealWeightShp: TcxCurrencyEdit [34]
    Left = 242
    Top = 175
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 34
    Width = 108
  end
  object cxLabel17: TcxLabel [35]
    Left = 242
    Top = 155
    Caption = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090' ('#1096#1087#1088')'
  end
  object cxLabel18: TcxLabel [36]
    Left = 374
    Top = 155
    Hint = #1050#1086#1083'-'#1074#1086' '#1096#1090'. '#1092#1072#1082#1090' ('#1090#1091#1096#1077#1085#1082#1072')'
    Caption = #1050#1086#1083'-'#1074#1086' '#1096#1090'.'#1092#1072#1082#1090
  end
  object ceCountReal: TcxCurrencyEdit [37]
    Left = 370
    Top = 175
    Hint = #1050#1086#1083'-'#1074#1086' '#1096#1090'. '#1092#1072#1082#1090' ('#1090#1091#1096#1077#1085#1082#1072')'
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 37
    Width = 86
  end
  object cxLabel19: TcxLabel [38]
    Left = 370
    Top = 200
    Hint = #1050#1086#1083'-'#1074#1086' '#1096#1090'. '#1092#1072#1082#1090' ('#1090#1091#1096#1077#1085#1082#1072')'
    Caption = #1050#1086#1083'-'#1074#1086' '#1092#1086#1088#1084#1086#1074#1082#1072'+1'#1076#1077#1085#1100','#1082#1075
  end
  object ceAmountForm: TcxCurrencyEdit [39]
    Left = 370
    Top = 218
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 39
    Width = 187
  end
  object cxLabel20: TcxLabel [40]
    Left = 370
    Top = 241
    Caption = #1050#1086#1083'-'#1074#1086' '#1092#1086#1088#1084#1086#1074#1082#1072'+2'#1076#1077#1085#1100','#1082#1075
  end
  object ceAmountForm_two: TcxCurrencyEdit [41]
    Left = 370
    Top = 261
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 41
    Width = 187
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 11
    Top = 258
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 120
    Top = 258
  end
  inherited ActionList: TActionList
    Left = 391
    Top = 272
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides [0]
    end
    inherited actRefresh: TdsdDataSetRefresh [1]
    end
    inherited FormClose: TdsdFormClose [2]
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MovementId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementItemId_order'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DocumentKindId'
        Value = Null
        Component = GuidesDocumentKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DocumentKindName'
        Value = Null
        Component = GuidesDocumentKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 71
    Top = 258
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionUnionTech'
    Params = <
      item
        Name = 'inMovementItemId_order'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementItemId_order'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioMovementItemId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioMovementId'
        Value = ''
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = Null
        Component = FormParams
        ComponentItem = 'FromId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = FormParams
        ComponentItem = 'ToId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentKindId'
        Value = Null
        Component = GuidesDocumentKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptId'
        Value = '0'
        Component = ReceiptGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = 0.000000000000000000
        Component = ReceiptGoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCount'
        Value = ''
        Component = ceCount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountReal'
        Value = Null
        Component = ceCountReal
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRealWeight'
        Value = 0.000000000000000000
        Component = ceRealWeight
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRealWeightMsg'
        Value = Null
        Component = ceRealWeightMsg
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRealWeightShp'
        Value = Null
        Component = ceRealWeightShp
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCuterCount'
        Value = ''
        Component = ceСuterCount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCuterWeight'
        Value = Null
        Component = ceCuterWeight
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountForm'
        Value = Null
        Component = ceAmountForm
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountForm_two'
        Value = Null
        Component = ceAmountForm_two
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = ''
        Component = GooodsKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindCompleteId'
        Value = ''
        Component = GooodsKindCompleteGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 480
    Top = 272
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ProductionUnionTech'
    Params = <
      item
        Name = 'inMovementId'
        Value = ''
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementItemId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementItemId_order'
        Value = ''
        Component = FormParams
        ComponentItem = 'MovementItemId_order'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'FromId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'ToId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId'
        Value = ''
        Component = FormParams
        ComponentItem = 'inMovementId'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = ''
        Component = FormParams
        ComponentItem = 'inFromId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = FormParams
        ComponentItem = 'inToId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementItemId'
        Value = ''
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = ''
        Component = ReceiptGoodsGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = ReceiptGoodsGuides
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindId'
        Value = ''
        Component = GooodsKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindName'
        Value = ''
        Component = GooodsKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindCompleteId'
        Value = ''
        Component = GooodsKindCompleteGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindCompleteName'
        Value = ''
        Component = GooodsKindCompleteGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptId'
        Value = 0d
        Component = ReceiptGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptCode'
        Value = ''
        Component = ceReceiptCode
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptName'
        Value = 0.000000000000000000
        Component = ReceiptGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RealWeight'
        Value = ''
        Component = ceRealWeight
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CuterCount'
        Value = ''
        Component = ceСuterCount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Count'
        Value = ''
        Component = ceCount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount_order'
        Value = ''
        Component = ceAmountOrder
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CuterCount_order'
        Value = ''
        Component = ceСuterCountOrder
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount'
        Value = Null
        Component = ceAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = 0.000000000000000000
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CuterWeight'
        Value = Null
        Component = ceCuterWeight
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'RealWeightMsg'
        Value = Null
        Component = ceRealWeightMsg
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'RealWeightShp'
        Value = Null
        Component = ceRealWeightShp
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountReal'
        Value = Null
        Component = ceCountReal
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountForm'
        Value = Null
        Component = ceAmountForm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 257
    Top = 275
  end
  object ReceiptGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRecipe
    FormNameParam.Value = 'TReceipt_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TReceipt_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ReceiptGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ReceiptGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptCode_user'
        Value = Null
        Component = ceReceiptCode
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindId'
        Value = ''
        Component = GooodsKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindName'
        Value = ''
        Component = GooodsKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindCompleteId_calc'
        Value = ''
        Component = GooodsKindCompleteGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindCompleteName_calc'
        Value = ''
        Component = GooodsKindCompleteGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterReceiptId'
        Value = 0
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterGoodsId'
        Value = 0
        Component = ReceiptGoodsGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterGoodsName'
        Value = ''
        Component = ReceiptGoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterGoodsKindId'
        Value = Null
        Component = GooodsKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 49
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <>
    ActionItemList = <>
    Left = 336
    Top = 138
  end
  object ReceiptGoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGooods
    FormNameParam.Value = 'TReceiptMainGoods_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TReceiptMainGoods_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ReceiptGoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ReceiptGoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindId'
        Value = ''
        Component = GooodsKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindName'
        Value = ''
        Component = GooodsKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptId'
        Value = Null
        Component = ReceiptGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptName'
        Value = Null
        Component = ReceiptGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindCompleteId'
        Value = Null
        Component = GooodsKindCompleteGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindCompleteName'
        Value = Null
        Component = GooodsKindCompleteGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptCode_user'
        Value = Null
        Component = ceReceiptCode
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 9
  end
  object GooodsKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGooodsKindGuides
    FormNameParam.Value = 'TGoodsKind_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsKind_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GooodsKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GooodsKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = ReceiptGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = ReceiptGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = ReceiptGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = ReceiptGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 20
  end
  object GooodsKindCompleteGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGooodsKindCompleteGuides
    FormNameParam.Value = 'TGoodsKind_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsKind_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GooodsKindCompleteGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GooodsKindCompleteGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = ReceiptGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = ReceiptGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = ReceiptGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = ReceiptGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 464
    Top = 12
  end
  object GuidesDocumentKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edDocumentKind
    FormNameParam.Value = 'TDocumentKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDocumentKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesDocumentKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesDocumentKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 145
  end
end
