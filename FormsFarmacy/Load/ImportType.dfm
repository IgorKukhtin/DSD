inherited ImportTypeForm: TImportTypeForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1058#1080#1087#1099' '#1080#1084#1087#1086#1088#1090#1072'>'
  ClientHeight = 339
  ClientWidth = 743
  ExplicitWidth = 751
  ExplicitHeight = 373
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 743
    Height = 313
    ExplicitWidth = 743
    ExplicitHeight = 313
    ClientRectBottom = 313
    ClientRectRight = 743
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 743
      ExplicitHeight = 313
      inherited cxGrid: TcxGrid
        Width = 369
        Height = 313
        Align = alLeft
        ExplicitWidth = 369
        ExplicitHeight = 313
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Appending = True
          OptionsData.Inserting = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Width = 34
          end
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Width = 113
          end
          object clProcedureName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1088#1086#1094#1077#1076#1091#1088#1099' '#1080#1084#1087#1086#1088#1090#1072
            DataBinding.FieldName = 'ProcedureName'
            HeaderAlignmentVert = vaCenter
            Width = 124
          end
          object clisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            HeaderAlignmentVert = vaCenter
            Width = 52
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 369
        Top = 0
        Width = 374
        Height = 313
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 1
        ExplicitLeft = 366
        ExplicitTop = 64
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
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
          object clICode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Visible = False
            Width = 30
          end
          object clIName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
            DataBinding.FieldName = 'Name'
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
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 67
    Top = 168
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectItems
        end>
    end
    object dsdUpdateMaster: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdateImportType
      StoredProcList = <
        item
          StoredProc = spInsertUpdateImportType
        end>
      Caption = 'dsdUpdate'
      DataSource = MasterDS
    end
    object dsdUpdateChild: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdateImportTypeItems
      StoredProcList = <
        item
          StoredProc = spInsertUpdateImportTypeItems
        end>
      Caption = 'dsdUpdateChild'
      DataSource = ChildDS
    end
  end
  inherited MasterDS: TDataSource
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Top = 96
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ImportType'
    Left = 104
    Top = 64
  end
  inherited BarManager: TdxBarManager
    Left = 176
    Top = 80
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 280
    Top = 192
  end
  object spInsertUpdateImportType: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ImportType'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId '
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inCode'
        Component = MasterCDS
        ComponentItem = 'Code'
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inProcedureName'
        Component = MasterCDS
        ComponentItem = 'ProcedureName'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 232
    Top = 123
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 456
    Top = 80
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ImportTypeId '
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 536
    Top = 80
  end
  object spSelectItems: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ImportTypeItems'
    DataSet = ChildCDS
    DataSets = <
      item
        DataSet = ChildCDS
      end>
    Params = <>
    Left = 608
    Top = 72
  end
  object spInsertUpdateImportTypeItems: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ImportTypeItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId '
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inCode'
        Component = ChildCDS
        ComponentItem = 'Code'
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Component = ChildCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inImportTypeId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 632
    Top = 147
  end
  object dsdDBViewAddOnItems: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 464
    Top = 200
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    Params = <
      item
        Name = 'inObjectId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 192
    Top = 192
  end
  object spErasedUnErasedChild: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 456
    Top = 136
  end
end
