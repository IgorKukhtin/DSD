inherited TransportServiceForm: TTransportServiceForm
  ActiveControl = ceAmount
  Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1085#1072#1077#1084#1085#1099#1081' '#1090#1088#1072#1085#1089#1087#1086#1088#1090
  ClientHeight = 317
  ClientWidth = 595
  AddOnFormData.isSingle = False
  ExplicitWidth = 601
  ExplicitHeight = 349
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 184
    ExplicitLeft = 184
  end
  inherited bbCancel: TcxButton
    Left = 328
    ExplicitLeft = 328
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
    Left = 312
    Top = 61
    Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088'. '#1083#1080#1094#1086
  end
  object cxLabel2: TcxLabel [6]
    Left = 184
    Top = 111
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
  end
  object cxLabel4: TcxLabel [7]
    Left = 8
    Top = 165
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object cxLabel5: TcxLabel [8]
    Left = 312
    Top = 111
    Caption = #1057#1090#1072#1090#1100#1080' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object ceMainJuridical: TcxButtonEdit [9]
    Left = 312
    Top = 84
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 273
  end
  object cePaidKind: TcxButtonEdit [10]
    Left = 184
    Top = 134
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 6
    Width = 97
  end
  object ceUnit: TcxButtonEdit [11]
    Left = 8
    Top = 188
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
    Top = 134
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 10
    Width = 273
  end
  object ceOperDate: TcxDateEdit [13]
    Left = 152
    Top = 34
    TabOrder = 3
    Width = 129
  end
  object ceAmount: TcxCurrencyEdit [14]
    Left = 312
    Top = 34
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 8
    Width = 273
  end
  object cxLabel7: TcxLabel [15]
    Left = 312
    Top = 11
    Caption = #1057#1091#1084#1084#1072' '#1086#1087#1077#1088#1072#1094#1080#1080
  end
  object ceBusiness: TcxButtonEdit [16]
    Left = 312
    Top = 188
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 11
    Width = 273
  end
  object cxLabel9: TcxLabel [17]
    Left = 312
    Top = 165
    Caption = #1041#1080#1079#1085#1077#1089
  end
  object ceJuridical: TcxButtonEdit [18]
    Left = 8
    Top = 134
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 5
    Width = 170
  end
  object cxLabel6: TcxLabel [19]
    Left = 8
    Top = 111
    Caption = #1070#1088'. '#1083#1080#1094#1086
  end
  object ceContract: TcxButtonEdit [20]
    Left = 8
    Top = 84
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 4
    Width = 273
  end
  object cxLabel8: TcxLabel [21]
    Left = 8
    Top = 61
    Caption = #1044#1086#1075#1086#1074#1086#1088
  end
  object cxLabel10: TcxLabel [22]
    Left = 8
    Top = 219
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
  end
  object ceComment: TcxTextEdit [23]
    Left = 8
    Top = 240
    TabOrder = 23
    Width = 577
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 274
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 24
    Top = 274
  end
  inherited ActionList: TActionList
    Left = 95
    Top = 273
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides [0]
    end
    inherited actRefresh: TdsdDataSetRefresh [1]
    end
    inherited FormClose: TdsdFormClose [2]
    end
  end
  inherited FormParams: TdsdFormParams
    Left = 128
    Top = 274
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TransportService'
    Params = <
      item
        Name = 'ioid'
        Value = Null
        ParamType = ptInputOutput
      end
      item
        Name = 'iomiid'
        Value = Null
        ParamType = ptInputOutput
      end
      item
        Name = 'ininvnumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inoperdate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'indistance'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inprice'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'incountpoint'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'intreveltime'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'incomment'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'injuridicalid'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'incontractid'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'ininfomoneyid'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inpaidkindid'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inrouteid'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'incarid'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'incontractconditionkindid'
        Value = Null
        ParamType = ptInput
      end>
    Left = 352
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TransportService'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'id'
        Value = Null
      end
      item
        Name = 'invnumber'
        Value = Null
      end
      item
        Name = 'operdate'
        Value = Null
        DataType = ftDateTime
      end
      item
        Name = 'statuscode'
        Value = Null
      end
      item
        Name = 'statusname'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'amount'
        Value = Null
        DataType = ftFloat
      end
      item
        Name = 'distance'
        Value = Null
        DataType = ftFloat
      end
      item
        Name = 'price'
        Value = Null
        DataType = ftFloat
      end
      item
        Name = 'countpoint'
        Value = Null
        DataType = ftFloat
      end
      item
        Name = 'treveltime'
        Value = Null
        DataType = ftFloat
      end
      item
        Name = 'comment'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'contractid'
        Value = Null
      end
      item
        Name = 'contractname'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'infomoneyid'
        Value = Null
      end
      item
        Name = 'infomoneyname'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'juridicalid'
        Value = Null
      end
      item
        Name = 'juridicalname'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'paidkindid'
        Value = Null
      end
      item
        Name = 'paidkindname'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'routeid'
        Value = Null
      end
      item
        Name = 'routename'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'carid'
        Value = Null
      end
      item
        Name = 'carname'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'carmodelid'
        Value = Null
      end
      item
        Name = 'carmodelname'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'contractconditionkindid'
        Value = Null
      end
      item
        Name = 'contractconditionkindname'
        Value = Null
        DataType = ftString
      end>
    Left = 248
    Top = 240
  end
  object MainJuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMainJuridical
    FormName = 'TJuridicalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MainJuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MainJuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 496
    Top = 61
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
    Top = 133
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 176
    Top = 189
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
    Top = 117
  end
  object BusinessGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBusiness
    FormName = 'TBusinessForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 480
    Top = 181
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
    Left = 128
    Top = 125
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
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
        Guides = UnitGuides
      end
      item
        Guides = MainJuridicalGuides
      end
      item
        Guides = InfoMoneyGuides
      end
      item
        Guides = BusinessGuides
      end>
    ActionItemList = <>
    Left = 440
    Top = 272
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
    Top = 69
  end
end
