object UnitForm: TUnitForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103'>'
  ClientHeight = 420
  ClientWidth = 980
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
  object cxSplitter1: TcxSplitter
    Left = 0
    Top = 26
    Width = 8
    Height = 394
  end
  object cxGrid: TcxGrid
    Left = 8
    Top = 26
    Width = 972
    Height = 394
    Align = alClient
    TabOrder = 1
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ClientDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.HeaderHeight = 50
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object isIrna: TcxGridDBColumn
        Caption = #1048#1088#1085#1072
        DataBinding.FieldName = 'isIrna'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1088#1085#1072' ('#1044#1072'/'#1053#1077#1090')'
        Options.Editing = False
        Width = 45
      end
      object ParentName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072
        DataBinding.FieldName = 'ParentName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 38
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        SortIndex = 0
        SortOrder = soAscending
        Width = 142
      end
      object BranchName: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083
        DataBinding.FieldName = 'BranchName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 95
      end
      object BusinessName: TcxGridDBColumn
        Caption = #1041#1080#1079#1085#1077#1089
        DataBinding.FieldName = 'BusinessName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 76
      end
      object DepartmentName: TcxGridDBColumn
        Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090' 1 '#1088#1110#1074#1085#1103
        DataBinding.FieldName = 'DepartmentName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 88
      end
      object Department_twoName: TcxGridDBColumn
        Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090' 2 '#1088#1110#1074#1085#1103
        DataBinding.FieldName = 'Department_twoName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 88
      end
      object JuridicalName: TcxGridDBColumn
        Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object isPersonalService: TcxGridDBColumn
        Caption = #1060#1086#1088#1084#1080#1088'. '#1047#1055
        DataBinding.FieldName = 'isPersonalService'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1079#1087' '#1072#1074#1090#1086#1084#1072#1090#1086#1084
        Options.Editing = False
        Width = 70
      end
      object PersonalServiceDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1047#1055
        DataBinding.FieldName = 'PersonalServiceDate'
        PropertiesClassName = 'TcxDateEditProperties'
        Properties.Kind = ckDateTime
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1082#1086#1075#1076#1072' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1083#1080#1089#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1079#1087' '#1072#1074#1090#1086#1084#1072#1090#1086#1084
        Options.Editing = False
        Width = 93
      end
      object AccountGroupCode: TcxGridDBColumn
        Caption = #1050#1086#1076' c'#1095'. '#1075#1088'.'
        DataBinding.FieldName = 'AccountGroupCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object AreaName: TcxGridDBColumn
        Caption = #1056#1077#1075#1080#1086#1085
        DataBinding.FieldName = 'AreaName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object AccountGroupName: TcxGridDBColumn
        Caption = #1057#1095#1077#1090' '#1075#1088#1091#1087#1087#1072
        DataBinding.FieldName = 'AccountGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object AccountDirectionCode: TcxGridDBColumn
        Caption = #1050#1086#1076' c'#1095'. '#1085#1072#1087#1088'.'
        DataBinding.FieldName = 'AccountDirectionCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object FounderName: TcxGridDBColumn
        Caption = #1059#1095#1088#1077#1076#1080#1090#1077#1083#1080
        DataBinding.FieldName = 'FounderName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object CityName: TcxGridDBColumn
        Caption = #1043#1086#1088#1086#1076
        DataBinding.FieldName = 'CityName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object AccountDirectionName: TcxGridDBColumn
        Caption = #1057#1095#1077#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'AccountDirectionName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 76
      end
      object ProfitLossGroupCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1054#1055#1080#1059' '#1075#1088'.'
        DataBinding.FieldName = 'ProfitLossGroupCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object ProfitLossGroupName: TcxGridDBColumn
        Caption = #1054#1055#1080#1059' '#1075#1088#1091#1087#1087#1072
        DataBinding.FieldName = 'ProfitLossGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object ProfitLossDirectionCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1054#1055#1080#1059' '#1085#1072#1087#1088'.'
        DataBinding.FieldName = 'ProfitLossDirectionCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object ProfitLossDirectionName: TcxGridDBColumn
        Caption = #1054#1055#1080#1059' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'ProfitLossDirectionName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 76
      end
      object InvNumber: TcxGridDBColumn
        Caption = #1044#1086#1075#1086#1074#1086#1088' ('#1087#1077#1088#1077#1074#1099#1089#1090#1072#1074#1083#1077#1085#1080#1077' '#1079#1072#1090#1088#1072#1090')'
        DataBinding.FieldName = 'InvNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 114
      end
      object Contract_JuridicalName: TcxGridDBColumn
        Caption = #1070#1088'.'#1083#1080#1094#1086' ('#1076#1086#1075#1086#1074#1086#1088')'
        DataBinding.FieldName = 'Contract_JuridicalName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 66
      end
      object Contract_InfomoneyName: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103' ('#1076#1086#1075#1086#1074#1086#1088')'
        DataBinding.FieldName = 'Contract_InfomoneyName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 110
      end
      object RouteName: TcxGridDBColumn
        Caption = #1052#1072#1088#1096#1088#1091#1090
        DataBinding.FieldName = 'RouteName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 67
      end
      object RouteSortingName: TcxGridDBColumn
        Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1084#1072#1088#1096#1088#1091#1090#1072
        DataBinding.FieldName = 'RouteSortingName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 98
      end
      object PartnerCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
        DataBinding.FieldName = 'PartnerCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object PartnerName: TcxGridDBColumn
        Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
        DataBinding.FieldName = 'PartnerName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object isPartionDate: TcxGridDBColumn
        Caption = #1055#1072#1088#1090#1080#1080' '#1076#1072#1090#1099' '#1074' '#1091#1095#1077#1090#1077
        DataBinding.FieldName = 'isPartionDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object PersonalHeadName: TcxGridDBColumn
        Caption = #1056#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
        DataBinding.FieldName = 'PersonalHeadName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
      object UnitName_Head: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1088#1091#1082#1086#1074'.)'
        DataBinding.FieldName = 'UnitName_Head'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1103')'
        Options.Editing = False
        Width = 100
      end
      object BranchName_Head: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083' ('#1088#1091#1082#1086#1074'.)'
        DataBinding.FieldName = 'BranchName_Head'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1060#1080#1083#1080#1072#1083' ('#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1103')'
        Options.Editing = False
        Width = 80
      end
      object isPartionGoodsKind: TcxGridDBColumn
        Caption = #1055#1072#1088#1090#1080#1080' '#1087#1086' '#1074#1080#1076#1091' '#1091#1087#1072#1082'. '#1076#1083#1103' '#1089#1099#1088#1100#1103
        DataBinding.FieldName = 'isPartionGoodsKind'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 66
      end
      object isCountCount: TcxGridDBColumn
        Caption = #1059#1095#1077#1090' '#1073#1072#1090#1086#1085#1086#1074
        DataBinding.FieldName = 'isCountCount'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object isPartionGP: TcxGridDBColumn
        Caption = #1055#1072#1088#1090#1080#1080' '#1076#1083#1103' '#1043#1055' '#1080' '#1058#1091#1096#1077#1085#1082#1080
        DataBinding.FieldName = 'isPartionGP'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1072#1088#1090#1080#1080' '#1076#1083#1103' '#1043#1055' '#1080' '#1058#1091#1096#1077#1085#1082#1080
        Options.Editing = False
        Width = 60
      end
      object isAvance: TcxGridDBColumn
        Caption = #1053#1072#1095'. '#1072#1074#1072#1085#1089#1072' '#1072#1074#1090#1086#1084#1072#1090'.'
        DataBinding.FieldName = 'isAvance'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1072#1074#1072#1085#1089#1072' '#1072#1074#1090#1086#1084#1072#1090'.'
        Options.Editing = False
        Width = 60
      end
      object UnitCode_HistoryCost: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1087#1086#1076#1088'. ('#1089'/'#1089' '#1074#1086#1079#1074#1088#1072#1090')'
        DataBinding.FieldName = 'UnitCode_HistoryCost'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object UnitName_HistoryCost: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1089'/'#1089' '#1074#1086#1079#1074#1088#1072#1090')'
        DataBinding.FieldName = 'UnitName_HistoryCost'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actUnitChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object SheetWorkTimeName: TcxGridDBColumn
        Caption = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099' ('#1064#1072#1073#1083#1086#1085' '#1090#1072#1073#1077#1083#1103' '#1088'.'#1074#1088'.)'
        DataBinding.FieldName = 'SheetWorkTimeName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099' ('#1064#1072#1073#1083#1086#1085' '#1090#1072#1073#1077#1083#1103' '#1088'.'#1074#1088'.)'
        Options.Editing = False
        Width = 149
      end
      object Address: TcxGridDBColumn
        Caption = #1040#1076#1088#1077#1089
        DataBinding.FieldName = 'Address'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object AddressEDIN: TcxGridDBColumn
        Caption = #1040#1076#1088#1077#1089' '#1076#1083#1103' EDIN'
        DataBinding.FieldName = 'AddressEDIN'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 95
      end
      object CityKindName: TcxGridDBColumn
        Caption = #1042#1080#1076
        DataBinding.FieldName = 'CityKindName'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 105
      end
      object RegionName: TcxGridDBColumn
        Caption = #1054#1073#1083#1072#1089#1090#1100
        DataBinding.FieldName = 'RegionName'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 153
      end
      object ProvinceName: TcxGridDBColumn
        Caption = #1056#1072#1081#1086#1085
        DataBinding.FieldName = 'ProvinceName'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 113
      end
      object KATOTTG: TcxGridDBColumn
        Caption = #1050#1040#1058#1054#1058#1058#1043
        DataBinding.FieldName = 'KATOTTG'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object GLN: TcxGridDBColumn
        DataBinding.FieldName = 'GLN'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object Comment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object IsErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isIrna'
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
    object bbGridToExcel: TdxBarButton
      Action = actGridToExcel
      Category = 0
    end
    object bbProtocol: TdxBarButton
      Action = actProtocol
      Category = 0
    end
    object bbUpdate_isIrna: TdxBarButton
      Action = macUpdate_isIrna
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 232
    Top = 144
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
          StoredProc = spSelect
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
      DataSource = ClientDS
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
      DataSource = ClientDS
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
      ShortCut = 46
      ErasedFieldName = 'isErased'
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
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = ClientDS
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
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
    end
    object actGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actUnitChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'UnitChoiceForm'
      FormName = 'TUnit_ObjectForm'
      FormNameParam.Value = 'TUnit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'UnitId_HistoryCost'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'UnitName_HistoryCost'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'UnitCode_HistoryCost'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdate_HistoryCost: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_HistoryCost
      StoredProcList = <
        item
          StoredProc = spUpdate_HistoryCost
        end>
      Caption = 'actUpdate_HistoryCost'
      ImageIndex = 76
      DataSource = ClientDS
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
    object macUpdate_isIrna_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_isIrna
        end>
      View = cxGridDBTableView
      Caption = 'macUpdate_isIrna_list'
      ImageIndex = 66
    end
    object macUpdate_isIrna: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_isIrna_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1083#1103' '#1042#1099#1073#1088#1072#1085#1085#1099#1093' '#1101#1083#1077#1084#1077#1085#1090#1086#1074' '#1047#1085#1072#1095#1077#1085#1080#1077' <'#1048#1088#1085#1072'> '#1085#1072' '#1087#1088#1086#1090#1080#1074#1086#1087#1086#1083#1086#1078 +
        #1085#1086#1077'?'
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' '#1080#1079#1084#1077#1085#1077#1085#1086
      Caption = 'macUpdate_isIrna'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1047#1085#1072#1095#1077#1085#1080#1077' <'#1048#1088#1085#1072'> '#1044#1072'/'#1053#1077#1090
      ImageIndex = 66
    end
    object actUpdate_isIrna: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isIrna
      StoredProcList = <
        item
          StoredProc = spUpdate_isIrna
        end>
      Caption = 'actUpdate_isIrna'
      ImageIndex = 66
    end
  end
  object ClientDS: TDataSource
    DataSet = ClientDataSet
    Left = 360
    Top = 104
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    PacketRecords = 0
    Params = <>
    Left = 320
    Top = 152
  end
  object spSelect: TdsdStoredProc
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
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 232
    Top = 288
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
    Left = 176
    Top = 200
  end
  object spUpdate_HistoryCost: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Unit_HistoryCost'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId_HistoryCost'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'UnitId_HistoryCost'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 624
    Top = 232
  end
  object spUpdate_isIrna: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Guide_Irna'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisIrna'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isIrna'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 480
    Top = 136
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
    Left = 352
    Top = 224
  end
end
