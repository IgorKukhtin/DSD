inherited CurrencyMovementForm: TCurrencyMovementForm
  ActiveControl = ceAmount
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1050#1091#1088#1089#1086#1074#1072#1103' '#1088#1072#1079#1085#1080#1094#1072'>'
  ClientHeight = 257
  ClientWidth = 300
  AddOnFormData.isSingle = False
  ExplicitWidth = 306
  ExplicitHeight = 286
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 30
    Top = 222
    Height = 26
    ExplicitLeft = 30
    ExplicitTop = 222
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 174
    Top = 222
    Height = 26
    ExplicitLeft = 174
    ExplicitTop = 222
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
  object edOperDate: TcxDateEdit [4]
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
  object edCurrencyTo: TcxButtonEdit [7]
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
  object edCurrencyFrom: TcxButtonEdit [9]
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
    Top = 160
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edComment: TcxTextEdit [12]
    Left = 8
    Top = 179
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
    Top = 132
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
    Left = 168
    Top = 130
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Currency'
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
        Name = 'ioinvnumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inoperdate'
        Value = 0d
        Component = edOperDate
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
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyFromid'
        Value = ''
        Component = GuidesCurrencyFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyToid'
        Value = ''
        Component = GuidesCurrencyTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 168
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Currency'
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
        Component = edOperDate
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
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyFromId'
        Value = ''
        Component = GuidesCurrencyFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyFromName'
        Value = ''
        Component = GuidesCurrencyFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyToId'
        Value = ''
        Component = GuidesCurrencyTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyToName'
        Value = ''
        Component = GuidesCurrencyTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 248
    Top = 112
  end
  object GuidesCurrencyTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCurrencyTo
    FormNameParam.Value = 'TCurrency_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCurrency_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCurrencyTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCurrencyTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 63
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = GuidesCurrencyFrom
      end
      item
        Guides = GuidesCurrencyTo
      end
      item
      end
      item
      end>
    ActionItemList = <>
    Left = 208
    Top = 8
  end
  object GuidesCurrencyFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCurrencyFrom
    FormNameParam.Value = 'TCurrency_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCurrency_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCurrencyFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCurrencyFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 69
  end
end
