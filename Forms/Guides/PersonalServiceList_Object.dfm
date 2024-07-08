object PersonalServiceList_ObjectForm: TPersonalServiceList_ObjectForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1042#1077#1076#1086#1084#1086#1089#1090#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'>'
  ClientHeight = 320
  ClientWidth = 986
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
    Width = 986
    Height = 294
    Align = alClient
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
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taRightJustify
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 44
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object JuridicalName: TcxGridDBColumn
        Caption = #1070#1088'.'#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalName'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object isErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 78
      end
      object BranchName: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083
        DataBinding.FieldName = 'BranchName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 74
      end
      object BankName: TcxGridDBColumn
        Caption = #1041#1072#1085#1082
        DataBinding.FieldName = 'BankName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 61
      end
      object PaidKindName: TcxGridDBColumn
        Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
        DataBinding.FieldName = 'PaidKindName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 57
      end
      object MemberName: TcxGridDBColumn
        Caption = #1060#1080#1079'.'#1083#1080#1094#1086' ('#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100') '
        DataBinding.FieldName = 'MemberName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = MemberChoice
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 78
      end
      object MemberHeadManagerName: TcxGridDBColumn
        Caption = #1060#1080#1079'.'#1083#1080#1094#1086' ('#1080#1089#1087'. '#1076#1080#1088#1077#1082#1090#1086#1088') '
        DataBinding.FieldName = 'MemberHeadManagerName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = MemberHeadManagerChoice
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object MemberManagerName: TcxGridDBColumn
        Caption = #1060#1080#1079'.'#1083#1080#1094#1086' ('#1076#1080#1088#1077#1082#1090#1086#1088') '
        DataBinding.FieldName = 'MemberManagerName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = MemberManagerChoice
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 101
      end
      object MemberBookkeeperName: TcxGridDBColumn
        Caption = #1060#1080#1079'.'#1083#1080#1094#1086' ('#1073#1091#1093#1075#1072#1083#1090#1077#1088') '
        DataBinding.FieldName = 'MemberBookkeeperName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = MemberBookkeeperChoice
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 79
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
      object ServiceListName_AvanceF2: TcxGridDBColumn
        Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1076#1083#1103'"'#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'."'
        DataBinding.FieldName = 'ServiceListName_AvanceF2'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1076#1083#1103'"'#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'."'
        Options.Editing = False
        Width = 138
      end
      object isSecond: TcxGridDBColumn
        Caption = #1042#1090#1086#1088#1072#1103' '#1092#1086#1088#1084#1072
        DataBinding.FieldName = 'isSecond'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 59
      end
      object isRecalc: TcxGridDBColumn
        Caption = #1056#1072#1089#1087#1088#1077#1076'. '#1074' '#1074#1077#1076'. '#1092#1072#1082#1090
        DataBinding.FieldName = 'isRecalc'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103' '#1074' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1092#1072#1082#1090
        Options.Editing = False
        Width = 73
      end
      object isPersonalOut: TcxGridDBColumn
        Caption = #1056#1072#1079#1088'. '#1076#1083#1103' '#1091#1074#1086#1083'. ('#1044#1072'/'#1053#1077#1090')'
        DataBinding.FieldName = 'isPersonalOut'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1056#1072#1079#1088#1077#1096#1077#1085#1086' '#1076#1083#1103' '#1091#1074#1086#1083#1077#1085#1085#1099#1093' ('#1044#1072'/'#1053#1077#1090')'
        Options.Editing = False
        Width = 56
      end
      object isBankOut: TcxGridDBColumn
        Caption = #1044#1083#1103' '#1091#1074#1086#1083#1077#1085#1085#1099#1093' '#1073#1072#1085#1082
        DataBinding.FieldName = 'isBankOut'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1083#1103' '#1091#1074#1086#1083#1077#1085#1085#1099#1093' '#1073#1072#1085#1082
        Options.Editing = False
        Width = 100
      end
      object isDetail: TcxGridDBColumn
        Caption = #1044#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103
        DataBinding.FieldName = 'isDetail'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103' '#1076#1072#1085#1085#1099#1093
        Options.Editing = False
        Width = 50
      end
      object isAvanceNot: TcxGridDBColumn
        Caption = #1048#1089#1082#1083'. '#1080#1079' '#1072#1074#1072#1085#1089#1072
        DataBinding.FieldName = 'isAvanceNot'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1080#1079' '#1089#1087#1080#1089#1082#1072' '#1085#1072' '#1072#1074#1072#1085#1089
        Options.Editing = False
        Width = 50
      end
      object isBankNot: TcxGridDBColumn
        Caption = #1048#1089#1082#1083'. '#1080#1079' '#1074#1099#1087#1083#1072#1090#1099' '#1073#1072#1085#1082' 2'#1092
        DataBinding.FieldName = 'isBankNot'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1080#1079' '#1088#1072#1089#1095#1077#1090#1072' '#1042#1099#1087#1083#1072#1090#1072' '#1073#1072#1085#1082' 2'#1092
        Options.Editing = False
      end
      object isUser: TcxGridDBColumn
        Caption = #1054#1075#1088'. '#1076#1086#1089#1090#1091#1087
        DataBinding.FieldName = 'isUser'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1085#1099#1081' '#1076#1086#1089#1090#1091#1087
        Options.Editing = False
        Width = 60
      end
      object KoeffSummCardSecond: TcxGridDBColumn
        Caption = #1050#1086#1101#1092#1092'. '#1074#1099#1075#1088'. 2'#1092'.'
        DataBinding.FieldName = 'KoeffSummCardSecond'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 10
        Properties.DisplayFormat = ',0.######;-,0.######; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1101#1092#1092' '#1076#1083#1103' '#1074#1099#1075#1088#1091#1079#1082#1080' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1041#1072#1085#1082' 2'#1092'.'
        Options.Editing = False
        Width = 88
      end
      object Compensation: TcxGridDBColumn
        Caption = #1052#1077#1089#1103#1094' '#1082#1086#1084#1087#1077#1085#1089'.'
        DataBinding.FieldName = 'Compensation'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.;-,0.; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1052#1077#1089#1103#1094' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080
        Options.Editing = False
        Width = 88
      end
      object CompensationName: TcxGridDBColumn
        Caption = #1052#1077#1089#1103#1094' '#1085#1072#1095'. '#1082#1086#1084#1087#1077#1085#1089'. ('#1080#1085#1092'.)'
        DataBinding.FieldName = 'CompensationName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 85
      end
      object SummAvance: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1072#1074#1072#1085#1089'('#1072#1074#1090#1086')'
        DataBinding.FieldName = 'SummAvance'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.;-,0.; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1057#1091#1084#1084#1072' '#1072#1074#1072#1085#1089'('#1072#1074#1090#1086')'
        Options.Editing = False
        Width = 88
      end
      object SummAvanceMax: TcxGridDBColumn
        Caption = #1052#1072#1082#1089' '#1057#1091#1084#1084#1072' '#1072#1074#1072#1085#1089'('#1074#1074#1086#1076')'
        DataBinding.FieldName = 'SummAvanceMax'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.;-,0.; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1052#1072#1082#1089' '#1057#1091#1084#1084#1072' '#1072#1074#1072#1085#1089'('#1074#1074#1086#1076')'
        Options.Editing = False
        Width = 88
      end
      object HourAvance: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1095#1072#1089#1086#1074' '#1076#1083#1103' '#1072#1074#1072#1085#1089' ('#1072#1074#1090#1086')'
        DataBinding.FieldName = 'HourAvance'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.;-,0.; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1095#1072#1089#1086#1074' '#1076#1083#1103' '#1072#1074#1072#1085#1089'('#1072#1074#1090#1086')'
        Options.Editing = False
        Width = 88
      end
      object BankAccountName: TcxGridDBColumn
        Caption = #1056'/'#1089#1095#1077#1090
        DataBinding.FieldName = 'BankAccountName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
        Options.Editing = False
        Width = 70
      end
      object PSLExportKindName: TcxGridDBColumn
        Caption = #1058#1080#1087' '#1074#1099#1075#1088'. '#1074#1077#1076'-'#1090#1080' '#1074' '#1073#1072#1085#1082
        DataBinding.FieldName = 'PSLExportKindName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1058#1080#1087' '#1074#1099#1075#1088#1091#1079#1082#1080' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1074' '#1073#1072#1085#1082
        Options.Editing = False
        Width = 89
      end
      object ContentType: TcxGridDBColumn
        Caption = 'Content-Type'
        DataBinding.FieldName = 'ContentType'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 86
      end
      object OnFlowType: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1085#1072#1095'. '#1074' '#1073#1072#1085#1082#1077
        DataBinding.FieldName = 'OnFlowType'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1080#1076' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1074' '#1073#1072#1085#1082#1077
        Options.Editing = False
        Width = 70
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 40
    Top = 96
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 24
    Top = 144
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
    Left = 240
    Top = 88
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
          BeginGroup = True
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
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenForm'
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
    object bbProtocolOpenForm: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbUpdate_PersonalOut: TdxBarButton
      Action = macUpdate_PersonalOut
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1056#1072#1079#1088#1077#1096#1077#1085#1086' '#1076#1083#1103' '#1091#1074#1086#1083#1077#1085#1085#1099#1093' ('#1044#1072'/'#1053#1077#1090')'
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 264
    Top = 136
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TPersonalServiceListEditForm'
      FormNameParam.Value = 'TPersonalServiceListEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TPersonalServiceListEditForm'
      FormNameParam.Value = 'TPersonalServiceListEditForm'
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
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
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
          Name = 'JuridicalId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'MemberId'
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
    object ProtocolOpenForm: TdsdOpenForm
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
    object MemberChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TPositionForm'
      FormName = 'TMember_ObjectForm'
      FormNameParam.Value = 'TMember_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'MemberId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'MemberName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object MemberHeadManagerChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TMember_ObjectForm'
      FormName = 'TMember_ObjectForm'
      FormNameParam.Value = 'TMember_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'MemberHeadManagerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'MemberHeadManagerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object MemberManagerChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TMember_ObjectForm'
      FormName = 'TMember_ObjectForm'
      FormNameParam.Value = 'TMember_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'MemberManagerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'MemberManagerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object MemberBookkeeperChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TMember_ObjectForm'
      FormName = 'TMember_ObjectForm'
      FormNameParam.Value = 'TMember_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'MemberBookkeeperId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'MemberBookkeeperName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateMember: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Member
      StoredProcList = <
        item
          StoredProc = spUpdate_Member
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
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
    object actUpdate_PersonalOut: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actUpdateDataSet'
      ImageIndex = 5
      DataSource = DataSource
    end
    object macUpdate_PersonalOut: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_PersonalOut
        end
        item
          Action = actRefresh
        end>
      Caption = #1056#1072#1079#1088#1077#1096#1077#1085#1086' '#1076#1083#1103' '#1091#1074#1086#1083#1077#1085#1085#1099#1093' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 77
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_PersonalServiceList'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 144
    Top = 152
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_PersonalServiceList'
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
    Top = 216
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 176
    Top = 216
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
    Left = 48
    Top = 216
  end
  object spUpdate_Member: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_PersonalServiceList_Member'
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
        Name = 'inMemberId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'MemberId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberHeadManagerId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'MemberHeadManagerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberManagerId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'MemberManagerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberBookkeeperId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'MemberBookkeeperId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 571
    Top = 110
  end
end
