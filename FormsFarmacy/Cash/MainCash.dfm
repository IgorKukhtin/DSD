inherited MainCashForm: TMainCashForm
  Caption = #1055#1088#1086#1076#1072#1078#1072
  ClientHeight = 412
  ClientWidth = 674
  ExplicitWidth = 682
  ExplicitHeight = 439
  PixelsPerInch = 96
  TextHeight = 13
  object BottomPanel: TPanel [0]
    Left = 0
    Top = 216
    Width = 674
    Height = 196
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object CheckGrid: TcxGrid
      Left = 0
      Top = 0
      Width = 421
      Height = 196
      Align = alClient
      TabOrder = 0
      object CheckGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
        object CheckGridDBTableViewColumn1: TcxGridDBColumn
        end
        object CheckGridDBTableViewColumn2: TcxGridDBColumn
        end
        object CheckGridDBTableViewColumn3: TcxGridDBColumn
        end
        object CheckGridDBTableViewColumn4: TcxGridDBColumn
        end
        object CheckGridDBTableViewColumn5: TcxGridDBColumn
        end
      end
      object CheckGridLevel: TcxGridLevel
        GridView = CheckGridDBTableView
      end
    end
    object cxGrid: TcxGrid
      Left = 424
      Top = 0
      Width = 250
      Height = 196
      Align = alRight
      TabOrder = 1
      object cxGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object cxGridDBTableViewColumn1: TcxGridDBColumn
        end
        object cxGridDBTableViewColumn2: TcxGridDBColumn
        end
      end
      object cxGridLevel: TcxGridLevel
        GridView = cxGridDBTableView
      end
    end
    object cxSplitter1: TcxSplitter
      Left = 421
      Top = 0
      Width = 3
      Height = 196
      AlignSplitter = salRight
      Control = cxGrid
    end
  end
  object cxSplitter2: TcxSplitter [1]
    Left = 0
    Top = 213
    Width = 674
    Height = 3
    AlignSplitter = salBottom
  end
  object MainPanel: TPanel [2]
    Left = 0
    Top = 0
    Width = 674
    Height = 213
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object MainGrid: TcxGrid
      Left = 0
      Top = 0
      Width = 674
      Height = 172
      Align = alClient
      TabOrder = 0
      object MainGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object MainColName: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          HeaderAlignmentVert = vaCenter
          Width = 385
        end
        object MainColCode: TcxGridDBColumn
          Caption = #1050#1086#1076
          HeaderAlignmentVert = vaCenter
          Width = 73
        end
        object MainColRemains: TcxGridDBColumn
          Caption = #1054#1089#1090#1072#1090#1086#1082
          HeaderAlignmentVert = vaCenter
          Width = 58
        end
        object MainColPrice: TcxGridDBColumn
          Caption = #1062#1077#1085#1072
          HeaderAlignmentVert = vaCenter
          Width = 45
        end
        object MainColReserved: TcxGridDBColumn
          Caption = #1054#1090#1083#1086#1078#1077#1085#1085#1099#1077
          HeaderAlignmentVert = vaCenter
          Width = 87
        end
      end
      object MainGridLevel: TcxGridLevel
        GridView = MainGridDBTableView
      end
    end
    object SearchPanel: TPanel
      Left = 0
      Top = 172
      Width = 674
      Height = 41
      Align = alBottom
      Caption = 'SearchPanel'
      TabOrder = 1
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = BottomPanel
        Properties.Strings = (
          'Height')
      end
      item
        Component = CheckGrid
        Properties.Strings = (
          'Width')
      end
      item
        Component = cxGrid
        Properties.Strings = (
          'Width')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Component = MainGrid
        Properties.Strings = (
          'Height')
      end>
  end
  object dsdDBViewAddOnMain: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = MainGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 280
    Top = 96
  end
end
