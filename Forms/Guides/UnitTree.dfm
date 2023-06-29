object UnitTreeForm: TUnitTreeForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103'>'
  ClientHeight = 403
  ClientWidth = 811
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  PixelsPerInch = 96
  TextHeight = 13
  object cxDBTreeList: TcxDBTreeList
    Left = 0
    Top = 26
    Width = 313
    Height = 377
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
    OptionsCustomizing.ColumnHiding = True
    OptionsCustomizing.ColumnsQuickCustomization = True
    OptionsData.Editing = False
    OptionsData.Deleting = False
    OptionsView.ColumnAutoWidth = True
    OptionsView.GridLines = tlglBoth
    OptionsView.Indicator = True
    OptionsView.TreeLineStyle = tllsSolid
    RootValue = -1
    Styles.StyleSheet = dmMain.cxTreeListStyleSheet
    TabOrder = 1
    object ceParentName: TcxDBTreeListColumn
      Caption.AlignVert = vaCenter
      Caption.Text = #1043#1088#1091#1087#1087#1072
      DataBinding.FieldName = 'Name'
      Options.Editing = False
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
    Height = 377
    Control = cxDBTreeList
  end
  object cxGrid: TcxGrid
    Left = 321
    Top = 26
    Width = 490
    Height = 377
    Align = alClient
    TabOrder = 6
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = GridDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object isLeaf: TcxGridDBColumn
        Caption = '_'
        DataBinding.FieldName = 'isLeaf'
        PropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.Images = dmMain.TreeImageList
        Properties.Items = <
          item
            ImageIndex = 0
            Value = False
          end
          item
            ImageIndex = 2
            Value = True
          end>
        SortIndex = 0
        SortOrder = soAscending
        Width = 20
      end
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taRightJustify
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentVert = vaCenter
        SortIndex = 1
        SortOrder = soAscending
        Width = 160
      end
      object BranchName: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083
        DataBinding.FieldName = 'BranchName'
        HeaderAlignmentVert = vaCenter
        Width = 120
      end
      object CityName: TcxGridDBColumn
        Caption = #1043#1086#1088#1086#1076
        DataBinding.FieldName = 'CityName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object Address: TcxGridDBColumn
        Caption = #1040#1076#1088#1077#1089
        DataBinding.FieldName = 'Address'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object isCountCount: TcxGridDBColumn
        Caption = #1059#1095#1077#1090' '#1073#1072#1090#1086#1085#1086#1074
        DataBinding.FieldName = 'isCountCount'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object Comment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object isErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 94
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object TreeDS: TDataSource
    DataSet = TreeDataSet
    Left = 96
    Top = 96
  end
  object TreeDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 96
    Top = 144
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cxDBTreeList
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
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 232
    Top = 96
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChoice'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUnitChoiceForm'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbUnitChoiceForm: TdxBarButton
      Action = dsdOpenUnitForm
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1089#1087#1080#1089#1086#1082
      Category = 0
      ImageIndex = 28
    end
    object bbProtocol: TdxBarButton
      Action = actProtocol
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 240
    Top = 176
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
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
      RefreshOnTabSetChanges = False
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      FormName = 'TUnitEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = GridDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      FormName = 'TUnitEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSource = GridDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = TreeDS
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ParentId'
          Value = Null
          Component = TreeDataSet
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ShortCut = 13
      ImageIndex = 7
    end
    object dsdSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = TreeDS
    end
    object dsdOpenUnitForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'dsdOpenUnitForm'
      FormName = 'TUnitForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProtocol: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  object spTree: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Unit_Tree'
    DataSet = TreeDataSet
    DataSets = <
      item
        DataSet = TreeDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 152
    Top = 152
  end
  object GridDS: TDataSource
    DataSet = ClientDataSet
    Left = 360
    Top = 104
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    MasterSource = TreeDS
    PacketRecords = 0
    Params = <>
    Left = 360
    Top = 152
  end
  object spGrid: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Unit'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 416
    Top = 160
  end
  object dsdDBTreeAddOn: TdsdDBTreeAddOn
    ErasedFieldName = 'isErased'
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    DBTreeList = cxDBTreeList
    Left = 192
    Top = 240
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 336
    Top = 280
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 432
    Top = 240
  end
end
