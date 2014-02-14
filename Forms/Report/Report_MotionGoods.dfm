object Report_MotionGoodsForm: TReport_MotionGoodsForm
  Left = 0
  Top = 0
  Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
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
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 113
    Width = 1329
    Height = 282
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
          Kind = skSum
          Position = spFooter
          Column = StartCount
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Kind = skSum
          Position = spFooter
          Column = IncomeCount
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
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
          Column = EndCount
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
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = StartCount_Sh
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = StartCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = StartSumm
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = IncomeCount_Sh
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = IncomeCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = IncomeSumm
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SendInCount_Sh
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SendInCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SendInSumm
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SendOutCount_Sh
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SendOutCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SendOutSumm
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SaleCount_Sh
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SaleCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SaleSumm
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = ReturnOutCount_Sh
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = ReturnOutCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = ReturnOutSumm
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = ReturnInCount_Sh
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = ReturnInCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = ReturnInSumm
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = LossCount_Sh
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = LossCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = LossSumm
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = InventoryCount_Sh
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = InventoryCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = InventorySumm
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = EndCount_Sh
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = EndCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = EndSumm
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
          Format = ',0.##'
          Kind = skSum
          Column = StartCount
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = EndCount
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = StartSumm
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.##'
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
          Column = EndCount
        end
        item
          Format = ',0.##'
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
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = StartCount_Sh
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = IncomeCount_Sh
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = IncomeCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SendInCount_Sh
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SendInCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SendInSumm
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SendOutCount_Sh
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SendOutCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SendOutSumm
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SaleCount_Sh
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SaleCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SaleSumm
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = ReturnOutCount_Sh
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = ReturnOutCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = ReturnOutSumm
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = ReturnInCount_Sh
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = ReturnInCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = ReturnInSumm
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = LossCount_Sh
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = LossCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = LossSumm
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = InventoryCount_Sh
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = InventoryCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = InventorySumm
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = EndCount_Sh
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
      object LocationName: TcxGridDBColumn
        Caption = #1040#1085#1072#1083#1080#1090#1080#1082#1072'-'#1084#1077#1089#1090#1086
        DataBinding.FieldName = 'LocationName'
        Width = 39
      end
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        Width = 20
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        Width = 40
      end
      object GoodsKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsKindName'
        Width = 22
      end
      object PartionGoodsName: TcxGridDBColumn
        Caption = #1055#1072#1088#1090#1080#1103' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'PartionGoodsName'
        Width = 29
      end
      object AssetName: TcxGridDBColumn
        Caption = #1054#1057' ('#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1058#1052#1062')'
        DataBinding.FieldName = 'AssetName'
        Width = 42
      end
      object MeasureName: TcxGridDBColumn
        Caption = #1045#1076'.'#1080#1079#1084'.'
        DataBinding.FieldName = 'MeasureName'
        Width = 39
      end
      object Weight: TcxGridDBColumn
        Caption = #1042#1077#1089
        DataBinding.FieldName = 'Weight'
        Width = 28
      end
      object StartCount_Sh: TcxGridDBColumn
        Caption = #1053#1072#1095'.'#1086#1089#1090', '#1096#1090
        DataBinding.FieldName = 'StartCount_Sh'
        HeaderAlignmentHorz = taRightJustify
        Width = 33
      end
      object StartCount: TcxGridDBColumn
        Caption = #1053#1072#1095'.'#1086#1089#1090', '#1082#1075
        DataBinding.FieldName = 'StartCount'
        HeaderAlignmentHorz = taRightJustify
        Width = 33
      end
      object StartSumm: TcxGridDBColumn
        Caption = #1053#1072#1095'.'#1086#1089#1090', '#1075#1088#1085
        DataBinding.FieldName = 'StartSumm'
        HeaderAlignmentHorz = taRightJustify
        Width = 33
      end
      object IncomeCount_Sh: TcxGridDBColumn
        Caption = #1055#1088#1080#1093#1086#1076', '#1096#1090
        DataBinding.FieldName = 'IncomeCount_Sh'
        HeaderAlignmentHorz = taRightJustify
        Width = 33
      end
      object IncomeCount: TcxGridDBColumn
        Caption = #1055#1088#1080#1093#1086#1076', '#1082#1075
        DataBinding.FieldName = 'IncomeCount'
        HeaderAlignmentHorz = taCenter
        Width = 33
      end
      object IncomeSumm: TcxGridDBColumn
        Caption = #1055#1088#1080#1093#1086#1076', '#1075#1088#1085
        DataBinding.FieldName = 'IncomeSumm'
        Width = 33
      end
      object SendInCount_Sh: TcxGridDBColumn
        DataBinding.FieldName = 'SendInCount_Sh'
        FooterAlignmentHorz = taRightJustify
        Width = 33
      end
      object SendInCount: TcxGridDBColumn
        DataBinding.FieldName = 'SendInCount'
        Width = 33
      end
      object SendInSumm: TcxGridDBColumn
        DataBinding.FieldName = 'SendInSumm'
        Width = 33
      end
      object SendOutCount_Sh: TcxGridDBColumn
        DataBinding.FieldName = 'SendOutCount_Sh'
        HeaderAlignmentHorz = taRightJustify
        Width = 33
      end
      object SendOutCount: TcxGridDBColumn
        DataBinding.FieldName = 'SendOutCount'
        Width = 33
      end
      object SendOutSumm: TcxGridDBColumn
        DataBinding.FieldName = 'SendOutSumm'
        Width = 33
      end
      object SaleCount_Sh: TcxGridDBColumn
        Caption = #1055#1088#1086#1076#1072#1085#1086', '#1096#1090
        DataBinding.FieldName = 'SaleCount_Sh'
        Width = 33
      end
      object SaleCount: TcxGridDBColumn
        Caption = #1055#1088#1086#1076#1072#1085#1086', '#1082#1075
        DataBinding.FieldName = 'SaleCount'
        Width = 33
      end
      object SaleSumm: TcxGridDBColumn
        Caption = #1055#1088#1086#1076#1072#1085#1086', '#1075#1088#1085
        DataBinding.FieldName = 'SaleSumm'
        Width = 33
      end
      object ReturnOutCount_Sh: TcxGridDBColumn
        DataBinding.FieldName = 'ReturnOutCount_Sh'
        Width = 33
      end
      object ReturnOutCount: TcxGridDBColumn
        DataBinding.FieldName = 'ReturnOutCount'
        Width = 33
      end
      object ReturnOutSumm: TcxGridDBColumn
        DataBinding.FieldName = 'ReturnOutSumm'
        Width = 33
      end
      object ReturnInCount_Sh: TcxGridDBColumn
        Caption = #1042#1086#1079#1074#1088#1072#1090' ('#1087#1086#1082#1091#1087'), '#1096#1090
        DataBinding.FieldName = 'ReturnInCount_Sh'
        Width = 33
      end
      object ReturnInCount: TcxGridDBColumn
        Caption = #1042#1086#1079#1074#1088#1072#1090' ('#1087#1086#1082#1091#1087'), '#1082#1075
        DataBinding.FieldName = 'ReturnInCount'
        Width = 33
      end
      object ReturnInSumm: TcxGridDBColumn
        Caption = #1042#1086#1079#1074#1088#1072#1090' ('#1087#1086#1082#1091#1087'), '#1075#1088#1085
        DataBinding.FieldName = 'ReturnInSumm'
        Width = 33
      end
      object LossCount_Sh: TcxGridDBColumn
        Caption = #1057#1087#1080#1089#1072#1085#1086', '#1096#1090
        DataBinding.FieldName = 'LossCount_Sh'
        Width = 33
      end
      object LossCount: TcxGridDBColumn
        Caption = #1057#1087#1080#1089#1072#1085#1086', '#1082#1075
        DataBinding.FieldName = 'LossCount'
        Width = 33
      end
      object LossSumm: TcxGridDBColumn
        Caption = #1057#1087#1080#1089#1072#1085#1086', '#1075#1088#1085
        DataBinding.FieldName = 'LossSumm'
        Width = 33
      end
      object InventoryCount_Sh: TcxGridDBColumn
        Caption = #1048#1085#1074#1077#1085#1090', '#1096#1090
        DataBinding.FieldName = 'InventoryCount_Sh'
        Width = 33
      end
      object InventoryCount: TcxGridDBColumn
        Caption = #1048#1085#1074#1077#1085#1090', '#1082#1075
        DataBinding.FieldName = 'InventoryCount'
        Width = 33
      end
      object InventorySumm: TcxGridDBColumn
        Caption = #1048#1085#1074#1077#1085#1090', '#1075#1088#1085
        DataBinding.FieldName = 'InventorySumm'
        Width = 33
      end
      object EndCount_Sh: TcxGridDBColumn
        Caption = #1050#1086#1085'. '#1086#1089#1090', '#1096#1090
        DataBinding.FieldName = 'EndCount_Sh'
        Width = 33
      end
      object EndCount: TcxGridDBColumn
        Caption = #1050#1086#1085'. '#1086#1089#1090', '#1082#1075
        DataBinding.FieldName = 'EndCount'
        Width = 33
      end
      object EndSumm: TcxGridDBColumn
        Caption = #1050#1086#1085'. '#1086#1089#1090', '#1075#1088#1085
        DataBinding.FieldName = 'EndSumm'
        Width = 33
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
    Height = 87
    Align = alTop
    TabOrder = 5
    ExplicitLeft = -56
    ExplicitTop = 50
    object edGoodsGroup: TcxButtonEdit
      Left = 721
      Top = 9
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 0
      Width = 192
    end
    object deStart: TcxDateEdit
      Left = 16
      Top = 8
      EditValue = 41579d
      Properties.ShowTime = False
      TabOrder = 2
      Width = 121
    end
    object deEnd: TcxDateEdit
      Left = 176
      Top = 8
      EditValue = 41608d
      Properties.ShowTime = False
      TabOrder = 4
      Width = 121
    end
    object edUnitGroup: TcxButtonEdit
      Left = 422
      Top = 10
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 1
      Width = 203
    end
    object cxLabel3: TcxLabel
      Left = 316
      Top = 10
      Caption = #1043#1088'.'#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
    end
    object cxLabel1: TcxLabel
      Left = 651
      Top = 10
      Caption = #1043#1088'.'#1090#1086#1074#1072#1088#1072
    end
    object cxLabel2: TcxLabel
      Left = 673
      Top = 50
      Caption = #1058#1086#1074#1072#1088
    end
    object edGoods: TcxButtonEdit
      Left = 721
      Top = 50
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 192
    end
    object edLocation: TcxButtonEdit
      Left = 422
      Top = 50
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Width = 203
    end
    object cxLabel4: TcxLabel
      Left = 355
      Top = 50
      Caption = #1040#1085#1072#1083#1080#1090#1080#1082#1072
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 56
    Top = 64
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 88
    Top = 184
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
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
    Top = 232
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
    Left = 144
    Top = 24
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 2
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
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
      Action = ExecuteDialog
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 256
    Top = 232
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
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      Caption = #1044#1080#1072#1083#1086#1075' '#1091#1089#1090#1072#1085#1086#1074#1082#1080' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074
      Hint = #1044#1080#1072#1083#1086#1075' '#1091#1089#1090#1072#1085#1086#1074#1082#1080' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074
      ImageIndex = 35
      FormName = 'TReport_MotionGoodsDialogForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41579d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'EndDate'
          Value = 41608d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'GoodsId'
          Value = ''
          Component = GoodsGuides
          ComponentItem = 'Key'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GoodsGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'GoodsGroupId'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'Key'
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end
        item
          Name = 'UnitGroupId'
          Value = ''
          Component = UnitGroupGuides
          ComponentItem = 'Key'
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = UnitGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = LocationGuides
          ComponentItem = 'Key'
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = LocationGuides
          ComponentItem = 'Key'
          DataType = ftString
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpReport_MotionGoods'
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
        Value = 41608d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inUnitGroupId'
        Value = ''
        Component = UnitGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inLocationId'
        Value = ''
        Component = LocationGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 152
    Top = 176
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    Left = 216
    Top = 264
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 344
    Top = 272
  end
  object GoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroupForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 776
    Top = 32
  end
  object LocationGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLocation
    FormNameParam.Value = 'TUnitCarMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnitCarMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = LocationGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = LocationGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 472
    Top = 72
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 200
    Top = 64
  end
  object UnitGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitGroup
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 464
    Top = 24
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 736
    Top = 67
  end
  object RefreshDispatcher: TRefreshDispatcher
    RefreshAction = actRefresh
    ShowDialogAction = ExecuteDialog
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = UnitGroupGuides
      end
      item
        Component = LocationGuides
      end
      item
        Component = GoodsGroupGuides
      end
      item
        Component = GoodsGuides
      end>
    Left = 288
    Top = 64
  end
end
