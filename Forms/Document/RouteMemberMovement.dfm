inherited RouteMemberMovementForm: TRouteMemberMovementForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1052#1072#1088#1096#1088#1091#1090' '#1090#1086#1088#1075#1086#1074#1086#1075#1086' '#1072#1075#1077#1085#1090#1072'>'
  ClientHeight = 298
  ClientWidth = 294
  AddOnFormData.isSingle = False
  ExplicitWidth = 300
  ExplicitHeight = 326
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 34
    Top = 266
    ExplicitLeft = 34
    ExplicitTop = 266
  end
  inherited bbCancel: TcxButton
    Left = 165
    Top = 266
    ExplicitLeft = 165
    ExplicitTop = 266
  end
  object cxLabel1: TcxLabel [2]
    Left = 152
    Top = 11
    Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object Код: TcxLabel [3]
    Left = 8
    Top = 11
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
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
  object ceOperDate: TcxDateEdit [5]
    Left = 152
    Top = 34
    EditValue = 42242d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 129
  end
  object ceInsertName: TcxButtonEdit [6]
    Left = 8
    Top = 79
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 273
  end
  object cxLabel6: TcxLabel [7]
    Left = 8
    Top = 61
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
  end
  object edInsertDate: TcxDateEdit [8]
    Left = 8
    Top = 128
    EditValue = 42821d
    Properties.DateButtons = [btnClear, btnToday]
    Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
    Properties.EditFormat = 'dd.mm.yyyy hh:mm'
    Properties.InputKind = ikMask
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 129
  end
  object cxLabel14: TcxLabel [9]
    Left = 8
    Top = 109
    Caption = #1044#1072#1090#1072'/'#1042#1088'. '#1089#1086#1079#1076'. '#1076#1086#1082'.'
  end
  object cxLabel15: TcxLabel [10]
    Left = 152
    Top = 109
    Caption = #1044#1072#1090#1072'/'#1042#1088'. '#1089#1086#1079#1076'. '#1085#1072' '#1084#1086#1073'.'
  end
  object edInsertMobileDate: TcxDateEdit [11]
    Left = 152
    Top = 128
    EditValue = 42821d
    Properties.DateButtons = [btnClear, btnToday]
    Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
    Properties.EditFormat = 'dd.mm.yyyy hh:mm'
    Properties.InputKind = ikMask
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 129
  end
  object cxLabel4: TcxLabel [12]
    Left = 8
    Top = 156
    Caption = 'GUID, '#1075#1083#1086#1073'. '#1091#1085#1080#1082#1072#1083#1100#1085#1099#1081' '#1080#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
  end
  object ceGUID: TcxCurrencyEdit [13]
    Left = 8
    Top = 174
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 273
  end
  object cxLabel34: TcxLabel [14]
    Left = 8
    Top = 203
    Caption = 'GPS ('#1096#1080#1088#1086#1090#1072')'
  end
  object cxLabel35: TcxLabel [15]
    Left = 152
    Top = 203
    Caption = 'GPS ('#1076#1086#1083#1075#1086#1090#1072')'
  end
  object edGPSN: TcxCurrencyEdit [16]
    Left = 8
    Top = 219
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 16
    Width = 129
  end
  object edGPSE: TcxCurrencyEdit [17]
    Left = 152
    Top = 219
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 17
    Width = 129
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 247
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 8
    Top = 239
  end
  inherited ActionList: TActionList
    Left = 95
    Top = 246
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 247
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_RouteMember'
    Params = <
      item
        Name = 'ioid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ininvnumber'
        Value = 0.000000000000000000
        Component = ceInvNumber
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
        Name = 'inGPSN'
        Value = 'NULL'
        Component = edGPSN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGPSE'
        Value = 'NULL'
        Component = edGPSE
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 248
    Top = 60
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_RouteMember'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Invnumber'
        Value = 0.000000000000000000
        Component = ceInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'Operdate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Statuscode'
        Value = '0'
        Component = FormParams
        MultiSelectSeparator = ','
      end
      item
        Name = 'statusname'
        Value = Null
        Component = FormParams
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertName'
        Value = 0.000000000000000000
        Component = ceInsertName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertDate'
        Value = 'NULL'
        Component = edInsertDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertMobileDate'
        Value = 0.000000000000000000
        Component = edInsertMobileDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'GUID'
        Value = 0.000000000000000000
        Component = ceGUID
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GPSE'
        Value = 0.000000000000000000
        Component = edGPSE
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'GPSN'
        Value = 0.000000000000000000
        Component = edGPSN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 248
    Top = 12
  end
  object MemberGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInsertName
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 63
  end
end
