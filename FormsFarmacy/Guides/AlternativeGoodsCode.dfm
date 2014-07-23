inherited AlternativeGoodsCodeForm: TAlternativeGoodsCodeForm
  Caption = #1040#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074#1085#1099#1077' '#1082#1086#1076#1099
  ClientWidth = 798
  ExplicitLeft = 1
  ExplicitWidth = 814
  ExplicitHeight = 347
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 798
    ExplicitLeft = 8
    ExplicitTop = 28
    ExplicitHeight = 280
    ClientRectRight = 794
    inherited tsMain: TcxTabSheet
      ExplicitLeft = 5
      ExplicitTop = 5
      ExplicitWidth = 766
      ExplicitHeight = 272
      inherited cxGrid: TcxGrid
        Width = 310
        Height = 272
        Align = alLeft
        ExplicitWidth = 310
        ExplicitHeight = 272
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clObjectCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'ObjectCode'
          end
          object clValueData: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'ValueData'
          end
          object clGoodsMain: TcxGridDBColumn
            Caption = #1057#1089#1099#1083#1082#1072' '#1085#1072' '#1090#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsMain'
          end
          object clGoods: TcxGridDBColumn
            Caption = #1057#1089#1099#1083#1082#1072' '#1085#1072' '#1090#1086#1074#1072#1088
            DataBinding.FieldName = 'Goods'
          end
          object clRetail: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'Retail'
          end
          object clisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
          end
        end
      end
      object TcxGrid
        Left = 555
        Top = 0
        Width = 0
        Height = 272
        Align = alRight
        PopupMenu = PopupMenu
        TabOrder = 1
        ExplicitLeft = 8
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
        Width = 242
        Height = 272
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 2
        ExplicitLeft = 310
        ExplicitWidth = 228
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
            Width = 100
          end
          object clValueData1: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
            DataBinding.FieldName = 'ValueData'
            Width = 100
          end
          object clisErased1: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Width = 30
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
        Height = 272
        ExplicitLeft = 297
      end
      object cxGrid2: TcxGrid
        Left = 558
        Top = 0
        Width = 232
        Height = 272
        Align = alRight
        PopupMenu = PopupMenu
        TabOrder = 4
        ExplicitLeft = 547
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
            Width = 100
          end
          object clValueData2: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
            DataBinding.FieldName = 'ValueData'
            Width = 100
          end
          object clisErased2: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Width = 30
          end
        end
        object cxGridLevel3: TcxGridLevel
          GridView = cxGridDBTableView3
        end
      end
      object cxSplitter2: TcxSplitter
        Left = 555
        Top = 0
        Width = 3
        Height = 272
        AlignSplitter = salRight
        ExplicitLeft = 542
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
      end>
  end
  inherited MasterDS: TDataSource
    Left = 88
    Top = 104
  end
  inherited MasterCDS: TClientDataSet
    Left = 240
    Top = 120
  end
  inherited spSelect: TdsdStoredProc
    Left = 152
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Left = 240
    Top = 160
    DockControlHeights = (
      0
      0
      28
      0)
    inherited dxBarStatic: TdxBarStatic
      Left = 8
      Top = 96
    end
  end
end
