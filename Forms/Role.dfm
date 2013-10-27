object RoleForm: TRoleForm
  Left = 0
  Top = 0
  Caption = #1056#1086#1083#1080' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
  ClientHeight = 370
  ClientWidth = 752
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
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 385
    Height = 344
    Align = alLeft
    TabOrder = 0
    LookAndFeel.NativeStyle = True
    LookAndFeel.SkinName = 'UserSkin'
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taRightJustify
        HeaderAlignmentVert = vaCenter
        Width = 95
      end
      object clName: TcxGridDBColumn
        Caption = #1056#1086#1083#1100
        DataBinding.FieldName = 'Name'
        HeaderAlignmentVert = vaCenter
        Width = 224
      end
      object clErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 105
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxLeftSplitter: TcxSplitter
    Left = 385
    Top = 26
    Width = 8
    Height = 344
    Control = cxGrid
  end
  object Panel1: TPanel
    Left = 393
    Top = 26
    Width = 359
    Height = 344
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 6
    object UserGrid: TcxGrid
      Left = 0
      Top = 252
      Width = 359
      Height = 92
      Align = alClient
      TabOrder = 0
      LookAndFeel.NativeStyle = True
      LookAndFeel.SkinName = 'UserSkin'
      object UserView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = UserDS
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Appending = True
        OptionsData.Deleting = False
        OptionsSelection.InvertSelect = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object cxGridDBColumn1: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'Code'
          Visible = False
          HeaderAlignmentHorz = taRightJustify
          HeaderAlignmentVert = vaCenter
          Width = 95
        end
        object cxGridDBColumn2: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
          DataBinding.FieldName = 'Name'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = UserChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          HeaderAlignmentVert = vaCenter
          Width = 224
        end
      end
      object UserLevel: TcxGridLevel
        GridView = UserView
      end
    end
    object ActionGrid: TcxGrid
      Left = 0
      Top = 0
      Width = 359
      Height = 105
      Align = alTop
      TabOrder = 1
      LookAndFeel.NativeStyle = True
      LookAndFeel.SkinName = 'UserSkin'
      object ActionGridView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = ActionDS
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Appending = True
        OptionsData.Deleting = False
        OptionsSelection.InvertSelect = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object cxGridDBColumn5: TcxGridDBColumn
          Caption = #1044#1077#1081#1089#1090#1074#1080#1077
          DataBinding.FieldName = 'Name'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = ActionChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          HeaderAlignmentVert = vaCenter
          Width = 224
        end
      end
      object ActionGridLevel: TcxGridLevel
        GridView = ActionGridView
      end
    end
    object ProcessGrid: TcxGrid
      Left = 0
      Top = 113
      Width = 359
      Height = 131
      Align = alTop
      TabOrder = 2
      LookAndFeel.NativeStyle = True
      LookAndFeel.SkinName = 'UserSkin'
      object ProcessView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = ProcessDS
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Appending = True
        OptionsData.Deleting = False
        OptionsSelection.InvertSelect = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object cxGridDBColumn8: TcxGridDBColumn
          Caption = #1055#1088#1086#1094#1077#1089#1089
          DataBinding.FieldName = 'Name'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = ProcessChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          HeaderAlignmentVert = vaCenter
          Width = 100
        end
        object clProcess_EnumName: TcxGridDBColumn
          Caption = 'EnumName'
          DataBinding.FieldName = 'Process_EnumName'
          Width = 100
        end
      end
      object ProcessLevel: TcxGridLevel
        GridView = ProcessView
      end
    end
    object cxSplitterTop: TcxSplitter
      Left = 0
      Top = 105
      Width = 359
      Height = 8
      AlignSplitter = salTop
      Control = ActionGrid
    end
    object cxSplitterClient: TcxSplitter
      Left = 0
      Top = 244
      Width = 359
      Height = 8
      AlignSplitter = salTop
      Control = ProcessGrid
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 32
    Top = 72
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 40
    Top = 88
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
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
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 256
    Top = 64
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
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 184
    Top = 64
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
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'
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
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbChoice'
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
    object bbSetErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
    end
    object bbSetUnErased: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
    end
    object bbToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '       '
      Category = 0
      Hint = '       '
      Visible = ivAlways
    end
    object bbChoice: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 216
    Top = 64
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end
        item
          StoredProc = spAction
        end
        item
          StoredProc = spProcess
        end
        item
          StoredProc = spRoleUser
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TRoleEditForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
        end>
      isShowModal = False
      DataSource = DataSource
      DataSetRefresh = actRefresh
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TRoleEditForm'
      GuiParams = <
        item
          Name = 'Id'
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
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
      ErasedFieldName = 'isErased'
      DataSource = DataSource
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
      DataSource = DataSource
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      Params = <
        item
          Name = 'Key'
          Component = ClientDataSet
          ComponentItem = 'Id'
          DataType = ftString
        end
        item
          Name = 'TextValue'
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
    end
    object UserChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = #1042#1099#1073#1086#1088' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
      FormName = 'TUserForm'
      GuiParams = <
        item
          Name = 'Key'
          Component = UserCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'TextValue'
          Component = UserCDS
          ComponentItem = 'Name'
          DataType = ftString
        end>
      isShowModal = False
    end
    object UserUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateUserRole
      StoredProcList = <
        item
          StoredProc = spInsertUpdateUserRole
        end>
      DataSource = UserDS
    end
    object ProcessChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'ProcessChoiceForm'
      FormName = 'TProcessForm'
      GuiParams = <
        item
          Name = 'Key'
          Component = ProcessCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'TextValue'
          Component = ProcessCDS
          ComponentItem = 'Name'
          DataType = ftString
        end>
      isShowModal = False
    end
    object ActionChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'ActionChoiceForm'
      FormName = 'TActionForm'
      GuiParams = <
        item
          Name = 'Key'
          Component = ActionCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'TextValue'
          Component = ActionCDS
          ComponentItem = 'Name'
          DataType = ftString
        end>
      isShowModal = False
    end
    object ProcessUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateRoleProcess
      StoredProcList = <
        item
          StoredProc = spInsertUpdateRoleProcess
        end>
      Caption = 'ActionUpdateDataSet'
      DataSource = ProcessDS
    end
    object ActionUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateRoleAction
      StoredProcList = <
        item
          StoredProc = spInsertUpdateRoleAction
        end>
      Caption = 'ActionUpdateDataSet'
      DataSource = ActionDS
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Role'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    Left = 56
    Top = 104
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
    Left = 248
    Top = 272
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
        ParamType = ptInput
      end>
    Left = 72
    Top = 120
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 288
    Top = 64
  end
  object ProcessDS: TDataSource
    DataSet = ProcessCDS
    Left = 496
    Top = 160
  end
  object ProcessCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'RoleId'
    MasterFields = 'Id'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 448
    Top = 176
  end
  object ProcessAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = ProcessView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    Left = 432
    Top = 208
  end
  object spAction: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_RoleAction'
    DataSet = ActionCDS
    DataSets = <
      item
        DataSet = ActionCDS
      end>
    Params = <>
    Left = 528
    Top = 40
  end
  object ActionDS: TDataSource
    DataSet = ActionCDS
    Left = 488
    Top = 72
  end
  object ActionCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'RoleId'
    MasterFields = 'Id'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 440
    Top = 72
  end
  object ActionAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = ActionGridView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    Left = 448
    Top = 32
  end
  object spProcess: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_RoleProcess'
    DataSet = ProcessCDS
    DataSets = <
      item
        DataSet = ProcessCDS
      end>
    Params = <>
    Left = 480
    Top = 208
  end
  object UserCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'RoleId'
    MasterFields = 'Id'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 416
    Top = 280
  end
  object UserDS: TDataSource
    DataSet = UserCDS
    Left = 480
    Top = 272
  end
  object spRoleUser: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_RoleUser'
    DataSet = UserCDS
    DataSets = <
      item
        DataSet = UserCDS
      end>
    Params = <>
    Left = 464
    Top = 320
  end
  object UserAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = UserView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    Left = 416
    Top = 320
  end
  object spInsertUpdateUserRole: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_UserRole'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = UserCDS
        ComponentItem = 'UserRoleId'
        ParamType = ptInputOutput
      end
      item
        Name = 'inUserId'
        Component = UserCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'RoleId'
        Component = UserCDS
        ComponentItem = 'RoleId'
        ParamType = ptInput
      end>
    Left = 520
    Top = 296
  end
  object spInsertUpdateRoleAction: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_RoleAction'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = ActionCDS
        ComponentItem = 'RoleActionId'
        ParamType = ptInputOutput
      end
      item
        Name = 'inRoleId'
        Component = ActionCDS
        ComponentItem = 'RoleId'
        ParamType = ptInput
      end
      item
        Name = 'inActionId'
        Component = ActionCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 520
    Top = 88
  end
  object spInsertUpdateRoleProcess: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_RoleProcess'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = ProcessCDS
        ComponentItem = 'RoleProcessId'
        ParamType = ptInputOutput
      end
      item
        Name = 'inRoleId'
        Component = ProcessCDS
        ComponentItem = 'RoleId'
        ParamType = ptInput
      end
      item
        Name = 'inProcessId'
        Component = ProcessCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 544
    Top = 208
  end
end
