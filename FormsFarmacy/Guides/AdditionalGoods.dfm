inherited AdditionalGoodsForm: TAdditionalGoodsForm
  Caption = #1044#1086#1087#1086#1083#1085#1103#1102#1097#1080#1077' '#1090#1086#1074#1072#1088#1099
  ClientHeight = 587
  ClientWidth = 798
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 814
  ExplicitHeight = 625
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 798
    Height = 561
    ExplicitWidth = 798
    ExplicitHeight = 561
    ClientRectBottom = 561
    ClientRectRight = 798
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 798
      ExplicitHeight = 561
      inherited cxGrid: TcxGrid
        Width = 310
        Height = 321
        Align = alLeft
        ExplicitWidth = 310
        ExplicitHeight = 321
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsBehavior.IncSearch = True
          Styles.Content = nil
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
        Height = 321
        Align = alClient
        PopupMenu = PopupMenu1
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
        Height = 321
        Control = cxGrid
      end
      object cxGrid2: TcxGrid
        Left = 566
        Top = 0
        Width = 232
        Height = 321
        Align = alRight
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
        Height = 321
        AlignSplitter = salRight
        Control = cxGrid2
      end
      object GridAll: TcxGrid
        Left = 0
        Top = 329
        Width = 798
        Height = 232
        Align = alBottom
        TabOrder = 5
        object GridAllDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = dsAll
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
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object colId: TcxGridDBColumn
            Caption = #1048#1044
            DataBinding.FieldName = 'Id'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 38
          end
          object colGoodsMainId: TcxGridDBColumn
            Caption = #1048#1044' '#1075#1083'. '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsMainId'
            Visible = False
            VisibleForCustomization = False
            Width = 72
          end
          object colGoodsMainCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1075#1083'. '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsMainCode'
            Options.CellMerging = True
            Width = 56
          end
          object colGoodsMainName: TcxGridDBColumn
            Caption = #1043#1083#1072#1074#1085#1099#1081' '#1090#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsMainName'
            Options.CellMerging = True
            Width = 322
          end
          object colGoodsId: TcxGridDBColumn
            Caption = #1048#1044' '#1076#1086#1087'. '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsId'
            Visible = False
            VisibleForCustomization = False
            Width = 51
          end
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1087'. '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            Width = 64
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1044#1086#1087#1086#1083#1085#1103#1102#1097#1080#1081' '#1090#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            Width = 342
          end
        end
        object GridAllLevel1: TcxGridLevel
          GridView = GridAllDBTableView
        end
      end
      object cxSplitter3: TcxSplitter
        Left = 0
        Top = 321
        Width = 798
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = GridAll
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
        end
        item
          StoredProc = spAll
        end>
    end
    inherited actGridToExcel: TdsdGridToExcel
      Grid = GridAll
    end
    inherited actInsert: TInsertUpdateChoiceAction
      ShortCut = 0
      DataSource = ClientDS
    end
    inherited actUpdate: TdsdInsertUpdateAction
      ShortCut = 0
    end
    inherited dsdSetUnErased: TdsdUpdateErased
      ShortCut = 0
    end
    inherited dsdSetErased: TdsdUpdateErased
      ShortCut = 0
      DataSource = ClientDS
    end
    object actGoodsChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = DataSetCancel
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsChoice'
      FormName = 'TGoodsLiteForm'
      FormNameParam.Value = 'TGoodsLiteForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientCDS
          ComponentItem = 'GoodsId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object mactInsert: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = InsertRecord
        end
        item
          Action = actGoodsChoice
        end
        item
          Action = DataSetPost
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
      ShortCut = 45
    end
    object actInsertUpdateLink: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateGoodsLink
      StoredProcList = <
        item
          StoredProc = spInsertUpdateGoodsLink
        end>
      Caption = 'actInsertUpdateLink'
      DataSource = ClientDS
    end
    object InsertRecord: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView2
      Params = <>
      Caption = 'InsertRecord'
    end
    object DataSetPost: TDataSetPost
      Category = 'Dataset'
      Caption = 'P&ost'
      Hint = 'Post'
      DataSource = ClientDS
    end
    object DataSetCancel: TDataSetCancel
      Category = 'Dataset'
      Caption = '&Cancel'
      Hint = 'Cancel'
      DataSource = ClientDS
    end
    object actDeleteLink: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDeleteLink
      StoredProcList = <
        item
          StoredProc = spDeleteLink
        end>
    end
    object mactDeleteLink: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actDeleteLink
        end
        item
          Action = DataSetDelete
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1089#1074#1103#1079#1080'?'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      ImageIndex = 2
    end
    object DataSetDelete: TDataSetDelete
      Category = 'Dataset'
      Caption = '&Delete'
      Hint = 'Delete'
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
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
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
      Action = mactInsert
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
  inherited PopupMenu: TPopupMenu
    inherited N3: TMenuItem
      Visible = False
    end
    inherited N4: TMenuItem
      Visible = False
    end
    inherited N5: TMenuItem
      Visible = False
    end
    inherited N7: TMenuItem
      Visible = False
    end
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
    PackSize = 1
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
    Params = <>
    PackSize = 1
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
    StoredProcName = 'gpInsertUpdate_Object_LinkGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ClientCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ClientCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 408
    Top = 184
  end
  object spDeleteLink: TdsdStoredProc
    StoredProcName = 'lpDelete_Object'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 472
    Top = 64
  end
  object PopupMenu1: TPopupMenu
    Images = dmMain.ImageList
    Left = 328
    Top = 168
    object MenuItem1: TMenuItem
      Action = actInsert
    end
    object MenuItem2: TMenuItem
      Action = actUpdate
    end
    object MenuItem3: TMenuItem
      Action = mactDeleteLink
    end
    object MenuItem5: TMenuItem
      Caption = '-'
    end
    object MenuItem6: TMenuItem
      Action = dsdChoiceGuides
    end
    object MenuItem7: TMenuItem
      Action = actRefresh
    end
    object MenuItem8: TMenuItem
      Action = actGridToExcel
    end
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = GridAllDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    SearchAsFilter = False
    Left = 304
    Top = 472
  end
  object cdsAll: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 168
    Top = 416
  end
  object spAll: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Additional'
    DataSet = cdsAll
    DataSets = <
      item
        DataSet = cdsAll
      end>
    Params = <>
    PackSize = 1
    Left = 248
    Top = 416
  end
  object dsAll: TDataSource
    DataSet = cdsAll
    Left = 200
    Top = 416
  end
end
