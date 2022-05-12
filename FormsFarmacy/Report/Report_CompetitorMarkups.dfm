object Report_CompetitorMarkupsForm: TReport_CompetitorMarkupsForm
  Left = 0
  Top = 0
  Caption = #1057#1080#1089#1090#1077#1084#1072' '#1086#1087#1077#1088#1072#1090#1080#1074#1085#1086#1075#1086' '#1084#1086#1085#1080#1090#1086#1088#1080#1085#1075#1072' '#1082#1086#1085#1082#1091#1088#1077#1085#1090#1086#1074
  ClientHeight = 545
  ClientWidth = 1124
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
    Width = 1124
    Height = 31
    Align = alTop
    TabOrder = 0
    object deStart: TcxDateEdit
      Left = 44
      Top = 5
      EditValue = 43466d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 328
      Top = 5
      EditValue = 43466d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Visible = False
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 4
      Top = 6
      Caption = #1044#1072#1090#1072':'
    end
    object cxLabel2: TcxLabel
      Left = 218
      Top = 6
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
      Visible = False
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 57
    Width = 1124
    Height = 488
    Align = alClient
    TabOrder = 5
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <
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
          Format = ',0.####'
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
          Format = ',0.####'
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
          Format = #1057#1090#1088#1086#1082' 0'
          Kind = skCount
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
    end
    object cxGridDBBandedTableView: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.GroupByBox = False
      Styles.Content = dmMain.cxContentStyle
      Styles.Inactive = dmMain.cxSelection
      Styles.Footer = dmMain.cxFooterStyle
      Styles.Header = dmMain.cxHeaderStyle
      Styles.BandHeader = dmMain.cxHeaderStyle
      Bands = <
        item
          Width = 498
        end
        item
          Width = 278
        end
        item
          Visible = False
          VisibleForCustomization = False
        end>
      object GroupsName: TcxGridDBBandedColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GroupsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 129
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object SubGroupsName: TcxGridDBBandedColumn
        Caption = #1055#1086#1076#1075#1088#1091#1087#1087#1072
        DataBinding.FieldName = 'SubGroupsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 86
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object GoodsCode: TcxGridDBBandedColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 62
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object GoodsName: TcxGridDBBandedColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 251
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object PriceUnitMin: TcxGridDBBandedColumn
        Caption = #1052#1080#1085'. '#1094#1077#1085#1072
        DataBinding.FieldName = 'PriceUnitMin'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 68
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object MarginPercentMin: TcxGridDBBandedColumn
        Caption = #1055#1088#1086#1094#1077#1085#1090' '#1085#1072#1094#1077#1085#1082#1080
        DataBinding.FieldName = 'MarginPercentMin'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00 %'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 68
        Position.BandIndex = 1
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object JuridicalPriceMin: TcxGridDBBandedColumn
        Caption = #1062#1077#1085#1072' '#1087#1086#1089#1090'.'
        DataBinding.FieldName = 'JuridicalPriceMin'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 68
        Position.BandIndex = 1
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object PriceUnitMax: TcxGridDBBandedColumn
        Caption = #1052#1072#1082#1089'. '#1094#1077#1085#1072
        DataBinding.FieldName = 'PriceUnitMax'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 68
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 1
      end
      object JuridicalPriceMax: TcxGridDBBandedColumn
        Caption = #1062#1077#1085#1072' '#1087#1086#1089#1090'.'
        DataBinding.FieldName = 'JuridicalPriceMax'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 68
        Position.BandIndex = 1
        Position.ColIndex = 2
        Position.RowIndex = 1
      end
      object MarginPercentMax: TcxGridDBBandedColumn
        Caption = #1055#1088#1086#1094#1077#1085#1090' '#1085#1072#1094#1077#1085#1082#1080
        DataBinding.FieldName = 'MarginPercentMax'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00 %'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 68
        Position.BandIndex = 1
        Position.ColIndex = 1
        Position.RowIndex = 1
      end
      object Prece: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Prece'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        VisibleForCustomization = False
        Width = 65
        Position.BandIndex = 2
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object MarginPercentDeltaMin: TcxGridDBBandedColumn
        DataBinding.FieldName = 'MarginPercentDeltaMin'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '+,0.00 %;-,0.00 %; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        VisibleForCustomization = False
        Width = 65
        Position.BandIndex = 2
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object PreceNull: TcxGridDBBandedColumn
        DataBinding.FieldName = 'PreceNull'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        Visible = False
        VisibleForCustomization = False
        Width = 65
        Position.BandIndex = 2
        Position.ColIndex = 0
        Position.RowIndex = 1
      end
      object MarginPercentDeltaMax: TcxGridDBBandedColumn
        DataBinding.FieldName = 'MarginPercentDeltaMax'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '+,0.00 %;-,0.00 %; ;'
        Visible = False
        VisibleForCustomization = False
        Width = 65
        Position.BandIndex = 2
        Position.ColIndex = 1
        Position.RowIndex = 1
      end
      object ColorMin: TcxGridDBBandedColumn
        DataBinding.FieldName = 'ColorMin'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Position.BandIndex = 2
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object ColorMax: TcxGridDBBandedColumn
        DataBinding.FieldName = 'ColorMax'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Position.BandIndex = 2
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBBandedTableView
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
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      Category = 0
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      Visible = ivAlways
      ImageIndex = 1
      ShortCut = 115
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
      FormName = 'TDataDialogForm'
      FormNameParam.Value = 'TDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpReport_CompetitorMarkups'
    DataSet = CompetitorCDS
    DataSets = <
      item
        DataSet = CompetitorCDS
      end
      item
        DataSet = ClientDataSet
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inOperDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 64
    Top = 296
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 800
    Top = 8
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 352
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
    Left = 440
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
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 392
    Top = 304
  end
  object CompetitorCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 304
    Top = 304
  end
  object CrossDBViewReportAddOn: TCrossDBViewReportAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorColumn = MarginPercentDeltaMin
        BackGroundValueColumn = ColorMin
        ColorValueList = <>
      end
      item
        ColorColumn = MarginPercentDeltaMax
        BackGroundValueColumn = ColorMax
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    MultiplyColumnList = <>
    TemplateColumnList = <
      item
        HeaderColumnName = 'PriceName'
        TemplateColumn = Prece
      end
      item
        HeaderColumnName = 'MarginPercentDeltaMinName'
        TemplateColumn = MarginPercentDeltaMin
      end
      item
        HeaderColumnName = 'PriceNilName'
        TemplateColumn = PreceNull
      end
      item
        HeaderColumnName = 'MarginPercentDeltaMaxName'
        TemplateColumn = MarginPercentDeltaMax
      end>
    HeaderDataSet = CompetitorCDS
    BаndColumnName = 'CompetitorName'
    Left = 512
    Top = 208
  end
end
