inherited AdditionalGoodsForm: TAdditionalGoodsForm
  Caption = #1044#1086#1087#1086#1083#1085#1103#1102#1097#1080#1077' '#1090#1086#1074#1072#1088#1099
  ClientHeight = 567
  ClientWidth = 798
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 814
  ExplicitHeight = 605
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 798
    Height = 541
    ExplicitWidth = 798
    ExplicitHeight = 541
    ClientRectBottom = 541
    ClientRectRight = 798
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 798
      ExplicitHeight = 541
      inherited cxGrid: TcxGrid
        Width = 441
        Height = 301
        Align = alLeft
        ExplicitWidth = 441
        ExplicitHeight = 301
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsBehavior.IncSearch = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object ObjectCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'CodeInt'
            Options.Editing = False
            Width = 39
          end
          object ValueData: TcxGridDBColumn
            Caption = #1054#1089#1085#1086#1074#1085#1086#1081' '#1090#1086#1074#1072#1088
            DataBinding.FieldName = 'Name'
            Options.Editing = False
            Width = 209
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Width = 138
          end
          object NDS: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDS'
            Options.Editing = False
            Width = 44
          end
        end
      end
      object grSecondGoods: TcxGrid
        Left = 452
        Top = 0
        Width = 201
        Height = 301
        Align = alClient
        PopupMenu = PopupMenu1
        TabOrder = 2
        object tvSecondGoods: TcxGridDBTableView
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
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object GoodsSecondCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            Options.Editing = False
            Width = 48
          end
          object GoodsSecondName: TcxGridDBColumn
            Caption = #1044#1086#1087#1086#1083#1085#1103#1102#1097#1080#1081' '#1090#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsChoice
                Default = True
                Kind = bkEllipsis
              end>
            Width = 283
          end
        end
        object glSecondGoods: TcxGridLevel
          GridView = tvSecondGoods
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 441
        Top = 0
        Width = 3
        Height = 301
        Control = cxGrid
      end
      object grClientGoods: TcxGrid
        Left = 664
        Top = 0
        Width = 134
        Height = 301
        Align = alRight
        TabOrder = 4
        Visible = False
        object tvClientGoods: TcxGridDBTableView
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
          object GoodsCodeInt: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCodeInt'
            Width = 35
          end
          object GoodsClientName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' '#1091' '#1082#1083#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'GoodsName'
            Options.Editing = False
            Width = 153
          end
          object MakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            Width = 104
          end
        end
        object glClientGoods: TcxGridLevel
          GridView = tvClientGoods
        end
      end
      object cxSplitter2: TcxSplitter
        Left = 653
        Top = 0
        Width = 3
        Height = 301
        AlignSplitter = salRight
        Control = grClientGoods
      end
      object GridAll: TcxGrid
        Left = 0
        Top = 309
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
          object Id: TcxGridDBColumn
            Caption = #1048#1044
            DataBinding.FieldName = 'Id'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 38
          end
          object GoodsMainId: TcxGridDBColumn
            Caption = #1048#1044' '#1075#1083'. '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsMainId'
            Visible = False
            VisibleForCustomization = False
            Width = 72
          end
          object GoodsMainCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1075#1083'. '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsMainCode'
            Options.CellMerging = True
            Width = 56
          end
          object GoodsMainName: TcxGridDBColumn
            Caption = #1043#1083#1072#1074#1085#1099#1081' '#1090#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsMainName'
            Options.CellMerging = True
            Width = 322
          end
          object GoodsId: TcxGridDBColumn
            Caption = #1048#1044' '#1076#1086#1087'. '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsId'
            Visible = False
            VisibleForCustomization = False
            Width = 51
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1087'. '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsSecondCode'
            Width = 64
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1044#1086#1087#1086#1083#1085#1103#1102#1097#1080#1081' '#1090#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsSecondName'
            Width = 342
          end
        end
        object GridAllLevel1: TcxGridLevel
          GridView = GridAllDBTableView
        end
      end
      object cxSplitter3: TcxSplitter
        Left = 0
        Top = 301
        Width = 798
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = GridAll
      end
      object cxSplitter4: TcxSplitter
        Left = 444
        Top = 0
        Width = 8
        Height = 301
        HotZoneClassName = 'TcxMediaPlayer8Style'
        Control = cxGrid
      end
      object cxSplitter5: TcxSplitter
        Left = 656
        Top = 0
        Width = 8
        Height = 301
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salRight
        Control = grClientGoods
        Visible = False
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
        Component = grSecondGoods
        Properties.Strings = (
          'Width')
      end
      item
        Component = grClientGoods
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
          StoredProc = spAll
        end
        item
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
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ClientCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
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
      StoredProc = spInsertUpdate_Object_AdditionalGoods
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_Object_AdditionalGoods
        end>
      Caption = 'actInsertUpdateLink'
      DataSource = ClientDS
    end
    object InsertRecord: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = tvSecondGoods
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
      StoredProc = spDelete_Object_AdditionalGoods
      StoredProcList = <
        item
          StoredProc = spDelete_Object_AdditionalGoods
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
      ShortCut = 46
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
    Left = 216
    Top = 0
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
    Left = 152
    Top = 184
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
    Left = 48
    Top = 128
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
    Left = 736
    Top = 88
  end
  object spAdditioanlGoodsClient: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_AdditionalGoodsClient'
    DataSet = ClientMasterCDS
    DataSets = <
      item
        DataSet = ClientMasterCDS
      end>
    Params = <>
    PackSize = 1
    Left = 704
    Top = 128
  end
  object ClientMasterCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'GoodsMainId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 696
    Top = 88
  end
  object RetailGuides: TdsdGuides
    KeyField = 'Id'
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 464
    Top = 48
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
    Left = 288
    Top = 416
  end
  object AdditionalGoodsClientDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = tvClientGoods
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    SearchAsFilter = False
    Left = 728
    Top = 128
  end
  object spInsertUpdate_Object_AdditionalGoods: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_AdditionalGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ClientCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsSecondId'
        Value = Null
        Component = ClientCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 408
    Top = 184
  end
  object spDelete_Object_AdditionalGoods: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_AdditionalGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 408
    Top = 232
  end
  object PopupMenu1: TPopupMenu
    Images = dmMain.ImageList
    Left = 464
    Top = 96
    object MenuItem1: TMenuItem
      Action = mactInsert
    end
    object MenuItem2: TMenuItem
      Action = actUpdate
      Visible = False
    end
    object MenuItem3: TMenuItem
      Action = mactDeleteLink
    end
    object MenuItem5: TMenuItem
      Caption = '-'
    end
    object MenuItem6: TMenuItem
      Action = dsdChoiceGuides
      Visible = False
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
    Left = 288
    Top = 464
  end
  object cdsAll: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 168
    Top = 416
  end
  object spAll: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_AdditionalGoodsAll'
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
