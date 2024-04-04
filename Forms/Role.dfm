object RoleForm: TRoleForm
  Left = 0
  Top = 0
  Caption = #1056#1086#1083#1080' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
  ClientHeight = 527
  ClientWidth = 765
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
    Height = 501
    Align = alLeft
    TabOrder = 0
    LookAndFeel.NativeStyle = True
    LookAndFeel.SkinName = 'UserSkin'
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
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
        Width = 55
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
        Visible = False
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
    Height = 501
    Control = cxGrid
  end
  object Panel1: TPanel
    Left = 393
    Top = 26
    Width = 372
    Height = 501
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 6
    object UserGrid: TcxGrid
      Left = 0
      Top = 248
      Width = 372
      Height = 125
      Align = alTop
      TabOrder = 0
      LookAndFeel.NativeStyle = True
      LookAndFeel.SkinName = 'UserSkin'
      object UserView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = UserDS
        DataController.Filter.Options = [fcoCaseInsensitive]
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
        object colCodeUser: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'Code'
          Visible = False
          HeaderAlignmentHorz = taRightJustify
          HeaderAlignmentVert = vaCenter
          Width = 95
        end
        object colNameUser: TcxGridDBColumn
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
          Width = 167
        end
        object BranchName: TcxGridDBColumn
          Caption = #1060#1080#1083#1080#1072#1083
          DataBinding.FieldName = 'BranchName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 64
        end
        object UnitName: TcxGridDBColumn
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          DataBinding.FieldName = 'UnitName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 63
        end
        object PositionName: TcxGridDBColumn
          Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
          DataBinding.FieldName = 'PositionName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 64
        end
        object colisErased: TcxGridDBColumn
          Caption = #1059#1076#1072#1083#1077#1085
          DataBinding.FieldName = 'isErased'
          Visible = False
          Width = 20
        end
      end
      object UserLevel: TcxGridLevel
        GridView = UserView
      end
    end
    object ActionGrid: TcxGrid
      Left = 0
      Top = 0
      Width = 372
      Height = 105
      Align = alTop
      TabOrder = 1
      LookAndFeel.NativeStyle = True
      LookAndFeel.SkinName = 'UserSkin'
      object ActionGridView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = ActionDS
        DataController.Filter.Options = [fcoCaseInsensitive]
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
      Top = 111
      Width = 372
      Height = 131
      Align = alTop
      TabOrder = 2
      LookAndFeel.NativeStyle = True
      LookAndFeel.SkinName = 'UserSkin'
      object ProcessView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = ProcessDS
        DataController.Filter.Options = [fcoCaseInsensitive]
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
          Caption = #1055#1088#1086#1094#1077#1089#1089' '#1080#1079#1084#1077#1085#1077#1085#1080#1077
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
      Width = 372
      Height = 6
      AlignSplitter = salTop
      Control = ActionGrid
    end
    object cxSplitterClient: TcxSplitter
      Left = 0
      Top = 373
      Width = 372
      Height = 6
      AlignSplitter = salTop
      Control = UserGrid
    end
    object AccessGrid: TcxGrid
      Left = 0
      Top = 379
      Width = 372
      Height = 122
      Align = alClient
      TabOrder = 5
      LookAndFeel.NativeStyle = True
      LookAndFeel.SkinName = 'UserSkin'
      object AccessGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = ProcessAccessDS
        DataController.Filter.Options = [fcoCaseInsensitive]
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
        object cxGridDBColumn3: TcxGridDBColumn
          Caption = #1055#1088#1086#1094#1077#1089#1089' '#1076#1086#1089#1090#1091#1087
          DataBinding.FieldName = 'Name'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = ProcessAccessChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          HeaderAlignmentVert = vaCenter
          Width = 100
        end
        object cxGridDBColumn4: TcxGridDBColumn
          Caption = 'EnumName'
          DataBinding.FieldName = 'Process_EnumName'
          Width = 100
        end
      end
      object AccessGridLevel: TcxGridLevel
        GridView = AccessGridDBTableView
      end
    end
    object cxSplitter1: TcxSplitter
      Left = 0
      Top = 242
      Width = 372
      Height = 6
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
          ItemName = 'bbInsertMask'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'
        end
        item
          BeginGroup = True
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
          ItemName = 'bbChoice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpen'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolAction'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolProcess'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolUser'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolProcessAccess'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel_1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel_2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel_3'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel_4'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel_5'
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
    object dxBarStatic: TdxBarStatic
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbChoice: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbInsertMask: TdxBarButton
      Action = actInsertMask
      Category = 0
    end
    object bbProtocolOpen: TdxBarButton
      Action = actProtocolOpenForm
      Category = 0
    end
    object bbProtocolAction: TdxBarButton
      Action = actProtocolActionForm
      Category = 0
    end
    object bbProtocolProcess: TdxBarButton
      Action = actProtocolProcessForm
      Category = 0
    end
    object bbProtocolProcessAccess: TdxBarButton
      Action = actProtocolProcessAccessForm
      Category = 0
    end
    object bbProtocolUser: TdxBarButton
      Action = actProtocolUserForm
      Category = 0
    end
    object bbGridToExcel_1: TdxBarButton
      Action = actGridToExcel_1
      Category = 0
    end
    object bbGridToExcel_2: TdxBarButton
      Action = actGridToExcel_2
      Category = 0
    end
    object bbGridToExcel_3: TdxBarButton
      Action = actGridToExcel_3
      Category = 0
    end
    object bbGridToExcel_4: TdxBarButton
      Action = actGridToExcel_4
      Category = 0
    end
    object bbGridToExcel_5: TdxBarButton
      Action = actGridToExcel_5
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 216
    Top = 64
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
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
        end
        item
          StoredProc = spProcessAccess
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TRoleEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsertMask: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      ShortCut = 16429
      ImageIndex = 54
      FormName = 'TRoleMaskEditForm'
      FormNameParam.Value = 'TRoleMaskEditForm'
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
      isShowModal = False
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TRoleEditForm'
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
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
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
      MoveParams = <>
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
    object actGridToExcel_1: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel - 1'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16433
    end
    object actGridToExcel_2: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = ActionGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel - 2'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16434
    end
    object actGridToExcel_3: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = ProcessGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel - 3'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16435
    end
    object actGridToExcel_4: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = UserGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel - 4'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16436
    end
    object actGridToExcel_5: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = AccessGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel - 5'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16437
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
          Name = 'Code'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
    end
    object UserChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1042#1099#1073#1086#1088' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
      FormName = 'TUserForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = UserCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = UserCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName'
          Value = Null
          Component = UserCDS
          ComponentItem = 'BranchName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = UserCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionName'
          Value = Null
          Component = UserCDS
          ComponentItem = 'PositionName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object UserUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateUserRole
      StoredProcList = <
        item
          StoredProc = spInsertUpdateUserRole
        end>
      DataSource = UserDS
    end
    object ProcessAccessChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ProcessChoiceForm'
      FormName = 'TProcessForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ProcessAccessCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ProcessAccessCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object ProcessChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ProcessChoiceForm'
      FormName = 'TProcessForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ProcessCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ProcessCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object ActionChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ActionChoiceForm'
      FormName = 'TActionForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ActionCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ActionCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object ProcessAccessUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateProcessAccess
      StoredProcList = <
        item
          StoredProc = spInsertUpdateProcessAccess
        end>
      Caption = 'ActionUpdateDataSet'
      DataSource = ProcessAccessDS
    end
    object ProcessUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
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
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateRoleAction
      StoredProcList = <
        item
          StoredProc = spInsertUpdateRoleAction
        end>
      Caption = 'ActionUpdateDataSet'
      DataSource = ActionDS
    end
    object actProtocolUserForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = UserCDS
          ComponentItem = 'UserRoleId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = UserCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actProtocolProcessAccessForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1055#1088#1086#1094#1077#1089#1089' '#1076#1086#1089#1090#1091#1087
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1055#1088#1086#1094#1077#1089#1089' '#1076#1086#1089#1090#1091#1087
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ProcessAccessCDS
          ComponentItem = 'RoleProcessId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ProcessAccessCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actProtocolProcessForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1055#1088#1086#1094#1077#1089#1089#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1055#1088#1086#1094#1077#1089#1089#1072
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ProcessCDS
          ComponentItem = 'RoleProcessId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ProcessCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actProtocolActionForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1044#1077#1081#1089#1090#1074#1080#1103
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1044#1077#1081#1089#1090#1074#1080#1103
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ActionCDS
          ComponentItem = 'RoleActionId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ActionCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actProtocolOpenForm: TdsdOpenForm
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
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Role'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
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
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
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
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 112
    Top = 128
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
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
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
    PackSize = 1
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
    Left = 424
    Top = 88
  end
  object ActionAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = ActionGridView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 456
    Top = 48
  end
  object spProcess: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_RoleProcess'
    DataSet = ProcessCDS
    DataSets = <
      item
        DataSet = ProcessCDS
      end>
    Params = <>
    PackSize = 1
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
    Left = 432
    Top = 304
  end
  object UserDS: TDataSource
    DataSet = UserCDS
    Left = 472
    Top = 304
  end
  object spRoleUser: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_RoleUser'
    DataSet = UserCDS
    DataSets = <
      item
        DataSet = UserCDS
      end>
    Params = <>
    PackSize = 1
    Left = 488
    Top = 336
  end
  object UserAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = UserView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
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
        Value = Null
        Component = UserCDS
        ComponentItem = 'UserRoleId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserId'
        Value = Null
        Component = UserCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RoleId'
        Value = Null
        Component = UserCDS
        ComponentItem = 'RoleId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
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
        Value = Null
        Component = ActionCDS
        ComponentItem = 'RoleActionId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRoleId'
        Value = Null
        Component = ActionCDS
        ComponentItem = 'RoleId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inActionId'
        Value = Null
        Component = ActionCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 544
    Top = 88
  end
  object spInsertUpdateRoleProcess: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_RoleProcess'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ProcessCDS
        ComponentItem = 'RoleProcessId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRoleId'
        Value = Null
        Component = ProcessCDS
        ComponentItem = 'RoleId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProcessId'
        Value = Null
        Component = ProcessCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 544
    Top = 208
  end
  object ProcessAccessViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = ProcessView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 600
    Top = 464
  end
  object ProcessAccessCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'RoleId'
    MasterFields = 'Id'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 616
    Top = 432
  end
  object ProcessAccessDS: TDataSource
    DataSet = ProcessAccessCDS
    Left = 664
    Top = 416
  end
  object spProcessAccess: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_RoleProcessAccess'
    DataSet = ProcessAccessCDS
    DataSets = <
      item
        DataSet = ProcessAccessCDS
      end>
    Params = <>
    PackSize = 1
    Left = 648
    Top = 464
  end
  object spInsertUpdateProcessAccess: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_RoleProcessAccess'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioid'
        Value = Null
        Component = ProcessAccessCDS
        ComponentItem = 'RoleProcessId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inroleid'
        Value = Null
        Component = ProcessAccessCDS
        ComponentItem = 'RoleId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inprocessid'
        Value = Null
        Component = ProcessAccessCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 712
    Top = 464
  end
end
