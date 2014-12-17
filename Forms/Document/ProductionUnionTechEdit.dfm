inherited ProductionUnionTechEditForm: TProductionUnionTechEditForm
  ActiveControl = ceRealWeight
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1080#1079#1084#1077#1085#1080#1090#1100' /'#1047#1072#1082#1083#1072#1076#1082#1091' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'>'
  ClientHeight = 276
  ClientWidth = 605
  AddOnFormData.isSingle = False
  ExplicitWidth = 611
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
    Left = 184
    Top = 5
    Caption = #1044#1072#1090#1072
    Visible = False
  end
  object Код: TcxLabel [3]
    Left = 8
    Top = 5
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    Visible = False
  end
  object ceOperDate: TcxDateEdit [4]
    Left = 184
    Top = 24
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Visible = False
    Width = 97
  end
  object ceRealWeight: TcxCurrencyEdit [5]
    Left = 8
    Top = 157
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 4
    Width = 110
  end
  object cxLabel7: TcxLabel [6]
    Left = 8
    Top = 140
    Caption = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090
  end
  object ceRecipe: TcxButtonEdit [7]
    Left = 8
    Top = 114
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 342
  end
  object cxLabel6: TcxLabel [8]
    Left = 8
    Top = 95
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
  end
  object cxLabel10: TcxLabel [9]
    Left = 8
    Top = 184
    Caption = #1050#1086#1084#1077#1085#1090#1072#1088#1080#1081' '#1074' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077
  end
  object ceComment: TcxTextEdit [10]
    Left = 8
    Top = 201
    TabOrder = 5
    Width = 441
  end
  object cxLabel9: TcxLabel [11]
    Left = 460
    Top = 183
    Caption = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080
  end
  object ceDatePartionGoods: TcxDateEdit [12]
    Left = 460
    Top = 201
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 12
    Width = 137
  end
  object edInvNumber: TcxTextEdit [13]
    Left = 8
    Top = 24
    Properties.ReadOnly = True
    TabOrder = 13
    Text = '0'
    Visible = False
    Width = 156
  end
  object ceGooodsAndKind: TcxButtonEdit [14]
    Left = 8
    Top = 74
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 14
    Width = 342
  end
  object cxLabel12: TcxLabel [15]
    Left = 8
    Top = 55
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
  end
  object cxLabel3: TcxLabel [16]
    Left = 124
    Top = 140
    Caption = #1050#1086#1083'. '#1073#1072#1090#1086#1085#1086#1074
  end
  object ceCount: TcxCurrencyEdit [17]
    Left = 124
    Top = 157
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 17
    Width = 110
  end
  object cxLabel4: TcxLabel [18]
    Left = 240
    Top = 140
    Caption = #1050#1091#1090#1077#1088' '#1092#1072#1082#1090
  end
  object ceСuterCount: TcxCurrencyEdit [19]
    Left = 240
    Top = 157
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 19
    Width = 110
  end
  object cxLabel11: TcxLabel [20]
    Left = 371
    Top = 139
    Caption = #1050#1091#1090#1077#1088' '#1079#1072#1103#1074'.'
  end
  object ceСuterReq: TcxCurrencyEdit [21]
    Left = 371
    Top = 156
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 21
    Width = 110
  end
  object cxLabel13: TcxLabel [22]
    Left = 487
    Top = 139
    Caption = #1050#1086#1083' '#1079#1072#1103#1074'.'
  end
  object ceAmountReq: TcxCurrencyEdit [23]
    Left = 487
    Top = 156
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 23
    Width = 110
  end
  object cxLabel2: TcxLabel [24]
    Left = 374
    Top = 8
    Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
  end
  object cxLabel5: TcxLabel [25]
    Left = 371
    Top = 95
    Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
  end
  object ceRecipeCode: TcxCurrencyEdit [26]
    Left = 371
    Top = 112
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 26
    Width = 110
  end
  object ceGooodsKindGuides: TcxButtonEdit [27]
    Left = 371
    Top = 74
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 27
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
    Top = 217
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
        Name = 'inMovementId_Value'
        Value = '0'
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
        Name = 'ininvnumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inoperdate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inOperDatePartner'
        Value = 0d
        Component = ceDatePartionGoods
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inInvNumberPartner'
        Value = ''
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inamountIn'
        Value = 0.000000000000000000
        Component = ceRealWeight
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inamountOut'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'incomment'
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inbusinessid'
        Value = ''
        ParamType = ptInput
      end
      item
        Name = 'incontractid'
        Value = ''
        ParamType = ptInput
      end
      item
        Name = 'ininfomoneyid'
        Value = ''
        ParamType = ptInput
      end
      item
        Name = 'injuridicalid'
        Value = ''
        Component = RecipeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPartnerId'
        Value = ''
        Component = GooodsAndKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'injuridicalbasisid'
        Value = ''
        ParamType = ptInput
      end
      item
        Name = 'inpaidkindid'
        Value = ''
        ParamType = ptInput
      end
      item
        Name = 'inunitid'
        Value = ''
        ParamType = ptInput
      end>
    Left = 488
    Top = 224
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ProductionUnionTech'
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
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
        Name = 'InvNumber'
        Value = '0'
        Component = edInvNumber
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
      end
      item
        Name = 'OperDatePartner'
        Value = 0d
        Component = ceDatePartionGoods
        DataType = ftDateTime
      end
      item
        Name = 'InvNumberPartner'
        Value = ''
        DataType = ftString
      end
      item
        Name = 'AmountIn'
        Value = 0.000000000000000000
        Component = ceRealWeight
        DataType = ftFloat
      end
      item
        Name = 'AmountOut'
        Value = 0.000000000000000000
        DataType = ftFloat
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = RecipeGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = RecipeGuides
        ComponentItem = 'TextValue'
      end
      item
        Name = 'JuridicalBasisId'
        Value = ''
      end
      item
        Name = 'JuridicalBasisName'
        Value = ''
        DataType = ftString
      end
      item
        Name = 'BusinessId'
        Value = ''
      end
      item
        Name = 'BusinessName'
        Value = ''
        DataType = ftString
      end
      item
        Name = 'PaidKindId'
        Value = ''
      end
      item
        Name = 'PaidKindName'
        Value = ''
        DataType = ftString
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        DataType = ftString
      end
      item
        Name = 'UnitId'
        Value = ''
      end
      item
        Name = 'UnitName'
        Value = ''
        DataType = ftString
      end
      item
        Name = 'Comment'
        Value = ''
        Component = ceComment
        DataType = ftString
      end
      item
        Name = 'ContractId'
        Value = ''
      end
      item
        Name = 'ContractInvNumber'
        Value = ''
        DataType = ftString
      end
      item
        Name = 'PartnerId'
        Value = ''
        Component = GooodsAndKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = GooodsAndKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 544
    Top = 216
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
        Component = GooodsAndKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = GooodsAndKindGuides
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
    Top = 97
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <
      item
        Guides = RecipeGuides
      end
      item
      end
      item
      end
      item
      end>
    ActionItemList = <>
    Left = 264
    Top = 178
  end
  object GooodsAndKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGooodsAndKind
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GooodsAndKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GooodsAndKindGuides
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
    Left = 200
    Top = 57
  end
  object GooodsKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGooodsKindGuides
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
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
    Top = 52
  end
end
