inherited TransportServiceForm: TTransportServiceForm
  Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1085#1072#1077#1084#1085#1099#1081' '#1090#1088#1072#1085#1089#1087#1086#1088#1090
  ClientHeight = 342
  ClientWidth = 595
  AddOnFormData.isSingle = False
  ExplicitWidth = 601
  ExplicitHeight = 374
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 184
    Top = 308
    ExplicitLeft = 184
    ExplicitTop = 308
  end
  inherited bbCancel: TcxButton
    Left = 328
    Top = 308
    ExplicitLeft = 328
    ExplicitTop = 308
  end
  object cxLabel1: TcxLabel [2]
    Left = 152
    Top = 11
    Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object Код: TcxLabel [3]
    Left = 8
    Top = 11
    Caption = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object ceInvNumber: TcxCurrencyEdit [4]
    Left = 8
    Top = 34
    Enabled = False
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 2
    Width = 129
  end
  object cxLabel3: TcxLabel [5]
    Left = 8
    Top = 106
    Caption = #1058#1080#1087#1099' '#1091#1089#1083#1086#1074#1080#1081' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
  end
  object cxLabel2: TcxLabel [6]
    Left = 184
    Top = 155
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
  end
  object cxLabel67: TcxLabel [7]
    Left = 8
    Top = 209
    Caption = #1052#1072#1088#1096#1088#1091#1090
  end
  object cxLabel5: TcxLabel [8]
    Left = 312
    Top = 106
    Caption = #1057#1090#1072#1090#1100#1080' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object ceContractConditionKind: TcxButtonEdit [9]
    Left = 8
    Top = 129
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 8
    Width = 273
  end
  object cePaidKind: TcxButtonEdit [10]
    Left = 184
    Top = 178
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 6
    Width = 97
  end
  object ceRoute: TcxButtonEdit [11]
    Left = 8
    Top = 232
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 273
  end
  object ceInfoMoney: TcxButtonEdit [12]
    Left = 312
    Top = 129
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 273
  end
  object ceOperDate: TcxDateEdit [13]
    Left = 152
    Top = 34
    TabOrder = 3
    Width = 129
  end
  object ceCar: TcxButtonEdit [14]
    Left = 312
    Top = 177
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 10
    Width = 273
  end
  object cxLabel9: TcxLabel [15]
    Left = 312
    Top = 154
    Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
  end
  object ceJuridical: TcxButtonEdit [16]
    Left = 8
    Top = 178
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 5
    Width = 170
  end
  object cxLabel6: TcxLabel [17]
    Left = 8
    Top = 155
    Caption = #1070#1088'. '#1083#1080#1094#1086
  end
  object ceContract: TcxButtonEdit [18]
    Left = 8
    Top = 78
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 4
    Width = 273
  end
  object cxLabel8: TcxLabel [19]
    Left = 8
    Top = 55
    Caption = #1044#1086#1075#1086#1074#1086#1088
  end
  object cxLabel10: TcxLabel [20]
    Left = 8
    Top = 255
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
  end
  object ceComment: TcxTextEdit [21]
    Left = 8
    Top = 276
    TabOrder = 21
    Width = 577
  end
  object cxLabel4: TcxLabel [22]
    Left = 311
    Top = 16
    Caption = #1055#1088#1086#1073#1077#1075' '#1092#1072#1082#1090', '#1082#1084
  end
  object ceDistance: TcxCurrencyEdit [23]
    Left = 311
    Top = 33
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 23
    Width = 129
  end
  object cxLabel11: TcxLabel [24]
    Left = 456
    Top = 17
    Caption = #1062#1077#1085#1072' ('#1090#1086#1087#1083#1080#1074#1072')'
  end
  object cePrice: TcxCurrencyEdit [25]
    Left = 456
    Top = 34
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 25
    Width = 129
  end
  object cxLabel12: TcxLabel [26]
    Left = 312
    Top = 61
    Caption = #1050#1086#1083'-'#1074#1086' '#1090#1086#1095#1077#1082
  end
  object ceCountPoint: TcxCurrencyEdit [27]
    Left = 312
    Top = 78
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 27
    Width = 129
  end
  object cxLabel13: TcxLabel [28]
    Left = 456
    Top = 61
    Caption = #1042#1088#1077#1084#1103' '#1074' '#1087#1091#1090#1080', '#1095#1072#1089#1086#1074
  end
  object ceTrevelTime: TcxCurrencyEdit [29]
    Left = 456
    Top = 78
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 29
    Width = 129
  end
  object cxLabel14: TcxLabel [30]
    Left = 312
    Top = 209
    Caption = #1052#1072#1088#1082#1072' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
  end
  object ceCarModel: TcxButtonEdit [31]
    Left = 312
    Top = 230
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 31
    Width = 273
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 294
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 294
  end
  inherited ActionList: TActionList
    Left = 95
    Top = 293
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
        Value = Null
        ParamType = ptInput
      end>
    Left = 136
    Top = 294
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TransportService'
    Params = <
      item
        Name = 'ioid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'iomiid'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MIId'
        ParamType = ptInputOutput
      end
      item
        Name = 'ininvnumber'
        Value = 0.000000000000000000
        Component = ceInvNumber
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
        Name = 'inAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'indistance'
        Value = 0.000000000000000000
        Component = ceDistance
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inprice'
        Value = 0.000000000000000000
        Component = cePrice
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'incountpoint'
        Value = 0.000000000000000000
        Component = ceCountPoint
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'intreveltime'
        Value = 0.000000000000000000
        Component = ceTrevelTime
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
        Name = 'injuridicalid'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'incontractid'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'ininfomoneyid'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inpaidkindid'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inrouteid'
        Value = ''
        Component = RouteGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'incarid'
        Value = ''
        Component = CarGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'incontractconditionkindid'
        Value = ''
        Component = ContractConditionKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 280
    Top = 52
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TransportService'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
      end
      item
        Name = 'MIId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MIId'
      end
      item
        Name = 'Invnumber'
        Value = 0.000000000000000000
        Component = ceInvNumber
      end
      item
        Name = 'Operdate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
      end
      item
        Name = 'Statuscode'
        Value = '0'
        Component = FormParams
      end
      item
        Name = 'statusname'
        Component = FormParams
        DataType = ftString
      end
      item
        Name = 'Amount'
        Value = 0.000000000000000000
        DataType = ftFloat
      end
      item
        Name = 'Distance'
        Value = 0.000000000000000000
        Component = ceDistance
        DataType = ftFloat
      end
      item
        Name = 'Price'
        Value = 0.000000000000000000
        Component = cePrice
        DataType = ftFloat
      end
      item
        Name = 'CountPoint'
        Value = 0.000000000000000000
        Component = ceCountPoint
        DataType = ftFloat
      end
      item
        Name = 'TrevelTime'
        Value = 0.000000000000000000
        Component = ceTrevelTime
        DataType = ftFloat
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
        Component = ContractGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ContractName'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'RouteId'
        Value = ''
        Component = RouteGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'RouteName'
        Value = ''
        Component = RouteGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CarId'
        Value = ''
        Component = CarGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'CarName'
        Value = ''
        Component = CarGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CarModelId'
        Value = ''
        Component = CarModelGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'CarModelName'
        Value = ''
        Component = CarModelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ContractConditionKindId'
        Value = ''
        Component = ContractConditionKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ContractConditionKindName'
        Value = ''
        Component = ContractConditionKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 280
    Top = 108
  end
  object ContractConditionKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceContractConditionKind
    FormName = 'TContractConditionKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractConditionKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractConditionKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 168
    Top = 106
  end
  object PaidKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePaidKind
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 208
    Top = 177
  end
  object RouteGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRoute
    FormName = 'TRouteForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = RouteGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RouteGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 136
    Top = 225
  end
  object InfoMoneyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormName = 'TInfoMoneyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 480
    Top = 112
  end
  object CarGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCar
    FormName = 'TCarForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = CarGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CarGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 480
    Top = 170
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormName = 'TJuridicalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 104
    Top = 169
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <
      item
        Guides = ContractGuides
      end
      item
        Guides = JuridicalGuides
      end
      item
        Guides = PaidKindGuides
      end
      item
        Guides = RouteGuides
      end
      item
        Guides = ContractConditionKindGuides
      end
      item
        Guides = InfoMoneyGuides
      end
      item
        Guides = CarGuides
      end>
    ActionItemList = <>
    Left = 280
    Top = 268
  end
  object ContractGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceContract
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 128
    Top = 63
  end
  object CarModelGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCarModel
    FormName = 'TCarModelForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = CarModelGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CarModelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 432
    Top = 211
  end
end
