inherited JuridicalForm: TJuridicalForm
  Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
  ClientHeight = 473
  ClientWidth = 691
  ExplicitWidth = 699
  ExplicitHeight = 500
  PixelsPerInch = 96
  TextHeight = 13
  object cxDBTreeList: TcxDBTreeList
    Left = 0
    Top = 26
    Width = 289
    Height = 447
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
    RootValue = -1
    Styles.StyleSheet = dmMain.cxTreeListStyleSheet
    TabOrder = 1
    object ceName: TcxDBTreeListColumn
      Caption.Text = #1043#1088#1091#1087#1087#1072
      DataBinding.FieldName = 'Name'
      Options.Editing = False
      Width = 128
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
  object cxSplitter: TcxSplitter
    Left = 289
    Top = 26
    Width = 8
    Height = 447
    Control = cxDBTreeList
  end
  object cxGrid: TcxGrid
    Left = 297
    Top = 26
    Width = 394
    Height = 447
    Align = alClient
    TabOrder = 6
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = GridDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object ceTreeState: TcxGridDBColumn
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
        Width = 24
        IsCaptionAssigned = True
      end
      object ceCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taRightJustify
        HeaderAlignmentVert = vaCenter
        Width = 53
      end
      object ceJuridicalName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentVert = vaCenter
        Width = 183
      end
      object ceisErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 66
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
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
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
          ItemName = 'bbChoiceGuides'
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
    end
    object bbInsert: TdxBarButton
      Action = actInsert
      Category = 0
    end
    object bbEdit: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object bbErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
    end
    object bbUnErased: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbGridToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 232
    Top = 144
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = TreeStoredProc
      StoredProcList = <
        item
          StoredProc = TreeStoredProc
        end
        item
          StoredProc = GridStoredProc
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TJuridicalEditForm'
      GuiParams = <
        item
          Name = 'Id'
          DataType = ftInteger
          ParamType = ptOutput
          Value = '0'
        end>
      isShowModal = True
      DataSource = GridDS
      DataSetRefresh = actRefresh
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TJuridicalEditForm'
      GuiParams = <
        item
          Name = 'Id'
          Component = GridDataSet
          ComponentItem = 'Id'
          DataType = ftInteger
          ParamType = ptInput
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSource = GridDS
      DataSetRefresh = actRefresh
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      DataSource = GridDS
    end
    object dsdSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
      isSetErased = False
      DataSource = GridDS
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      Params = <
        item
          Name = 'Key'
          Component = GridDataSet
          ComponentItem = 'Id'
          DataType = ftString
          ParamType = ptOutput
        end
        item
          Name = 'TextValue'
          Component = GridDataSet
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptOutput
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ShortCut = 13
      ImageIndex = 7
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
  end
  object TreeStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Juridical_Tree'
    DataSet = TreeDataSet
    DataSets = <
      item
        DataSet = TreeDataSet
      end>
    Params = <>
    Left = 152
    Top = 152
  end
  object dsdFormParams: TdsdFormParams
    Params = <>
    Left = 136
    Top = 216
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    SortImages = dmMain.SortImageList
    View = cxGridDBTableView
    Left = 360
    Top = 256
  end
  object dsdDBTreeAddOn: TdsdDBTreeAddOn
    SortImages = dmMain.SortImageList
    isLeafFieldName = 'isLeaf'
    DBTreeList = cxDBTreeList
    Left = 80
    Top = 208
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 336
    Top = 208
  end
  object GridDS: TDataSource
    DataSet = GridDataSet
    Left = 336
    Top = 104
  end
  object GridDataSet: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'JuridicalGroupId'
    MasterFields = 'Id'
    MasterSource = TreeDS
    PacketRecords = 0
    Params = <>
    Left = 336
    Top = 152
  end
  object GridStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Juridical'
    DataSet = GridDataSet
    DataSets = <
      item
        DataSet = GridDataSet
      end>
    Params = <>
    Left = 392
    Top = 160
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Component = ClientDataSet
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInput
      end>
    Left = 288
    Top = 208
  end
end
