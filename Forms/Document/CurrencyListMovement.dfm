inherited CurrencyListMovementForm: TCurrencyListMovementForm
  ActiveControl = ceAmount
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1050#1091#1088#1089#1099' '#1074#1072#1083#1102#1090' '#1076#1083#1103' '#1088#1072#1089#1095#1077#1090#1086#1074'>'
  ClientHeight = 302
  ClientWidth = 291
  AddOnFormData.isSingle = False
  ExplicitWidth = 297
  ExplicitHeight = 331
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 30
    Top = 266
    Height = 26
    ExplicitLeft = 30
    ExplicitTop = 266
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 174
    Top = 266
    Height = 26
    ExplicitLeft = 174
    ExplicitTop = 266
    ExplicitHeight = 26
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
  object ceOperDate: TcxDateEdit [4]
    Left = 152
    Top = 34
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 118
  end
  object ceAmount: TcxCurrencyEdit [5]
    Left = 8
    Top = 80
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 5
    Width = 118
  end
  object cxLabel7: TcxLabel [6]
    Left = 8
    Top = 61
    Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1082#1091#1088#1089#1072
  end
  object ceCurrencyTo: TcxButtonEdit [7]
    Left = 152
    Top = 128
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 4
    Width = 118
  end
  object cxLabel6: TcxLabel [8]
    Left = 152
    Top = 109
    Caption = #1042#1072#1083#1102#1090#1072' ('#1088#1077#1079#1091#1083#1100#1090#1072#1090')'
  end
  object ceCurrencyFrom: TcxButtonEdit [9]
    Left = 152
    Top = 80
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 3
    Width = 118
  end
  object cxLabel8: TcxLabel [10]
    Left = 152
    Top = 61
    Caption = #1042#1072#1083#1102#1090#1072' ('#1079#1085#1072#1095#1077#1085#1080#1077')'
  end
  object cxLabel10: TcxLabel [11]
    Left = 8
    Top = 207
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [12]
    Left = 8
    Top = 226
    TabOrder = 6
    Width = 262
  end
  object edInvNumber: TcxTextEdit [13]
    Left = 8
    Top = 34
    Properties.ReadOnly = True
    TabOrder = 13
    Text = '0'
    Width = 118
  end
  object ceParValue: TcxCurrencyEdit [14]
    Left = 8
    Top = 128
    EditValue = 1.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0.'
    Properties.ReadOnly = False
    TabOrder = 14
    Width = 118
  end
  object cxLabel2: TcxLabel [15]
    Left = 8
    Top = 109
    Caption = #1053#1086#1084#1080#1085#1072#1083
  end
  object edPaidKind: TcxButtonEdit [16]
    Left = 8
    Top = 177
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 118
  end
  object cxLabel3: TcxLabel [17]
    Left = 8
    Top = 158
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
  end
  object cxLabel13: TcxLabel [18]
    Left = 152
    Top = 158
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1089#1072#1081#1090#1072
  end
  object edSiteTag: TcxButtonEdit [19]
    Left = 152
    Top = 177
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 118
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 139
    Top = 170
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 64
    Top = 98
  end
  inherited ActionList: TActionList
    Left = 247
    Top = 65
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Value'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 154
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_CurrencyList'
    Params = <
      item
        Name = 'ioid'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ininvnumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inoperdate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParValue'
        Value = 0d
        Component = ceParValue
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'incomment'
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSiteTagId'
        Value = Null
        Component = GuidesSiteTag
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyFromid'
        Value = ''
        Component = CurrencyFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyToid'
        Value = ''
        Component = CurrencyToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = Null
        Component = PaidKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 168
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_CurrencyList'
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Value'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inMovementId_Value'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = '0'
        Component = edInvNumber
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
        Name = 'Amount'
        Value = 0.000000000000000000
        Component = ceAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParValue'
        Value = ''
        Component = ceParValue
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyFromId'
        Value = ''
        Component = CurrencyFromGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyFromName'
        Value = ''
        Component = CurrencyFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyToId'
        Value = ''
        Component = CurrencyToGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyToName'
        Value = ''
        Component = CurrencyToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = Null
        Component = PaidKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = Null
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SiteTagId'
        Value = Null
        Component = GuidesSiteTag
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'SiteTagName'
        Value = Null
        Component = GuidesSiteTag
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 248
    Top = 112
  end
  object CurrencyToGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCurrencyTo
    FormNameParam.Value = 'TCurrency_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCurrency_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = CurrencyToGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CurrencyToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 71
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = CurrencyFromGuides
      end
      item
        Guides = CurrencyToGuides
      end
      item
      end
      item
      end>
    ActionItemList = <>
    Left = 208
    Top = 8
  end
  object CurrencyFromGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCurrencyFrom
    FormNameParam.Value = 'TCurrency_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCurrency_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = CurrencyFromGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CurrencyFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 13
  end
  object PaidKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 51
    Top = 144
  end
  object GuidesSiteTag: TdsdGuides
    KeyField = 'Id'
    LookupControl = edSiteTag
    FormNameParam.Value = 'TSiteTagForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSiteTagForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesSiteTag
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesSiteTag
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 176
  end
end
