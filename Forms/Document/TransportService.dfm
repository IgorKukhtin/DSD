inherited TransportServiceForm: TTransportServiceForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1085#1072#1077#1084#1085#1099#1081' '#1090#1088#1072#1085#1089#1087#1086#1088#1090'>'
  ClientHeight = 338
  ClientWidth = 597
  AddOnFormData.isSingle = False
  ExplicitWidth = 603
  ExplicitHeight = 366
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 184
    Top = 306
    ExplicitLeft = 184
    ExplicitTop = 306
  end
  inherited bbCancel: TcxButton
    Left = 328
    Top = 306
    ExplicitLeft = 328
    ExplicitTop = 306
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
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 2
    Width = 129
  end
  object cxLabel3: TcxLabel [5]
    Left = 8
    Top = 106
    Caption = #1059#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object cxLabel2: TcxLabel [6]
    Left = 312
    Top = 253
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
  end
  object cxLabel67: TcxLabel [7]
    Left = 8
    Top = 156
    Caption = #1052#1072#1088#1096#1088#1091#1090
  end
  object cxLabel5: TcxLabel [8]
    Left = 312
    Top = 205
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
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
    Left = 312
    Top = 276
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 129
  end
  object ceRoute: TcxButtonEdit [11]
    Left = 8
    Top = 178
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 273
  end
  object ceInfoMoney: TcxButtonEdit [12]
    Left = 312
    Top = 228
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 273
  end
  object ceOperDate: TcxDateEdit [13]
    Left = 152
    Top = 34
    EditValue = 42242d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 129
  end
  object ceCar: TcxButtonEdit [14]
    Left = 8
    Top = 228
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 273
  end
  object cxLabel9: TcxLabel [15]
    Left = 8
    Top = 205
    Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
  end
  object ceJuridical: TcxButtonEdit [16]
    Left = 8
    Top = 79
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 273
  end
  object cxLabel6: TcxLabel [17]
    Left = 8
    Top = 61
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object ceContract: TcxButtonEdit [18]
    Left = 456
    Top = 276
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 129
  end
  object cxLabel8: TcxLabel [19]
    Left = 456
    Top = 253
    Caption = #1044#1086#1075#1086#1074#1086#1088
  end
  object cxLabel10: TcxLabel [20]
    Left = 8
    Top = 255
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [21]
    Left = 8
    Top = 276
    TabOrder = 21
    Width = 273
  end
  object cxLabel4: TcxLabel [22]
    Left = 312
    Top = 61
    Caption = #1055#1088#1086#1073#1077#1075' '#1092#1072#1082#1090', '#1082#1084
  end
  object ceDistance: TcxCurrencyEdit [23]
    Left = 312
    Top = 79
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 23
    Width = 129
  end
  object cxLabel11: TcxLabel [24]
    Left = 456
    Top = 61
    Caption = #1062#1077#1085#1072' ('#1090#1086#1087#1083#1080#1074#1072')'
  end
  object cePrice: TcxCurrencyEdit [25]
    Left = 456
    Top = 79
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 25
    Width = 129
  end
  object cxLabel12: TcxLabel [26]
    Left = 312
    Top = 106
    Caption = #1050#1086#1083'-'#1074#1086' '#1090#1086#1095#1077#1082
  end
  object ceCountPoint: TcxCurrencyEdit [27]
    Left = 312
    Top = 126
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 27
    Width = 129
  end
  object cxLabel13: TcxLabel [28]
    Left = 456
    Top = 106
    Caption = #1042#1088#1077#1084#1103' '#1074' '#1087#1091#1090#1080', '#1095#1072#1089#1086#1074
  end
  object ceTrevelTime: TcxCurrencyEdit [29]
    Left = 456
    Top = 126
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 29
    Width = 129
  end
  object cxLabel7: TcxLabel [30]
    Left = 312
    Top = 156
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1052#1077#1089#1090#1086' '#1086#1090#1087#1088#1072#1074#1082#1080')'
  end
  object ceUnit: TcxButtonEdit [31]
    Left = 312
    Top = 178
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 31
    Width = 273
  end
  object cxLabel14: TcxLabel [32]
    Left = 312
    Top = 11
    Caption = #1044#1072#1090#1072'/'#1042#1088'.'#1074#1099#1077#1079#1076#1072' '#1087#1083#1072#1085' '
  end
  object edStartRunPlan: TcxDateEdit [33]
    Left = 312
    Top = 34
    EditValue = 42242d
    Properties.DateButtons = [btnClear, btnToday]
    Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
    Properties.EditFormat = 'dd.mm.yyyy hh:mm'
    Properties.InputKind = ikMask
    Properties.Kind = ckDateTime
    TabOrder = 33
    Width = 129
  end
  object cxLabel15: TcxLabel [34]
    Left = 456
    Top = 11
    Caption = #1044#1072#1090#1072'/'#1042#1088'.'#1074#1099#1077#1079#1076#1072' '#1092#1072#1082#1090
  end
  object edStartRun: TcxDateEdit [35]
    Left = 456
    Top = 34
    EditValue = 42242d
    Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
    Properties.EditFormat = 'dd.mm.yyyy hh:mm'
    Properties.InputKind = ikMask
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    TabOrder = 35
    Width = 129
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 295
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 295
  end
  inherited ActionList: TActionList
    Left = 95
    Top = 294
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
      end
      item
        Name = 'inPaidKindId'
        Value = '0'
        ParamType = ptInput
      end>
    Left = 136
    Top = 295
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
        Name = 'inStartRunPlan'
        Value = Null
        Component = edStartRunPlan
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'ioAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInputOutput
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
        Component = ContractJuridicalGuides
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
        Name = 'inContractConditionKindId'
        Value = ''
        Component = ContractConditionKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inUnitForwardingId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 248
    Top = 60
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
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
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
        Value = Null
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
        Component = ContractJuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = ContractJuridicalGuides
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
        Name = 'UnitForwardingId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'UnitForwardingName'
        Value = ''
        Component = UnitGuides
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
      end
      item
        Name = 'StartRunPlan'
        Value = Null
        Component = edStartRunPlan
        DataType = ftDateTime
      end
      item
        Name = 'StartRun'
        Value = Null
        Component = edStartRun
        DataType = ftDateTime
      end>
    Left = 280
    Top = 108
  end
  object ContractConditionKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceContractConditionKind
    FormNameParam.Value = 'TContractConditionKindForm'
    FormNameParam.DataType = ftString
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
      end
      item
        Name = 'inContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Id'
      end>
    Left = 160
    Top = 114
  end
  object PaidKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
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
    Left = 402
    Top = 265
  end
  object RouteGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRoute
    FormNameParam.Value = 'TRouteForm'
    FormNameParam.DataType = ftString
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
    Left = 144
    Top = 169
  end
  object InfoMoneyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormNameParam.Value = 'TInfoMoneyForm'
    FormNameParam.DataType = ftString
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
    Top = 211
  end
  object CarGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCar
    FormNameParam.Value = 'TCarForm'
    FormNameParam.DataType = ftString
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
    Left = 96
    Top = 202
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <
      item
        Guides = ContractJuridicalGuides
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
    Top = 286
  end
  object ContractGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceContract
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
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
      end
      item
        Name = 'JuridicalName'
        Value = ''
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
      end
      item
        Name = 'inPaidKindId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inPaidKindId'
      end>
    Left = 128
    Top = 63
  end
  object ContractJuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'JuridicalId'
        Value = ''
        Component = ContractJuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = ContractJuridicalGuides
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
      end
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptResult
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 520
    Top = 257
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 368
    Top = 160
  end
end
