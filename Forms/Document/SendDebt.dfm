inherited SendDebtForm: TSendDebtForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1042#1079#1072#1080#1084#1086#1079#1072#1095#1077#1090' ('#1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072')>'
  ClientHeight = 327
  ClientWidth = 592
  AddOnFormData.isSingle = False
  ExplicitWidth = 598
  ExplicitHeight = 352
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 184
    Top = 289
    ExplicitLeft = 184
    ExplicitTop = 289
  end
  inherited bbCancel: TcxButton
    Left = 328
    Top = 289
    ExplicitLeft = 328
    ExplicitTop = 289
  end
  object cxLabel1: TcxLabel [2]
    Left = 152
    Top = 4
    Caption = #1044#1072#1090#1072
  end
  object Код: TcxLabel [3]
    Left = 8
    Top = 4
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object ceInvNumber: TcxCurrencyEdit [4]
    Left = 8
    Top = 24
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 2
    Width = 129
  end
  object cxLabel2: TcxLabel [5]
    Left = 9
    Top = 190
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099' ('#1044#1077#1073#1077#1090')'
  end
  object cxLabel5: TcxLabel [6]
    Left = 8
    Top = 140
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103' ('#1044#1077#1073#1077#1090')'
  end
  object cePaidKindFrom: TcxButtonEdit [7]
    Left = 9
    Top = 211
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
    Top = 160
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
    Top = 24
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 129
  end
  object ceJuridicalFrom: TcxButtonEdit [10]
    Left = 8
    Top = 69
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
    Top = 51
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086' ('#1044#1077#1073#1077#1090')'
  end
  object ceContractFrom: TcxButtonEdit [12]
    Left = 153
    Top = 211
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
    Top = 190
    Caption = #1044#1086#1075#1086#1074#1086#1088' ('#1044#1077#1073#1077#1090')'
  end
  object cxLabel10: TcxLabel [14]
    Left = 8
    Top = 232
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [15]
    Left = 8
    Top = 251
    TabOrder = 15
    Width = 576
  end
  object cxLabel4: TcxLabel [16]
    Left = 312
    Top = 4
    Caption = #1057#1091#1084#1084#1072
  end
  object ceAmount: TcxCurrencyEdit [17]
    Left = 312
    Top = 24
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 17
    Width = 129
  end
  object cxLabel3: TcxLabel [18]
    Left = 312
    Top = 51
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086' ('#1050#1088#1077#1076#1080#1090')'
  end
  object ceJuridicalTo: TcxButtonEdit [19]
    Left = 312
    Top = 69
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
    Top = 140
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103' ('#1050#1088#1077#1076#1080#1090')'
  end
  object ceInfoMoneyTo: TcxButtonEdit [21]
    Left = 312
    Top = 160
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
    Top = 190
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099' ('#1050#1088#1077#1076#1080#1090')'
  end
  object cxLabel11: TcxLabel [23]
    Left = 456
    Top = 190
    Caption = #1044#1086#1075#1086#1074#1086#1088' ('#1050#1088#1077#1076#1080#1090')'
  end
  object cePaidKindTo: TcxButtonEdit [24]
    Left = 312
    Top = 211
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
    Top = 211
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 25
    Width = 128
  end
  object cePartnerFrom: TcxButtonEdit [26]
    Left = 8
    Top = 115
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 26
    Width = 273
  end
  object cxLabel12: TcxLabel [27]
    Left = 8
    Top = 96
    Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1044#1077#1073#1077#1090')'
  end
  object cePartnerTo: TcxButtonEdit [28]
    Left = 312
    Top = 115
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 28
    Width = 273
  end
  object cxLabel13: TcxLabel [29]
    Left = 312
    Top = 96
    Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1050#1088#1077#1076#1080#1090')'
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 281
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 281
  end
  inherited ActionList: TActionList
    Left = 95
    Top = 280
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
      end>
    Left = 136
    Top = 281
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
        DataType = ftString
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
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPartnerFromId'
        Value = ''
        Component = PartnerFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inContractfromId'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindFromId'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyFromId'
        Value = ''
        Component = InfoMoneyFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalToId'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPartnerToId'
        Value = ''
        Component = PartnerToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inContractToId'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindToId'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyToId'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 280
    Top = 30
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_SendDebt'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
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
        Name = 'InfoMoneyToId'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'Key'
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
      end
      item
        Name = 'Comment'
        Value = ''
        Component = ceComment
        DataType = ftString
      end
      item
        Name = 'PartnerFromId'
        Value = ''
        Component = PartnerFromGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PartnerFromName'
        Value = ''
        Component = PartnerFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PartnerToId'
        Value = ''
        Component = PartnerToGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PartnerToName'
        Value = ''
        Component = PartnerToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 280
    Top = 138
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
    Top = 200
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
    Top = 146
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <
      item
        Guides = ContractJuridicalFromGuides
      end
      item
        Guides = ContractJuridicalToGuides
      end
      item
      end>
    ActionItemList = <>
    Left = 280
    Top = 272
  end
  object ContractFromGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceContractFrom
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
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
        ComponentItem = 'JuridicalId'
      end
      item
        Name = 'JuridicalFromName'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'JuridicalName'
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
      end
      item
        Name = 'inPaidKindId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inPaidKindId'
      end>
    Left = 216
    Top = 205
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
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'TextValue'
        ParamType = ptInput
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = InfoMoneyFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'InfoMoneyName_all'
        Value = ''
        Component = InfoMoneyFromGuides
        ComponentItem = 'TextValue'
        ParamType = ptInput
      end
      item
        Name = 'PartnerId'
        Value = ''
        Component = PartnerFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = PartnerFromGuides
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
    Left = 145
    Top = 56
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
        Component = ContractJuridicalToGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 504
    Top = 205
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
    Top = 146
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
    Top = 208
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
        Name = 'Key'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'InfoMoneyName_all'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PartnerId'
        Value = ''
        Component = PartnerToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = PartnerToGuides
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
    Left = 481
    Top = 42
  end
  object PartnerFromGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePartnerFrom
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PartnerFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PartnerFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 208
    Top = 104
  end
  object PartnerToGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePartnerTo
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PartnerToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PartnerToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 504
    Top = 104
  end
end
