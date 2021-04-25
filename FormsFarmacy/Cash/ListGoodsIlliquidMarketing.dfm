inherited ListGoodsIlliquidMarketingForm: TListGoodsIlliquidMarketingForm
  BorderIcons = [biSystemMenu]
  Caption = #1053#1077#1083#1077#1082#1074#1080#1076#1099' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102
  ClientHeight = 411
  ClientWidth = 1029
  OnDestroy = ParentFormDestroy
  AddOnFormData.isFreeAtClosing = True
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1045
  ExplicitHeight = 450
  PixelsPerInch = 96
  TextHeight = 13
  object Label12: TLabel [0]
    Left = 786
    Top = 4
    Width = 68
    Height = 13
    Align = alCustom
    Caption = #1053#1077#1083#1077#1082#1074#1080#1076#1099':  '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object ListGoodsIlliquidMarketingGrid: TcxGrid [1]
    Left = 0
    Top = 28
    Width = 1029
    Height = 383
    Align = alClient
    TabOrder = 0
    object ListGoodsIlliquidMarketingGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ListGoodsIlliquidMarketingDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = GoodsName
        end
        item
          Format = ',0.###;-,0.###; ;'
          Kind = skSum
          Column = AmountCheck
        end
        item
          Format = ',0.###;-,0.###; ;'
          Kind = skSum
          Column = DeferredSend
        end
        item
          Format = ',0.###;-,0.###; ;'
          Kind = skSum
          Column = Remains
        end
        item
          Format = ',0.##;-,0.##; ;'
          Kind = skSum
          Column = SummaCheck
        end
        item
          Format = ',0.###;-,0.###; ;'
          Kind = skSum
          Column = AmountReserve
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GridLineColor = clBtnFace
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 55
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 177
      end
      object ExpirationDate: TcxGridDBColumn
        Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
        DataBinding.FieldName = 'ExpirationDate'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 74
      end
      object Price: TcxGridDBColumn
        Caption = #1062#1077#1085#1072
        DataBinding.FieldName = 'Price'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 86
      end
      object DeferredSend: TcxGridDBColumn
        Caption = #1042' '#1086#1090#1083#1086#1078'. '#1087#1077#1088#1077#1084#1077#1097'.'
        DataBinding.FieldName = 'DeferredSend'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.###;-,0.###; ;'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 77
      end
      object AmountReserve: TcxGridDBColumn
        Caption = #1042' '#1042#1048#1055' '#1095#1077#1082#1072#1093
        DataBinding.FieldName = 'AmountReserve'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.###;-,0.###; ;'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 71
      end
      object Remains: TcxGridDBColumn
        Caption = #1054#1089#1090#1072#1090#1086#1082
        DataBinding.FieldName = 'Remains'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.###;-,0.###; ;'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object AmountCheck: TcxGridDBColumn
        Caption = #1042' '#1095#1077#1082
        DataBinding.FieldName = 'AmountCheck'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.###;-,0.###; ;'
        HeaderAlignmentHorz = taCenter
        Styles.Content = dmMain.cxHeaderL1Style
      end
      object SummaCheck: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072
        DataBinding.FieldName = 'SummaCheck'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 66
      end
      object PartionDateKindName: TcxGridDBColumn
        Caption = #1058#1080#1087' '#1089#1088#1086#1082#1072
        DataBinding.FieldName = 'PartionDateKindName'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 126
      end
      object CheckList: TcxGridDBColumn
        Caption = #1053#1086#1084#1077#1088' '#1042#1048#1055' '#1095#1077#1082#1072
        DataBinding.FieldName = 'CheckList'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 129
      end
    end
    object ListGoodsIlliquidMarketingGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = ListGoodsIlliquidMarketingGridDBTableView
    end
  end
  object edIlliquidAssets: TcxCurrencyEdit [2]
    Left = 847
    Top = 65
    Properties.DisplayFormat = ',0.00;-,0.00'
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 74
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 304
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 320
    Top = 304
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    Left = 183
    Top = 279
    inherited actRefresh: TdsdDataSetRefresh
      BeforeAction = actCheckSumm
      StoredProc = spListGoodsIlliquidMarketing
      StoredProcList = <
        item
          StoredProc = spListGoodsIlliquidMarketing
        end>
      ShortCut = 0
    end
    object actSend: TAction
      Caption = #1054#1087#1091#1089#1090#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1086#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1074' '#1095#1077#1082
      Hint = #1054#1087#1091#1089#1090#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1086#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1074' '#1095#1077#1082
      ImageIndex = 30
      OnExecute = actSendExecute
    end
    object actClear: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1074#1089#1077' '#1074#1074#1077#1076#1077#1085#1085#1099#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1074#1089#1077' '#1074#1074#1077#1076#1077#1085#1085#1099#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072
      ImageIndex = 77
      OnExecute = actClearExecute
    end
    object actExportExel: TdsdGridToExcel
      MoveParams = <>
      Grid = ListGoodsIlliquidMarketingGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actAddOne: TAction
      Caption = 'actAddOne'
      OnExecute = actAddOneExecute
    end
    object actCheckSumm: TAction
      Caption = 'actCheckSumm'
      OnExecute = actCheckSummExecute
    end
  end
  object ListGoodsIlliquidMarketingDS: TDataSource
    DataSet = ListGoodsIlliquidMarketingCDS
    Left = 528
    Top = 136
  end
  object ListGoodsIlliquidMarketingCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    AfterOpen = ListGoodsIlliquidMarketingCDSAfterOpen
    BeforePost = ListGoodsIlliquidMarketingCDSBeforePost
    Left = 360
    Top = 136
  end
  object BarManager: TdxBarManager
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
    Left = 64
    Top = 64
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      28
      0)
    object dxBarManager1Bar1: TdxBar
      Caption = 'Custom 1'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 613
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
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
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
          ItemName = 'bbClear'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbExportExel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem2'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarButton1: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100' '#1080#1079' '#1083#1080#1089#1090#1072' '#1086#1090#1082#1072#1079#1086#1074
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100' '#1080#1079' '#1083#1080#1089#1090#1072' '#1086#1090#1082#1072#1079#1086#1074
      Visible = ivAlways
      ImageIndex = 52
      ShortCut = 46
    end
    object cxBarEditItem1: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxSpinEditProperties'
    end
    object dxBarButton2: TdxBarButton
      Action = actSend
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Category = 0
      Visible = ivAlways
    end
    object dxBarStatic1: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object bbClear: TdxBarButton
      Action = actClear
      Category = 0
    end
    object bbExportExel: TdxBarButton
      Action = actExportExel
      Category = 0
    end
    object dxBarContainerItem1: TdxBarContainerItem
      Caption = 'New Item'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = Label12
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edIlliquidAssets
    end
  end
  object spListGoodsIlliquidMarketing: TdsdStoredProc
    StoredProcName = 'gpSelect_CashGoodsIlliquid'
    DataSet = ListGoodsIlliquidMarketingCDS
    DataSets = <
      item
        DataSet = ListGoodsIlliquidMarketingCDS
      end>
    Params = <>
    PackSize = 1
    Left = 64
    Top = 144
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = ListGoodsIlliquidMarketingGridDBTableView
    OnDblClickActionList = <
      item
        Action = actAddOne
      end>
    ActionItemList = <>
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 432
    Top = 232
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'IlliquidAssets'
        Value = Null
        Component = edIlliquidAssets
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 728
    Top = 152
  end
end
