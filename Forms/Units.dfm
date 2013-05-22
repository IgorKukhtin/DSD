inherited UnitForm: TUnitForm
  Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
  ClientHeight = 515
  ClientWidth = 710
  ExplicitWidth = 718
  ExplicitHeight = 542
  PixelsPerInch = 96
  TextHeight = 13
  object cxDBTreeList: TcxDBTreeList
    Left = 0
    Top = 26
    Width = 313
    Height = 489
    Align = alLeft
    Bands = <
      item
      end>
    DataController.DataSource = TreeDS
    DataController.ParentField = 'ParentId'
    DataController.KeyField = 'Id'
    Images = dmMain.TreeImageList
    Navigator.Buttons.CustomButtons = <>
    OptionsBehavior.IncSearch = True
    OptionsData.Editing = False
    OptionsData.Deleting = False
    OptionsView.ColumnAutoWidth = True
    OptionsView.GridLines = tlglBoth
    OptionsView.TreeLineStyle = tllsSolid
    RootValue = -1
    TabOrder = 1
    object cxDBTreeListcxDBTreeListColumn2: TcxDBTreeListColumn
      Caption.Text = #1043#1088#1091#1087#1087#1072
      DataBinding.FieldName = 'Name'
      Width = 110
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
  object cxSplitter1: TcxSplitter
    Left = 313
    Top = 26
    Width = 8
    Height = 489
    Control = cxDBTreeList
  end
  object cxGrid: TcxGrid
    Left = 321
    Top = 26
    Width = 389
    Height = 489
    Align = alClient
    TabOrder = 6
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = GridDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.ColumnAutoWidth = True
      object cxGridDBTableViewColumn1: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
      end
      object cxGridDBTableViewColumn2: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
      end
      object cxGridDBTableViewColumn3: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083
        DataBinding.FieldName = 'BranchName'
      end
      object cxGridDBTableViewColumn4: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object TreeDS: TDataSource
    DataSet = ClientTreeDataSet
    Left = 96
    Top = 96
  end
  object ClientTreeDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 96
    Top = 144
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <>
    StorageName = 'cxPropertiesStore'
    Left = 232
    Top = 96
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 152
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
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbChoice'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbRefresh'
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
      ImageIndex = 4
    end
    object bbInsert: TdxBarButton
      Action = actInsert
      Category = 0
      ImageIndex = 0
    end
    object bbEdit: TdxBarButton
      Action = actUpdate
      Category = 0
      ImageIndex = 1
    end
    object bbErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
      ImageIndex = 2
    end
    object bbUnErased: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
      ImageIndex = 8
    end
    object bbChoice: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
      ImageIndex = 7
    end
  end
  object ActionList: TActionList
    Left = 232
    Top = 144
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spTree
      StoredProcList = <
        item
          StoredProc = spTree
        end
        item
          StoredProc = spGrid
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      FormName = 'TUnitEditForm'
      GuiParams = <
        item
          Name = 'Id'
          DataType = ftInteger
          ParamType = ptOutput
          Value = '0'
        end>
      isShowModal = True
      DataSource = TreeDS
      DataSetRefresh = actRefresh
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      FormName = 'TUnitEditForm'
      GuiParams = <
        item
          Name = 'Id'
          Component = ClientGridDataSet
          DataType = ftInteger
          ParamType = ptInput
          Value = ''
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSource = TreeDS
      DataSetRefresh = actRefresh
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      StoredProcList = <>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 46
      isSetErased = False
      DataSource = TreeDS
    end
    object dsdSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      StoredProcList = <>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 32776
      isSetErased = False
      DataSource = TreeDS
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      Params = <>
      FormParams = dsdFormParams
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ShortCut = 13
    end
  end
  object spTree: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_UnitGroup'
    DataSet = ClientTreeDataSet
    DataSets = <
      item
        DataSet = ClientTreeDataSet
      end>
    Params = <>
    Left = 152
    Top = 152
  end
  object GridDS: TDataSource
    DataSet = ClientGridDataSet
    Left = 360
    Top = 104
  end
  object ClientGridDataSet: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'UnitGroupId'
    MasterFields = 'Id'
    MasterSource = TreeDS
    PacketRecords = 0
    Params = <>
    Left = 360
    Top = 152
  end
  object spGrid: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Unit'
    DataSet = ClientGridDataSet
    DataSets = <
      item
        DataSet = ClientGridDataSet
      end>
    Params = <>
    Left = 416
    Top = 160
  end
  object dsdDBTreeAddOn: TdsdDBTreeAddOn
    DBTreeList = cxDBTreeList
    Left = 192
    Top = 240
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Key'
        Component = ClientGridDataSet
        ComponentItem = 'Id'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'TextValue'
        Component = ClientGridDataSet
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end>
    Left = 344
    Top = 232
  end
end
