object Report_BalanceForm: TReport_BalanceForm
  Left = 0
  Top = 0
  Caption = #1041#1072#1083#1072#1085#1089
  ClientHeight = 440
  ClientWidth = 1329
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1329
    Height = 31
    Align = alTop
    TabOrder = 0
    object deStart: TcxDateEdit
      Left = 101
      Top = 5
      EditValue = 44197d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 310
      Top = 5
      EditValue = 44197d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 4
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel2: TcxLabel
      Left = 200
      Top = 6
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
  end
  object cxDBPivotGrid: TcxDBPivotGrid
    Left = 0
    Top = 57
    Width = 1329
    Height = 383
    Align = alClient
    DataSource = DataSource
    Groups = <>
    TabOrder = 1
    object pvRootName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1040'-'#1055
      DataBinding.FieldName = 'RootName'
      Visible = True
      UniqueName = #1040'-'#1055
    end
    object pvAccountGroupName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
      DataBinding.FieldName = 'AccountGroupName'
      Visible = True
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvAccountDirectionName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1057#1095#1077#1090' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
      DataBinding.FieldName = 'AccountDirectionName'
      Visible = True
      UniqueName = #1057#1095#1077#1090' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvAccountName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1057#1095#1077#1090' - '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
      DataBinding.FieldName = 'AccountName'
      Visible = True
      UniqueName = #1057#1095#1077#1090' - '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
    end
    object pvInfoMoneyName: TcxDBPivotGridField
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      DataBinding.FieldName = 'InfoMoneyName'
      Visible = True
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvObjectDirection: TcxDBPivotGridField
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
      DataBinding.FieldName = 'ByObjectName'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvByObjectItemName: TcxDBPivotGridField
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1069#1083#1077#1084#1077#1085#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
      DataBinding.FieldName = 'ByObjectItemName'
      Visible = True
      UniqueName = #1069#1083#1077#1084#1077#1085#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
    end
    object pvAmountDebetStart: TcxDBPivotGridField
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1044#1077#1073#1077#1090' '#1085#1072' '#1085#1072#1095#1072#1083#1086
      DataBinding.FieldName = 'AmountDebetStart'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      Visible = True
      UniqueName = 'AmountDebetStart'
    end
    object pvAmountKreditStart: TcxDBPivotGridField
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = #1050#1088#1077#1076#1080#1090' '#1085#1072' '#1085#1072#1095#1072#1083#1086
      DataBinding.FieldName = 'AmountKreditStart'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      Visible = True
      UniqueName = 'AmountKreditStart'
    end
    object pvAmountActiveStart: TcxDBPivotGridField
      Area = faData
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
      DataBinding.FieldName = 'AmountActiveStart'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountPassiveStart: TcxDBPivotGridField
      Area = faData
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
      DataBinding.FieldName = 'AmountPassiveStart'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountDebet: TcxDBPivotGridField
      Area = faData
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1044#1077#1073#1077#1090' '#1086#1073#1086#1088#1086#1090
      DataBinding.FieldName = 'AmountDebet'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
      Styles.ColumnHeader = dmMain.cxSelection
      Visible = True
      UniqueName = #1044#1077#1073#1077#1090' '#1086#1073#1086#1088#1086#1090
    end
    object pvAmountKredit: TcxDBPivotGridField
      Area = faData
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1050#1088#1077#1076#1080#1090' '#1086#1073#1086#1088#1086#1090
      DataBinding.FieldName = 'AmountKredit'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
      Styles.ColumnHeader = dmMain.cxSelection
      Visible = True
      UniqueName = #1050#1088#1077#1076#1080#1090' '#1086#1073#1086#1088#1086#1090
    end
    object pvAmountDebetEnd: TcxDBPivotGridField
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1044#1077#1073#1077#1090' '#1085#1072' '#1082#1086#1085#1077#1094
      DataBinding.FieldName = 'AmountDebetEnd'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      Visible = True
      UniqueName = 'AmountDebetEnd'
    end
    object pvAmountKreditEnd: TcxDBPivotGridField
      AreaIndex = 6
      IsCaptionAssigned = True
      Caption = #1050#1088#1077#1076#1080#1090' '#1085#1072' '#1082#1086#1085#1077#1094
      DataBinding.FieldName = 'AmountKreditEnd'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      Visible = True
      UniqueName = 'AmountKreditEnd'
    end
    object pvAmountActiveEnd: TcxDBPivotGridField
      Area = faData
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
      DataBinding.FieldName = 'AmountActiveEnd'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvAmountPassiveEnd: TcxDBPivotGridField
      Area = faData
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
      DataBinding.FieldName = 'AmountPassiveEnd'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
  end
  object cbTotal: TcxCheckBox
    Left = 134
    Top = 179
    Caption = 'C'#1075#1088#1091#1087#1087#1080#1088#1086#1074#1072#1090#1100
    Properties.ReadOnly = False
    TabOrder = 6
    Width = 101
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
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbPrint2'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bb'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
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
    object bbStaticText: TdxBarButton
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbPrint2: TdxBarButton
      Action = actPrint2
      Category = 0
      ImageIndex = 16
    end
    object bb: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cbTotal
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 40
    Top = 200
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
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountId'
          Value = Null
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
          Value = Null
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
          Value = Null
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
          Value = Null
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
          Value = Null
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
        end>
      isShowModal = False
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
    object dsdExecStoredProc1: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetBalanceParam
      StoredProcList = <
        item
          StoredProc = spGetBalanceParam
        end>
      Caption = 'dsdExecStoredProc1'
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_BalanceDialogForm'
      FormNameParam.Value = 'TReport_BalanceDialogForm'
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
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint2: TdsdPrintAction
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
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42370d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090')'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = ClientDataSet
          UserName = 'frxDBDItems'
          IndexFieldNames = 'RootName;AccountGroupName;AccountDirectionName;AccountName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTotal'
          Value = Null
          Component = cbTotal
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1059#1055' '#1041#1072#1083#1072#1085#1089' ('#1044#1077#1073#1077#1090' '#1050#1088#1077#1076#1080#1090')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1059#1055' '#1041#1072#1083#1072#1085#1089' ('#1044#1077#1073#1077#1090' '#1050#1088#1077#1076#1080#1090')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
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
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42370d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1040#1082#1090#1080#1074'/'#1055#1072#1089#1089#1080#1074')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1040#1082#1090#1080#1074'/'#1055#1072#1089#1089#1080#1074')'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = ClientDataSet
          UserName = 'frxDBDItems'
          IndexFieldNames = 'RootName;AccountGroupName;AccountDirectionName;AccountName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTotal'
          Value = Null
          Component = cbTotal
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1059#1055' '#1041#1072#1083#1072#1085#1089
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1059#1055' '#1041#1072#1083#1072#1085#1089
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpReport_Balance'
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
      end>
    PackSize = 1
    Left = 208
    Top = 288
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 528
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 400
    Top = 48
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end>
    Left = 488
    Top = 48
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
    Left = 392
    Top = 272
  end
  object spGetBalanceParam: TdsdStoredProc
    StoredProcName = 'gpGetBalanceParam'
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
        Value = Null
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
        Value = Null
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
        Name = 'AccountId'
        Value = Null
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
        Name = 'InfoMoneyId'
        Value = Null
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
        Value = Null
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
      end>
    PackSize = 1
    Left = 288
    Top = 304
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'AccountId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountGroupId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountGroupName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountDirectionId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountDirectionName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BusinessId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'BusinessName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 184
  end
end
