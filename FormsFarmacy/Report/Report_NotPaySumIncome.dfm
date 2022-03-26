object Report_NotPaySumIncomeForm: TReport_NotPaySumIncomeForm
  Left = 0
  Top = 0
  Caption = #1053#1077' '#1086#1087#1083#1072#1095#1077#1085#1085#1099#1077' '#1087#1088#1080#1093#1086#1076#1099' '#1080#1090#1086#1075#1080' '#1087#1086' '#1102#1088'. '#1083#1080#1094#1072#1084
  ClientHeight = 440
  ClientWidth = 751
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
    Width = 751
    Height = 31
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 807
    object deStart: TcxDateEdit
      Left = 101
      Top = 5
      EditValue = 43466d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 310
      Top = 5
      EditValue = 43466d
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
  object cxGrid: TcxGrid
    Left = 0
    Top = 57
    Width = 751
    Height = 383
    Align = alClient
    TabOrder = 5
    ExplicitWidth = 807
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
          Column = TotalSumm
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
          Column = TotalSumm
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = JuridicalName
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
          Column = TotalPaySumm
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsBehavior.FocusCellOnCycle = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.DataRowSizing = True
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object JuridicalCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'JuridicalCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object JuridicalName: TcxGridDBColumn
        Caption = #1070#1088'. '#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 239
      end
      object JuridicalFromCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1087#1086#1089#1090'.'
        DataBinding.FieldName = 'JuridicalFromCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 47
      end
      object JuridicalFromName: TcxGridDBColumn
        Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
        DataBinding.FieldName = 'JuridicalFromName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 171
      end
      object TotalSumm: TcxGridDBColumn
        Caption = #1048#1090#1086#1075#1086', '#1075#1088#1085
        DataBinding.FieldName = 'TotalSumm'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 115
      end
      object TotalPaySumm: TcxGridDBColumn
        Caption = #1053#1077' '#1086#1087#1083#1072#1095#1077#1085#1086', '#1075#1088#1085
        DataBinding.FieldName = 'TotalPaySumm'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 152
    Top = 208
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 96
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
    Left = 312
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
    Left = 224
    Top = 208
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
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
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
      Caption = #1055#1077#1095#1072#1090#1100' ('#1040#1082#1090#1080#1074'/'#1055#1072#1089#1089#1080#1074')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1040#1082#1090#1080#1074'/'#1055#1072#1089#1089#1080#1074')'
      Visible = ivAlways
      ImageIndex = 3
      ShortCut = 16464
    end
    object bbPrint2: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090')'
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbcbTotal: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object bbOpenReport_AccountMotion: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1091
      Category = 0
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1091
      Visible = ivAlways
      ImageIndex = 26
    end
    object bbReport_Account: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091'>'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091'>'
      Visible = ivAlways
      ImageIndex = 25
    end
    object bbPrint3: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090') '#1089#1074#1077#1088#1085#1091#1090#1086
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090') '#1089#1074#1077#1088#1085#1091#1090#1086
      Visible = ivAlways
      ImageIndex = 18
    end
    object bbGroup: TdxBarControlContainerItem
      Caption = 'bbGroup'
      Category = 0
      Hint = 'bbGroup'
      Visible = ivAlways
    end
    object bbUpdate: TdxBarButton
      Action = actUpdate
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 32
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
      Grid = cxGrid
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
      FormName = 'TReport_PeriodDialogForm'
      FormNameParam.Value = 'TReport_PeriodDialogForm'
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
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TSendForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 43466d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpReport_NotPaySumIncome'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inDateStart'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateFinal'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 64
    Top = 296
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 784
    Top = 16
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
  object spGetBalanceParam: TdsdStoredProc
    StoredProcName = 'gpGetBalanceParam'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inData'
        Value = ''
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
    Left = 192
    Top = 296
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
    Left = 392
    Top = 208
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = actUpdate
      end>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 392
    Top = 304
  end
end
