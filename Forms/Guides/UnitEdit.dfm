object UnitEditForm: TUnitEditForm
  Left = 0
  Top = 0
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
  ClientHeight = 606
  ClientWidth = 507
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = DataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 280
    Top = 21
    TabOrder = 0
    Width = 209
  end
  object cxLabel1: TcxLabel
    Left = 280
    Top = 3
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 112
    Top = 576
    Width = 75
    Height = 25
    Action = InsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 306
    Top = 576
    Width = 75
    Height = 25
    Action = FormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 40
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 40
    Top = 21
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 209
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 46
    Caption = #1043#1088#1091#1087#1087#1072
  end
  object cxLabel4: TcxLabel
    Left = 280
    Top = 46
    Caption = #1060#1080#1083#1080#1072#1083
  end
  object ceParent: TcxButtonEdit
    Left = 40
    Top = 64
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 8
    Width = 209
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 89
    Caption = #1041#1080#1079#1085#1077#1089
  end
  object ceBranch: TcxButtonEdit
    Left = 280
    Top = 64
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 10
    Width = 209
  end
  object ceBusiness: TcxButtonEdit
    Left = 41
    Top = 105
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 11
    Width = 209
  end
  object cxLabel5: TcxLabel
    Left = 280
    Top = 89
    Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object ceJuridical: TcxButtonEdit
    Left = 280
    Top = 107
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 13
    Width = 209
  end
  object cxLabel6: TcxLabel
    Left = 40
    Top = 132
    Caption = #1057#1095#1077#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
  end
  object ceAccountDirection: TcxButtonEdit
    Left = 40
    Top = 150
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 15
    Width = 209
  end
  object cxLabel7: TcxLabel
    Left = 280
    Top = 132
    Caption = #1054#1055#1080#1059' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
  end
  object ceProfitLossDirection: TcxButtonEdit
    Left = 280
    Top = 150
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 17
    Width = 209
  end
  object cbPartionDate: TcxCheckBox
    Left = 40
    Top = 177
    Caption = #1055#1072#1088#1090#1080#1080' '#1076#1072#1090#1099' '#1074' '#1091#1095#1077#1090#1077
    TabOrder = 18
    Width = 157
  end
  object cxLabel8: TcxLabel
    Left = 40
    Top = 218
    Caption = #1044#1086#1075#1086#1074#1086#1088' ('#1087#1077#1088#1077#1074#1099#1089#1090#1072#1074#1083#1077#1085#1080#1077' '#1079#1072#1090#1088#1072#1090')'
  end
  object ceContract: TcxButtonEdit
    Left = 40
    Top = 236
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 20
    Width = 209
  end
  object ceContract_Juridical: TcxButtonEdit
    Left = 280
    Top = 236
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 209
  end
  object cxLabel9: TcxLabel
    Left = 280
    Top = 218
    Caption = #1070#1088'.'#1083#1080#1094#1086' ('#1076#1086#1075#1086#1074#1086#1088')'
  end
  object cxLabel10: TcxLabel
    Left = 40
    Top = 261
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103' ('#1076#1086#1075#1086#1074#1086#1088')'
  end
  object ceContract_Infomoney: TcxButtonEdit
    Left = 40
    Top = 279
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 24
    Width = 209
  end
  object cxLabel11: TcxLabel
    Left = 40
    Top = 304
    Caption = #1052#1072#1088#1096#1088#1091#1090
  end
  object cxLabel12: TcxLabel
    Left = 280
    Top = 304
    Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1084#1072#1088#1096#1088#1091#1090#1072
  end
  object ceRoute: TcxButtonEdit
    Left = 40
    Top = 322
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 27
    Width = 209
  end
  object ceRouteSorting: TcxButtonEdit
    Left = 280
    Top = 322
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 28
    Width = 209
  end
  object cxLabel13: TcxLabel
    Left = 280
    Top = 175
    Caption = #1056#1077#1075#1080#1086#1085
  end
  object ceArea: TcxButtonEdit
    Left = 280
    Top = 193
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 30
    Width = 209
  end
  object cxLabel14: TcxLabel
    Left = 280
    Top = 261
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1056#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1100' '#1087#1086#1076#1088'.)'
  end
  object cePersonalHead: TcxButtonEdit
    Left = 280
    Top = 279
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 32
    Width = 209
  end
  object cxLabel15: TcxLabel
    Left = -200
    Top = 726
    Caption = #1052#1072#1088#1096#1088#1091#1090
  end
  object cxLabel16: TcxLabel
    Left = 40
    Top = 347
    Caption = #1040#1076#1088#1077#1089
  end
  object edAddress: TcxTextEdit
    Left = 40
    Top = 365
    TabOrder = 35
    Width = 209
  end
  object cxLabel17: TcxLabel
    Left = 40
    Top = 476
    Caption = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099' ('#1064#1072#1073#1083#1086#1085' '#1090#1072#1073#1077#1083#1103' '#1088'.'#1074#1088'.)'
  end
  object ceSheetWorkTime: TcxButtonEdit
    Left = 40
    Top = 494
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 37
    Width = 209
  end
  object cbPartionGoodsKind: TcxCheckBox
    Left = 40
    Top = 197
    Caption = #1055#1072#1088#1090#1080#1080' '#1087#1086' '#1074#1080#1076#1091' '#1091#1087#1072#1082'. '#1076#1083#1103' '#1089#1099#1088#1100#1103
    TabOrder = 38
    Width = 209
  end
  object cxLabel18: TcxLabel
    Left = 41
    Top = 521
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edComment: TcxTextEdit
    Left = 40
    Top = 539
    TabOrder = 40
    Width = 210
  end
  object cbCountCount: TcxCheckBox
    Left = 272
    Top = 433
    Caption = #1059#1095#1077#1090' '#1073#1072#1090#1086#1085#1086#1074
    TabOrder = 41
    Width = 93
  end
  object cbPartionGP: TcxCheckBox
    Left = 272
    Top = 453
    Caption = #1055#1072#1088#1090#1080#1080' '#1076#1083#1103' '#1043#1055' '#1080' '#1058#1091#1096#1077#1085#1082#1080
    TabOrder = 42
    Width = 162
  end
  object cbAvance: TcxCheckBox
    Left = 371
    Top = 433
    Caption = #1053#1072#1095'. '#1072#1074#1072#1085#1089#1072' '#1072#1074#1090#1086#1084#1072#1090'.'
    TabOrder = 43
    Width = 133
  end
  object edGLN: TcxTextEdit
    Left = 280
    Top = 365
    TabOrder = 44
    Width = 100
  end
  object cxLabel19: TcxLabel
    Left = 280
    Top = 347
    Caption = 'GLN'
  end
  object edKATOTTG: TcxTextEdit
    Left = 389
    Top = 365
    TabOrder = 46
    Width = 100
  end
  object cxLabel20: TcxLabel
    Left = 389
    Top = 347
    Caption = #1050#1040#1058#1054#1058#1058#1043
  end
  object cxLabel21: TcxLabel
    Left = 40
    Top = 390
    Caption = #1043#1086#1088#1086#1076
  end
  object edCity: TcxButtonEdit
    Left = 40
    Top = 408
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 49
    Width = 209
  end
  object cxLabel23: TcxLabel
    Left = 40
    Top = 433
    Caption = #1040#1076#1088#1077#1089' '#1076#1083#1103' EDIN'
  end
  object edAddressEDIN: TcxTextEdit
    Left = 40
    Top = 451
    TabOrder = 51
    Width = 209
  end
  object ceFounder: TcxButtonEdit
    Left = 280
    Top = 408
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 52
    Width = 209
  end
  object cxLabel22: TcxLabel
    Left = 280
    Top = 390
    Caption = #1059#1095#1088#1077#1076#1080#1090#1077#1083#1100
  end
  object cxLabel24: TcxLabel
    Left = 280
    Top = 476
    Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090' 1 '#1088#1110#1074#1085#1103
  end
  object deDepartment: TcxButtonEdit
    Left = 280
    Top = 494
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 55
    Width = 209
  end
  object cxLabel25: TcxLabel
    Left = 280
    Top = 521
    Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090' 2 '#1088#1110#1074#1085#1103
  end
  object deDepartment_two: TcxButtonEdit
    Left = 280
    Top = 539
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 57
    Width = 209
  end
  object ActionList: TActionList
    Top = 16
    object DataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object InsertUpdateGuides: TdsdInsertUpdateGuides
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
    object FormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Unit'
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
        Component = ceCode
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
        Name = 'inisPartionDate'
        Value = False
        Component = cbPartionDate
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartionGoodsKind'
        Value = Null
        Component = cbPartionGoodsKind
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCountCount'
        Value = Null
        Component = cbCountCount
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartionGP'
        Value = Null
        Component = cbPartionGP
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAvance'
        Value = Null
        Component = cbAvance
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'ParentId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBusinessId'
        Value = ''
        Component = BusinessGuides
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
        Name = 'inContractId'
        Value = Null
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccountDirectionId'
        Value = ''
        Component = AccountDirectionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProfitLossDirectionId'
        Value = ''
        Component = ProfitLossDirectionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteID'
        Value = Null
        Component = RouteGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteSortingId'
        Value = Null
        Component = RouteSortingGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAreaId'
        Value = Null
        Component = AreaGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCityId'
        Value = Null
        Component = GuidesCity
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
        Name = 'inFounderId'
        Value = Null
        Component = FounderGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDepartmentId'
        Value = Null
        Component = GuidesDepartment
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDepartment_twoId'
        Value = Null
        Component = GuidesDepartment_two
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSheetWorkTimeId'
        Value = Null
        Component = SheetWorkTimeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAddress'
        Value = Null
        Component = edAddress
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAddressEDIN'
        Value = Null
        Component = edAddressEDIN
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
        Name = 'inGLN'
        Value = Null
        Component = edGLN
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKATOTTG'
        Value = Null
        Component = edKATOTTG
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 136
    Top = 16
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 24
    Top = 112
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Unit'
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
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParentId'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParentName'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchName'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BusinessId'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BusinessName'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'TextValue'
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
        Name = 'ContractId'
        Value = Null
        Component = ContractGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = Null
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Contract_JuridicalName'
        Value = Null
        Component = Contract_JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountDirectionId'
        Value = ''
        Component = AccountDirectionGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountDirectionName'
        Value = ''
        Component = AccountDirectionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossDirectionId'
        Value = ''
        Component = ProfitLossDirectionGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossDirectionName'
        Value = ''
        Component = ProfitLossDirectionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Contract_InfomoneyName'
        Value = Null
        Component = Contract_InfomoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteId'
        Value = Null
        Component = RouteGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteName'
        Value = Null
        Component = RouteGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteSortingId'
        Value = Null
        Component = RouteSortingGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteSortingName'
        Value = Null
        Component = RouteSortingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AreaId'
        Value = Null
        Component = AreaGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AreaName'
        Value = Null
        Component = AreaGuides
        ComponentItem = 'TextValue'
        DataType = ftString
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
        Name = 'isPartionDate'
        Value = Null
        Component = cbPartionDate
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPartionGoodsKind'
        Value = Null
        Component = cbPartionGoodsKind
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Address'
        Value = Null
        Component = edAddress
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SheetWorkTimeId'
        Value = Null
        Component = SheetWorkTimeGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'SheetWorkTimeName'
        Value = Null
        Component = SheetWorkTimeGuides
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
        Name = 'isCountCount'
        Value = Null
        Component = cbCountCount
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPartionGP'
        Value = Null
        Component = cbPartionGP
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAvance'
        Value = Null
        Component = cbAvance
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'GLN'
        Value = Null
        Component = edGLN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'KATOTTG'
        Value = Null
        Component = edKATOTTG
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CityId'
        Value = Null
        Component = GuidesCity
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CityName_full'
        Value = Null
        Component = GuidesCity
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AddressEDIN'
        Value = Null
        Component = edAddressEDIN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FounderId'
        Value = Null
        Component = FounderGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FounderName'
        Value = Null
        Component = FounderGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DepartmentId'
        Value = Null
        Component = GuidesDepartment
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DepartmentName'
        Value = Null
        Component = GuidesDepartment
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Department_twoId'
        Value = Null
        Component = GuidesDepartment_two
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Department_twoName'
        Value = Null
        Component = GuidesDepartment_two
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 192
  end
  object ParentGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParent
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 64
  end
  object BranchGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBranch
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 384
    Top = 64
  end
  object BusinessGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBusiness
    FormNameParam.Value = 'TBusiness_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBusiness_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 120
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
    Left = 384
    Top = 112
  end
  object AccountDirectionGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceAccountDirection
    FormNameParam.Value = 'TAccountDirection_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAccountDirection_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = AccountDirectionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = AccountDirectionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 144
  end
  object ProfitLossDirectionGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceProfitLossDirection
    FormNameParam.Value = 'TProfitLossDirection_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProfitLossDirection_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ProfitLossDirectionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ProfitLossDirectionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 384
    Top = 168
  end
  object ContractGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceContract
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = Null
        Component = Contract_JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = Contract_JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = Null
        Component = Contract_InfomoneyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName_all'
        Value = Null
        Component = Contract_InfomoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 184
    Top = 240
  end
  object Contract_JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceContract_Juridical
    DisableGuidesOpen = True
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    ParentDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Contract_JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Contract_JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 432
    Top = 240
  end
  object Contract_InfomoneyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceContract_Infomoney
    DisableGuidesOpen = True
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Contract_InfomoneyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Contract_InfomoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 144
    Top = 296
  end
  object RouteGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRoute
    FormNameParam.Value = 'TRouteForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRouteForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = RouteGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RouteGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 340
  end
  object RouteSortingGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRouteSorting
    FormNameParam.Value = 'TRouteSortingForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRouteSortingForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = RouteSortingGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RouteSortingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 400
    Top = 349
  end
  object AreaGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceArea
    FormNameParam.Value = 'TAreaForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAreaForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = AreaGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = AreaGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 336
    Top = 216
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
    Left = 367
    Top = 295
  end
  object SheetWorkTimeGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceSheetWorkTime
    FormNameParam.Value = 'TSheetWorkTime_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSheetWorkTime_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = SheetWorkTimeGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = SheetWorkTimeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 127
    Top = 486
  end
  object GuidesCity: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCity
    FormNameParam.Value = 'TCityForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCityForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCity
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name_full'
        Value = ''
        Component = GuidesCity
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 179
    Top = 432
  end
  object FounderGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceFounder
    FormNameParam.Value = 'TFounderForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TFounderForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FounderGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FounderGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 402
    Top = 438
  end
  object GuidesDepartment: TdsdGuides
    KeyField = 'Id'
    LookupControl = deDepartment
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesDepartment
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesDepartment
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 488
  end
  object GuidesDepartment_two: TdsdGuides
    KeyField = 'Id'
    LookupControl = deDepartment_two
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesDepartment_two
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesDepartment_two
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 533
  end
end
