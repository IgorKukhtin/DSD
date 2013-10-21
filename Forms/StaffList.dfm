object StaffListForm: TStaffListForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1064#1090#1072#1090#1085#1086#1077' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077'>'
  ClientHeight = 600
  ClientWidth = 857
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
    Width = 345
    Height = 430
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
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentVert = vaCenter
        Width = 54
      end
      object clName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentVert = vaCenter
        Width = 243
      end
      object clIsErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 32
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxGridStaffList: TcxGrid
    Left = 345
    Top = 26
    Width = 512
    Height = 430
    Align = alClient
    TabOrder = 1
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    object cxGridDBTableViewStaffLis: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = StaffListDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = clFundPayMonth
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
      object clPositionName: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        DataBinding.FieldName = 'PositionName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentVert = vaCenter
        Width = 155
      end
      object clPositionLevelName: TcxGridDBColumn
        Caption = #1056#1072#1079#1088#1103#1076
        DataBinding.FieldName = 'PositionLevelName'
        HeaderAlignmentVert = vaCenter
        Width = 67
      end
      object clHoursPlan: TcxGridDBColumn
        Caption = #1055#1083#1072#1085' '#1095#1072#1089#1086#1074
        DataBinding.FieldName = 'HoursPlan'
        HeaderAlignmentVert = vaCenter
        Width = 98
      end
      object clPersonalCount: TcxGridDBColumn
        Caption = #1050#1086#1083'.'#1077#1076'.'
        DataBinding.FieldName = 'PersonalCount'
        HeaderAlignmentVert = vaCenter
        Width = 61
      end
      object clFundPayMonth: TcxGridDBColumn
        Caption = #1060#1086#1085#1076' '#1086#1087#1083#1072#1090#1099' ('#1079#1072' '#1084#1077#1089#1103#1094')'
        DataBinding.FieldName = 'FundPayMonth'
        HeaderAlignmentVert = vaCenter
        Width = 99
      end
      object clFundPayTurn: TcxGridDBColumn
        Caption = #1060#1086#1085#1076' '#1086#1087#1083#1072#1090#1099' ('#1079#1072' '#1076#1077#1085#1100')'
        DataBinding.FieldName = 'FundPayTurn'
        Width = 90
      end
      object clComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        Width = 89
      end
      object clsfIsErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 46
      end
    end
    object cxGridLevel1: TcxGridLevel
      GridView = cxGridDBTableViewStaffLis
    end
  end
  object cxGrid2: TcxGrid
    Left = 0
    Top = 456
    Width = 857
    Height = 144
    Align = alBottom
    TabOrder = 6
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    object cxGridDBTableView2: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = MasterDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = cxGridDBColumn15
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
      object cxGridDBColumn10: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'UnitName'
        HeaderAlignmentVert = vaCenter
        Width = 132
      end
      object cxGridDBColumn11: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        DataBinding.FieldName = 'PositionName'
        HeaderAlignmentVert = vaCenter
        Width = 155
      end
      object cxGridDBColumn12: TcxGridDBColumn
        Caption = #1056#1072#1079#1088#1103#1076
        DataBinding.FieldName = 'PositionLevelName'
        HeaderAlignmentVert = vaCenter
        Width = 67
      end
      object cxGridDBColumn13: TcxGridDBColumn
        Caption = #1055#1083#1072#1085' '#1095#1072#1089#1086#1074
        DataBinding.FieldName = 'HoursPlan'
        HeaderAlignmentVert = vaCenter
        Width = 98
      end
      object cxGridDBColumn14: TcxGridDBColumn
        Caption = #1050#1086#1083'.'#1077#1076'.'
        DataBinding.FieldName = 'PersonalCount'
        HeaderAlignmentVert = vaCenter
        Width = 61
      end
      object cxGridDBColumn15: TcxGridDBColumn
        Caption = #1060#1086#1085#1076' '#1086#1087#1083#1072#1090#1099' ('#1079#1072' '#1084#1077#1089#1103#1094')'
        DataBinding.FieldName = 'FundPayMonth'
        HeaderAlignmentVert = vaCenter
        Width = 99
      end
      object cxGridDBColumn16: TcxGridDBColumn
        Caption = #1060#1086#1085#1076' '#1086#1087#1083#1072#1090#1099' ('#1079#1072' '#1076#1077#1085#1100')'
        DataBinding.FieldName = 'FundPayTurn'
        Width = 90
      end
      object cxGridDBColumn17: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        Width = 89
      end
      object cxGridDBColumn18: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 46
      end
    end
    object cxGridLevel2: TcxGridLevel
      GridView = cxGridDBTableView2
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
      Action = InsertRecord
      Category = 0
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
      DataSource = MasterDS
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
    object InsertRecord: TInsertRecord
      Category = 'DSDLib'
      View = cxGridDBTableViewStaffLis
      Action = PositionChoiceForm
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1096#1090'.'#1077#1076'.'
      ShortCut = 45
      ImageIndex = 0
    end
    object PositionChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'PositionChoiceForm'
      FormName = 'TPositionForm'
      GuiParams = <
        item
          Name = 'key'
          Component = StaffListCDS
          ComponentItem = 'Positionid'
        end
        item
          Name = 'TextValue'
          Component = StaffListCDS
          ComponentItem = 'PositionName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object actUpdateStaffList: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateObject
      StoredProcList = <
        item
          StoredProc = spInsertUpdateObject
        end>
      Caption = 'dsdUpdateStaffList'
      DataSource = StaffListDS
    end
  end
  object spSelectMaster: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Unit'
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
  object StaffListCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'Id'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 425
    Top = 309
  end
  object StaffListDS: TDataSource
    DataSet = StaffListCDS
    Left = 422
    Top = 229
  end
  object spSelectStaffList: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_StaffList'
    DataSet = StaffListCDS
    DataSets = <
      item
        DataSet = StaffListCDS
      end>
    Params = <>
    Left = 514
    Top = 213
  end
  object spInsertUpdateObject: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_StaffList'
    DataSet = StaffListCDS
    DataSets = <
      item
        DataSet = StaffListCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = StaffListCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inHoursPlan'
        Component = StaffListCDS
        ComponentItem = 'HoursPlan'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPersonalCount'
        Component = StaffListCDS
        ComponentItem = 'PersonalCount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inFundPayMonth'
        Component = StaffListCDS
        ComponentItem = 'FundPayMonth'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inFundPayTurn'
        Component = StaffListCDS
        ComponentItem = 'inFundPayTurn'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Component = StaffListCDS
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
        Name = 'inPositionId'
        Component = StaffListCDS
        ComponentItem = 'inPositionId'
        ParamType = ptInput
      end
      item
        Name = 'inPositionLevelId'
        Component = StaffListCDS
        ComponentItem = 'PositionLevelId'
        ParamType = ptInput
      end>
    Left = 640
    Top = 208
  end
end
