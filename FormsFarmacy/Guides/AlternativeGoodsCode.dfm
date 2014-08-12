inherited AlternativeGoodsCodeForm: TAlternativeGoodsCodeForm
  Caption = #1040#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074#1085#1099#1077' '#1082#1086#1076#1099
  ClientWidth = 798
  ExplicitWidth = 806
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
      object TcxGrid
        Left = 563
        Top = 0
        Width = 0
        Height = 282
        Align = alRight
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
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
          object clIName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
            DataBinding.FieldName = 'Name'
            Width = 100
          end
          object clImportTypeItemsName: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1080#1084#1087#1086#1088#1090#1072
            DataBinding.FieldName = 'ImportTypeItemsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Width = 100
          end
          object clIisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Width = 30
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
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
          object clObjectCode1: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'ObjectCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Width = 52
          end
          object clValueData1: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'ValueData'
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
          object clObjectCode2: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'ObjectCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Width = 42
          end
          object clValueData2: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'ValueData'
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
      end
      object cxLabel1: TcxLabel
        Left = 24
        Top = 32
        Caption = #1057#1077#1090#1100': '
      end
      object beRetail: TcxButtonEdit
        Left = 24
        Top = 55
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 7
        Width = 201
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
        end
        item
          Visible = True
          ItemName = 'bbRetailLabel'
        end
        item
          Visible = True
          ItemName = 'bbRetailEdit'
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
    object bbRetailLabel: TdxBarControlContainerItem
      Caption = 'RetailLabel'
      Category = 0
      Visible = ivAlways
      Control = cxLabel1
    end
    object bbRetailEdit: TdxBarControlContainerItem
      Caption = 'RetailEdit'
      Category = 0
      Visible = ivAlways
      Control = beRetail
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = ''
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
  object spAlternativeCode: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_AlternativeGoodsCode'
    DataSet = ClientCDS
    DataSets = <
      item
        DataSet = ClientCDS
      end>
    Params = <
      item
        Name = 'inObjectId'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
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
  object DataSource2: TDataSource
    DataSet = ClientDataSet2
    Left = 592
    Top = 104
  end
  object dsdStoredProc2: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods_Lite'
    DataSet = ClientDataSet2
    DataSets = <
      item
        DataSet = ClientDataSet2
      end>
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        ParamType = ptInput
      end>
    Left = 640
    Top = 104
  end
  object ClientDataSet2: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 688
    Top = 104
  end
  object RetailGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = beRetail
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
end
