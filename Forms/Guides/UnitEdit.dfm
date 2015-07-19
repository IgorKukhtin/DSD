object UnitEditForm: TUnitEditForm
  Left = 0
  Top = 0
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
  ClientHeight = 444
  ClientWidth = 497
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
    Top = 25
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
    Top = 408
    Width = 75
    Height = 25
    Action = InsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 306
    Top = 408
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
    Top = 25
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 209
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 50
    Caption = #1043#1088#1091#1087#1087#1072
  end
  object cxLabel4: TcxLabel
    Left = 280
    Top = 50
    Caption = #1060#1080#1083#1080#1072#1083
  end
  object ceParent: TcxButtonEdit
    Left = 40
    Top = 71
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
    Top = 100
    Caption = #1041#1080#1079#1085#1077#1089
  end
  object ceBranch: TcxButtonEdit
    Left = 280
    Top = 71
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 10
    Width = 209
  end
  object ceBusiness: TcxButtonEdit
    Left = 40
    Top = 121
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
    Top = 100
    Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object ceJuridical: TcxButtonEdit
    Left = 280
    Top = 121
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
    Top = 150
    Caption = #1057#1095#1077#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
  end
  object ceAccountDirection: TcxButtonEdit
    Left = 40
    Top = 171
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
    Top = 150
    Caption = #1054#1055#1080#1059' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
  end
  object ceProfitLossDirection: TcxButtonEdit
    Left = 280
    Top = 171
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
    Top = 208
    Caption = #1055#1072#1088#1090#1080#1080' '#1076#1072#1090#1099' '#1074' '#1091#1095#1077#1090#1077
    TabOrder = 18
    Width = 157
  end
  object cxLabel8: TcxLabel
    Left = 40
    Top = 241
    Caption = #1044#1086#1075#1086#1074#1086#1088' ('#1087#1077#1088#1077#1074#1099#1089#1090#1072#1074#1083#1077#1085#1080#1077' '#1079#1072#1090#1088#1072#1090')'
  end
  object ceContract: TcxButtonEdit
    Left = 40
    Top = 262
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
    Top = 262
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
    Top = 241
    Caption = #1070#1088'.'#1083#1080#1094#1086' ('#1076#1086#1075#1086#1074#1086#1088')'
  end
  object cxLabel10: TcxLabel
    Left = 40
    Top = 291
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103' ('#1076#1086#1075#1086#1074#1086#1088')'
  end
  object ceContract_Infomoney: TcxButtonEdit
    Left = 40
    Top = 312
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 24
    Width = 449
  end
  object cxLabel11: TcxLabel
    Left = 40
    Top = 341
    Caption = #1052#1072#1088#1096#1088#1091#1090
  end
  object cxLabel12: TcxLabel
    Left = 280
    Top = 341
    Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1084#1072#1088#1096#1088#1091#1090#1072
  end
  object ceRoute: TcxButtonEdit
    Left = 40
    Top = 362
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
    Top = 362
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
    Top = 198
    Caption = #1056#1077#1075#1080#1086#1085
  end
  object ceArea: TcxButtonEdit
    Left = 280
    Top = 214
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 30
    Width = 209
  end
  object ActionList: TActionList
    Top = 40
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
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inisPartionDate'
        Value = 'False'
        Component = cbPartionDate
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inParentId'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'ParentId'
        ParamType = ptInput
      end
      item
        Name = 'inBranchId'
        Value = ''
        Component = BranchGuides
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
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inAccountDirectionId'
        Value = ''
        Component = AccountDirectionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inProfitLossDirectionId'
        Value = ''
        Component = ProfitLossDirectionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inRouteID'
        Value = Null
        Component = RouteGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inRouteSortingId'
        Value = Null
        Component = RouteSortingGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inAreaId'
        Value = Null
        Component = AreaGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 24
    Top = 384
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
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
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
      end
      item
        Name = 'ParentId'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ParentName'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'BranchId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'BranchName'
        Value = ''
        Component = BranchGuides
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
        DataType = ftString
      end
      item
        Name = 'ContractId'
        Value = Null
        Component = ContractGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'InvNumber'
        Value = Null
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'Contract_JuridicalName'
        Value = Null
        Component = Contract_JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'AccountDirectionId'
        Value = ''
        Component = AccountDirectionGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'AccountDirectionName'
        Value = ''
        Component = AccountDirectionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ProfitLossDirectionId'
        Value = ''
        Component = ProfitLossDirectionGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ProfitLossDirectionName'
        Value = ''
        Component = ProfitLossDirectionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'Contract_InfomoneyName'
        Value = Null
        Component = Contract_InfomoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'RouteId'
        Value = Null
        Component = RouteGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'RouteName'
        Value = Null
        Component = RouteGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'RouteSortingId'
        Value = Null
        Component = RouteSortingGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'RouteSortingName'
        Value = Null
        Component = RouteSortingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'AreaId'
        Value = Null
        Component = AreaGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'AreaName'
        Value = Null
        Component = AreaGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'isPartionDate'
        Value = Null
        Component = cbPartionDate
        DataType = ftBoolean
      end>
    PackSize = 1
    Left = 16
    Top = 176
  end
  object ParentGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParent
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 160
    Top = 64
  end
  object BranchGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBranch
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 384
    Top = 64
  end
  object BusinessGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBusiness
    FormNameParam.Value = 'TBusiness_ObjectForm'
    FormNameParam.DataType = ftString
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 160
    Top = 120
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 384
    Top = 112
  end
  object AccountDirectionGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceAccountDirection
    FormNameParam.Value = 'TAccountDirection_ObjectForm'
    FormNameParam.DataType = ftString
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = AccountDirectionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 168
    Top = 168
  end
  object ProfitLossDirectionGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceProfitLossDirection
    FormNameParam.Value = 'TProfitLossDirection_ObjectForm'
    FormNameParam.DataType = ftString
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ProfitLossDirectionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 384
    Top = 168
  end
  object ContractGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceContract
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'JuridicalId'
        Value = Null
        Component = Contract_JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = Contract_JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'InfoMoneyId'
        Value = Null
        Component = Contract_InfomoneyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'InfoMoneyName_all'
        Value = Null
        Component = Contract_InfomoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Contract_JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Contract_InfomoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 352
    Top = 296
  end
  object RouteGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRoute
    FormNameParam.Value = 'TRouteForm'
    FormNameParam.DataType = ftString
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RouteGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 96
    Top = 340
  end
  object RouteSortingGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRouteSorting
    FormNameParam.Value = 'TRouteSortingForm'
    FormNameParam.DataType = ftString
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RouteSortingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 400
    Top = 349
  end
  object AreaGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceArea
    FormNameParam.Value = 'TAreaForm'
    FormNameParam.DataType = ftString
    FormName = 'TAreaForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = AreaGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = AreaGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 336
    Top = 216
  end
end
