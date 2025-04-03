object PersonalServiceListEditForm: TPersonalServiceListEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'>'
  ClientHeight = 443
  ClientWidth = 623
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
    Left = 10
    Top = 72
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 10
    Top = 52
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 341
    Top = 407
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 484
    Top = 407
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object cxLabel2: TcxLabel
    Left = 10
    Top = 8
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 10
    Top = 30
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 63
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 98
    Caption = #1070#1088'.'#1083#1080#1094#1086
  end
  object ceJuridical: TcxButtonEdit
    Left = 10
    Top = 118
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 497
    Top = 99
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
  end
  object cePaidKind: TcxButtonEdit
    Left = 497
    Top = 118
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 90
  end
  object cxLabel5: TcxLabel
    Left = 314
    Top = 58
    Caption = #1060#1080#1083#1080#1072#1083
  end
  object ceBranch: TcxButtonEdit
    Left = 314
    Top = 76
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 11
    Width = 177
  end
  object cxLabel16: TcxLabel
    Left = 314
    Top = 99
    Caption = #1041#1072#1085#1082
  end
  object edBankId: TcxButtonEdit
    Left = 314
    Top = 118
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 177
  end
  object ceisSecond: TcxCheckBox
    Left = 85
    Top = 30
    Caption = #1042#1090#1086#1088#1072#1103' '#1092#1086#1088#1084#1072
    TabOrder = 14
    Width = 95
  end
  object cxLabel6: TcxLabel
    Left = 10
    Top = 148
    Caption = #1060#1080#1079'.'#1083#1080#1094#1086' ('#1080#1089#1087'. '#1076#1080#1088#1077#1082#1090#1086#1088')'
  end
  object edMemberHeadManager: TcxButtonEdit
    Left = 10
    Top = 166
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 16
    Width = 273
  end
  object cxLabel7: TcxLabel
    Left = 10
    Top = 193
    Caption = #1060#1080#1079'.'#1083#1080#1094#1086' ('#1076#1080#1088#1077#1082#1090#1086#1088')'
  end
  object edMemberManager: TcxButtonEdit
    Left = 10
    Top = 211
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 18
    Width = 273
  end
  object cxLabel8: TcxLabel
    Left = 314
    Top = 148
    Caption = #1060#1080#1079'.'#1083#1080#1094#1086' ('#1073#1091#1093#1075#1072#1083#1090#1077#1088')'
  end
  object edMemberBookkeeper: TcxButtonEdit
    Left = 314
    Top = 166
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 20
    Width = 273
  end
  object cxLabel33: TcxLabel
    Left = 10
    Top = 242
    Hint = #1050#1086#1101#1092#1092'. '#1076#1083#1103' '#1084#1086#1076#1077#1083#1080' '#1088#1072#1073#1086#1095#1077#1077' '#1074#1088#1077#1084#1103' '#1080#1079' '#1087#1091#1090'. '#1083#1080#1089#1090#1072
    Caption = #1052#1077#1089#1103#1094' '#1085#1072#1095'-'#1080#1103' '#1082#1086#1084#1087#1077#1085#1089'.'
  end
  object edCompensation: TcxCurrencyEdit
    Left = 10
    Top = 259
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0.'
    TabOrder = 22
    Width = 138
  end
  object cbRecalc: TcxCheckBox
    Left = 154
    Top = 262
    Hint = #1044#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103' '#1074' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1092#1072#1082#1090
    Caption = #1056#1072#1089#1087#1088#1077#1076'. '#1074' '#1074#1077#1076'. '#1092#1072#1082#1090
    ParentShowHint = False
    ShowHint = True
    TabOrder = 23
    Width = 134
  end
  object edisBankOut: TcxCheckBox
    Left = 308
    Top = 12
    Caption = #1076#1083#1103' '#1059#1074#1086#1083#1077#1085#1085#1099#1093' ('#1073#1072#1085#1082')'
    TabOrder = 24
    Width = 138
  end
  object cxLabel12: TcxLabel
    Left = 10
    Top = 286
    Caption = #1056'/'#1057#1095#1077#1090
  end
  object edBankAccount: TcxButtonEdit
    Left = 10
    Top = 303
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 26
    Width = 177
  end
  object cxLabel9: TcxLabel
    Left = 193
    Top = 284
    Hint = #1058#1080#1087' '#1074#1099#1075#1088#1091#1079#1082#1080' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1074' '#1073#1072#1085#1082
    Caption = #1058#1080#1087' '#1074#1099#1075#1088'. '#1074' '#1073#1072#1085#1082
  end
  object edPSLExportKind: TcxButtonEdit
    Left = 193
    Top = 303
    Hint = #1058#1080#1087' '#1074#1099#1075#1088#1091#1079#1082#1080' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1074' '#1073#1072#1085#1082
    ParentShowHint = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    ShowHint = True
    TabOrder = 28
    Width = 90
  end
  object edContentType: TcxTextEdit
    Left = 10
    Top = 353
    TabOrder = 29
    Width = 133
  end
  object cxLabel10: TcxLabel
    Left = 10
    Top = 334
    Caption = 'Content-Type'
  end
  object edOnFlowType: TcxTextEdit
    Left = 150
    Top = 353
    TabOrder = 31
    Width = 133
  end
  object cxLabel11: TcxLabel
    Left = 150
    Top = 334
    Caption = #1042#1080#1076' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1074' '#1073#1072#1085#1082#1077
  end
  object cbDetail: TcxCheckBox
    Left = 194
    Top = 30
    Hint = #1044#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103' '#1076#1072#1085#1085#1099#1093
    Caption = #1044#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103
    ParentShowHint = False
    ShowHint = True
    TabOrder = 33
    Width = 94
  end
  object edKoeffSummCardSecond: TcxCurrencyEdit
    Left = 497
    Top = 76
    Hint = #1050#1086#1101#1092#1092' '#1076#1083#1103' '#1074#1099#1075#1088#1091#1079#1082#1080' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1041#1072#1085#1082' 2'#1092'.'
    EditValue = 0.000000000000000000
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 16
    Properties.DisplayFormat = ',0.########'
    ShowHint = True
    TabOrder = 34
    Width = 90
  end
  object cxLabel13: TcxLabel
    Left = 497
    Top = 58
    Hint = #1050#1086#1101#1092#1092' '#1076#1083#1103' '#1074#1099#1075#1088#1091#1079#1082#1080' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1041#1072#1085#1082' 2'#1092'.'
    Caption = #1050#1086#1101#1092#1092'. '#1074#1099#1075#1088'. 2'#1092'.'
    ParentShowHint = False
    ShowHint = True
  end
  object cxLabel14: TcxLabel
    Left = 314
    Top = 194
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1056#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1100' '#1087#1086#1076#1088'.)'
  end
  object cePersonalHead: TcxButtonEdit
    Left = 314
    Top = 211
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 37
    Width = 273
  end
  object cxLabel15: TcxLabel
    Left = 314
    Top = 242
    Caption = #1057#1091#1084#1084#1072' '#1072#1074#1072#1085#1089' ('#1072#1074#1090#1086')'
  end
  object edSummAvance: TcxCurrencyEdit
    Left = 314
    Top = 259
    EditValue = '0'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 39
    Width = 132
  end
  object cxLabel17: TcxLabel
    Left = 314
    Top = 286
    Caption = #1050#1086#1083'. '#1095#1072#1089#1086#1074' '#1076#1083#1103' '#1072#1074#1072#1085#1089#1072
  end
  object edSummAvanceMax: TcxCurrencyEdit
    Left = 457
    Top = 259
    EditValue = '0'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 41
    Width = 130
  end
  object edHourAvance: TcxCurrencyEdit
    Left = 314
    Top = 303
    EditValue = '0'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 42
    Width = 132
  end
  object cxLabel18: TcxLabel
    Left = 457
    Top = 242
    Caption = #1052#1072#1082#1089' '#1057#1091#1084#1084#1072' '#1072#1074#1072#1085#1089' ('#1074#1074#1086#1076')'
  end
  object cbAvanceNot: TcxCheckBox
    Left = 452
    Top = 303
    Hint = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1080#1079' '#1089#1087#1080#1089#1082#1072' '#1085#1072' '#1072#1074#1072#1085#1089
    Caption = #1048#1089#1082#1083'. '#1080#1079' '#1089#1087'. '#1085#1072' '#1072#1074#1072#1085#1089
    ParentShowHint = False
    ShowHint = True
    TabOrder = 44
    Width = 134
  end
  object cxLabel19: TcxLabel
    Left = 314
    Top = 334
    Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'('#1072#1074#1072#1085#1089' '#1050#1072#1088#1090#1072' '#1060'2)'
  end
  object edPersonalServiceList_AvanceF2: TcxButtonEdit
    Left = 314
    Top = 353
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 46
    Width = 274
  end
  object cbCompensationNot: TcxCheckBox
    Left = 458
    Top = 10
    Hint = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1080#1079' '#1088#1072#1089#1095#1077#1090#1072' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080' '#1076#1083#1103' '#1086#1090#1087#1091#1089#1082#1072
    Caption = #1048#1089#1082#1083'. '#1080#1079' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080
    ParentShowHint = False
    ShowHint = True
    TabOrder = 47
    Width = 135
  end
  object cbBankNot: TcxCheckBox
    Left = 458
    Top = 37
    Hint = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1080#1079' '#1088#1072#1089#1095#1077#1090#1072' '#1042#1099#1087#1083#1072#1090#1072' '#1073#1072#1085#1082' 2'#1092
    Caption = #1048#1089#1082#1083'. '#1080#1079' '#1074#1099#1087#1083#1072#1090#1099' '#1073#1072#1085#1082' 2'#1092
    ParentShowHint = False
    ShowHint = True
    TabOrder = 48
    Width = 161
  end
  object cbisNotAuto: TcxCheckBox
    Left = 308
    Top = 37
    Hint = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1080#1079' '#1088#1072#1089#1095#1077#1090#1072' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080' '#1076#1083#1103' '#1086#1090#1087#1091#1089#1082#1072
    Caption = #1048#1089#1082#1083'.'#1080#1079' '#1072#1074#1090#1086'.'#1085#1072#1095#1080#1089#1083'.'#1047#1055
    ParentShowHint = False
    ShowHint = True
    TabOrder = 49
    Width = 147
  end
  object cbisNotRound: TcxCheckBox
    Left = 8
    Top = 389
    Hint = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1080#1079' '#1088#1072#1089#1095#1077#1090#1072' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080' '#1076#1083#1103' '#1086#1090#1087#1091#1089#1082#1072
    Caption = #1048#1089#1082#1083'. '#1080#1079' '#1086#1082#1088#1091#1075#1083'. '#1087#1086' '#1082#1072#1089#1089#1077
    ParentShowHint = False
    ShowHint = True
    TabOrder = 50
    Width = 170
  end
  object ActionList: TActionList
    Left = 88
    Top = 48
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
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_PersonalServiceList'
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
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
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
      end
      item
        Name = 'inBranchId'
        Value = Null
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankId'
        Value = Null
        Component = BankGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberHeadManagerId'
        Value = Null
        Component = GuidesMemberHeadManager
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberManagerId'
        Value = Null
        Component = GuidesMemberManager
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberBookkeeperId'
        Value = Null
        Component = GuidesMemberBookkeeper
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalHeadId'
        Value = Null
        Component = GuidesPersonalHead
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
        Name = 'inPSLExportKindId'
        Value = Null
        Component = GuidesPSLExportKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalServiceListId_AvanceF2'
        Value = Null
        Component = GuidesPersonalServiceList_AvanceF2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCompensation'
        Value = Null
        Component = edCompensation
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummAvance'
        Value = Null
        Component = edSummAvance
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummAvanceMax'
        Value = Null
        Component = edSummAvanceMax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHourAvance'
        Value = Null
        Component = edHourAvance
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffSummCardSecond'
        Value = 0
        Component = edKoeffSummCardSecond
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSecond'
        Value = Null
        Component = ceisSecond
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisRecalc'
        Value = Null
        Component = cbRecalc
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisBankOut'
        Value = Null
        Component = edisBankOut
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDetail'
        Value = Null
        Component = cbDetail
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAvanceNot'
        Value = Null
        Component = cbAvanceNot
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisBankNot'
        Value = Null
        Component = cbBankNot
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCompensationNot'
        Value = Null
        Component = cbCompensationNot
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotAuto'
        Value = Null
        Component = cbisNotAuto
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotRound'
        Value = Null
        Component = cbisNotRound
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContentType'
        Value = Null
        Component = edContentType
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOnFlowType'
        Value = Null
        Component = edOnFlowType
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 192
    Top = 56
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 64
    Top = 96
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_PersonalServiceList'
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
        Name = 'BranchId'
        Value = Null
        Component = BranchGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchName'
        Value = Null
        Component = BranchGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankId'
        Value = Null
        Component = BankGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankName'
        Value = Null
        Component = BankGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSecond'
        Value = Null
        Component = ceisSecond
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRecalc'
        Value = Null
        Component = cbRecalc
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isBankOut'
        Value = Null
        Component = edisBankOut
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberBookkeeperId'
        Value = Null
        Component = GuidesMemberBookkeeper
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberBookkeeperName'
        Value = Null
        Component = GuidesMemberBookkeeper
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberHeadManagerId'
        Value = Null
        Component = GuidesMemberHeadManager
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberHeadManagerName'
        Value = Null
        Component = GuidesMemberHeadManager
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberManagerId'
        Value = Null
        Component = GuidesMemberManager
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberManagerName'
        Value = Null
        Component = GuidesMemberManager
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Compensation'
        Value = Null
        Component = edCompensation
        DataType = ftFloat
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
        Name = 'PSLExportKindId'
        Value = Null
        Component = GuidesPSLExportKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PSLExportKindName'
        Value = Null
        Component = GuidesPSLExportKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContentType'
        Value = Null
        Component = edContentType
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OnFlowType'
        Value = Null
        Component = edOnFlowType
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDetail'
        Value = Null
        Component = cbDetail
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'KoeffSummCardSecond'
        Value = Null
        Component = edKoeffSummCardSecond
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalHeadId'
        Value = Null
        Component = GuidesPersonalHead
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalHeadName'
        Value = Null
        Component = GuidesPersonalHead
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'HourAvance'
        Value = Null
        Component = edHourAvance
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummAvance'
        Value = Null
        Component = edSummAvance
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummAvanceMax'
        Value = Null
        Component = edSummAvanceMax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAvanceNot'
        Value = Null
        Component = cbAvanceNot
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceListId_AvanceF2'
        Value = Null
        Component = GuidesPersonalServiceList_AvanceF2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceListName_AvanceF2'
        Value = Null
        Component = GuidesPersonalServiceList_AvanceF2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCompensationNot'
        Value = Null
        Component = cbCompensationNot
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isBankNot'
        Value = Null
        Component = cbBankNot
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNotAuto'
        Value = Null
        Component = cbisNotAuto
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNotRound'
        Value = Null
        Component = cbisNotRound
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 88
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
    Top = 80
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 40
    Top = 56
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        DataType = ftString
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
    Left = 136
    Top = 120
  end
  object PaidKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePaidKind
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 517
    Top = 99
  end
  object BranchGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBranch
    FormNameParam.Value = 'TBranchForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBranchForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 424
    Top = 101
  end
  object BankGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBankId
    FormNameParam.Value = 'TBankForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BankGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BankGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 373
    Top = 96
  end
  object GuidesMemberHeadManager: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMemberHeadManager
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMemberHeadManager
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMemberHeadManager
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 181
    Top = 158
  end
  object GuidesMemberManager: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMemberManager
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMemberManager
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMemberManager
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 204
    Top = 203
  end
  object GuidesMemberBookkeeper: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMemberBookkeeper
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMemberBookkeeper
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMemberBookkeeper
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 397
    Top = 156
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
      end>
    Left = 66
    Top = 307
  end
  object GuidesPSLExportKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPSLExportKind
    FormNameParam.Value = 'TPSLExportKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPSLExportKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPSLExportKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPSLExportKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 219
    Top = 292
  end
  object GuidesPersonalHead: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonalHead
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalHead
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalHead
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 487
    Top = 195
  end
  object GuidesPersonalServiceList_AvanceF2: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalServiceList_AvanceF2
    FormNameParam.Value = 'TPersonalServiceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalServiceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalServiceList_AvanceF2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalServiceList_AvanceF2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 424
    Top = 333
  end
end
