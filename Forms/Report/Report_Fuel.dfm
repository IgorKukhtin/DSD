inherited Report_FuelForm: TReport_FuelForm
  Caption = #1056#1072#1089#1093#1086#1076' '#1090#1086#1087#1083#1080#1074#1072
  ClientHeight = 395
  ClientWidth = 1329
  ExplicitLeft = -537
  ExplicitTop = -74
  ExplicitWidth = 1337
  ExplicitHeight = 429
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 65
    Width = 1329
    Height = 330
    Align = alClient
    TabOrder = 0
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = StartAmount
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = IncomeAmount
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = StartSumm
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = IncomeSumm
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = EndAmount
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = EndSumm
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Position = spFooter
        end
        item
          Format = ',0.00'
          Position = spFooter
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
          Column = StartAmount
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = EndAmount
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = StartSumm
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = IncomeSumm
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
          Column = EndAmount
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = EndSumm
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
        end
        item
          Format = ',0.00'
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.Footer = True
      OptionsView.GroupFooters = gfAlwaysVisible
      OptionsView.HeaderAutoHeight = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object CarCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'CarCode'
        HeaderAlignmentVert = vaCenter
        Width = 30
      end
      object CarName: TcxGridDBColumn
        Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
        DataBinding.FieldName = 'CarName'
        HeaderAlignmentVert = vaCenter
        Width = 42
      end
      object FuelCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1090#1086#1087#1083#1080#1074#1072
        DataBinding.FieldName = 'FuelCode'
        HeaderAlignmentVert = vaCenter
        Width = 22
      end
      object FuelName: TcxGridDBColumn
        Caption = #1058#1086#1087#1083#1080#1074#1086
        DataBinding.FieldName = 'FuelName'
        HeaderAlignmentVert = vaCenter
        Width = 30
      end
      object StartAmount: TcxGridDBColumn
        Caption = #1053#1072#1095'. '#1086#1089#1090'. '#1082#1086#1083'.'
        DataBinding.FieldName = 'StartAmount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taRightJustify
        HeaderAlignmentVert = vaCenter
        Width = 44
      end
      object StartSumm: TcxGridDBColumn
        Caption = #1053#1072#1095'. '#1086#1089#1090'.  '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'StartSumm'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taRightJustify
        HeaderAlignmentVert = vaCenter
        Width = 44
      end
      object IncomeAmount: TcxGridDBColumn
        Caption = #1055#1088#1080#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'IncomeAmount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 29
      end
      object IncomeSumm: TcxGridDBColumn
        Caption = #1055#1088#1080#1093#1086#1076' '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'IncomeSumm'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object RateAmount: TcxGridDBColumn
        Caption = #1056#1072#1089#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'RateAmount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.AssignedValues.DisplayFormat = True
        HeaderAlignmentVert = vaCenter
        Width = 29
      end
      object RateSumm: TcxGridDBColumn
        Caption = #1056#1072#1089#1093#1086#1076' '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'RateSumm'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object EndAmount: TcxGridDBColumn
        Caption = #1050#1086#1085'. '#1086#1089#1090'. '#1082#1086#1083'.'
        DataBinding.FieldName = 'EndAmount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentVert = vaCenter
        Width = 44
      end
      object EndSumm: TcxGridDBColumn
        Caption = #1050#1086#1085'. '#1086#1089#1090'. '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'EndSumm'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1329
    Height = 39
    Align = alTop
    TabOrder = 5
    object deStart: TcxDateEdit
      Left = 101
      Top = 10
      EditValue = 41395d
      Properties.ShowTime = False
      TabOrder = 0
      Width = 81
    end
    object deEnd: TcxDateEdit
      Left = 299
      Top = 11
      EditValue = 41395d
      Properties.ShowTime = False
      TabOrder = 1
      Width = 87
    end
    object cxLabel2: TcxLabel
      Left = 601
      Top = 12
      Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
    end
    object edCar: TcxButtonEdit
      Left = 672
      Top = 10
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 3
      Width = 161
    end
    object cxLabel4: TcxLabel
      Left = 398
      Top = 12
      Caption = #1042#1080#1076' '#1090#1086#1087#1083#1080#1074#1072
    end
    object ceFuel: TcxButtonEdit
      Left = 472
      Top = 10
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 124
    end
    object cxLabel1: TcxLabel
      Left = 9
      Top = 10
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel3: TcxLabel
      Left = 187
      Top = 11
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 144
    Top = 160
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 64
    Top = 272
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
    Left = 8
    Top = 64
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 72
    Top = 64
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
      FloatLeft = 298
      FloatTop = 240
      FloatClientWidth = 51
      FloatClientHeight = 71
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbDialogForm'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbToExcel'
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
    object bbDialogForm: TdxBarButton
      Caption = #1044#1080#1072#1083#1086#1075' '#1091#1089#1090#1072#1085#1086#1074#1082#1080' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074
      Category = 0
      Hint = #1044#1080#1072#1083#1086#1075' '#1091#1089#1090#1072#1085#1086#1074#1082#1080' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074
      Visible = ivAlways
      ImageIndex = 35
    end
    object bbPrint: TdxBarButton
      Action = dsdPrintAction
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 40
    Top = 64
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
    end
    object actExportToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object dsdPrintAction: TdsdPrintAction
      Category = 'DSDLib'
      StoredProcList = <>
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      Params = <
        item
          Name = 'PeriodStart'
          Value = 41395d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'PeriodEnd'
          Value = 41395d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'FuelBenzin'
          Value = '1'
        end
        item
          Name = 'FuelDizel'
          Value = '2'
        end
        item
          Name = 'FuelPropan'
          Value = '3'
        end
        item
          Name = 'FuelMetan'
          Value = '4'
        end>
      ReportName = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1088#1072#1089#1093#1086#1076#1072' '#1090#1086#1087#1083#1080#1074#1072
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpReport_Fuel'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inStartDate'
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        Value = 41395d
      end
      item
        Name = 'inEndDate'
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        Value = 41395d
      end
      item
        Name = 'inFuelId'
        Component = FuelGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inCarId'
        Component = CarGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end>
    Left = 432
    Top = 232
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    Left = 304
    Top = 296
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 112
    Top = 64
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 176
  end
  object CarGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCar
    FormName = 'TCarForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = CarGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'TextValue'
        Component = CarGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 640
    Top = 27
  end
  object RefreshDispatcher: TRefreshDispatcher
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = FuelGuides
      end
      item
        Component = CarGuides
      end>
    Left = 232
    Top = 65528
  end
  object frxDBDataset: TfrxDBDataset
    UserName = 'frxDBDataset'
    CloseDataSource = False
    DataSource = DataSource
    BCDToCurrency = False
    Left = 264
    Top = 200
  end
  object FuelGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceFuel
    FormName = 'TFuelForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = FuelGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'TextValue'
        Component = FuelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 431
    Top = 39
  end
end
