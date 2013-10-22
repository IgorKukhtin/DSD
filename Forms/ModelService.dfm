object ModelServiceForm: TModelServiceForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1052#1086#1076#1077#1083#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'>'
  ClientHeight = 606
  ClientWidth = 926
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  isAlwaysRefresh = False
  isFree = False
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 481
    Height = 358
    Align = alLeft
    TabOrder = 0
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = MasterDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Appending = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentVert = vaCenter
        Width = 35
      end
      object clName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1052#1086#1076#1077#1083#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
        DataBinding.FieldName = 'Name'
        HeaderAlignmentVert = vaCenter
        Width = 109
      end
      object clModelServiceKindName: TcxGridDBColumn
        Caption = #1058#1080#1087' '#1084#1086#1076#1077#1083#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
        DataBinding.FieldName = 'ModelServiceKindName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ModelServiceKindChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = False
        Width = 90
      end
      object clUnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'UnitName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = UnitFromChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = False
        Width = 87
      end
      object clmsComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        Width = 51
      end
      object clIsErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 93
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxGridModelServiceItemMaster: TcxGrid
    Left = 481
    Top = 26
    Width = 445
    Height = 358
    Align = alClient
    TabOrder = 1
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    ExplicitLeft = 487
    object cxGridDBTableViewModelServiceItemMaster: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ModelServiceItemMasterDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = clSelectKindName
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Appending = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clFromName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1086#1090' '#1082#1086#1075#1086
        DataBinding.FieldName = 'FromName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = UnitFromChoiceFormMaster
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = False
        HeaderAlignmentVert = vaCenter
        Width = 67
      end
      object clToName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1082#1086#1084#1091
        DataBinding.FieldName = 'ToName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = UnitFromChoiceFormChild
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = False
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object clMovementDesc: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
        DataBinding.FieldName = 'MovementDesc'
        HeaderAlignmentVert = vaCenter
        Width = 76
      end
      object clRatio: TcxGridDBColumn
        Caption = #1050#1086#1101#1092'. '#1074#1099#1073#1086#1088#1072' '#1076#1072#1085#1085#1099#1093
        DataBinding.FieldName = 'Ratio'
        HeaderAlignmentVert = vaCenter
        Width = 88
      end
      object clComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        Width = 59
      end
      object clSelectKindName: TcxGridDBColumn
        Caption = #1058#1080#1087' '#1074#1099#1073#1086#1088#1072' '#1076#1072#1085#1085#1099#1093
        DataBinding.FieldName = 'SelectKindName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = SelectKindChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = False
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object clmsimIsErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 25
      end
    end
    object cxGridLevel1: TcxGridLevel
      GridView = cxGridDBTableViewModelServiceItemMaster
    end
  end
  object cxGridStaffListCost: TcxGrid
    Left = 0
    Top = 384
    Width = 926
    Height = 222
    Align = alBottom
    TabOrder = 6
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    ExplicitLeft = -8
    ExplicitTop = 390
    object cxGridDBTableViewModelServiceItemChild: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ModelServiceItemChildDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = clsfcComment
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clmsicFromName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088' '#1086#1090
        DataBinding.FieldName = 'FromName'
        HeaderAlignmentVert = vaCenter
        Width = 301
      end
      object clmsicToName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088' ('#1082#1086#1084#1091')'
        DataBinding.FieldName = 'ToName'
        HeaderAlignmentVert = vaCenter
        Width = 257
      end
      object clsfcComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentVert = vaCenter
        Width = 283
      end
    end
    object cxGridLevel2: TcxGridLevel
      GridView = cxGridDBTableViewModelServiceItemChild
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 56
    Top = 104
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 160
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
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
    Left = 288
    Top = 104
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
    Left = 168
    Top = 104
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
          ItemName = 'bbModelService'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
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
          Visible = True
          ItemName = 'bbModelServiceItemChild'
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
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1075#1083#1072#1074#1085#1099#1081' '#1101#1083#1077#1084#1077#1085#1090
      Category = 0
      Visible = ivAlways
      ImageIndex = 0
      ShortCut = 45
    end
    object bbEdit: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      ShortCut = 115
    end
    object bbErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
    end
    object bbUnErased: TdxBarButton
      Action = dsdSetUnErased
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
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbModelServiceItemChild: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086#1076#1095#1080#1085#1077#1085#1085#1099#1081' '#1101#1083#1077#1084#1077#1085#1090
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086#1076#1095#1080#1085#1077#1085#1085#1099#1081' '#1101#1083#1077#1084#1077#1085#1090
      Visible = ivAlways
      ImageIndex = 0
    end
    object bbModelService: TdxBarButton
      Action = actInsert
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 288
    Top = 160
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spSelectMaster
      StoredProcList = <
        item
          StoredProc = spSelectMaster
        end
        item
          StoredProc = spSelectModelServiceItemMaster
        end
        item
          StoredProc = spSelectModelServiceItemChild
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
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
      ErasedFieldName = 'isErased'
      DataSource = ModelServiceItemMasterDS
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
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      Params = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'Id'
          DataType = ftString
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
        end
        item
          Name = 'PersonalDriverId'
          Component = MasterCDS
          ComponentItem = 'PersonalDriverId'
        end
        item
          Name = 'PersonalDriverCode'
          Component = MasterCDS
          ComponentItem = 'PersonalDriverCode'
        end
        item
          Name = 'PersonalDriverName'
          Component = MasterCDS
          ComponentItem = 'PersonalDriverName'
          DataType = ftString
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = MasterDS
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actUpdateModelServiceItemMaster: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateObjectModelServiceItemMaster
      StoredProcList = <
        item
          StoredProc = spInsertUpdateObjectModelServiceItemMaster
        end>
      Caption = 'dsdUpdateModelServiceItemMaster'
      DataSource = ModelServiceItemMasterDS
    end
    object UnitFromChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'UnitFromChoiceForm'
      FormName = 'TUnitForm'
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'UnitId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object actUpdateModelServiceItemChild: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateObjectModelServiceItemChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateObjectModelServiceItemChild
        end>
      Caption = 'actUpdateModelServiceItemChild'
      DataSource = ModelServiceItemChildDS
    end
    object actUpdateModelService: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateObjectModelService
      StoredProcList = <
        item
          StoredProc = spInsertUpdateObjectModelService
        end>
      Caption = 'actUpdateModelService'
      DataSource = MasterDS
    end
    object ModelServiceKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'ModelServiceKindChoiceForm'
      FormName = 'TModelServiceKindForm'
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'ModelServiceKindId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'ModelServiceKindName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1084#1086#1076#1077#1083#1100
      ImageIndex = 0
      FormName = 'TModelForm'
      GuiParams = <>
      isShowModal = True
      DataSource = MasterDS
      DataSetRefresh = actRefresh
    end
    object actInsertMaster: TdsdInsertUpdateAction
      Category = 'DSDLib'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1075#1083#1072#1074#1085#1099#1081' '#1101#1083#1077#1084#1077#1085#1090
      ImageIndex = 0
      GuiParams = <>
      isShowModal = True
      DataSource = ModelServiceItemMasterDS
      DataSetRefresh = actRefresh
    end
    object UnitFromChoiceFormMaster: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'UnitFromChoiceFormMaster'
      FormName = 'TUnitForm'
      GuiParams = <
        item
          Name = 'Key'
          Component = ModelServiceItemMasterCDS
          ComponentItem = 'UnitId'
        end
        item
          Name = 'TextValue'
          Component = ModelServiceItemMasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object UnitFromChoiceFormChild: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'UnitFromChoiceFormChild'
      FormName = 'TUnitForm'
      GuiParams = <
        item
          Name = 'Key'
          Component = ModelServiceItemChildCDS
          ComponentItem = 'UnitId'
        end
        item
          Name = 'TextValue'
          Component = ModelServiceItemChildCDS
          ComponentItem = 'UnitName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object SelectKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'SelectKindChoiceForm'
      FormName = 'TSelectKindForm'
      GuiParams = <
        item
          Name = 'key'
          Component = ModelServiceItemMasterCDS
          ComponentItem = 'SelectKindId'
        end
        item
          Name = 'TextValue'
          Component = ModelServiceItemMasterCDS
          ComponentItem = 'SelectKindName'
          DataType = ftString
        end>
      isShowModal = True
    end
  end
  object spSelectMaster: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ModelService'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <>
    Left = 48
    Top = 216
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 168
    Top = 160
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    Left = 168
    Top = 216
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 288
    Top = 208
  end
  object ModelServiceItemMasterCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'Id'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 809
    Top = 125
  end
  object ModelServiceItemMasterDS: TDataSource
    DataSet = ModelServiceItemMasterCDS
    Left = 806
    Top = 189
  end
  object spSelectModelServiceItemMaster: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ModelServiceItemMaster'
    DataSet = ModelServiceItemMasterCDS
    DataSets = <
      item
        DataSet = ModelServiceItemMasterCDS
      end>
    Params = <>
    Left = 642
    Top = 157
  end
  object spInsertUpdateObjectModelServiceItemMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ModelServiceItemMaster'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = ModelServiceItemMasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inMovementDesc'
        Component = ModelServiceItemMasterCDS
        ComponentItem = 'MovementDesc'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inRatio'
        Component = ModelServiceItemMasterCDS
        ComponentItem = 'Ratio'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Component = ModelServiceItemMasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inModelServiceId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inFromId'
        Component = ModelServiceItemMasterCDS
        ComponentItem = 'FromId'
        ParamType = ptInput
      end
      item
        Name = 'inToId'
        Component = ModelServiceItemMasterCDS
        ComponentItem = 'ToId'
        ParamType = ptInput
      end
      item
        Name = 'inSelectKindId'
        Component = ModelServiceItemMasterCDS
        ComponentItem = 'SelectKindId'
        ParamType = ptInput
      end>
    Left = 656
    Top = 216
  end
  object ModelServiceItemChildCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'id'
    MasterFields = 'Id'
    MasterSource = ModelServiceItemMasterDS
    PacketRecords = 0
    Params = <>
    Left = 201
    Top = 549
  end
  object ModelServiceItemChildDS: TDataSource
    DataSet = ModelServiceItemChildCDS
    Left = 86
    Top = 549
  end
  object spSelectModelServiceItemChild: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ModelServiceItemChild'
    DataSet = ModelServiceItemChildCDS
    DataSets = <
      item
        DataSet = ModelServiceItemChildCDS
      end>
    Params = <>
    Left = 498
    Top = 477
  end
  object spInsertUpdateObjectModelServiceItemChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ModelServiceItemChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = ModelServiceItemChildCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inComment'
        Component = ModelServiceItemChildCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inFromId'
        Component = ModelServiceItemMasterCDS
        ComponentItem = 'FromId'
        ParamType = ptInput
      end
      item
        Name = 'inToId'
        Component = ModelServiceItemChildCDS
        ComponentItem = 'ToId'
        ParamType = ptInput
      end>
    Left = 320
    Top = 488
  end
  object spInsertUpdateObjectModelService: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ModelService'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
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
        Name = 'inComment'
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
      end
      item
        Name = 'inModelServiceKindId'
        Component = MasterCDS
        ComponentItem = 'ModelServiceKindId'
        ParamType = ptInput
      end>
    Left = 152
    Top = 288
  end
end
