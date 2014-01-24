inherited ServiceForm: TServiceForm
  ActiveControl = ceAmountDebet
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1091#1089#1083#1091#1075'>'
  ClientHeight = 265
  ClientWidth = 606
  AddOnFormData.isSingle = False
  ExplicitWidth = 612
  ExplicitHeight = 290
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 183
    Top = 222
    ExplicitLeft = 183
    ExplicitTop = 222
  end
  inherited bbCancel: TcxButton
    Left = 327
    Top = 222
    ExplicitLeft = 327
    ExplicitTop = 222
  end
  object cxLabel1: TcxLabel [2]
    Left = 152
    Top = 11
    Caption = #1044#1072#1090#1072
  end
  object Код: TcxLabel [3]
    Left = 8
    Top = 11
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
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
  object cxLabel2: TcxLabel [5]
    Left = 184
    Top = 111
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
  end
  object cxLabel4: TcxLabel [6]
    Left = 314
    Top = 111
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object cxLabel5: TcxLabel [7]
    Left = 295
    Top = 61
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object cePaidKind: TcxButtonEdit [8]
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
  object ceUnit: TcxButtonEdit [9]
    Left = 295
    Top = 134
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 10
    Width = 304
  end
  object ceInfoMoney: TcxButtonEdit [10]
    Left = 295
    Top = 84
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 304
  end
  object ceOperDate: TcxDateEdit [11]
    Left = 152
    Top = 34
    TabOrder = 3
    Width = 129
  end
  object ceAmountDebet: TcxCurrencyEdit [12]
    Left = 293
    Top = 34
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 7
    Width = 142
  end
  object cxLabel7: TcxLabel [13]
    Left = 293
    Top = 11
    Caption = #1044#1077#1073#1077#1090', '#1089#1091#1084#1084#1072' ('#1084#1099' '#1086#1082#1072#1079#1072#1083#1080')'
  end
  object ceJuridical: TcxButtonEdit [14]
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
  object cxLabel6: TcxLabel [15]
    Left = 8
    Top = 111
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object ceContract: TcxButtonEdit [16]
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
  object cxLabel8: TcxLabel [17]
    Left = 8
    Top = 61
    Caption = #1044#1086#1075#1086#1074#1086#1088
  end
  object cxLabel10: TcxLabel [18]
    Left = 7
    Top = 163
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [19]
    Left = 7
    Top = 184
    TabOrder = 11
    Width = 592
  end
  object ceAmountKredit: TcxCurrencyEdit [20]
    Left = 447
    Top = 34
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 8
    Width = 152
  end
  object cxLabel3: TcxLabel [21]
    Left = 447
    Top = 11
    Caption = #1050#1088#1077#1076#1080#1090', '#1089#1091#1084#1084#1072' ('#1084#1099' '#1087#1086#1083#1091#1095#1080#1083#1080')'
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 210
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 24
    Top = 210
  end
  inherited ActionList: TActionList
    Left = 95
    Top = 209
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides [0]
    end
    inherited actRefresh: TdsdDataSetRefresh [1]
    end
    inherited FormClose: TdsdFormClose [2]
    end
  end
  inherited FormParams: TdsdFormParams
    Left = 128
    Top = 210
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Service'
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
        Name = 'inamountIn'
        Value = 0.000000000000000000
        Component = ceAmountDebet
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inamountOut'
        Value = 0.000000000000000000
        Component = ceAmountKredit
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
        Name = 'incontactid'
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
        Name = 'injuridicalid'
        Value = ''
        Component = JuridicalGuides
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
        Component = PaidKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inunitid'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 336
    Top = 160
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Service'
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
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'InvNumber'
        Value = 0.000000000000000000
        Component = ceInvNumber
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
      end
      item
        Name = 'AmountIn'
        Value = 0.000000000000000000
        Component = ceAmountDebet
        DataType = ftFloat
      end
      item
        Name = 'AmountOut'
        Value = 0.000000000000000000
        Component = ceAmountKredit
        DataType = ftFloat
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
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
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
        Component = ContractGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ContractInvNumber'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 272
    Top = 152
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
    Left = 400
    Top = 109
  end
  object InfoMoneyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormName = 'TInfoMoney_ObjectForm'
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
    Left = 472
    Top = 69
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormName = 'TJuridical_ObjectForm'
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
        Guides = InfoMoneyGuides
      end>
    ActionItemList = <>
    Left = 408
    Top = 160
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
