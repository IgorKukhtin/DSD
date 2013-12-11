object Report_HistoryCostForm: TReport_HistoryCostForm
  Left = 0
  Top = 0
  Caption = #1057#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1100
  ClientHeight = 395
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
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 67
    Width = 1329
    Height = 328
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
          Column = Price_Calc
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = CalcCount
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = StartCount
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = StartCount_calc
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = IncomeCount
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = IncomeCount_calc
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
          Column = StartSumm_calc
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
          Column = IncomeSumm_calc
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = OutCount_calc
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = OutSumm_calc
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = EndCount_calc
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = EndSumm_calc
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = OperCount
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Position = spFooter
          Column = OperPrice
        end
        item
          Format = ',0.00'
          Position = spFooter
          Column = Price
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.00'
          Kind = skSum
          Column = Price_Calc
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = CalcCount
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = StartCount
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = StartCount_calc
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = IncomeCount
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = IncomeCount_calc
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = StartSumm
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = StartSumm_calc
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = IncomeSumm
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = IncomeSumm_calc
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = OutCount_calc
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = OutSumm_calc
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = EndCount_calc
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = EndSumm_calc
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = OperCount
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Column = OperPrice
        end
        item
          Format = ',0.00'
          Column = Price
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
      object ObjectCostId: TcxGridDBColumn
        DataBinding.FieldName = 'ObjectCostId'
        HeaderAlignmentHorz = taCenter
        Width = 40
      end
      object MovementId: TcxGridDBColumn
        DataBinding.FieldName = 'MovementId'
        HeaderAlignmentHorz = taCenter
        Width = 40
      end
      object MovementItemId: TcxGridDBColumn
        DataBinding.FieldName = 'MovementItemId'
        HeaderAlignmentHorz = taCenter
        Width = 40
      end
      object ContainerId: TcxGridDBColumn
        DataBinding.FieldName = 'ContainerId'
        Width = 60
      end
      object OperDate: TcxGridDBColumn
        DataBinding.FieldName = 'OperDate'
        HeaderAlignmentHorz = taCenter
        Width = 45
      end
      object InvNumber: TcxGridDBColumn
        DataBinding.FieldName = 'InvNumber'
        HeaderAlignmentHorz = taCenter
        Width = 30
      end
      object MovementDescCode: TcxGridDBColumn
        DataBinding.FieldName = 'MovementDescCode'
        HeaderAlignmentHorz = taCenter
        Width = 80
      end
      object OperCount: TcxGridDBColumn
        DataBinding.FieldName = 'OperCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        Width = 40
      end
      object OperPrice: TcxGridDBColumn
        DataBinding.FieldName = 'OperPrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        Width = 30
      end
      object Price: TcxGridDBColumn
        DataBinding.FieldName = 'Price'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        Width = 30
      end
      object Price_Calc: TcxGridDBColumn
        DataBinding.FieldName = 'Price_Calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        Width = 30
      end
      object UnitParentName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
        DataBinding.FieldName = 'UnitParentName'
        Width = 70
      end
      object UnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'UnitName'
        Width = 70
      end
      object GoodsGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074
        DataBinding.FieldName = 'GoodsGroupName'
        Width = 70
      end
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        Width = 30
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        Width = 55
      end
      object GoodsKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsKindName'
        Width = 40
      end
      object InfoMoneyCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1057#1090'.'
        DataBinding.FieldName = 'InfoMoneyCode'
        Width = 40
      end
      object InfoMoneyName: TcxGridDBColumn
        Caption = #1057#1090#1072#1090#1100#1103
        DataBinding.FieldName = 'InfoMoneyName'
        Width = 70
      end
      object InfoMoneyCode_Detail: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1057#1090'-'#1076
        DataBinding.FieldName = 'InfoMoneyCode_Detail'
        Width = 40
      end
      object InfoMoneyName_Detail: TcxGridDBColumn
        Caption = #1057#1090#1072#1090#1100#1103' '#1076#1077#1090#1072#1083#1100#1085#1086
        DataBinding.FieldName = 'InfoMoneyName_Detail'
        Width = 70
      end
      object PartionGoodsName: TcxGridDBColumn
        Caption = #1055#1072#1088#1090#1080#1103' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'PartionGoodsName'
        Width = 50
      end
      object PersonalName: TcxGridDBColumn
        Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
        DataBinding.FieldName = 'PersonalName'
        Width = 50
      end
      object BusinessName: TcxGridDBColumn
        Caption = #1041#1080#1079#1085#1077#1089
        DataBinding.FieldName = 'BusinessName'
        Width = 70
      end
      object JuridicalBasisName: TcxGridDBColumn
        Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalBasisName'
        Width = 70
      end
      object BranchName: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083
        DataBinding.FieldName = 'BranchName'
        Width = 70
      end
      object AssetName: TcxGridDBColumn
        Caption = #1054#1057' ('#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1058#1052#1062')'
        DataBinding.FieldName = 'AssetName'
        Width = 50
      end
      object CalcCount: TcxGridDBColumn
        DataBinding.FieldName = 'CalcCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        Width = 30
      end
      object StartCount: TcxGridDBColumn
        DataBinding.FieldName = 'StartCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        Width = 75
      end
      object StartCount_calc: TcxGridDBColumn
        DataBinding.FieldName = 'StartCount_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        Width = 75
      end
      object IncomeCount: TcxGridDBColumn
        DataBinding.FieldName = 'IncomeCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        Width = 75
      end
      object IncomeCount_calc: TcxGridDBColumn
        DataBinding.FieldName = 'IncomeCount_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        Width = 75
      end
      object StartSumm: TcxGridDBColumn
        DataBinding.FieldName = 'StartSumm'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        Width = 75
      end
      object StartSumm_calc: TcxGridDBColumn
        DataBinding.FieldName = 'StartSumm_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        Width = 75
      end
      object IncomeSumm: TcxGridDBColumn
        DataBinding.FieldName = 'IncomeSumm'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        Width = 75
      end
      object IncomeSumm_calc: TcxGridDBColumn
        DataBinding.FieldName = 'IncomeSumm_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        Width = 75
      end
      object OutCount_calc: TcxGridDBColumn
        DataBinding.FieldName = 'OutCount_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        Width = 75
      end
      object OutSumm_calc: TcxGridDBColumn
        DataBinding.FieldName = 'OutSumm_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        Width = 75
      end
      object EndCount_calc: TcxGridDBColumn
        DataBinding.FieldName = 'EndCount_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        Width = 75
      end
      object EndSumm_calc: TcxGridDBColumn
        DataBinding.FieldName = 'EndSumm_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        Width = 75
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 26
    Width = 1329
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 5
    object deStart: TcxDateEdit
      Left = 208
      Top = 8
      EditValue = 41579d
      TabOrder = 0
      Width = 121
    end
    object deEnd: TcxDateEdit
      Left = 352
      Top = 8
      EditValue = 41579d
      TabOrder = 1
      Width = 121
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 96
    Top = 96
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 96
    Top = 144
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
    Left = 232
    Top = 96
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
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 152
    Top = 88
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
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 232
    Top = 144
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
      RefreshOnTabSetChanges = False
    end
    object actExportToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpReport_HistoryCost'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41579d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41579d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 152
    Top = 152
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    OnlyEditingCellOnEnter = False
    Left = 232
    Top = 192
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 232
    Top = 232
  end
end
