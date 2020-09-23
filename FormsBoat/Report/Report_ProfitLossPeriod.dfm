object Report_ProfitLossPeriodForm: TReport_ProfitLossPeriodForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' '#1086' '#1055#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1059#1073#1099#1090#1082#1072#1093
  ClientHeight = 395
  ClientWidth = 906
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 906
    Height = 33
    Align = alTop
    TabOrder = 0
    object deStart1: TcxDateEdit
      Left = 97
      Top = 5
      EditValue = 43466d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd1: TcxDateEdit
      Left = 276
      Top = 5
      EditValue = 43466d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel7: TcxLabel
      Left = 492
      Top = 6
      Caption = #1055#1077#1088#1080#1086#1076'2 '#1089' ...'
    end
    object cxLabel9: TcxLabel
      Left = 654
      Top = 6
      AutoSize = False
      Caption = #1055#1077#1088#1080#1086#1076'2 '#1087#1086' ...'
      Height = 17
      Width = 76
    end
    object deStart2: TcxDateEdit
      Left = 565
      Top = 5
      EditValue = 43466d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 4
      Width = 79
    end
    object deEnd2: TcxDateEdit
      Left = 732
      Top = 5
      EditValue = 43466d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 5
      Width = 79
    end
    object cxLabel3: TcxLabel
      Left = 24
      Top = 6
      Caption = #1055#1077#1088#1080#1086#1076'1 '#1089' ...'
    end
    object cxLabel4: TcxLabel
      Left = 197
      Top = 6
      AutoSize = False
      Caption = #1055#1077#1088#1080#1086#1076'1 '#1087#1086' ...'
      Height = 17
      Width = 76
    end
  end
  object cxDBPivotGrid: TcxDBPivotGrid
    Left = 0
    Top = 59
    Width = 906
    Height = 336
    Align = alClient
    DataSource = DataSource
    Groups = <>
    TabOrder = 1
    object clProfitLossGroupName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1054#1055#1080#1059' '#1075#1088#1091#1087#1087#1072
      DataBinding.FieldName = 'ProfitLossGroupName'
      Visible = True
      UniqueName = #1043#1088#1091#1087#1087#1072' '#1054#1055#1080#1059
    end
    object clProfitLossDirectionName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1054#1055#1080#1059' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
      DataBinding.FieldName = 'ProfitLossDirectionName'
      Visible = True
      UniqueName = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object clProfitLossName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1054#1055#1080#1059' '#1089#1090#1072#1090#1100#1103
      DataBinding.FieldName = 'ProfitLossName'
      Visible = True
      UniqueName = #1057#1090#1072#1090#1100#1103
    end
    object clUnitName_ProfitLoss: TcxDBPivotGridField
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1052#1072#1075#1072#1079#1080#1085
      DataBinding.FieldName = 'UnitName_ProfitLoss'
      Visible = True
      UniqueName = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object clMovementDescName: TcxDBPivotGridField
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      DataBinding.FieldName = 'MovementDescName'
      Visible = True
      UniqueName = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object clInfoMoneyCode: TcxDBPivotGridField
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1059#1055' '#1089#1090'.'
      DataBinding.FieldName = 'InfoMoneyCode'
      Hidden = True
      UniqueName = #1050#1086#1076' '#1059#1055' '#1089#1090'.'
    end
    object clInfoMoneyGroupName: TcxDBPivotGridField
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      DataBinding.FieldName = 'InfoMoneyGroupName'
      Hidden = True
      UniqueName = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object clInfoMoneyDestinationName: TcxDBPivotGridField
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
      DataBinding.FieldName = 'InfoMoneyDestinationName'
      Hidden = True
      UniqueName = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
    end
    object clInfoMoneyName: TcxDBPivotGridField
      AreaIndex = 6
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      DataBinding.FieldName = 'InfoMoneyName'
      Hidden = True
      UniqueName = #1059#1055' '#1089#1090#1072#1090#1100#1103
    end
    object clOperYear: TcxDBPivotGridField
      Area = faColumn
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1043#1086#1076
      DataBinding.FieldName = 'OperYear'
      DisplayFormat = 'YY'
      PropertiesClassName = 'TcxDateEditProperties'
      Properties.DisplayFormat = 'YYYY'
      Visible = True
      UniqueName = #1059#1055' '#1089#1090#1072#1090#1100#1103
    end
    object clOperMonth: TcxDBPivotGridField
      Area = faColumn
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1052#1077#1089#1103#1094
      DataBinding.FieldName = 'OperMonth'
      PropertiesClassName = 'TcxDateEditProperties'
      Properties.DisplayFormat = 'YYYY MMMM'
      Visible = True
      UniqueName = #1059#1055' '#1089#1090#1072#1090#1100#1103
    end
    object clAmount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 0
      AllowedAreas = [faData]
      IsCaptionAssigned = True
      Caption = #1057#1091#1084#1084#1072
      DataBinding.FieldName = 'Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.;-,0. ; ;'
      Visible = True
      UniqueName = #1057#1091#1084#1084#1072
    end
    object clPercent: TcxDBPivotGridField
      Area = faData
      AreaIndex = 3
      AllowedAreas = [faData]
      IsCaptionAssigned = True
      Caption = '% '#1086#1090#1082#1083'. '#1087#1088#1086#1096#1083'. '#1087#1077#1088#1080#1086#1076
      DataBinding.FieldName = 'Percent'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.#;-,0.#; ;'
      Visible = True
      UniqueName = #1057#1091#1084#1084#1072
    end
    object PercentMonth: TcxDBPivotGridField
      Area = faData
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = '% '#1086#1090#1082#1083'. '#1087#1088#1086#1096#1083'. '#1084#1077#1089'.'
      DataBinding.FieldName = 'PercentMonth'
      Visible = True
      UniqueName = '% '#1086#1090#1082#1083'. '#1087#1088#1086#1096#1083'. '#1084#1077#1089'.'
    end
    object clAmountDif: TcxDBPivotGridField
      Area = faData
      AreaIndex = 1
      AllowedAreas = [faData]
      IsCaptionAssigned = True
      Caption = #1056#1072#1079#1085#1080#1094#1072
      DataBinding.FieldName = 'AmountDif'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.;-,0. ; ;'
      Hidden = True
      UniqueName = #1057#1091#1084#1084#1072
    end
    object clAmountPast: TcxDBPivotGridField
      Area = faData
      AreaIndex = 5
      AllowedAreas = [faData]
      IsCaptionAssigned = True
      Caption = #1057#1091#1084#1084#1072' ('#1087#1088#1086#1096#1083#1099#1081' '#1087#1077#1088#1080#1086#1076')'
      DataBinding.FieldName = 'AmountPast'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.;-,0. ; ;'
      ImageAlign = taCenter
      Hidden = True
      Width = 70
      UniqueName = #1057#1091#1084#1084#1072
    end
    object clAmountMonthDif: TcxDBPivotGridField
      Area = faData
      AreaIndex = 2
      AllowedAreas = [faData]
      IsCaptionAssigned = True
      Caption = #1056#1072#1079#1085#1080#1094#1072
      DataBinding.FieldName = 'AmountMonthDif'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.;-,0. ; ;'
      Hidden = True
      UniqueName = #1057#1091#1084#1084#1072
    end
    object clAmountMonthPast: TcxDBPivotGridField
      Area = faData
      AreaIndex = 6
      AllowedAreas = [faData]
      IsCaptionAssigned = True
      Caption = #1057#1091#1084#1084#1072' ('#1087#1088#1086#1096#1083#1099#1081' '#1087#1077#1088#1080#1086#1076')'
      DataBinding.FieldName = 'AmountMonthPast'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.;-,0. ; ;'
      ImageAlign = taCenter
      Hidden = True
      Width = 70
      UniqueName = #1057#1091#1084#1084#1072
    end
    object clDirectionObjectName: TcxDBPivotGridField
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
      DataBinding.FieldName = 'DirectionObjectName'
      Visible = True
      UniqueName = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 24
    Top = 216
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 52
    Top = 216
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd1
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart1
        Properties.Strings = (
          'Date')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Component = deStart2
        Properties.Strings = (
          'Date')
      end
      item
        Component = deEnd2
        Properties.Strings = (
          'Date')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 352
    Top = 280
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 112
    Top = 256
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
      ShowCaption = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbToExcel: TdxBarButton
      Action = actExportToExcel
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 200
    Top = 192
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actExportToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxDBPivotGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object MultiAction1: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = dsdExecStoredProc1
        end
        item
          Action = dsdOpenForm1
        end>
      Caption = 'MultiAction1'
    end
    object dsdOpenForm1: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'dsdOpenForm1'
      FormName = 'TReport_AccountForm'
      FormNameParam.Value = 'TReport_AccountForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart1
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd1
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'AccountId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'AccountGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountDirectionId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'AccountDirectionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountDirectionName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountDirectionName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = FormParams
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BusinessId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'BusinessId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'BusinessName'
          Value = Null
          Component = FormParams
          ComponentItem = 'BusinessName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProfitLossGroupId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'ProfitLossGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProfitLossGroupName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ProfitLossGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProfitLossDirectionId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'ProfitLossDirectionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProfitLossDirectionName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ProfitLossDirectionName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProfitLossId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'ProfitLossId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProfitLossName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ProfitLossName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'BranchId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName'
          Value = Null
          Component = FormParams
          ComponentItem = 'BranchName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object dsdExecStoredProc1: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetProfitLostParam
      StoredProcList = <
        item
          StoredProc = spGetProfitLostParam
        end>
      Caption = 'dsdExecStoredProc1'
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_ProfitLossPeriodDialogForm'
      FormNameParam.Value = 'TReport_ProfitLossPeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate1'
          Value = 41640d
          Component = deStart1
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate1'
          Value = 41640d
          Component = deEnd1
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartDate2'
          Value = 41640d
          Component = deStart2
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate2'
          Value = 41640d
          Component = deEnd2
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42370d
          FromParam.Component = deStart1
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42370d
          FromParam.Component = deEnd1
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      DataSets = <
        item
          DataSet = ClientDataSet
          UserName = 'frxDBDItems'
          IndexFieldNames = 'ProfitLossGroupName;ProfitLossDirectionName;ProfitLossName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart1
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd1
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'maintext'
          Value = #1088'/'#1089#1095#1077#1090#1091
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTotal'
          Value = Null
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1059#1055' '#1054#1055#1080#1059
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1059#1055' '#1054#1055#1080#1059
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpReport_ProfitLossPeriod'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inStartDate1'
        Value = 41640d
        Component = deStart1
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate1'
        Value = 41640d
        Component = deEnd1
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate2'
        Value = 41640d
        Component = deStart2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate2'
        Value = 41640d
        Component = deEnd2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 120
    Top = 192
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 232
    Top = 232
  end
  object spGetProfitLostParam: TdsdStoredProc
    StoredProcName = 'gpGetProfitLossParam'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inData'
        Value = ''
        Component = PivotAddOn
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RootType'
        Value = '0'
        Component = FormParams
        ComponentItem = 'RootType'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountGroupId'
        Value = '9023'
        Component = FormParams
        ComponentItem = 'AccountGroupId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountGroupName'
        Value = '100000 '#1057#1086#1073#1089#1090#1074#1077#1085#1085#1099#1081' '#1082#1072#1087#1080#1090#1072#1083
        Component = FormParams
        ComponentItem = 'AccountGroupName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountDirectionId'
        Value = '9072'
        Component = FormParams
        ComponentItem = 'AccountDirectionId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountDirectionName'
        Value = '100300 '#1055#1088#1080#1073#1099#1083#1100' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1087#1077#1088#1080#1086#1076#1072
        Component = FormParams
        ComponentItem = 'AccountDirectionName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountId'
        Value = '9210'
        Component = FormParams
        ComponentItem = 'AccountId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountName'
        Value = '100301 '#1055#1088#1080#1073#1099#1083#1100' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1087#1077#1088#1080#1086#1076#1072
        Component = FormParams
        ComponentItem = 'AccountName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = FormParams
        ComponentItem = 'InfoMoneyId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = FormParams
        ComponentItem = 'InfoMoneyName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectDirectionId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'ObjectDirectionId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectDestinationId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'ObjectDestinationId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'JuridicalBasisId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BusinessId'
        Value = ''
        Component = FormParams
        ComponentItem = 'BusinessId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BusinessName'
        Value = ''
        Component = FormParams
        ComponentItem = 'BusinessName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossGroupId'
        Value = ''
        Component = FormParams
        ComponentItem = 'ProfitLossGroupId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossGroupName'
        Value = ''
        Component = FormParams
        ComponentItem = 'ProfitLossGroupName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossDirectionId'
        Value = ''
        Component = FormParams
        ComponentItem = 'ProfitLossDirectionId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossDirectionName'
        Value = ''
        Component = FormParams
        ComponentItem = 'ProfitLossDirectionName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossId'
        Value = ''
        Component = FormParams
        ComponentItem = 'ProfitLossId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossName'
        Value = ''
        Component = FormParams
        ComponentItem = 'ProfitLossName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchId'
        Value = ''
        Component = FormParams
        ComponentItem = 'BranchId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchName'
        Value = ''
        Component = FormParams
        ComponentItem = 'BranchName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 304
  end
  object PivotAddOn: TPivotAddOn
    ErasedFieldName = 'isErased'
    PivotGrid = cxDBPivotGrid
    OnDblClickActionList = <
      item
        Action = MultiAction1
      end>
    ActionItemList = <
      item
        Action = MultiAction1
        ShortCut = 13
      end>
    ColorRuleList = <>
    SummaryList = <>
    Left = 80
    Top = 320
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'AccountId'
        Value = '9210'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountName'
        Value = '100301 '#1055#1088#1080#1073#1099#1083#1100' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1087#1077#1088#1080#1086#1076#1072
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountGroupId'
        Value = '9023'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountGroupName'
        Value = '100000 '#1057#1086#1073#1089#1090#1074#1077#1085#1085#1099#1081' '#1082#1072#1087#1080#1090#1072#1083
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountDirectionId'
        Value = '9072'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountDirectionName'
        Value = '100300 '#1055#1088#1080#1073#1099#1083#1100' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1087#1077#1088#1080#1086#1076#1072
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BusinessId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'BusinessName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RootType'
        Value = '0'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectDirectionId'
        Value = '0'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectDestinationId'
        Value = '0'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisId'
        Value = '0'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossGroupId'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossGroupName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossDirectionId'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossDirectionName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossId'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchId'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 184
  end
  object PeriodChoice1: TPeriodChoice
    DateStart = deStart1
    DateEnd = deEnd1
    Left = 416
    Top = 8
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice1
      end
      item
        Component = PeriodChoice2
      end
      item
      end>
    Left = 688
    Top = 280
  end
  object PeriodChoice2: TPeriodChoice
    DateStart = deStart2
    DateEnd = deEnd2
    Left = 688
    Top = 8
  end
  object cfCalcPercent: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = clPercent
    GridFields = <
      item
        Field = clAmountDif
      end
      item
        Field = clAmountPast
      end>
    CalcFieldsType = cfPercent
    Left = 520
    Top = 248
  end
  object cfCalcPercentMonth: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = PercentMonth
    GridFields = <
      item
        Field = clAmountMonthDif
      end
      item
        Field = clAmountMonthPast
      end>
    CalcFieldsType = cfPercent
    Left = 504
    Top = 312
  end
end
