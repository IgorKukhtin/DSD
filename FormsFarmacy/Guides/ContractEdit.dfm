inherited ContractEditForm: TContractEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1080#1079#1084#1077#1085#1080#1090#1100' '#1044#1086#1075#1086#1074#1086#1088
  ClientHeight = 529
  ClientWidth = 366
  ExplicitWidth = 372
  ExplicitHeight = 558
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 63
    Top = 500
    ExplicitLeft = 63
    ExplicitTop = 500
  end
  inherited bbCancel: TcxButton
    Left = 207
    Top = 500
    ExplicitLeft = 207
    ExplicitTop = 500
  end
  object cxLabel2: TcxLabel [2]
    Left = 11
    Top = 454
    Caption = #1050#1086#1076
    Visible = False
  end
  object edCode: TcxCurrencyEdit [3]
    Left = 11
    Top = 470
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 2
    Visible = False
    Width = 95
  end
  object cxLabel1: TcxLabel [4]
    Left = 10
    Top = 11
    Caption = #1053#1086#1084#1077#1088' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object edName: TcxTextEdit [5]
    Left = 10
    Top = 32
    TabOrder = 3
    Width = 239
  end
  object cxLabel4: TcxLabel [6]
    Left = 10
    Top = 105
    Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088'. '#1083#1080#1094#1086
  end
  object ceJuridicalBasis: TcxButtonEdit [7]
    Left = 10
    Top = 126
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 166
  end
  object cxLabel3: TcxLabel [8]
    Left = 10
    Top = 447
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edComment: TcxTextEdit [9]
    Left = 10
    Top = 467
    TabOrder = 7
    Width = 337
  end
  object cxLabel5: TcxLabel [10]
    Left = 182
    Top = 106
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object ceJuridical: TcxButtonEdit [11]
    Left = 182
    Top = 126
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 165
  end
  object cxLabel6: TcxLabel [12]
    Left = 10
    Top = 160
    Caption = #1044#1085#1077#1081' '#1086#1090#1089#1088#1086#1095#1082#1080
  end
  object ceDeferment: TcxCurrencyEdit [13]
    Left = 10
    Top = 178
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 6
    Width = 95
  end
  object cxLabel7: TcxLabel [14]
    Left = 125
    Top = 160
    Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1089
  end
  object edStartDate: TcxDateEdit [15]
    Left = 125
    Top = 178
    EditValue = 42370d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 15
    Width = 103
  end
  object cxLabel8: TcxLabel [16]
    Left = 244
    Top = 160
    Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1076#1086
  end
  object edEndDate: TcxDateEdit [17]
    Left = 244
    Top = 178
    EditValue = 42370d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 17
    Width = 103
  end
  object cxLabel9: TcxLabel [18]
    Left = 184
    Top = 60
    Caption = '% '#1082#1086#1088#1088#1077#1082#1090'. '#1085#1072#1094#1077#1085#1082#1080
  end
  object cePercent: TcxCurrencyEdit [19]
    Left = 184
    Top = 79
    Properties.DisplayFormat = ',0.##'
    TabOrder = 19
    Width = 163
  end
  object cxLabel10: TcxLabel [20]
    Left = 10
    Top = 203
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1087#1072#1094#1080#1077#1085#1090#1072'('#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090')'
  end
  object ceGroupMemberSP: TcxButtonEdit [21]
    Left = 10
    Top = 224
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 168
  end
  object cxLabel11: TcxLabel [22]
    Left = 184
    Top = 204
    Caption = '% '#1089#1082#1080#1076#1082#1080' ('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
  end
  object cePercentSP: TcxCurrencyEdit [23]
    Left = 182
    Top = 224
    Properties.DisplayFormat = ',0.##'
    TabOrder = 23
    Width = 165
  end
  object cxLabel12: TcxLabel [24]
    Left = 10
    Top = 254
    Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
  end
  object edBankAccount: TcxButtonEdit [25]
    Left = 8
    Top = 274
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 25
    Width = 168
  end
  object edBank: TcxTextEdit [26]
    Left = 182
    Top = 274
    Properties.ReadOnly = True
    TabOrder = 26
    Width = 165
  end
  object cxLabel13: TcxLabel [27]
    Left = 182
    Top = 253
    Caption = #1041#1072#1085#1082
  end
  object cxLabel14: TcxLabel [28]
    Left = 10
    Top = 306
    Caption = #1052#1080#1085'. '#1079#1072#1082#1072#1079', '#1075#1088#1085
  end
  object ceOrderSumm: TcxCurrencyEdit [29]
    Left = 10
    Top = 327
    Properties.DisplayFormat = ',0.##'
    TabOrder = 29
    Width = 110
  end
  object cxLabel15: TcxLabel [30]
    Left = 123
    Top = 306
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1084#1080#1085'. '#1089#1091#1084#1084#1077' '#1079#1072#1082#1072#1079#1072
  end
  object ceOrderSummComment: TcxTextEdit [31]
    Left = 123
    Top = 327
    TabOrder = 31
    Width = 224
  end
  object cxLabel16: TcxLabel [32]
    Left = 10
    Top = 354
    Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1086#1077' '#1074#1088#1077#1084#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' ('#1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086')'
  end
  object ceOrderTime: TcxTextEdit [33]
    Left = 10
    Top = 375
    TabOrder = 33
    Width = 337
  end
  object edSigningDate: TcxDateEdit [34]
    Left = 254
    Top = 32
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 34
    Width = 93
  end
  object cxLabel17: TcxLabel [35]
    Left = 254
    Top = 11
    Caption = #1044#1072#1090#1072' '#1087#1086#1076#1087#1080#1089#1072#1085#1080#1103
  end
  object cxLabel18: TcxLabel [36]
    Left = 10
    Top = 60
    Caption = #1057#1091#1084#1084#1072' '#1086#1089#1085'. '#1076#1086#1075'.'
  end
  object ceTotalSumm: TcxCurrencyEdit [37]
    Left = 10
    Top = 79
    Properties.DisplayFormat = ',0.##'
    TabOrder = 37
    Width = 166
  end
  object cxLabel19: TcxLabel [38]
    Left = 10
    Top = 403
    Caption = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1079#1072' '#1087#1088#1072#1081#1089
  end
  object edMember: TcxButtonEdit [39]
    Left = 10
    Top = 423
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 39
    Width = 337
  end
  object cbPartialPay: TcxCheckBox [40]
    Left = 240
    Top = 251
    Hint = #1054#1087#1083#1072#1090#1072' '#1095#1072#1089#1090#1103#1084#1080' '#1087#1088#1080#1093#1086#1076#1072
    Caption = #1054#1087#1083#1072#1090#1072' '#1095#1072#1089#1090#1103#1084#1080
    TabOrder = 40
    Width = 107
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 291
    Top = 118
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 307
    Top = 451
  end
  inherited ActionList: TActionList
    Left = 39
    Top = 173
  end
  inherited FormParams: TdsdFormParams
    Left = 163
    Top = 459
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Contract'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = edCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalBasisId'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGroupMemberSPId'
        Value = Null
        Component = GroupMemberSPGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountId'
        Value = Null
        Component = BankAccountGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = Null
        Component = GuidesMember
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDeferment'
        Value = 0.000000000000000000
        Component = ceDeferment
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercent'
        Value = Null
        Component = cePercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercentSP'
        Value = Null
        Component = cePercentSP
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTotalSumm'
        Value = Null
        Component = ceTotalSumm
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOrderSumm'
        Value = Null
        Component = ceOrderSumm
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOrderSummComment'
        Value = Null
        Component = ceOrderSummComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOrderTime'
        Value = Null
        Component = ceOrderTime
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSigningDate'
        Value = 'NULL'
        Component = edSigningDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = 42370d
        Component = edStartDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = edEndDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartialPay'
        Value = Null
        Component = cbPartialPay
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 298
    Top = 342
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Contract'
    Params = <
      item
        Name = 'Id'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisId'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisName'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupMemberSPid'
        Value = Null
        Component = GroupMemberSPGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupMemberSPName'
        Value = Null
        Component = GroupMemberSPGuides
        ComponentItem = 'TextValue'
        DataType = ftString
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
        Name = 'Deferment'
        Value = 0.000000000000000000
        Component = ceDeferment
        MultiSelectSeparator = ','
      end
      item
        Name = 'SigningDate'
        Value = 'NULL'
        Component = edSigningDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate'
        Value = 'NULL'
        Component = edStartDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 'NULL'
        Component = edEndDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Percent'
        Value = Null
        Component = cePercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentSP'
        Value = Null
        Component = cePercentSP
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        Component = ceTotalSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountId'
        Value = Null
        Component = BankAccountGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountName'
        Value = Null
        Component = BankAccountGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankName'
        Value = Null
        Component = edBank
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OrderSumm'
        Value = Null
        Component = ceOrderSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'OrderSummComment'
        Value = Null
        Component = ceOrderSummComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OrderTime'
        Value = Null
        Component = ceOrderTime
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId'
        Value = Null
        Component = GuidesMember
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = Null
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPartialPay'
        Value = Null
        Component = cbPartialPay
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 226
    Top = 222
  end
  object JuridicalBasisGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridicalBasis
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 121
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 210
    Top = 121
  end
  object GroupMemberSPGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGroupMemberSP
    FormNameParam.Value = 'TGroupMemberSPForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGroupMemberSPForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GroupMemberSPGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GroupMemberSPGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 217
  end
  object BankAccountGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBankAccount
    FormNameParam.Value = 'TBankAccountForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankAccountForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BankAccountGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BankAccountGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankName'
        Value = Null
        Component = edBank
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 251
  end
  object GuidesMember: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember
    FormNameParam.Value = 'TMemberForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 168
    Top = 408
  end
end
