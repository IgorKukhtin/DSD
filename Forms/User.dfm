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
  AddOnFormData.Params = FormParams
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
    ExplicitLeft = 608
    ExplicitTop = 363
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = 'C'#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = clMemberName
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
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
      object isDateOut: TcxGridDBColumn
        Caption = #1059#1074#1086#1083#1077#1085
        DataBinding.FieldName = 'isDateOut'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1059#1074#1086#1083#1077#1085' '#1044#1072'/'#1053#1077#1090
        Options.Editing = False
        Width = 33
      end
      object DateOut: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1091#1074'.'
        DataBinding.FieldName = 'DateOut'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
        Options.Editing = False
        Width = 63
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
      object MobileModel: TcxGridDBColumn
        Caption = #1052#1086#1076#1077#1083#1100' '#1084#1086#1073'. '#1091#1089#1090#1088'-'#1074#1072
        DataBinding.FieldName = 'MobileModel'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object MobileVesion: TcxGridDBColumn
        Caption = #1042#1077#1088#1089#1080#1103' Android'
        DataBinding.FieldName = 'MobileVesion'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object MobileVesionSDK: TcxGridDBColumn
        Caption = #1042#1077#1088#1089#1080#1103' SDK + ProjectMobile'
        DataBinding.FieldName = 'MobileVesionSDK'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
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
      object PhoneAuthent: TcxGridDBColumn
        Caption = #8470' '#1090#1077#1083'. ('#1040#1091#1090#1077#1085#1090#1080#1092#1080#1082#1072#1094#1080#1103')'
        DataBinding.FieldName = 'PhoneAuthent'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #8470' '#1090#1077#1083#1077#1092#1086#1085#1072' '#1076#1083#1103' '#1040#1091#1090#1077#1085#1090#1080#1092#1080#1082#1072#1094#1080#1080
        Options.Editing = False
        Width = 85
      end
      object isProjectAuthent: TcxGridDBColumn
        Caption = 'Google Authenticator'
        DataBinding.FieldName = 'isProjectAuthent'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1040#1091#1090#1077#1085#1090#1080#1092#1080#1082#1072#1094#1080#1103' - Google Authenticator ('#1044#1072'/'#1053#1077#1090')'
        Options.Editing = False
        Width = 85
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
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object clUpdateMobileTo: TcxGridDBColumn
        Caption = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' '#1089#1080#1085#1093#1088'. '#1085#1072' '#1084#1086#1073'. '#1091#1089#1090'-'#1074#1072
        DataBinding.FieldName = 'UpdateMobileTo'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object GUID: TcxGridDBColumn
        Caption = 'UUID '#1089#1077#1089#1089#1080#1080
        DataBinding.FieldName = 'GUID'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = 'UUID '#1089#1077#1089#1089#1080#1080' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
        Options.Editing = False
        Width = 85
      end
      object Data_GUID: TcxGridDBColumn
        Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1086#1082#1086#1085'. '#1080#1089#1087'. UUID-'#1089#1077#1089#1089#1080#1080
        DataBinding.FieldName = 'Data_GUID'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1076#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1103' UUID-'#1089#1077#1089#1089#1080#1080
        Options.Editing = False
        Width = 85
      end
      object isKeyAuthent: TcxGridDBColumn
        Caption = #1057#1077#1082#1088#1077#1090#1085#1099#1081' '#1050#1083#1102#1095' ('#1076#1072'/'#1085#1077#1090')'
        DataBinding.FieldName = 'isKeyAuthent'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1057#1086#1079#1076#1072#1085' '#1057#1077#1082#1088#1077#1090#1085#1099#1081' '#1050#1083#1102#1095' '#1076#1083#1103' Google Authenticator'
        Options.Editing = False
        Width = 80
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
        object Code_ch1: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'Code'
          Options.Editing = False
          Width = 50
        end
        object Name_ch1: TcxGridDBColumn
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
          Width = 289
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
          Width = 220
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
    Left = 240
    Top = 56
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
    Left = 216
    Top = 112
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
          ItemName = 'bbUpdate_PhoneAuthent'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_UserRole_forMask'
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
          ItemName = 'bbUpdate_KeyAuthent'
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
          ItemName = 'bbsPrint'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel_Role'
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
    object bbGridToExcel: TdxBarButton
      Action = actGridToExcel
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
    object bbProtocolOpen: TdxBarButton
      Action = actProtocolOpenForm
      Category = 0
    end
    object bbProtocolRole: TdxBarButton
      Action = actProtocolRoleForm
      Category = 0
    end
    object bbUpdate_PhoneAuthent: TdxBarButton
      Action = macUpdate_PhoneAuthent
      Category = 0
    end
    object bbUpdate_UserRole_forMask: TdxBarButton
      Action = macUpdate_UserRole_byMask
      Category = 0
    end
    object bbUpdate_KeyAuthent: TdxBarButton
      Action = actUpdate_KeyAuthent
      Category = 0
    end
    object bbGridToExcel_Role: TdxBarButton
      Action = actGridToExcel_Role
      Category = 0
    end
    object bbPrintUser_Badge: TdxBarButton
      Action = actPrintUser_Badge
      Category = 0
    end
    object bbPrintUser_Badge_list: TdxBarButton
      Action = macPrintUser_Badge_list
      Category = 0
    end
    object bbsPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 3
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrintUser_Badge'
        end
        item
          Visible = True
          ItemName = 'bbPrintUser_Badge_list'
        end>
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 296
    Top = 72
    object actRefresh_Role: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUserRole
      StoredProcList = <
        item
          StoredProc = spUserRole
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
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
    object actGridToExcel_Role: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = RoleGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel ('#1056#1086#1083#1080')'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel ('#1056#1086#1083#1080')'
      ImageIndex = 6
      ShortCut = 16434
    end
    object actGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel ('#1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080')'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel ('#1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080')'
      ImageIndex = 6
      ShortCut = 16433
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
    object macUpdate_PhoneAuthent: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_PhoneAuthent
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#8470' '#1090#1077#1083#1077#1092#1086#1085#1086#1074' '#1080#1079' '#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072' <'#1052#1086#1073#1080#1083#1100#1085#1099#1077' '#1090#1077#1083#1077#1092#1086#1085#1099' '#1089#1086#1090#1088#1091#1076#1085 +
        #1080#1082#1086#1074'>'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#8470' '#1090#1077#1083#1077#1092#1086#1085#1086#1074' '#1080#1079' '#1057#1087#1088'. <'#1052#1086#1073#1080#1083#1100#1085#1099#1077' '#1090#1077#1083#1077#1092#1086#1085#1099' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074'>'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#8470' '#1090#1077#1083#1077#1092#1086#1085#1086#1074' '#1080#1079' '#1057#1087#1088'. <'#1052#1086#1073#1080#1083#1100#1085#1099#1077' '#1090#1077#1083#1077#1092#1086#1085#1099' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074'>'
      ImageIndex = 41
    end
    object actUpdate_PhoneAuthent: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_PhoneAuthent
      StoredProcList = <
        item
          StoredProc = spUpdate_PhoneAuthent
        end>
      Caption = 'actUpdate_PhoneAuthent'
      ImageIndex = 41
    end
    object ChoiceUser_mask: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TUser_ObjectForm'
      ImageIndex = 27
      FormName = 'TUser_ObjectForm'
      FormNameParam.Value = 'TUser_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'UserId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object macUpdate_UserRole_byMask: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ChoiceUser_mask
        end
        item
          Action = actUpdate_UserRole_byMask
        end
        item
          Action = actRefresh_Role
        end>
      QuestionBeforeExecute = #1042#1099#1073#1088#1072#1090#1100' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' <'#1054#1090' '#1050#1086#1075#1086'> '#1076#1083#1103' '#1082#1086#1087#1080#1088#1086#1074#1072#1085#1080#1103' '#1056#1086#1083#1077#1081'?'
      InfoAfterExecute = #1056#1086#1083#1080' '#1089#1082#1086#1087#1080#1088#1086#1074#1072#1085#1099
      Caption = '<'#1054#1090' '#1050#1086#1075#1086'> '#1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1056#1086#1083#1080
      Hint = '<'#1054#1090' '#1050#1086#1075#1086'> '#1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1056#1086#1083#1080
      ImageIndex = 27
    end
    object actUpdate_UserRole_byMask: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_UserRole_byMask
      StoredProcList = <
        item
          StoredProc = spUpdate_UserRole_byMask
        end>
      Caption = 'Update_UserRole_byMask'
      ImageIndex = 27
    end
    object actUpdate_KeyAuthent: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_KeyAuthent
      StoredProcList = <
        item
          StoredProc = spUpdate_KeyAuthent
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1057#1077#1082#1088#1077#1090#1085#1099#1081' '#1050#1083#1102#1095' '#1076#1083#1103' Google Authenticator'
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1057#1077#1082#1088#1077#1090#1085#1099#1081' '#1050#1083#1102#1095' '#1076#1083#1103' Google Authenticator'
      ImageIndex = 10
      QuestionBeforeExecute = 
        #1057#1077#1082#1088#1077#1090#1085#1099#1081' '#1050#1083#1102#1095' '#1073#1091#1076#1077#1090' '#1091#1076#1072#1083#1077#1085'. '#1055#1088#1080' '#1089#1083#1077#1076#1091#1102#1097#1077#1084' '#1074#1093#1086#1076#1077' '#1074' '#1087#1088#1086#1075#1088#1072#1084#1084#1091', '#1073#1091 +
        #1076#1077#1090' '#1087#1088#1077#1076#1083#1086#1076#1078#1077#1085#1086' '#1086#1090#1089#1082#1072#1085#1080#1088#1086#1074#1072#1090#1100' '#1085#1072' '#1084#1086#1073#1080#1083#1100#1085#1086#1084'  '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1077' '#1057#1077#1082#1088#1077#1090#1085#1099#1081 +
        ' '#1050#1083#1102#1095' '#1076#1083#1103' Google Authenticator.'#1055#1088#1086#1076#1086#1083#1078#1080#1090#1100'?'
    end
    object actPrintUser_Badge: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPrintUser_Badge
      StoredProcList = <
        item
          StoredProc = spPrintUser_Badge
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1073#1077#1081#1076#1078#1080#1082#1072' '#1076#1083#1103' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080' '#1074' '#1084#1086#1073#1080#1083#1100#1085#1086#1084' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1080
      Hint = #1055#1077#1095#1072#1090#1100' '#1073#1077#1081#1076#1078#1080#1082#1072' '#1076#1083#1103' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080' '#1074' '#1084#1086#1073#1080#1083#1100#1085#1086#1084' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1080
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintUser_BadgeCDS
          UserName = 'frxDBDItems'
        end>
      Params = <>
      ReportName = 'PrintUser_Badge'
      ReportNameParam.Value = 'PrintUser_Badge'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
      PreviewWindowMaximized = False
    end
    object macPrintUser_Badge_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actPrintUser_Badge
        end>
      View = cxGridDBTableView
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1087#1080#1089#1082#1072' '#1073#1077#1081#1076#1078#1077#1081' '#1076#1083#1103' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080' '#1074' '#1084#1086#1073#1080#1083#1100#1085#1086#1084' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1080
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1087#1080#1089#1082#1072' '#1073#1077#1081#1076#1078#1077#1081' '#1076#1083#1103' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080' '#1074' '#1084#1086#1073#1080#1083#1100#1085#1086#1084' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1080
      ImageIndex = 15
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
    Left = 88
    Top = 152
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
    ViewDocumentList = <>
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
    ViewDocumentList = <>
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
        Name = 'inName'
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
        Name = 'inMemberId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'MemberId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 120
    Top = 224
  end
  object spUpdate_PhoneAuthent: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_User_PhoneAuthent'
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 40
    Top = 208
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 704
    Top = 80
  end
  object spUpdate_UserRole_byMask: TdsdStoredProc
    StoredProcName = 'gpInsert_Object_UserRole_byMask'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inuserid'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inuserid_mask'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 704
    Top = 136
  end
  object spUpdate_KeyAuthent: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_User_GoogleSecret_null'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUserId'
        Value = ''
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 72
    Top = 272
  end
  object PrintUser_BadgeCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 296
    Top = 136
  end
  object spPrintUser_Badge: TdsdStoredProc
    StoredProcName = 'gpSelect_User_PrintBadge'
    DataSet = PrintUser_BadgeCDS
    DataSets = <
      item
        DataSet = PrintUser_BadgeCDS
      end>
    Params = <
      item
        Name = 'inUserId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 343
    Top = 136
  end
end
