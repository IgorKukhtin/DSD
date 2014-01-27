inherited SendDebtForm: TSendDebtForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1042#1079#1072#1080#1084#1086#1079#1072#1095#1077#1090' ('#1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072')>'
  ClientHeight = 370
  ClientWidth = 590
  AddOnFormData.isSingle = False
  ExplicitWidth = 596
  ExplicitHeight = 402
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 184
    Top = 314
    ExplicitLeft = 184
    ExplicitTop = 314
  end
  inherited bbCancel: TcxButton
    Left = 328
    Top = 314
    ExplicitLeft = 328
    ExplicitTop = 314
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
  object cxLabel2: TcxLabel [5]
    Left = 9
    Top = 204
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
  end
  object cxLabel5: TcxLabel [6]
    Left = 8
    Top = 152
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object cePaidKindFrom: TcxButtonEdit [7]
    Left = 9
    Top = 227
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 6
    Width = 128
  end
  object ceInfoMoneyFrom: TcxButtonEdit [8]
    Left = 8
    Top = 175
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 273
  end
  object ceOperDate: TcxDateEdit [9]
    Left = 152
    Top = 34
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 129
  end
  object ceJuridicalFrom: TcxButtonEdit [10]
    Left = 8
    Top = 125
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 5
    Width = 273
  end
  object cxLabel6: TcxLabel [11]
    Left = 8
    Top = 107
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086' ('#1086#1090')'
  end
  object ceContractFrom: TcxButtonEdit [12]
    Left = 153
    Top = 227
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 4
    Width = 128
  end
  object cxLabel8: TcxLabel [13]
    Left = 153
    Top = 204
    Caption = #1044#1086#1075#1086#1074#1086#1088
  end
  object cxLabel10: TcxLabel [14]
    Left = 8
    Top = 254
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [15]
    Left = 8
    Top = 273
    TabOrder = 15
    Width = 576
  end
  object cxLabel4: TcxLabel [16]
    Left = 312
    Top = 16
    Caption = #1057#1091#1084#1084#1072
  end
  object ceAmount: TcxCurrencyEdit [17]
    Left = 312
    Top = 33
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 17
    Width = 129
  end
  object cxLabel3: TcxLabel [18]
    Left = 312
    Top = 107
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086' ('#1082#1086#1084#1091')'
  end
  object ceJuridicalTo: TcxButtonEdit [19]
    Left = 312
    Top = 125
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 19
    Width = 273
  end
  object cxLabel7: TcxLabel [20]
    Left = 312
    Top = 152
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object ceInfoMoneyTo: TcxButtonEdit [21]
    Left = 312
    Top = 175
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 21
    Width = 273
  end
  object cxLabel9: TcxLabel [22]
    Left = 312
    Top = 204
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
  end
  object cxLabel11: TcxLabel [23]
    Left = 456
    Top = 204
    Caption = #1044#1086#1075#1086#1074#1086#1088
  end
  object cePaidKindTo: TcxButtonEdit [24]
    Left = 312
    Top = 227
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 24
    Width = 128
  end
  object ceContractTo: TcxButtonEdit [25]
    Left = 456
    Top = 227
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 25
    Width = 128
  end
  object cxLabel14: TcxLabel [26]
    Left = 8
    Top = 58
    Caption = #1043#1083#1072#1074#1085#1086#1077' '#1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object ceJuridicalBasis: TcxButtonEdit [27]
    Left = 8
    Top = 78
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 27
    Width = 273
  end
  object cxLabel15: TcxLabel [28]
    Left = 312
    Top = 58
    Caption = #1041#1080#1079#1085#1077#1089
  end
  object ceBusiness: TcxButtonEdit [29]
    Left = 312
    Top = 78
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 29
    Width = 273
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 303
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 303
  end
  inherited ActionList: TActionList
    Left = 95
    Top = 302
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
    Top = 303
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_SendDebt'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inInvNumber'
        Value = 0.000000000000000000
        Component = ceInvNumber
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inBusinessId'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'BusinessId'
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalBasisId'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'JuridicalBasisId'
        ParamType = ptInput
      end
      item
        Name = 'ioMasterId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MI_MasterId'
        ParamType = ptInputOutput
      end
      item
        Name = 'ioChildId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MI_ChildId'
        ParamType = ptInputOutput
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalFromId'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'JuridicalFromId'
        ParamType = ptInput
      end
      item
        Name = 'inContractfromId'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'ContractfromId'
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindFromId'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'PaidKindFromId'
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyFromId'
        Value = ''
        Component = InfoMoneyFromGuides
        ComponentItem = 'InfoMoneyFromId'
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalToId'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'JuridicalToId'
        ParamType = ptInput
      end
      item
        Name = 'inContractToId'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'ContractToId'
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindToId'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'PaidKindToId '
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyToId'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'InfoMoneyToId'
        ParamType = ptInput
      end>
    Left = 280
    Top = 94
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_SendDebt'
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
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'MI_MasterId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MI_MasterId'
      end
      item
        Name = 'MI_ChildId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MI_ChildId'
      end
      item
        Name = 'Invnumber'
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
        Name = 'JuridicalBasisId'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalBasisName'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'BusinessId'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'BusinessName'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'InfoMoneyGroupFromName'
        Value = ''
        DataType = ftString
      end
      item
        Name = 'InfoMoneyFromId'
        Value = ''
        Component = InfoMoneyFromGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'InfoMoneyFromCode'
        Value = ''
        Component = InfoMoneyFromGuides
        ComponentItem = 'Code'
      end
      item
        Name = 'InfoMoneyFromName'
        Value = ''
        Component = InfoMoneyFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ContractFromId'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ContractFromName'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'JuridicalFromId'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalFromCode'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'Code'
        DataType = ftString
      end
      item
        Name = 'JuridicalFromName'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'FromOKPO'
        Value = ''
        DataType = ftString
      end
      item
        Name = 'PaidKindFromId'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PaidKindFromName'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'InfoMoneyGroupToName'
        Value = ''
        DataType = ftString
      end
      item
        Name = 'InfoMoneyToId Integer'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'InfoMoneyToCode'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'Code'
      end
      item
        Name = 'InfoMoneyToName'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ContractToId'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ContractToName'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'JuridicalToId'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalToCode'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'Code'
      end
      item
        Name = 'JuridicalToName'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ToOKPO'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'PaidKindToId'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PaidKindToName'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'Amount'
        Value = 0.000000000000000000
        Component = ceAmount
        DataType = ftFloat
      end>
    Left = 280
    Top = 154
  end
  object PaidKindFromGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePaidKindFrom
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'PaidKindFromId'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PaidKindFromName'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 59
    Top = 216
  end
  object InfoMoneyFromGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoneyFrom
    FormNameParam.Value = 'TInfoMoneyForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoneyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = InfoMoneyFromGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 192
    Top = 161
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <
      item
        Guides = ContractFromGuides
      end>
    ActionItemList = <>
    Left = 280
    Top = 294
  end
  object ContractFromGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridicalFrom
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractFromGuides
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
        Component = PaidKindFromGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = InfoMoneyFromGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = InfoMoneyFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 128
    Top = 109
  end
  object ContractJuridicalFromGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridicalFrom
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'TextValue'
      end>
    Left = 209
    Top = 224
  end
  object ContractToGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceContractTo
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractToGuides
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
        Component = PaidKindToGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 448
    Top = 109
  end
  object InfoMoneyToGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoneyTo
    FormNameParam.Value = 'TInfoMoneyForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoneyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 440
    Top = 161
  end
  object PaidKindToGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePaidKindTo
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'PaidKindToId'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PaidKindToName'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 347
    Top = 224
  end
  object ContractJuridicalToGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridicalTo
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'JuridicalId'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicaName'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PaidKindToId'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'Key'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'Key'
        ParamType = ptResult
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 481
    Top = 208
  end
  object JuridicalBasisGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridicalBasis
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridicalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 169
    Top = 56
  end
  object BusinessGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBusiness
    FormNameParam.Value = 'TBusinessForm'
    FormNameParam.DataType = ftString
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
    Left = 465
    Top = 56
  end
end
