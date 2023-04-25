inherited GoodsInventoryForm: TGoodsInventoryForm
  Caption = #1042#1099#1073#1086#1088' '#1090#1086#1074#1072#1088#1072
  ClientHeight = 503
  ClientWidth = 614
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  AddOnFormData.Params = FormParams
  ExplicitWidth = 632
  ExplicitHeight = 550
  PixelsPerInch = 96
  TextHeight = 13
  object GoodsInventoryGrid: TcxGrid [0]
    Left = 0
    Top = 52
    Width = 614
    Height = 451
    Align = alClient
    TabOrder = 1
    object GoodsInventoryGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = GoodsInventoryDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = colGoodsName
        end
        item
          Format = ',0.###;-,0.###; ;'
          Kind = skSum
        end
        item
          Format = ',0.###;-,0.###; ;'
          Kind = skSum
          Column = colRemains
        end
        item
          Format = ',0.###;-,0.###; ;'
          Kind = skSum
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
      object colGoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object colGoodsName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 447
      end
      object colRemains: TcxGridDBColumn
        Caption = #1054#1089#1090#1072#1090#1086#1082
        DataBinding.FieldName = 'Remains'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.###;-,0.###; ;'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 70
      end
      object cplcolor_calc: TcxGridDBColumn
        DataBinding.FieldName = 'color_calc'
        Visible = False
        VisibleForCustomization = False
      end
    end
    object GoodsInventoryGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = GoodsInventoryGridDBTableView
    end
  end
  object pnl1: TPanel [1]
    Left = 0
    Top = 27
    Width = 614
    Height = 25
    Align = alTop
    TabOrder = 0
    object TextEdit: TcxTextEdit
      Left = 1
      Top = 1
      Align = alClient
      TabOrder = 0
      DesignSize = (
        612
        23)
      Width = 612
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 304
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    Left = 280
    Top = 304
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    Left = 183
    Top = 303
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = GoodsInventoryCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = GoodsInventoryCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = GoodsInventoryCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'BarCode'
          Value = Null
          Component = GoodsInventoryCDS
          ComponentItem = 'BarCode'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
    end
  end
  object GoodsInventoryDS: TDataSource
    DataSet = GoodsInventoryCDS
    Left = 312
    Top = 144
  end
  object GoodsInventoryCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'GoodsName'
    Params = <>
    StoreDefs = True
    Left = 176
    Top = 144
  end
  object BarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
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
    Top = 112
    DockControlHeights = (
      0
      0
      27
      0)
    object Bar: TdxBar
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
          ItemName = 'dxBarButton1'
        end
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
      Left = 280
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
      Left = 208
      Top = 65528
    end
    object bbGridToExcel: TdxBarButton
      Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1072'  '#1087#1086' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072#1084' '#1042#1057#1045#1061' '#1055#1054#1057#1058#1040#1042#1065#1048#1050#1054#1042
      Category = 0
      Hint = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1072'  '#1087#1086' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072#1084' '#1042#1057#1045#1061' '#1055#1054#1057#1058#1040#1042#1065#1048#1050#1054#1042
      Visible = ivAlways
      ImageIndex = 65
      Lowered = True
      PaintStyle = psCaptionGlyph
      Left = 232
    end
    object bbOpen: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      Left = 160
    end
    object dxBarButton1: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
  end
  object spSelect: TdsdStoredProcSQLite
    DataSet = GoodsInventoryCDS
    DataSets = <
      item
        DataSet = GoodsInventoryCDS
      end>
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    SQLList = <
      item
        SQL.Strings = (
          'SELECT G.Id             AS GoodsId'
          '     , G.Code           AS GoodsCode'
          '     , G.Name           AS GoodsName'
          '     , G.BarCode        AS BarCode'
          '     , G.isErased       AS isErased'
          '     , G.color_calc     AS color_calc '
          '     , R.Remains        AS Remains'
          'FROM Goods AS G'
          '     LEFT JOIN Remains AS R ON R.GoodsId = G.Id'
          '                           AND R.UnitId = :inUnitId'
          'ORDER BY G.Name')
      end>
    Left = 429
    Top = 145
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UnitId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 64
    Top = 224
  end
  object FieldFilter: TdsdFieldFilter
    TextEdit = TextEdit
    DataSet = GoodsInventoryCDS
    Column = colGoodsName
    ColumnList = <
      item
        Column = colGoodsName
      end
      item
        Column = colGoodsCode
      end>
    CheckBoxList = <>
    Left = 432
    Top = 216
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = GoodsInventoryGridDBTableView
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        BackGroundValueColumn = cplcolor_calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 424
    Top = 296
  end
end
