inherited AdditionalGoodsForm: TAdditionalGoodsForm
  Caption = #1040#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074#1085#1099#1077' '#1082#1086#1076#1099
  ClientWidth = 798
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 806
  ExplicitHeight = 335
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 798
    ExplicitWidth = 798
    ClientRectRight = 798
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 798
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 310
        Align = alLeft
        ExplicitWidth = 310
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsBehavior.IncSearch = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clObjectCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'CodeInt'
            Options.Editing = False
            Width = 52
          end
          object clValueData: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            Options.Editing = False
            Width = 244
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 313
        Top = 0
        Width = 250
        Height = 282
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 2
        object cxGridDBTableView2: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ClientDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.Appending = True
          OptionsData.CancelOnExit = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object clValueData1: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsChoice
                Default = True
                Kind = bkEllipsis
              end>
            Width = 184
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBTableView2
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 310
        Top = 0
        Width = 3
        Height = 282
        Control = cxGrid
      end
      object cxGrid2: TcxGrid
        Left = 566
        Top = 0
        Width = 232
        Height = 282
        Align = alRight
        PopupMenu = PopupMenu
        TabOrder = 4
        object cxGridDBTableView3: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ClientMasterDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.Appending = True
          OptionsData.CancelOnExit = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object clValueData2: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsMainName'
            Options.Editing = False
            Width = 176
          end
        end
        object cxGridLevel3: TcxGridLevel
          GridView = cxGridDBTableView3
        end
      end
      object cxSplitter2: TcxSplitter
        Left = 563
        Top = 0
        Width = 3
        Height = 282
        AlignSplitter = salRight
        Control = cxGrid2
      end
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cxGrid
        Properties.Strings = (
          'Width')
      end
      item
        Component = cxGrid1
        Properties.Strings = (
          'Width')
      end
      item
        Component = cxGrid2
        Properties.Strings = (
          'Width')
      end
      item
        Component = RetailGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spAdditionalGoods
        end
        item
          StoredProc = spAdditioanlGoodsClient
        end>
    end
    object actGoodsChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actGoodsChoice'
      FormName = 'TGoodsLiteForm'
      FormNameParam.Value = 'TGoodsLiteForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actInsertUpdateLink: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = 'actInsertUpdateLink'
      DataSource = ClientMasterDS
    end
  end
  inherited MasterDS: TDataSource
    Left = 152
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Left = 152
    Top = 48
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods_Lite'
    Params = <
      item
        Name = 'inObjectId'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 152
    Top = 136
  end
  inherited BarManager: TdxBarManager
    Left = 264
    Top = 48
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      Left = 8
      Top = 96
    end
    inherited bbInsert: TdxBarButton
      Enabled = False
      Visible = ivNever
    end
    inherited bbEdit: TdxBarButton
      Enabled = False
      Visible = ivNever
    end
    inherited bbErased: TdxBarButton
      Enabled = False
      Visible = ivNever
    end
    inherited bbUnErased: TdxBarButton
      Enabled = False
      Visible = ivNever
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = ''
    SearchAsFilter = False
    Left = 248
    Top = 144
  end
  inherited spErasedUnErased: TdsdStoredProc
    Left = 24
  end
  object ClientDS: TDataSource
    DataSet = ClientCDS
    Left = 408
    Top = 96
  end
  object spAdditionalGoods: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_AdditionalGoods'
    DataSet = ClientCDS
    DataSets = <
      item
        DataSet = ClientCDS
      end>
    Params = <>
    Left = 408
    Top = 144
  end
  object ClientCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'GoodsMainId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 408
    Top = 48
  end
  object ClientMasterDS: TDataSource
    DataSet = ClientMasterCDS
    Left = 592
    Top = 104
  end
  object spAdditioanlGoodsClient: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_AdditionalGoodsChild'
    DataSet = ClientMasterCDS
    DataSets = <
      item
        DataSet = ClientMasterCDS
      end>
    Params = <
      item
        Name = 'inObjectId'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 640
    Top = 104
  end
  object ClientMasterCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'GoodsId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 688
    Top = 104
  end
  object RetailGuides: TdsdGuides
    KeyField = 'Id'
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 48
    Top = 80
  end
  object AdditionalGoodsDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 504
    Top = 160
  end
  object AdditionalGoodsClientDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView3
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    SearchAsFilter = False
    Left = 696
    Top = 160
  end
  object spInsertUpdateGoodsLink: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_AdditionalGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = ClientCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsMainId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Component = ClientCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end>
    Left = 408
    Top = 184
  end
end
