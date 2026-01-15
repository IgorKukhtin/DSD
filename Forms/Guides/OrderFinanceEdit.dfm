object OrderFinanceEditForm: TOrderFinanceEditForm
  Left = 0
  Top = 0
  Caption = #1042#1080#1076' '#1055#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103' '#1087#1083#1072#1090#1077#1078#1077#1081
  ClientHeight = 431
  ClientWidth = 564
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 11
    Top = 76
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 11
    Top = 56
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 291
    Top = 391
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 427
    Top = 391
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 11
    Top = 6
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 11
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 142
  end
  object cxLabel7: TcxLabel
    Left = 309
    Top = 250
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edComment: TcxTextEdit
    Left = 309
    Top = 270
    TabOrder = 7
    Width = 247
  end
  object cxLabel10: TcxLabel
    Left = 181
    Top = 9
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
  end
  object edPaidKind: TcxButtonEdit
    Left = 180
    Top = 26
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 104
  end
  object cxLabel2: TcxLabel
    Left = 11
    Top = 105
    Caption = #1056'/'#1057#1095#1077#1090' ('#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072')'
  end
  object edBankAccount: TcxButtonEdit
    Left = 11
    Top = 125
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 11
    Top = 154
    Caption = #1041#1072#1085#1082' ('#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072')'
  end
  object edBank: TcxButtonEdit
    Left = 11
    Top = 174
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 11
    Top = 201
    Caption = #1060#1048#1054' - '#1085#1072' '#1082#1086#1085#1090#1088#1086#1083#1077'-1'
  end
  object ceMember_1: TcxButtonEdit
    Left = 11
    Top = 221
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 247
  end
  object cxLabel12: TcxLabel
    Left = 11
    Top = 250
    Caption = #1060#1048#1054' - '#1085#1072' '#1082#1086#1085#1090#1088#1086#1083#1077'-2'
  end
  object ceMember_2: TcxButtonEdit
    Left = 11
    Top = 270
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 247
  end
  object cxLabel5: TcxLabel
    Left = 309
    Top = 6
    Caption = #1040#1074#1090#1086#1088' '#1079#1072#1103#1074#1082#1080' - 1'
  end
  object edInsertUser: TcxButtonEdit
    Left = 309
    Top = 29
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 247
  end
  object cxLabel6: TcxLabel
    Left = 309
    Top = 56
    Caption = #1040#1074#1090#1086#1088' '#1079#1072#1103#1074#1082#1080' - 2'
  end
  object edInsertUser_2: TcxButtonEdit
    Left = 309
    Top = 76
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 247
  end
  object cxLabel8: TcxLabel
    Left = 309
    Top = 105
    Caption = #1040#1074#1090#1086#1088' '#1079#1072#1103#1074#1082#1080' - 3'
  end
  object edInsertUser_3: TcxButtonEdit
    Left = 309
    Top = 125
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 247
  end
  object cxLabel9: TcxLabel
    Left = 309
    Top = 152
    Caption = #1040#1074#1090#1086#1088' '#1079#1072#1103#1074#1082#1080' - 4'
  end
  object edInsertUser_4: TcxButtonEdit
    Left = 309
    Top = 174
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 25
    Width = 247
  end
  object cxLabel11: TcxLabel
    Left = 309
    Top = 201
    Caption = #1040#1074#1090#1086#1088' '#1079#1072#1103#1074#1082#1080' - 5'
  end
  object edInsertUser_5: TcxButtonEdit
    Left = 309
    Top = 221
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 27
    Width = 247
  end
  object cbisStatus_off: TcxCheckBox
    Left = 179
    Top = 299
    Caption = #1056#1072#1079#1088#1077#1096#1077#1085#1086' '#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1083#1072#1085#1072' '#1087#1086' '#1076#1085#1103#1084' - '#1074' '#1087#1088#1086#1074#1077#1076#1077#1085#1085#1086#1084' '#1076#1086#1082'. ('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 28
    Width = 377
  end
  object cbisOperDate: TcxCheckBox
    Left = 180
    Top = 323
    Caption = #1047#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1076#1072#1090#1072' '#1087#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1083#1072#1085' ('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 29
    Width = 281
  end
  object cbisPlan_1: TcxCheckBox
    Left = 11
    Top = 299
    Caption = #1055#1083#1072#1090#1080#1084' 1.'#1087#1085'.('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 30
    Width = 140
  end
  object cbisPlan_2: TcxCheckBox
    Left = 11
    Top = 323
    Caption = #1055#1083#1072#1090#1080#1084' 2.'#1074#1090'.('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 31
    Width = 140
  end
  object cbisPlan_3: TcxCheckBox
    Left = 11
    Top = 347
    Caption = #1055#1083#1072#1090#1080#1084' 3.'#1089#1088'.('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 32
    Width = 140
  end
  object cbisPlan_4: TcxCheckBox
    Left = 11
    Top = 371
    Caption = #1055#1083#1072#1090#1080#1084' 4.'#1095#1090'.('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 33
    Width = 140
  end
  object cbisPlan_5: TcxCheckBox
    Left = 11
    Top = 395
    Caption = #1055#1083#1072#1090#1080#1084' 5.'#1087#1090'.('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 34
    Width = 140
  end
  object cbSB: TcxCheckBox
    Left = 180
    Top = 348
    Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1057#1041' ('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 35
    Width = 169
  end
  object ActionList: TActionList
    Left = 192
    Top = 98
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdFormClose1: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = #1054#1082
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_OrderFinance'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
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
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = Null
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountId'
        Value = Null
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId_insert'
        Value = Null
        Component = GuidesInsert
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId_insert_2'
        Value = Null
        Component = GuidesInsert_2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId_insert_3'
        Value = Null
        Component = GuidesInsert_3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId_insert_4'
        Value = Null
        Component = GuidesInsert_4
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId_insert_5'
        Value = Null
        Component = GuidesInsert_5
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId_1'
        Value = Null
        Component = GuidesMember1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId_2'
        Value = Null
        Component = GuidesMember2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisStatus_off'
        Value = Null
        Component = cbisStatus_off
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOperDate'
        Value = Null
        Component = cbisOperDate
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPlan_1'
        Value = Null
        Component = cbisPlan_1
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPlan_2'
        Value = Null
        Component = cbisPlan_2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPlan_3'
        Value = Null
        Component = cbisPlan_3
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPlan_4'
        Value = Null
        Component = cbisPlan_4
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPlan_5'
        Value = Null
        Component = cbisPlan_5
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSB'
        Value = Null
        Component = cbSB
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 487
    Top = 218
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 344
    Top = 218
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_OrderFinance'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
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
        Name = 'PaidKindId'
        Value = Null
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = Null
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountId'
        Value = Null
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountName'
        Value = Null
        Component = GuidesBankAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankId'
        Value = Null
        Component = GuidesBank
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankName'
        Value = Null
        Component = GuidesBank
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId_insert'
        Value = Null
        Component = GuidesInsert
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName_insert'
        Value = Null
        Component = GuidesInsert
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId_insert_2'
        Value = Null
        Component = GuidesInsert_2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName_insert_2'
        Value = Null
        Component = GuidesInsert_2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId_insert_3'
        Value = Null
        Component = GuidesInsert_3
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName_insert_3'
        Value = Null
        Component = GuidesInsert_3
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId_insert_4'
        Value = Null
        Component = GuidesInsert_4
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName_insert_4'
        Value = Null
        Component = GuidesInsert_4
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId_insert_5'
        Value = Null
        Component = GuidesInsert_5
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName_insert_5'
        Value = Null
        Component = GuidesInsert_5
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId_1'
        Value = Null
        Component = GuidesMember1
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName_1'
        Value = Null
        Component = GuidesMember1
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId_2'
        Value = Null
        Component = GuidesMember2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName_2'
        Value = Null
        Component = GuidesMember2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isStatus_off'
        Value = Null
        Component = cbisStatus_off
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOperDate'
        Value = Null
        Component = cbisOperDate
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPlan_1'
        Value = Null
        Component = cbisPlan_1
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPlan_2'
        Value = Null
        Component = cbisPlan_2
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPlan_3'
        Value = Null
        Component = cbisPlan_3
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPlan_4'
        Value = Null
        Component = cbisPlan_4
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPlan_5'
        Value = Null
        Component = cbisPlan_5
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSB'
        Value = Null
        Component = cbSB
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 399
    Top = 218
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 144
    Top = 66
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 232
    Top = 138
  end
  object GuidesPaidKind: TdsdGuides
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
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 16
  end
  object GuidesBankAccount: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBankAccount
    FormNameParam.Value = 'TBankAccount_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankAccount_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankId'
        Value = Null
        Component = GuidesBank
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankName'
        Value = Null
        Component = GuidesBank
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 32
    Top = 100
  end
  object GuidesBank: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBank
    FormNameParam.Value = 'TBankForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBank
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBank
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 64
    Top = 173
  end
  object GuidesMember1: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMember_1
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMember1
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMember1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        ComponentItem = 'Code'
        MultiSelectSeparator = ','
      end>
    Left = 445
    Top = 72
  end
  object GuidesMember2: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMember_2
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMember2
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMember2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        ComponentItem = 'Code'
        MultiSelectSeparator = ','
      end>
    Left = 445
    Top = 160
  end
  object GuidesInsert: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInsertUser
    Key = '0'
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesInsert
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInsert
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 8466
        MultiSelectSeparator = ','
      end>
    Left = 443
    Top = 11
  end
  object GuidesInsert_2: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInsertUser_2
    Key = '0'
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesInsert_2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInsert_2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 8466
        MultiSelectSeparator = ','
      end>
    Left = 435
    Top = 52
  end
  object GuidesInsert_3: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInsertUser_3
    Key = '0'
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesInsert_3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInsert_3
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 8466
        MultiSelectSeparator = ','
      end>
    Left = 427
    Top = 93
  end
  object GuidesInsert_4: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInsertUser_4
    Key = '0'
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesInsert_4
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInsert_4
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 8466
        MultiSelectSeparator = ','
      end>
    Left = 427
    Top = 142
  end
  object GuidesInsert_5: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInsertUser_5
    Key = '0'
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesInsert_5
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInsert_5
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 8466
        MultiSelectSeparator = ','
      end>
    Left = 427
    Top = 189
  end
end
