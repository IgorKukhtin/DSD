inherited GoodsByGoodsKind1CLinkForm: TGoodsByGoodsKind1CLinkForm
  Caption = #1057#1074#1103#1079#1100' '#1089' '#1090#1086#1074#1072#1088#1072#1084#1080' '#1089' 1'#1057
  ClientHeight = 401
  ClientWidth = 835
  ExplicitWidth = 851
  ExplicitHeight = 436
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 835
    Height = 375
    ExplicitWidth = 835
    ExplicitHeight = 375
    ClientRectBottom = 375
    ClientRectRight = 835
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 835
      ExplicitHeight = 375
      inherited cxGrid: TcxGrid
        Width = 417
        Height = 375
        Align = alLeft
        ExplicitWidth = 417
        ExplicitHeight = 375
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            Options.Editing = False
            Width = 37
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            Options.Editing = False
            Width = 232
          end
          object colGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            Width = 134
          end
        end
      end
      object cxDetailGrid: TcxGrid
        Left = 422
        Top = 0
        Width = 413
        Height = 375
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DetailDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
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
          object colDetailCode: TcxGridDBColumn
            Caption = #1050#1086#1076' 1'#1057
            DataBinding.FieldName = 'Code'
            Width = 56
          end
          object colDetailName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' 1'#1057
            DataBinding.FieldName = 'Name'
            Width = 119
          end
          object colDetailBranch: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceBranchForm
                Default = True
                Kind = bkEllipsis
              end>
            Width = 121
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter: TcxSplitter
        Left = 417
        Top = 0
        Width = 5
        Height = 375
        Control = cxGrid
      end
      object edBranch: TcxButtonEdit
        Left = 192
        Top = 40
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 3
        Width = 177
      end
    end
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spDetailSelect
        end>
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DetailDS
    end
    object actChoiceBranchForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'actChoiceBranchForm'
      FormName = 'TBranchForm'
      FormNameParam.Value = 'TBranchForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = DetailCDS
          ComponentItem = 'BranchId'
        end
        item
          Name = 'TextValue'
          Component = DetailCDS
          ComponentItem = 'BranchName'
          DataType = ftString
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 48
  end
  inherited MasterCDS: TClientDataSet
    Top = 48
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsByGoodsKind1CLink_Master'
    Top = 48
  end
  inherited BarManager: TdxBarManager
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem'
        end>
    end
    object dxBarControlContainerItem: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edBranch
    end
  end
  object DetailCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'MasterId'
    MasterFields = 'MasterId'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 448
    Top = 136
  end
  object DetailDS: TDataSource
    DataSet = DetailCDS
    Left = 480
    Top = 136
  end
  object spDetailSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsByGoodsKind1CLink'
    DataSet = DetailCDS
    DataSets = <
      item
        DataSet = DetailCDS
      end>
    Params = <>
    Left = 512
    Top = 136
  end
  object BranchGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    FormNameParam.Value = 'TBranchForm'
    FormNameParam.DataType = ftString
    FormName = 'TBranchForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 232
    Top = 120
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsByGoodsKind1CLink'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Component = DetailCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inCode'
        Component = DetailCDS
        ComponentItem = 'Code'
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Component = DetailCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
      end
      item
        Name = 'inBranchId'
        Component = DetailCDS
        ComponentItem = 'BranchId'
        ParamType = ptInput
      end
      item
        Name = 'inBranchTopId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'Id'
        Component = DetailCDS
        ComponentItem = 'Id'
      end
      item
        Name = 'BranchId'
        Component = DetailCDS
        ComponentItem = 'BranchId'
      end
      item
        Name = 'BranchName'
        Component = DetailCDS
        ComponentItem = 'BranchName'
        DataType = ftString
      end>
    Left = 624
    Top = 216
  end
end
