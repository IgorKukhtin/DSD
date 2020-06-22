object Report_Cash_OlapForm: TReport_Cash_OlapForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1082#1072#1089#1089#1077'> ('#1054#1051#1040#1055')'
  ClientHeight = 448
  ClientWidth = 877
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
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object PanelHead: TPanel
    Left = 0
    Top = 0
    Width = 877
    Height = 55
    Align = alTop
    TabOrder = 0
    object deStart: TcxDateEdit
      Left = 83
      Top = 5
      EditValue = 43831d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 79
    end
    object deEnd: TcxDateEdit
      Left = 83
      Top = 29
      EditValue = 43831d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 79
    end
    object cxLabel1: TcxLabel
      Left = 12
      Top = 6
      Caption = #1055#1077#1088#1080#1086#1076' '#1089' ...'
    end
    object cxLabel2: TcxLabel
      Left = 5
      Top = 30
      AutoSize = False
      Caption = #1055#1077#1088#1080#1086#1076' '#1087#1086' ...'
      Height = 17
      Width = 76
    end
    object cxLabel3: TcxLabel
      Left = 183
      Top = 7
      Caption = #1050#1072#1089#1089#1072':'
    end
    object edCash: TcxButtonEdit
      Left = 183
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 191
    end
    object cxLabel4: TcxLabel
      Left = 392
      Top = 6
      Caption = #1057#1095#1077#1090' '#1085#1072#1079#1074#1072#1085#1080#1077':'
    end
    object edAccount: TcxButtonEdit
      Left = 392
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 236
    end
    object cxLabel8: TcxLabel
      Left = 644
      Top = 6
      Caption = #1042#1072#1083#1102#1090#1072':'
    end
    object edCurrency: TcxButtonEdit
      Left = 644
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 77
    end
  end
  object cxDBPivotGrid: TcxDBPivotGrid
    Left = 0
    Top = 81
    Width = 877
    Height = 367
    Align = alClient
    DataSource = DataSource
    Groups = <>
    OptionsView.RowGrandTotalWidth = 693
    TabOrder = 1
    object pvMonthName: TcxDBPivotGridField
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1052#1077#1089#1103#1094
      DataBinding.FieldName = 'MonthName'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvYear: TcxDBPivotGridField
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1043#1086#1076
      DataBinding.FieldName = 'Year'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvOperDate: TcxDBPivotGridField
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1044#1072#1090#1072
      DataBinding.FieldName = 'OperDate'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvGroupName: TcxDBPivotGridField
      AreaIndex = 14
      IsCaptionAssigned = True
      Caption = #1042#1080#1076
      DataBinding.FieldName = 'GroupName'
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvCurrencyName: TcxDBPivotGridField
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1042#1072#1083#1102#1090#1072
      DataBinding.FieldName = 'CurrencyName'
      Visible = True
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvBranchName: TcxDBPivotGridField
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1060#1080#1083#1080#1072#1083
      DataBinding.FieldName = 'BranchName'
      Visible = True
      Width = 100
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvCashName: TcxDBPivotGridField
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = #1050#1072#1089#1089#1072
      DataBinding.FieldName = 'CashName'
      Visible = True
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvMoneyPlaceCode: TcxDBPivotGridField
      AreaIndex = 9
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' ('#1086#1090' '#1082#1086#1075#1086', '#1082#1086#1084#1091')'
      DataBinding.FieldName = 'MoneyPlaceCode'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvMoneyPlaceName: TcxDBPivotGridField
      AreaIndex = 19
      IsCaptionAssigned = True
      Caption = #1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091
      DataBinding.FieldName = 'MoneyPlaceName'
      Visible = True
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvItemName: TcxDBPivotGridField
      AreaIndex = 20
      IsCaptionAssigned = True
      Caption = #1069#1083#1077#1084#1077#1085#1090
      DataBinding.FieldName = 'ItemName'
      Visible = True
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvContractInvNumber: TcxDBPivotGridField
      AreaIndex = 10
      IsCaptionAssigned = True
      Caption = #8470' '#1076#1086#1075'.'
      DataBinding.FieldName = 'ContractInvNumber'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvContractTagName: TcxDBPivotGridField
      AreaIndex = 11
      IsCaptionAssigned = True
      Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
      DataBinding.FieldName = 'ContractTagName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvInfoMoneyCode: TcxDBPivotGridField
      AreaIndex = 15
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1059#1055
      DataBinding.FieldName = 'InfoMoneyCode'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyName: TcxDBPivotGridField
      AreaIndex = 18
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      DataBinding.FieldName = 'InfoMoneyName'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyName_all: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
      DataBinding.FieldName = 'InfoMoneyName_all'
      Visible = True
      Width = 150
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyGroupName: TcxDBPivotGridField
      AreaIndex = 16
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      DataBinding.FieldName = 'InfoMoneyGroupName'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyDestinationName: TcxDBPivotGridField
      AreaIndex = 17
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
      DataBinding.FieldName = 'InfoMoneyDestinationName'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvUnitCode: TcxDBPivotGridField
      AreaIndex = 12
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1087#1086#1076#1088'.'
      DataBinding.FieldName = 'UnitCode'
      UniqueName = #1043#1088#1091#1087#1087#1072' 2'
    end
    object pvUnitName: TcxDBPivotGridField
      AreaIndex = 13
      IsCaptionAssigned = True
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      DataBinding.FieldName = 'UnitName'
      Visible = True
      UniqueName = #1043#1088#1091#1087#1087#1072' 2'
    end
    object pvDebetSumm: TcxDBPivotGridField
      Area = faData
      AreaIndex = 1
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1054#1073#1086#1088#1086#1090' '#1044#1077#1073#1077#1090
      DataBinding.FieldName = 'DebetSumm'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvKreditSumm: TcxDBPivotGridField
      Area = faData
      AreaIndex = 3
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1054#1073#1086#1088#1086#1090' '#1050#1088#1077#1076#1080#1090
      DataBinding.FieldName = 'KreditSumm'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvDebetSumm_Currency: TcxDBPivotGridField
      Area = faData
      AreaIndex = 2
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1054#1073#1086#1088#1086#1090' '#1044#1077#1073#1077#1090' '#1074' '#1074#1072#1083'.'
      DataBinding.FieldName = 'DebetSumm_Currency'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvKreditSumm_Currency: TcxDBPivotGridField
      Area = faData
      AreaIndex = 4
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1054#1073#1086#1088#1086#1090' '#1050#1088#1077#1076#1080#1090' '#1074' '#1074#1072#1083'.'
      DataBinding.FieldName = 'KreditSumm_Currency'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvTotalSumm: TcxDBPivotGridField
      Area = faData
      AreaIndex = 0
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1050#1091#1088#1089'. '#1088#1072#1079#1085'. ('#1089#1095#1077#1090')'
      DataBinding.FieldName = 'TotalSumm'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvProfitLossGroupCode: TcxDBPivotGridField
      AreaIndex = 22
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1054#1055#1080#1059' '#1075#1088'. ('#1076#1083#1103' '#1087#1086#1076#1088'. )'
      DataBinding.FieldName = 'ProfitLossGroupCode'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvProfitLossGroupName: TcxDBPivotGridField
      AreaIndex = 21
      IsCaptionAssigned = True
      Caption = #1054#1055#1080#1059' '#1075#1088#1091#1087#1087#1072' ('#1076#1083#1103' '#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103')'
      DataBinding.FieldName = 'ProfitLossGroupName'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvProfitLossDirectionCode: TcxDBPivotGridField
      AreaIndex = 23
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1054#1055#1080#1059' '#1085#1072#1087#1088'.  ('#1076#1083#1103' '#1087#1086#1076#1088'.)'
      DataBinding.FieldName = 'ProfitLossDirectionCode'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvProfitLossDirectionName: TcxDBPivotGridField
      AreaIndex = 24
      IsCaptionAssigned = True
      Caption = #1054#1055#1080#1059' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077'  ('#1076#1083#1103' '#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103')'
      DataBinding.FieldName = 'ProfitLossDirectionName'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvAccountName: TcxDBPivotGridField
      AreaIndex = 6
      IsCaptionAssigned = True
      Caption = #1057#1095#1077#1090
      DataBinding.FieldName = 'AccountName'
      Visible = True
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvCashFlowName_in: TcxDBPivotGridField
      AreaIndex = 7
      IsCaptionAssigned = True
      Caption = #1057#1090#1072#1090#1100#1103' '#1044#1044#1057' '#1087#1088#1080#1093#1086#1076
      DataBinding.FieldName = 'CashFlowName_in'
      Visible = True
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvCashFlowName_out: TcxDBPivotGridField
      AreaIndex = 8
      IsCaptionAssigned = True
      Caption = #1057#1090#1072#1090#1100#1103' '#1044#1044#1057' '#1088#1072#1089#1093#1086#1076
      DataBinding.FieldName = 'CashFlowName_out'
      Visible = True
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 120
    Top = 208
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 80
    Top = 208
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
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
        Component = GuidesCash
        Properties.Strings = (
          'key'
          'TextValue')
      end
      item
        Component = GuidesCurrency
        Properties.Strings = (
          'key'
          'TextValue')
      end
      item
        Component = GuidesAccount
        Properties.Strings = (
          'key'
          'TextValue')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 256
    Top = 200
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
    Left = 176
    Top = 216
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
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbToExcel: TdxBarButton
      Action = actExportToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 40
    Top = 200
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
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
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Cash_OlapDialogForm'
      FormNameParam.Value = 'TReport_Cash_OlapDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CashId'
          Value = ''
          Component = GuidesCash
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CashName'
          Value = ''
          Component = GuidesCash
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountId'
          Value = ''
          Component = GuidesAccount
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountName'
          Value = ''
          Component = GuidesAccount
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CurrencyId'
          Value = ''
          Component = GuidesCurrency
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CurrencyName'
          Value = ''
          Component = GuidesCurrency
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  object spReport: TdsdStoredProc
    StoredProcName = 'gpReport_Cash_Olap'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccountId'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashId'
        Value = Null
        Component = GuidesCash
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId'
        Value = Null
        Component = GuidesCurrency
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 72
    Top = 344
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 544
    Top = 280
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 448
    Top = 336
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesCurrency
      end
      item
        Component = GuidesCash
      end
      item
        Component = GuidesAccount
      end
      item
        Component = deStart
      end
      item
        Component = deEnd
      end>
    Left = 472
    Top = 248
  end
  object PivotAddOn: TPivotAddOn
    ErasedFieldName = 'isErased'
    PivotGrid = cxDBPivotGrid
    OnDblClickActionList = <>
    ActionItemList = <>
    ColorRuleList = <>
    SummaryList = <>
    Left = 392
    Top = 272
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 360
    Top = 184
  end
  object GuidesCash: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCash
    FormNameParam.Value = 'TCash_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCash_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 272
    Top = 16
  end
  object GuidesAccount: TdsdGuides
    KeyField = 'Id'
    LookupControl = edAccount
    FormNameParam.Value = 'TAccount_ObjectDescForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAccount_ObjectDescForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 472
    Top = 8
  end
  object GuidesCurrency: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCurrency
    FormNameParam.Value = 'TCurrency_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCurrency_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCurrency
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCurrency
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 664
    Top = 11
  end
  object PeriodChoice2: TPeriodChoice
    Left = 520
    Top = 328
  end
  object cfPrice: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    GridFields = <
      item
        Field = pvTotalSumm
      end>
    CalcFieldsType = cfDivision
    Left = 736
    Top = 88
  end
  object cfPricePartner: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    GridFields = <
      item
        Field = pvDebetSumm
      end>
    CalcFieldsType = cfDivision
    Left = 656
    Top = 152
  end
  object cfPriceSaleReal: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    GridFields = <
      item
        Field = pvDebetSumm
      end>
    CalcFieldsType = cfDivision
    Left = 656
    Top = 312
  end
end
