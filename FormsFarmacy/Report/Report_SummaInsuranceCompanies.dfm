inherited Report_SummaInsuranceCompaniesForm: TReport_SummaInsuranceCompaniesForm
  Caption = #1054#1090#1095#1077#1090' '#1055#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1089#1090#1088#1072#1093#1086#1074#1099#1084' '#1082#1086#1084#1087#1072#1085#1080#1103#1084' '#1076#1083#1103' '#1079'/'#1087' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1072#1084
  ClientHeight = 432
  ClientWidth = 620
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 636
  ExplicitHeight = 471
  PixelsPerInch = 96
  TextHeight = 13
  object DataPanel: TPanel [0]
    Left = 0
    Top = 0
    Width = 620
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 777
    object edDateStart: TcxDateEdit
      Left = 60
      Top = 6
      EditValue = 43831d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 89
    end
    object cxLabel2: TcxLabel
      Left = 7
      Top = 7
      Caption = #1044#1072#1090#1072' '#1089' :'
    end
  end
  object deEnd: TcxDateEdit [1]
    Left = 58
    Top = 33
    EditValue = 43831d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object cxLabel7: TcxLabel [2]
    Left = 4
    Top = 33
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxGrid: TcxGrid [3]
    Left = 0
    Top = 91
    Width = 620
    Height = 341
    Align = alClient
    TabOrder = 4
    ExplicitWidth = 777
    ExplicitHeight = 489
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = MasterDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.##'
          Kind = skSum
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SummSale
        end
        item
          Format = ',0.##'
          Kind = skSum
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = UnitName
        end
        item
          Format = ',0.##'
          Kind = skSum
        end
        item
          Format = ',0.##'
          Kind = skSum
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SummSale
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsBehavior.FocusCellOnCycle = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.DataRowSizing = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object JuridicalMainName: TcxGridDBColumn
        Caption = #1070#1088'.'#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalMainName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 141
      end
      object UnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'UnitName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 271
      end
      object SummSale: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072
        DataBinding.FieldName = 'SummSale'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 142
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxLabel6: TcxLabel [4]
    Left = 155
    Top = 7
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object edUnit: TcxButtonEdit [5]
    Left = 251
    Top = 6
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 349
  end
  object cxLabel1: TcxLabel [6]
    Left = 155
    Top = 33
    Caption = #1070#1088'. '#1083#1080#1094#1086' ('#1085#1072#1096#1077'):'
  end
  object edJuridical: TcxButtonEdit [7]
    Left = 251
    Top = 33
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 349
  end
  object MasterCDS: TClientDataSet [8]
    Aggregates = <>
    Params = <>
    Left = 400
    Top = 247
  end
  object RefreshDispatcher: TRefreshDispatcher [9]
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ShowDialogAction = ExecuteDialog
    ComponentList = <
      item
        Component = GuidesUnit
      end
      item
        Component = GuidesJuridicalOur
      end
      item
        Component = PeriodChoice
      end>
    Left = 48
    Top = 160
  end
  object ChildDBViewAddOn: TdsdDBViewAddOn [10]
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
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
    Left = 448
    Top = 160
  end
  inherited cxPropertiesStore: TcxPropertiesStore [11]
    Components = <
      item
        Component = edDateStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = deEnd
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
    Left = 24
  end
  inherited ActionList: TActionList [12]
    Images = dmMain.ImageList
    Left = 127
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
    end
    object GridToExcel: TdsdGridToExcel
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
      FormName = 'TReport_SummaInsuranceCompaniesDialogForm'
      FormNameParam.Value = 'TReport_SummaInsuranceCompaniesDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 43831d
          Component = edDateStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43831d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalOurId'
          Value = ''
          Component = GuidesJuridicalOur
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalOurName'
          Value = ''
          Component = GuidesJuridicalOur
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
  object GuidesUnit: TdsdGuides [13]
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 432
    Top = 16
  end
  object GuidesJuridicalOur: TdsdGuides [14]
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridicalCorporateForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalCorporateForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridicalOur
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridicalOur
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 40
  end
  object PeriodChoice: TPeriodChoice [15]
    DateStart = edDateStart
    DateEnd = deEnd
    Left = 247
    Top = 255
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn [16]
    Left = 75
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'JuridicalId_1'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName_1'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId_2'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName_2'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId_3'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName_3'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId_1'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName_1'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId_2'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName_2'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId_3'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName_3'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 182
    Top = 159
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_SummaInsuranceCompanies'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 0d
        Component = edDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalOurId'
        Value = ''
        Component = GuidesJuridicalOur
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 336
    Top = 183
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
    Left = 54
    Top = 215
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar: TdxBar
      AllowClose = False
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 409
      FloatTop = 390
      FloatClientWidth = 51
      FloatClientHeight = 93
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
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
    object bbPrint: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbGridToExel: TdxBarButton
      Action = GridToExcel
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 478
    Top = 231
  end
end
