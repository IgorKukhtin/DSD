object SearchRemainsVIPForm: TSearchRemainsVIPForm
  Left = 0
  Top = 0
  Caption = #1055#1086#1080#1089#1082' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1086#1074' VIP'
  ClientHeight = 466
  ClientWidth = 788
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 26
    Width = 788
    Height = 31
    Align = alTop
    TabOrder = 0
    object edGoodsSearch: TcxTextEdit
      Left = 308
      Top = 3
      Hint = #1053#1072#1078#1084#1080#1090#1077' Ctrl+Enter '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072
      TabOrder = 0
      OnKeyDown = edSearchKeyDown
      Width = 190
    end
    object cxLabel2: TcxLabel
      Left = 11
      Top = 4
      Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1082#1086#1076#1091
    end
    object edCodeSearch: TcxTextEdit
      Left = 94
      Top = 3
      Hint = #1053#1072#1078#1084#1080#1090#1077' Enter '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072
      TabOrder = 2
      OnKeyDown = edSearchKeyDown
      Width = 101
    end
    object cxLabel1: TcxLabel
      Left = 202
      Top = 4
      Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1085#1072#1079#1074#1072#1085#1080#1102
    end
    object edUnit: TcxButtonEdit
      Left = 589
      Top = 3
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 184
    end
    object cxLabel4: TcxLabel
      Left = 504
      Top = 5
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 57
    Width = 788
    Height = 223
    Align = alClient
    ShowCaption = False
    TabOrder = 1
    object cxGrid: TcxGrid
      Left = 1
      Top = 1
      Width = 786
      Height = 221
      Align = alClient
      TabOrder = 0
      object cxGridDBTableView: TcxGridDBTableView
        OnDblClick = cxGridDBTableViewDblClick
        OnKeyDown = cxGridDBTableViewKeyDown
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = DataSource
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.KeyFieldNames = 'Id;UnitId'
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = ',0.00'
            Kind = skSum
            Column = colAmount
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
            Column = AmountReserve
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = ',0.00'
            Kind = skSum
            Column = colAmount
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
            Column = AmountReserve
          end
          item
            Format = ',0.####;-,0.####; ;'
            Kind = skSum
          end
          item
            Format = ',0.####;-,0.####; ;'
            Kind = skSum
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = colAmountSun
          end>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
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
        object AreaName: TcxGridDBColumn
          Caption = #1056#1077#1075#1080#1086#1085
          DataBinding.FieldName = 'AreaName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object colUnitName: TcxGridDBColumn
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          DataBinding.FieldName = 'UnitName'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 169
        end
        object colGoodsCode: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'GoodsCode'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
        object colGoodsName: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'GoodsName'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 208
        end
        object colNDS: TcxGridDBColumn
          Caption = #1053#1044#1057
          DataBinding.FieldName = 'NDS'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 0
          Properties.DisplayFormat = ',0 %'
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 101
        end
        object colAmount: TcxGridDBColumn
          Caption = #1054#1089#1090#1072#1090#1086#1082
          DataBinding.FieldName = 'Amount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 3
          Properties.DisplayFormat = ',0.000;-,0.000; ;'
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 98
        end
        object colAmountSun: TcxGridDBColumn
          Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1057#1059#1053' '#1091#1076#1072#1083#1077#1085#1085#1086#1077' '
          DataBinding.FieldName = 'AmountSun'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 3
          Properties.DisplayFormat = ',0.000;-,0.000; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 93
        end
        object colPriceSaleUnit: TcxGridDBColumn
          Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
          DataBinding.FieldName = 'PriceSaleUnit'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.00;-,0.00; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 77
        end
        object colPriceSale: TcxGridDBColumn
          Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080
          DataBinding.FieldName = 'PriceSale'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.00;-,0.00; ;'
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 85
        end
        object AmountReserve: TcxGridDBColumn
          Caption = #1054#1090#1083'. '#1090#1086#1074#1072#1088
          DataBinding.FieldName = 'AmountReserve'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.00;-,0.00; ;'
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1054#1090#1083#1086#1078#1077#1085#1085#1099#1081' '#1090#1086#1074#1072#1088
          Options.Editing = False
          Width = 73
        end
        object colMinExpirationDate: TcxGridDBColumn
          Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1086#1089#1090#1072#1090#1082#1072
          DataBinding.FieldName = 'MinExpirationDate'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 112
        end
        object colColor_calc: TcxGridDBColumn
          DataBinding.FieldName = 'Color_calc'
          Visible = False
        end
      end
      object cxGridLevel: TcxGridLevel
        GridView = cxGridDBTableView
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 280
    Width = 788
    Height = 186
    Align = alBottom
    ShowCaption = False
    TabOrder = 6
    object cxGridSelected: TcxGrid
      Left = 1
      Top = 1
      Width = 786
      Height = 184
      Align = alClient
      TabOrder = 0
      object cxGridDBTableViewSelected: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = SelectedDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.KeyFieldNames = 'Id;UnitId'
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = ',0.00'
            Kind = skSum
            Column = cxGridDBTableViewSelectedchAmount
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
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = ',0.00'
            Kind = skSum
            Column = cxGridDBTableViewSelectedchAmount
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
            Format = ',0.####;-,0.####; ;'
            Kind = skSum
          end
          item
            Format = ',0.####;-,0.####; ;'
            Kind = skSum
          end>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsBehavior.FocusCellOnCycle = True
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsCustomize.DataRowSizing = True
        OptionsData.CancelOnExit = False
        OptionsData.Inserting = False
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        OptionsView.GroupSummaryLayout = gslAlignWithColumns
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object cxGridDBTableViewSelectedchUnitName: TcxGridDBColumn
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          DataBinding.FieldName = 'UnitName'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 321
        end
        object cxGridDBTableViewSelectedchGoodsCode: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'GoodsCode'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
        object cxGridDBTableViewSelectedchGoodsName: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'GoodsName'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 260
        end
        object cxGridDBTableViewSelectedchAmount: TcxGridDBColumn
          Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
          DataBinding.FieldName = 'Amount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 3
          Properties.DisplayFormat = ',0.000;-,0.000; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 98
        end
      end
      object cxGridLevelSelected: TcxGridLevel
        GridView = cxGridDBTableViewSelected
      end
    end
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Properties.Strings = (
          'Date')
      end
      item
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
    Left = 264
    Top = 88
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inStartDate'
        Value = 42370d
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 392
    Top = 88
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_GoodsSearchRemainsVIP'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inCodeSearch'
        Value = ''
        Component = edCodeSearch
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsSearch'
        Value = ''
        Component = edGoodsSearch
        DataType = ftString
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
    Left = 264
    Top = 152
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 136
    Top = 152
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
    Left = 136
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
          ItemName = 'bbStaticText'
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
          ItemName = 'dxBarButton4'
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
          ItemName = 'dxBarButton6'
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
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Category = 0
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Visible = ivAlways
      ImageIndex = 6
      ShortCut = 16472
    end
    object bbStaticText: TdxBarButton
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbExecuteDialog: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Visible = ivAlways
      ImageIndex = 35
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
      ShortCut = 16464
    end
    object bb: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarButton1: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1092#1080#1083#1100#1090#1088
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1089#1080#1090#1100' '#1092#1080#1083#1100#1090#1088' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1099#1084' '#1090#1086#1074#1072#1088#1072#1084' '#1085#1072' '#1087#1086#1074#1086#1076' '#1075#1088#1080#1076
      Visible = ivAlways
      ImageIndex = 33
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton2: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1092#1080#1083#1100#1090#1088' '#1085#1072' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1099
      Category = 0
      Hint = 
        #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1092#1080#1083#1100#1090#1088' '#1085#1072' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1099' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1086#1084#1091' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1086#1084#1091' '#1082#1086 +
        #1085#1090#1088#1072#1082#1090#1091
      Visible = ivAlways
      ImageIndex = 34
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton3: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarButton4: TdxBarButton
      Action = actExportExel
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Category = 0
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Visible = ivAlways
      ImageIndex = 6
      ShortCut = 16472
    end
    object dxBarButton6: TdxBarButton
      Action = actCreteSend
      Category = 0
    end
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 32
    Top = 152
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 32
    Top = 88
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actExportExel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
      DefaultFileName = 'IncomeConsumptionBalance'
    end
    object actCreteSend: TAction
      Category = 'DSDLib'
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      ImageIndex = 79
      OnExecute = actCreteSendExecute
    end
    object actOpenChoiceUnitTree: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenChoiceUnitTree'
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = 'TUnitTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 536
    Top = 88
  end
  object SelectedDS: TDataSource
    DataSet = SelectedCDS
    Left = 136
    Top = 344
  end
  object SelectedCDS: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftInteger
      end
      item
        Name = 'GoodsCode'
        DataType = ftInteger
      end
      item
        Name = 'GoodsName'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'UnitId'
        DataType = ftInteger
      end
      item
        Name = 'UnitName'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Amount'
        DataType = ftCurrency
      end
      item
        Name = 'Price'
        DataType = ftCurrency
      end>
    IndexDefs = <>
    IndexFieldNames = 'Id;UnitId'
    Params = <>
    StoreDefs = True
    BeforePost = SelectedCDSBeforePost
    Left = 32
    Top = 344
    Data = {
      C60000009619E0BD010000001800000007000000000003000000C60002496404
      0001000000000009476F6F6473436F6465040001000000000009476F6F64734E
      616D65010049000000010005574944544802000200140006556E697449640400
      01000000000008556E69744E616D650100490000000100055749445448020002
      00140006416D6F756E7408000400000001000753554254595045020049000600
      4D6F6E6579000550726963650800040000000100075355425459504502004900
      06004D6F6E6579000000}
    object SelectedCDSId: TIntegerField
      FieldName = 'Id'
    end
    object SelectedCDSGoodsCode: TIntegerField
      FieldName = 'GoodsCode'
    end
    object SelectedCDSGoodsName: TStringField
      FieldName = 'GoodsName'
    end
    object SelectedCDSUnitId: TIntegerField
      FieldName = 'UnitId'
    end
    object SelectedCDSUnitName: TStringField
      FieldName = 'UnitName'
    end
    object SelectedCDSAmount: TCurrencyField
      FieldName = 'Amount'
    end
    object SelectedCDSPrice: TCurrencyField
      FieldName = 'Price'
    end
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    isShowModal = True
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
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
    Left = 664
    Top = 24
  end
  object DBViewAddOn: TdsdDBViewAddOn
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
    Left = 464
    Top = 168
  end
  object dsdDBViewAddOnSelected: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewSelected
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
    Left = 632
    Top = 320
  end
  object UnitCDS: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'UnitId'
        DataType = ftInteger
      end
      item
        Name = 'Summa'
        DataType = ftCurrency
      end
      item
        Name = 'MovementId'
        DataType = ftInteger
      end>
    IndexDefs = <>
    IndexFieldNames = 'UnitId'
    Params = <>
    StoreDefs = True
    Left = 248
    Top = 344
    Data = {
      5E0000009619E0BD0100000018000000030000000000030000005E0006556E69
      74496404000100000000000553756D6D61080004000000010007535542545950
      450200490006004D6F6E6579000A4D6F76656D656E7449640400010000000000
      0000}
    object UnitCDSUnitId: TIntegerField
      FieldName = 'UnitId'
    end
    object UnitCDSSumma: TCurrencyField
      FieldName = 'Summa'
    end
    object UnitCDSMovementId: TIntegerField
      FieldName = 'MovementId'
    end
  end
  object gpInsertUpdate_SendVIP: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_SendVIP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = ''
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisUrgently'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 400
    Top = 312
  end
  object gpInsertUpdate_MI_SendVIP: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_SendVIP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = ''
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 400
    Top = 376
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_GoodsSearchRemainsVIP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'SummaUrgentlySendVIP'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isBlockVIP'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaFormSendVIP'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceFormSendVIP'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 264
    Top = 208
  end
end
