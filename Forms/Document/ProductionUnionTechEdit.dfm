inherited ProductionUnionTechEditForm: TProductionUnionTechEditForm
  ActiveControl = ceRealWeight
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1080#1079#1084#1077#1085#1080#1090#1100' /'#1047#1072#1082#1083#1072#1076#1082#1091' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'>'
  ClientHeight = 276
  ClientWidth = 717
  AddOnFormData.isSingle = False
  ExplicitWidth = 723
  ExplicitHeight = 308
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 167
    Top = 235
    Height = 26
    ExplicitLeft = 167
    ExplicitTop = 235
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 311
    Top = 235
    Height = 26
    ExplicitLeft = 311
    ExplicitTop = 235
    ExplicitHeight = 26
  end
  object cxLabel1: TcxLabel [2]
    Left = 487
    Top = 144
    Caption = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080
    Visible = False
  end
  object ceOperDate: TcxDateEdit [3]
    Left = 487
    Top = 161
    Enabled = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 97
  end
  object ceRealWeight: TcxCurrencyEdit [4]
    Left = 8
    Top = 120
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.0000'
    TabOrder = 4
    Width = 110
  end
  object cxLabel7: TcxLabel [5]
    Left = 8
    Top = 100
    Caption = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090
  end
  object ceRecipe: TcxButtonEdit [6]
    Left = 8
    Top = 74
    Enabled = False
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
    Top = 144
    Caption = #1050#1086#1084#1077#1085#1090#1072#1088#1080#1081' '#1074' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077
  end
  object ceComment: TcxTextEdit [9]
    Left = 8
    Top = 161
    TabOrder = 5
    Width = 441
  end
  object ceGooods: TcxButtonEdit [10]
    Left = 8
    Top = 34
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 342
  end
  object cxLabel12: TcxLabel [11]
    Left = 8
    Top = 11
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
  end
  object cxLabel3: TcxLabel [12]
    Left = 124
    Top = 100
    Caption = #1050#1086#1083'. '#1073#1072#1090#1086#1085#1086#1074
  end
  object ceCount: TcxCurrencyEdit [13]
    Left = 124
    Top = 120
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.0000'
    TabOrder = 13
    Width = 110
  end
  object cxLabel4: TcxLabel [14]
    Left = 240
    Top = 100
    Caption = #1050#1091#1090#1077#1088' '#1092#1072#1082#1090
  end
  object ceСuterCount: TcxCurrencyEdit [15]
    Left = 240
    Top = 120
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.0000'
    TabOrder = 15
    Width = 110
  end
  object cxLabel11: TcxLabel [16]
    Left = 371
    Top = 100
    Caption = #1050#1091#1090#1077#1088' '#1079#1072#1103#1074'.'
  end
  object ceСuterCountOrder: TcxCurrencyEdit [17]
    Left = 371
    Top = 120
    Enabled = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.0000'
    TabOrder = 17
    Width = 110
  end
  object cxLabel13: TcxLabel [18]
    Left = 487
    Top = 100
    Caption = #1050#1086#1083' '#1079#1072#1103#1074'.'
  end
  object ceAmountOrder: TcxCurrencyEdit [19]
    Left = 487
    Top = 120
    Enabled = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.0000'
    TabOrder = 19
    Width = 110
  end
  object cxLabel2: TcxLabel [20]
    Left = 374
    Top = 11
    Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
  end
  object cxLabel5: TcxLabel [21]
    Left = 371
    Top = 55
    Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
  end
  object ceGooodsKindGuides: TcxButtonEdit [22]
    Left = 371
    Top = 34
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 22
    Width = 145
  end
  object ceRecipeCode: TcxTextEdit [23]
    Left = 371
    Top = 73
    Enabled = False
    TabOrder = 23
    Width = 150
  end
  object cxLabel8: TcxLabel [24]
    Left = 534
    Top = 11
    Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055
  end
  object ceGooodsKindCompleateGuides: TcxButtonEdit [25]
    Left = 531
    Top = 34
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 25
    Width = 145
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 11
    Top = 228
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 104
    Top = 228
  end
  inherited ActionList: TActionList
    Left = 423
    Top = 177
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
        Name = 'Id'
        Value = '0'
        ParamType = ptInput
      end
      item
        Name = 'MIOrderId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'FromId'
        Value = '0'
        ParamType = ptInput
      end
      item
        Name = 'ToId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inMovementId_Value'
        Value = '0'
        ParamType = ptInput
      end
      item
        Name = 'OperDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 56
    Top = 228
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionUnion_MasterTech'
    Params = <
      item
        Name = 'ioid'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inFromId'
        Value = Null
        Component = FormParams
        ComponentItem = 'FromId'
        ParamType = ptInput
      end
      item
        Name = 'inToId'
        Value = ''
        Component = FormParams
        ComponentItem = 'ToId'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = 0.000000000000000000
        Component = GooodsRecipesGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inCount'
        Value = ''
        Component = ceCount
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inRealWeight'
        Value = 0.000000000000000000
        Component = ceRealWeight
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inCuterCount'
        Value = ''
        Component = ceСuterCount
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Value = ''
        Component = GooodsKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindCompleateId'
        Value = ''
        Component = GooodsKindCompleateGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inReceiptId'
        Value = '0'
        Component = RecipeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Value = ''
        Component = GooodsRecipesGuides
        ComponentItem = 'Key'
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end>
    Left = 488
    Top = 224
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ProductionUnionTech'
    Params = <
      item
        Name = 'inId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inMIOrderId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MIOrderId'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inFromId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'FromId'
        ParamType = ptInput
      end
      item
        Name = 'inToId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'ToId'
        ParamType = ptInput
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
      end
      item
        Name = 'GoodsId'
        Value = ''
        Component = GooodsRecipesGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GooodsRecipesGuides
        ComponentItem = 'TextValue'
      end
      item
        Name = 'GoodsKindId'
        Value = ''
        Component = GooodsKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsKindName'
        Value = ''
        Component = GooodsKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'GoodsKindCompleateId'
        Value = ''
        Component = GooodsKindCompleateGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsKindCompleateName'
        Value = ''
        Component = GooodsKindCompleateGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ReceiptId'
        Value = 0d
        Component = RecipeGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ReceiptCode'
        Value = ''
        Component = ceRecipeCode
        DataType = ftString
      end
      item
        Name = 'ReceiptName'
        Value = 0.000000000000000000
        Component = RecipeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'Comment'
        Value = 0.000000000000000000
        Component = ceComment
        DataType = ftString
      end
      item
        Name = 'Count'
        Value = ''
        Component = ceCount
        DataType = ftFloat
      end
      item
        Name = 'RealWeight'
        Value = ''
        Component = ceRealWeight
        DataType = ftFloat
      end
      item
        Name = 'CuterCount'
        Value = ''
        Component = ceСuterCount
        DataType = ftFloat
      end
      item
        Name = 'AmountOrder'
        Value = ''
        Component = ceAmountOrder
        DataType = ftFloat
      end
      item
        Name = 'CuterCountOrder'
        Value = ''
        Component = ceСuterCountOrder
        DataType = ftFloat
      end
      item
        Name = 'isErased'
        Value = ''
        DataType = ftBoolean
      end
      item
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = ''
        Component = GooodsRecipesGuides
        ComponentItem = 'Key'
        ParamType = ptUnknown
      end
      item
        Value = ''
        Component = GooodsRecipesGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptUnknown
      end>
    Left = 544
    Top = 176
  end
  object RecipeGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRecipe
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = RecipeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = RecipeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PaidKindId'
        Value = ''
        ParamType = ptInput
      end
      item
        Name = 'PaidKindName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        ParamType = ptInput
      end
      item
        Name = 'InfoMoneyName_all'
        Value = ''
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PartnerId'
        Value = ''
        Component = GooodsRecipesGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = GooodsRecipesGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'MasterJuridicalId'
        Value = 0
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        DataType = ftString
      end>
    Left = 128
    Top = 57
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <>
    ActionItemList = <>
    Left = 264
    Top = 186
  end
  object GooodsRecipesGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGooods
    FormNameParam.Value = 'TRecipesMasterForm'
    FormNameParam.DataType = ftString
    FormName = 'TRecipesMasterForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = RecipeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'Code'
        Value = Null
        Component = ceRecipeCode
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RecipeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'GoodsId'
        Value = ''
        Component = GooodsRecipesGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GooodsRecipesGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'GoodsKindId'
        Value = ''
        Component = GooodsKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsKindName'
        Value = ''
        Component = GooodsKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'GoodsKindCompleteId'
        Value = Null
        Component = GooodsKindCompleateGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsKindCompleteName'
        Value = Null
        Component = GooodsKindCompleateGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 200
    Top = 17
  end
  object GooodsKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGooodsKindGuides
    FormNameParam.Value = 'TGoodsKind_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsKind_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GooodsKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GooodsKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = RecipeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = RecipeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = RecipeGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = RecipeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 416
    Top = 4
  end
  object GooodsKindCompleateGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGooodsKindCompleateGuides
    FormNameParam.Value = 'TGoodsKind_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsKind_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GooodsKindCompleateGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GooodsKindCompleateGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = RecipeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = RecipeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = RecipeGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = RecipeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 616
    Top = 12
  end
end
