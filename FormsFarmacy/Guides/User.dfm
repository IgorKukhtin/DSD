object UserForm: TUserForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080'>'
  ClientHeight = 357
  ClientWidth = 1006
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
    Width = 649
    Height = 331
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
      OptionsData.Inserting = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 26
      end
      object clName: TcxGridDBColumn
        Caption = #1051#1086#1075#1080#1085
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 87
      end
      object clMemberName: TcxGridDBColumn
        Caption = #1060#1048#1054
        DataBinding.FieldName = 'MemberName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 87
      end
      object BranchCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1092'.'
        DataBinding.FieldName = 'BranchCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 26
      end
      object BranchName: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083
        DataBinding.FieldName = 'BranchName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 61
      end
      object UnitCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1087'.'
        DataBinding.FieldName = 'UnitCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 35
      end
      object UnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'UnitName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 61
      end
      object PositionName: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        DataBinding.FieldName = 'PositionName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 61
      end
      object isSite: TcxGridDBColumn
        Caption = #1044#1083#1103' '#1089#1072#1081#1090#1072
        DataBinding.FieldName = 'isSite'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1083#1103' '#1089#1072#1081#1090#1072' ('#1076#1072'/'#1085#1077#1090')'
        Width = 60
      end
      object User_: TcxGridDBColumn
        DataBinding.FieldName = 'User_'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 47
      end
      object UserSign: TcxGridDBColumn
        Caption = #1069#1083'. '#1087#1086#1076#1087#1080#1089#1100
        DataBinding.FieldName = 'UserSign'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object UserSeal: TcxGridDBColumn
        Caption = #1069#1083'. '#1087#1077#1095#1072#1090#1100
        DataBinding.FieldName = 'UserSeal'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object UserKey: TcxGridDBColumn
        Caption = #1069#1083'. '#1050#1083#1102#1095
        DataBinding.FieldName = 'UserKey'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object clProjectMobile: TcxGridDBColumn
        Caption = #1057#1077#1088#1080#1081#1085#1099#1081' '#8470' '#1084#1086#1073'. '#1091#1089#1090#1088'-'#1074#1072
        DataBinding.FieldName = 'ProjectMobile'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 82
      end
      object clisProjectMobile: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1099#1081' '#1072#1075#1077#1085#1090
        DataBinding.FieldName = 'isProjectMobile'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1058#1086#1088#1075#1086#1074#1099#1081' '#1072#1075#1077#1085#1090' ('#1044#1072'/'#1053#1077#1090')'
        Options.Editing = False
        Width = 70
      end
      object BillNumberMobile: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'. '#1089' '#1084#1086#1073'. '#1091#1089#1090#1088'-'#1074#1072
        DataBinding.FieldName = 'BillNumberMobile'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object clUpdateMobileFrom: TcxGridDBColumn
        Caption = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' '#1089#1080#1085#1093#1088'. '#1089' '#1084#1086#1073'. '#1091#1089#1090'-'#1074#1072
        DataBinding.FieldName = 'UpdateMobileFrom'
        Options.Editing = False
      end
      object clUpdateMobileTo: TcxGridDBColumn
        Caption = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' '#1089#1080#1085#1093#1088'. '#1085#1072' '#1084#1086#1073'. '#1091#1089#1090'-'#1074#1072
        DataBinding.FieldName = 'UpdateMobileTo'
        Options.Editing = False
      end
      object clErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object Foto: TcxGridDBColumn
        Caption = #1055#1091#1090#1100' '#1082' '#1092#1086#1090#1086
        DataBinding.FieldName = 'Foto'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1091#1090#1100' '#1082' '#1089#1090#1072#1085#1076#1072#1088#1090#1085#1099#1084' '#1092#1086#1090#1086
        Options.Editing = False
        Width = 80
      end
      object InDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1087#1088#1080#1085#1103#1090#1080#1103' '#1085#1072' '#1088#1072#1073#1086#1090#1091
        DataBinding.FieldName = 'InDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 77
      end
      object FarmacyCashDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1087#1086#1089#1083'. '#1076#1077#1081#1089#1090#1074'.'
        DataBinding.FieldName = 'FarmacyCashDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1082#1086#1075#1076#1072' '#1074' '#1087#1086#1089#1083#1077#1076#1085#1080#1081' '#1088#1072#1079' '#1088#1072#1073#1086#1090#1072#1083' '#1080' '#1087#1088#1086#1074#1086#1076#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1063#1077#1082
        Options.Editing = False
        Width = 84
      end
      object isNewUser: TcxGridDBColumn
        Caption = #1053#1086#1074#1099#1081' '#1089#1086#1090#1088#1091#1076#1085#1080#1082
        DataBinding.FieldName = 'isNewUser'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 76
      end
      object isDismissedUser: TcxGridDBColumn
        Caption = #1059#1074#1086#1083#1077#1085#1085#1099#1081' '#1089#1086#1090#1088#1091#1076#1085#1080#1082
        DataBinding.FieldName = 'isDismissedUser'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 89
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxSplitter: TcxSplitter
    Left = 649
    Top = 26
    Width = 2
    Height = 331
    Control = cxGrid
  end
  object Panel: TPanel
    Left = 651
    Top = 26
    Width = 355
    Height = 331
    Align = alClient
    TabOrder = 2
    object RoleGrid: TcxGrid
      Left = 1
      Top = 1
      Width = 353
      Height = 176
      Align = alTop
      TabOrder = 1
      LookAndFeel.NativeStyle = True
      LookAndFeel.SkinName = 'UserSkin'
      object RoleGridView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = RoleDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Appending = True
        OptionsData.Deleting = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object cxGridDBColumn5: TcxGridDBColumn
          Caption = #1056#1086#1083#1100
          DataBinding.FieldName = 'Name'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = OpenChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentVert = vaCenter
          Width = 224
        end
      end
      object RoleGridLevel: TcxGridLevel
        GridView = RoleGridView
      end
    end
    object PeriodCloseGrid: TcxGrid
      Left = 1
      Top = 180
      Width = 353
      Height = 150
      Align = alClient
      TabOrder = 0
      LookAndFeel.NativeStyle = True
      LookAndFeel.SkinName = 'UserSkin'
      object PeriodCloseGridView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = PeriodCloseDS
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
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object RoleName: TcxGridDBColumn
          Caption = #1056#1086#1083#1080
          DataBinding.FieldName = 'RoleName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = ChoiceRole
              Default = True
              Kind = bkEllipsis
            end>
          Width = 159
        end
        object Name: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072
          DataBinding.FieldName = 'Name'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = ChoiceUnit
              Default = True
              Kind = bkEllipsis
            end>
          Width = 232
        end
        object CloseDate_excl: TcxGridDBColumn
          Caption = #1055#1077#1088#1080#1086#1076
          DataBinding.FieldName = 'CloseDate_excl'
          Width = 68
        end
      end
      object PeriodCloseGridLevel: TcxGridLevel
        GridView = PeriodCloseGridView
      end
    end
    object HorSplitter: TcxSplitter
      Left = 1
      Top = 177
      Width = 353
      Height = 3
      AlignSplitter = salTop
      Control = RoleGrid
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 16
    Top = 200
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 24
    Top = 128
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cxGrid
        Properties.Strings = (
          'Width')
      end
      item
        Component = Panel
        Properties.Strings = (
          'Width')
      end
      item
        Component = PeriodCloseGrid
        Properties.Strings = (
          'Height')
      end
      item
        Component = RoleGrid
        Properties.Strings = (
          'Height')
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
    Top = 120
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
    Top = 144
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
          ItemName = 'bbProtocolRole'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
          Visible = True
          ItemName = 'bbOpenUserHelsiEdit'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
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
      ShowCaption = False
    end
    object bbChoice: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbProtocolOpen: TdxBarButton
      Action = actProtocolOpenForm
      Category = 0
    end
    object bbProtocolRole: TdxBarButton
      Action = actProtocolRoleForm
      Category = 0
    end
    object bbOpenUserHelsiEdit: TdxBarButton
      Action = OpenUserHelsiEditForm
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actClearDefaultUnit
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 312
    Top = 160
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spUserRole
        end
        item
          StoredProc = spPeriodClose
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
      FormName = 'TUserEditForm'
      FormNameParam.Value = 'TUserEditForm'
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
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TUserEditForm'
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
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
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
        end
        item
          Name = 'BranchName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BranchName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PositionName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'MemberName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
    end
    object UpdateDataSetUser: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateUser
      StoredProcList = <
        item
          StoredProc = spInsertUpdateUser
        end>
      Caption = 'UpdateDataSetUser'
      DataSource = DataSource
    end
    object UpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateUserRole
      StoredProcList = <
        item
          StoredProc = spInsertUpdateUserRole
        end>
      Caption = 'UpdateDataSet'
      DataSource = RoleDS
    end
    object OpenChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      FormName = 'TRoleForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = RoleCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = RoleCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object ChoiceRole: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      FormName = 'TRoleForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PeriodCloseCDS
          ComponentItem = 'RoleId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PeriodCloseCDS
          ComponentItem = 'RoleName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object ChoiceUnit: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      FormName = 'TObject_UnitForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PeriodCloseCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PeriodCloseCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object UpdatePeriodClose: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdatePeriodClose
      StoredProcList = <
        item
          StoredProc = spInsertUpdatePeriodClose
        end>
      DataSource = PeriodCloseDS
    end
    object actProtocolRoleForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1056#1086#1083#1080
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1056#1086#1083#1080
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = RoleCDS
          ComponentItem = 'UserRoleId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = RoleCDS
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
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
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
    object OpenUserHelsiEditForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1059#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1076#1083#1103' '#1076#1086#1089#1090#1091#1087#1072' '#1082' '#1089#1072#1081#1090#1072#1084' '#1076#1083#1103' '#1087#1086#1075#1072#1096#1077#1085#1080#1103' '#1088#1077#1094#1077#1087#1090#1086#1074
      Hint = #1059#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1076#1083#1103' '#1076#1086#1089#1090#1091#1087#1072' '#1082' '#1089#1072#1081#1090#1072#1084' '#1076#1083#1103' '#1087#1086#1075#1072#1096#1077#1085#1080#1103' '#1088#1077#1094#1077#1087#1090#1086#1074
      ImageIndex = 55
      FormName = 'TUserHelsiEditForm'
      FormNameParam.Value = 'TUserHelsiEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'ID'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'ID'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actClearDefaultUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spClearDefaultUnit
      StoredProcList = <
        item
          StoredProc = spClearDefaultUnit
        end>
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1074' '#1076#1077#1092#1072#1091#1083#1100#1090#1077' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1074' '#1076#1077#1092#1072#1091#1083#1100#1090#1077' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
      ImageIndex = 76
      QuestionBeforeExecute = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1074' '#1076#1077#1092#1072#1091#1083#1100#1090#1077' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086'.'
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_User'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 88
    Top = 120
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
    Left = 248
    Top = 232
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inobjectid'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 72
    Top = 184
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 272
    Top = 192
  end
  object RoleAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
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
    PropertiesCellList = <>
    Left = 392
    Top = 96
  end
  object spUserRole: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_UserRole'
    DataSet = RoleCDS
    DataSets = <
      item
        DataSet = RoleCDS
      end>
    Params = <>
    PackSize = 1
    Left = 528
    Top = 152
  end
  object spInsertUpdateUserRole: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_UserRole'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioid'
        Value = Null
        Component = RoleCDS
        ComponentItem = 'UserRoleId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inuserid'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inroleid'
        Value = Null
        Component = RoleCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 528
    Top = 120
  end
  object RoleDS: TDataSource
    DataSet = RoleCDS
    Left = 472
    Top = 160
  end
  object RoleCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'UserId'
    MasterFields = 'Id'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 432
    Top = 128
  end
  object PeriodCloseDS: TDataSource
    DataSet = PeriodCloseCDS
    Left = 384
    Top = 216
  end
  object PeriodCloseCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'UserId_excl'
    MasterFields = 'Id'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 384
    Top = 264
  end
  object PeriodCloseViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    OnDblClickActionList = <>
    ActionItemList = <>
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 472
    Top = 216
  end
  object spPeriodClose: TdsdStoredProc
    StoredProcName = 'gpSelect_PeriodClose'
    DataSet = PeriodCloseCDS
    DataSets = <
      item
        DataSet = PeriodCloseCDS
      end>
    Params = <>
    PackSize = 1
    Left = 600
    Top = 144
  end
  object spInsertUpdatePeriodClose: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_PeriodClose'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioid'
        Value = Null
        Component = PeriodCloseCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inuserid'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inroleid'
        Value = Null
        Component = PeriodCloseCDS
        ComponentItem = 'RoleId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inunitid'
        Value = Null
        Component = PeriodCloseCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inperiod'
        Value = Null
        Component = PeriodCloseCDS
        ComponentItem = 'Period'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 576
    Top = 232
  end
  object spInsertUpdateUser: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_User'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioid'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPassword'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'User_'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSign'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'UserSign'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSeal'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'UserSeal'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKey'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'UserKey'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProjectMobile'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'ProjectMobile'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisProjectMobile'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isProjectMobile'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSite'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isSite'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'MemberId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPasswordWages'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PasswordWages'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisWorkingMultiple'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isWorkingMultiple'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNewUser'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isNewUser'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDismissedUser'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isDismissedUser'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 120
    Top = 224
  end
  object spClearDefaultUnit: TdsdStoredProc
    StoredProcName = 'gpUpdate_Clear_DefaultUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUserID'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 120
    Top = 280
  end
end
