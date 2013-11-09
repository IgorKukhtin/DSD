inherited ServiceForm: TServiceForm
  Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077
  ClientHeight = 271
  ClientWidth = 595
  AddOnFormData.isAlwaysRefresh = False
  ExplicitWidth = 611
  ExplicitHeight = 306
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 184
    Top = 226
    ExplicitLeft = 184
    ExplicitTop = 226
  end
  inherited bbCancel: TcxButton
    Left = 328
    Top = 226
    ExplicitLeft = 328
    ExplicitTop = 226
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
    Left = 8
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
    TabOrder = 7
    Width = 273
  end
  object cePaidKind: TcxButtonEdit [10]
    Left = 8
    Top = 134
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 8
    Width = 273
  end
  object ceUnit: TcxButtonEdit [11]
    Left = 8
    Top = 188
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
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
    TabOrder = 11
    Width = 129
  end
  object ceAmount: TcxCurrencyEdit [14]
    Left = 312
    Top = 34
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 12
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
    TabOrder = 14
    Width = 273
  end
  object cxLabel9: TcxLabel [17]
    Left = 312
    Top = 165
    Caption = #1041#1080#1079#1085#1077#1089
  end
  object ceJuridical: TcxButtonEdit [18]
    Left = 8
    Top = 84
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 16
    Width = 273
  end
  object cxLabel6: TcxLabel [19]
    Left = 8
    Top = 61
    Caption = #1070#1088'. '#1083#1080#1094#1086
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 226
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 8
    Top = 226
  end
  inherited ActionList: TActionList
    Left = 79
    Top = 225
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides [0]
    end
    inherited actRefresh: TdsdDataSetRefresh [1]
    end
    inherited FormClose: TdsdFormClose [2]
    end
  end
  inherited FormParams: TdsdFormParams
    Left = 112
    Top = 226
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Service'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
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
        Name = 'inAmount'
        Value = 0.000000000000000000
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inMainJuridicalId'
        Value = ''
        Component = MainJuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inBusinessId'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 336
    Top = 232
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Service'
    Params = <
      item
        Name = 'Id'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
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
        Name = 'Amount'
        Value = 0.000000000000000000
        Component = ceAmount
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
        Name = 'MainJuridicalId'
        Value = ''
        Component = MainJuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'MainJuridicalName'
        Value = ''
        Component = MainJuridicalGuides
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
      end>
    Left = 304
    Top = 216
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
    PositionDataSet = 'MainDataCDS'
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
    Left = 192
    Top = 165
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormName = 'TObject_UnitForm'
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
    Left = 208
    Top = 229
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
    Left = 456
    Top = 157
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
      end>
    Left = 200
    Top = 117
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <
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
    Left = 424
    Top = 224
  end
end
