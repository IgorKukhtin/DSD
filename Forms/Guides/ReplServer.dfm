object ReplServerForm: TReplServerForm
  Left = 0
  Top = 0
  Caption = #1057#1077#1088#1074#1077#1088#1072' '#1076#1083#1103' '#1056#1077#1087#1083#1080#1082#1080' '#1041#1044
  ClientHeight = 346
  ClientWidth = 895
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
    Width = 895
    Height = 320
    Align = alClient
    TabOrder = 0
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1057#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = Name
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = Name
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.GroupSummaryLayout = gslAlignWithColumnsAndDistribute
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentVert = vaCenter
        Width = 58
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 110
      end
      object Host: TcxGridDBColumn
        Caption = #1057#1077#1088#1074#1077#1088
        DataBinding.FieldName = 'Host'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 105
      end
      object UserName: TcxGridDBColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
        DataBinding.FieldName = 'UserName'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 92
      end
      object Password: TcxGridDBColumn
        Caption = #1055#1072#1088#1086#1083#1100
        DataBinding.FieldName = 'Password'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 66
      end
      object Port: TcxGridDBColumn
        Caption = #1055#1086#1088#1090
        DataBinding.FieldName = 'Port'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 66
      end
      object DataBaseName: TcxGridDBColumn
        Caption = #1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093
        DataBinding.FieldName = 'DataBaseName'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 111
      end
      object StartTo: TcxGridDBColumn
        Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1085#1072#1095#1072#1083#1072' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1074' '#1073#1072#1079#1091'-Child'
        DataBinding.FieldName = 'StartTo'
        PropertiesClassName = 'TcxDateEditProperties'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1085#1072#1095#1072#1083#1072' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1074' '#1073#1072#1079#1091'-Child'
        Width = 94
      end
      object StartFrom: TcxGridDBColumn
        Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1085#1072#1095#1072#1083#1072' '#1087#1086#1083#1091#1095#1077#1085#1080#1103' '#1080#1079' '#1073#1072#1079#1099'-Child'
        DataBinding.FieldName = 'StartFrom'
        PropertiesClassName = 'TcxDateEditProperties'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1085#1072#1095#1072#1083#1072' '#1087#1086#1083#1091#1095#1077#1085#1080#1103' '#1080#1079' '#1073#1072#1079#1099'-Child'
        Width = 86
      end
      object EndTo: TcxGridDBColumn
        Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1074' '#1073#1072#1079#1091'-Child'
        DataBinding.FieldName = 'EndTo'
        PropertiesClassName = 'TcxDateEditProperties'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1074' '#1073#1072#1079#1091'-Child'
        Width = 86
      end
      object EndFrom: TcxGridDBColumn
        Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1087#1086#1083#1091#1095#1077#1085#1080#1103' '#1080#1079' '#1073#1072#1079#1099'-Child'
        DataBinding.FieldName = 'EndFrom'
        PropertiesClassName = 'TcxDateEditProperties'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 86
      end
      object CountTo: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1087#1072#1082#1077#1090#1086#1074' '#1074' '#1087#1086#1089#1083'. '#1089#1077#1089#1089#1080#1080' '#1087#1088#1080' '#1086#1090#1087#1088#1072#1074#1082#1077' '#1074' '#1073#1072#1079#1091'-Child'
        DataBinding.FieldName = 'CountTo'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderHint = #1082#1086#1083'-'#1074#1086' '#1087#1072#1082#1077#1090#1086#1074' '#1074' '#1087#1086#1089#1083#1077#1076#1085#1077#1081' '#1089#1077#1089#1089#1080#1080' '#1087#1088#1080' '#1086#1090#1087#1088#1072#1074#1082#1077' '#1074' '#1073#1072#1079#1091'-Child'
        Width = 89
      end
      object CountFrom: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1087#1072#1082#1077#1090#1086#1074' '#1074' '#1087#1086#1089#1083'. '#1089#1077#1089#1089#1080#1080' '#1087#1088#1080' '#1087#1086#1083#1091#1095#1077#1085#1080#1080' '#1080#1079' '#1073#1072#1079#1099'-Child'
        DataBinding.FieldName = 'CountFrom'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderHint = #1082#1086#1083'-'#1074#1086' '#1087#1072#1082#1077#1090#1086#1074' '#1074' '#1087#1086#1089#1083#1077#1076#1085#1077#1081' '#1089#1077#1089#1089#1080#1080' '#1087#1088#1080' '#1087#1086#1083#1091#1095#1077#1085#1080#1080' '#1080#1079' '#1073#1072#1079#1099'-Child'
        Width = 93
      end
      object isErrTo: TcxGridDBColumn
        Caption = #1041#1099#1083#1072' '#1086#1096#1080#1073#1082#1072' '#1087#1088#1080' '#1086#1090#1087#1088#1072#1074#1082#1077' '#1074' '#1073#1072#1079#1091'-Child'
        DataBinding.FieldName = 'isErrTo'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderHint = #1073#1099#1083#1072' '#1086#1096#1080#1073#1082#1072' '#1087#1088#1080' '#1086#1090#1087#1088#1072#1074#1082#1077' '#1074' '#1073#1072#1079#1091'-Child'
        Width = 77
      end
      object isErrFrom: TcxGridDBColumn
        Caption = #1041#1099#1083#1072' '#1086#1096#1080#1073#1082#1072' '#1087#1088#1080' '#1087#1086#1083#1091#1095#1077#1085#1080#1080' '#1080#1079' '#1073#1072#1079#1099'-Child'
        DataBinding.FieldName = 'isErrFrom'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderHint = #1073#1099#1083#1072' '#1086#1096#1080#1073#1082#1072' '#1087#1088#1080' '#1087#1086#1083#1091#1095#1077#1085#1080#1080' '#1080#1079' '#1073#1072#1079#1099'-Child'
        Width = 89
      end
      object isErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 28
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 48
    Top = 96
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 40
    Top = 152
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
    Left = 280
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
    Left = 160
    Top = 96
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
          ItemName = 'bbUpdateStartTo'
        end
        item
          Visible = True
          ItemName = 'bbUpdateStartFrom'
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
          ItemName = 'bbChoiceGuides'
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
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
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
      ShowCaption = False
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbUpdateStartTo: TdxBarButton
      Action = macUpdateStartTo
      Category = 0
    end
    object bbUpdateStartFrom: TdxBarButton
      Action = macUpdateStartFrom
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 280
    Top = 152
    object actUpdateStartFrom: TdsdDataSetRefresh
      Category = 'UpdateDate'
      MoveParams = <>
      StoredProc = spUpdate_ReplServer_StartFrom
      StoredProcList = <
        item
          StoredProc = spUpdate_ReplServer_StartFrom
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 77
      RefreshOnTabSetChanges = True
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialogUpdateStartFrom: TExecuteDialog
      Category = 'UpdateDate'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' / '#1074#1088#1077#1084#1103
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' / '#1074#1088#1077#1084#1103
      ImageIndex = 77
      FormName = 'TDataTimeDialogForm'
      FormNameParam.Value = 'TDataTimeDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 43282d
          Component = ClientDataSet
          ComponentItem = 'StartFrom'
          DataType = ftDateTime
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TReplServerEditForm'
      FormNameParam.Value = 'TReplServerEditForm'
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
    object macUpdateStartFrom: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogUpdateStartFrom
        end
        item
          Action = actUpdateStartFrom
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1085#1072#1095#1072#1083#1086' '#1087#1086#1083#1091#1095#1077#1085#1080#1103' '#1080#1079' '#1073#1072#1079#1099'-Child'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1085#1072#1095#1072#1083#1086' '#1087#1086#1083#1091#1095#1077#1085#1080#1103' '#1080#1079' '#1073#1072#1079#1099'-Child'
      ImageIndex = 77
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TReplServerEditForm'
      FormNameParam.Value = 'TReplServerEditForm'
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
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
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
    object actUpdateStartTo: TdsdDataSetRefresh
      Category = 'UpdateDate'
      MoveParams = <>
      StoredProc = spUpdate_ReplServer_StartTo
      StoredProcList = <
        item
          StoredProc = spUpdate_ReplServer_StartTo
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 76
      RefreshOnTabSetChanges = True
    end
    object ExecuteDialogUpdateStartTo: TExecuteDialog
      Category = 'UpdateDate'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' / '#1074#1088#1077#1084#1103
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' / '#1074#1088#1077#1084#1103
      ImageIndex = 76
      FormName = 'TDataTimeDialogForm'
      FormNameParam.Value = 'TDataTimeDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 43282d
          Component = ClientDataSet
          ComponentItem = 'StartTo'
          DataType = ftDateTime
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macUpdateStartTo: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogUpdateStartTo
        end
        item
          Action = actUpdateStartTo
        end
        item
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1085#1072#1095#1072#1083#1086' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1074' '#1073#1072#1079#1091'-Child'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1085#1072#1095#1072#1083#1086' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1074' '#1073#1072#1079#1091'-Child'
      ImageIndex = 76
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ReplServer'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 40
    Top = 208
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 160
    Top = 152
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
    Left = 288
    Top = 208
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
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 448
    Top = 112
  end
  object spUpdate_ReplServer_StartTo: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_ReplServer_Start'
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
        Name = 'inOperDate'
        Value = 43282d
        Component = ClientDataSet
        ComponentItem = 'StartTo'
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTo'
        Value = 'TRUE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 698
    Top = 160
  end
  object spUpdate_ReplServer_StartFrom: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_ReplServer_Start'
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
        Name = 'inOperDate'
        Value = 'NULL'
        Component = ClientDataSet
        ComponentItem = 'StartFrom'
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTo'
        Value = 'FALSE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 690
    Top = 208
  end
end
