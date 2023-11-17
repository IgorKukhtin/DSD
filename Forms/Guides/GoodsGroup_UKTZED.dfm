object GoodsGroup_UKTZEDForm: TGoodsGroup_UKTZEDForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074' ('#1082#1086#1076' UKTZED)>'
  ClientHeight = 332
  ClientWidth = 699
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
    Width = 699
    Height = 306
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
          Format = 'C'#1090#1088#1086#1082': ,0'
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
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.Footer = True
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object ParentName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' ('#1088#1086#1076#1080#1090#1077#1083#1100')'
        DataBinding.FieldName = 'ParentName'
        FooterAlignmentHorz = taCenter
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 85
      end
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        FooterAlignmentHorz = taCenter
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 135
      end
      object isAsset: TcxGridDBColumn
        Caption = #1055#1088#1080#1079#1085#1072#1082' - '#1054#1057
        DataBinding.FieldName = 'isAsset'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 67
      end
      object CodeUKTZED: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1087#1086' '#1059#1050#1058' '#1047#1045#1044
        DataBinding.FieldName = 'CodeUKTZED'
        FooterAlignmentHorz = taCenter
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 121
      end
      object CodeUKTZED_new: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1087#1086' '#1059#1050#1058' '#1047#1045#1044' ('#1085#1086#1074#1099#1081')'
        DataBinding.FieldName = 'CodeUKTZED_new'
        FooterAlignmentHorz = taCenter
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 141
      end
      object DateUKTZED_new: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1076#1077#1081#1089#1090#1074'. '#1059#1050#1058' '#1047#1045#1044' ('#1085#1086#1074#1099#1081')'
        DataBinding.FieldName = 'DateUKTZED_new'
        FooterAlignmentHorz = taCenter
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072' '#1076#1077#1081#1089#1090#1074#1080#1103' '#1076#1083#1103' '#1050#1086#1076' '#1087#1086' '#1059#1050#1058' '#1047#1045#1044' ('#1085#1086#1074#1099#1081')'
        Width = 91
      end
      object TradeMarkName: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
        DataBinding.FieldName = 'TradeMarkName'
        Visible = False
        FooterAlignmentHorz = taCenter
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 66
      end
      object GoodsTagName: TcxGridDBColumn
        Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsTagName'
        Visible = False
        FooterAlignmentHorz = taCenter
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 66
      end
      object GoodsPlatformName: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' '#1087#1083#1086#1097#1072#1076#1082#1072
        DataBinding.FieldName = 'GoodsPlatformName'
        Visible = False
        FooterAlignmentHorz = taCenter
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 66
      end
      object TaxImport: TcxGridDBColumn
        Caption = #1055#1088#1080#1079#1085#1072#1082' '#1080#1084#1087#1086#1088#1090'. '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'TaxImport'
        Visible = False
        FooterAlignmentHorz = taCenter
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 66
      end
      object DKPP: TcxGridDBColumn
        DataBinding.FieldName = 'DKPP'
        Visible = False
        FooterAlignmentHorz = taCenter
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 66
      end
      object TaxAction: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1074#1080#1076#1072' '#1076#1077#1103#1090'. '#1089'.-'#1093'. '#1087#1088#1086#1080#1079#1074'.'
        DataBinding.FieldName = 'TaxAction'
        Visible = False
        FooterAlignmentHorz = taCenter
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 66
      end
      object InfoMoneyName: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
        DataBinding.FieldName = 'InfoMoneyName'
        FooterAlignmentHorz = taCenter
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 181
      end
      object isErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        FooterAlignmentHorz = taCenter
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
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
          ItemName = 'bbStartLoad_UKTZEDnew'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad_UKTZEDnewByName'
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
    object bbProtocolOpenForm: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbStartLoad_UKTZEDnew: TdxBarButton
      Action = macStartLoad_UKTZEDnew
      Category = 0
    end
    object bbStartLoad_UKTZEDnewByName: TdxBarButton
      Action = macStartLoad_UKTZEDnewByName
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 280
    Top = 152
    object actGetImportSetting_UKTZEDnewByName: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_byName
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_byName
        end>
      Caption = 'actGetImportSetting_UKTZEDnew'
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
      RefreshOnTabSetChanges = True
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TGoodsGroupEditForm'
      FormNameParam.Value = 'TGoodsGroupEditForm'
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
    object macStartLoad_UKTZEDnewByName: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_UKTZEDnewByName
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1082#1086#1076#1086#1074' '#1059#1050#1058#1047' '#1080#1079' '#1092#1072#1081#1083#1072' ('#1087#1086' '#1043#1088#1091#1087#1087#1077')?'
      InfoAfterExecute = #1082#1086#1076#1072' '#1059#1050#1058#1047' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1059#1050#1058#1047' '#1085#1072' '#1076#1072#1090#1091' ('#1087#1086' '#1043#1088#1091#1087#1087#1077')'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1086#1076' '#1059#1050#1058#1047' '#1085#1072' '#1076#1072#1090#1091' '#1080#1079' '#1092#1072#1081#1083#1072' ('#1087#1086' '#1043#1088#1091#1087#1087#1077')'
      ImageIndex = 41
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TGoodsGroupEditForm'
      FormNameParam.Value = 'TGoodsGroupEditForm'
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
      ShortCut = 13
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
    object actUpdateDataSource: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateCodeUKTZED
      StoredProcList = <
        item
          StoredProc = spUpdateCodeUKTZED
        end>
      Caption = 'actUpdateDataSource'
      DataSource = DataSource
    end
    object actGetImportSetting_UKTZEDnew: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSetting_UKTZEDnew'
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <>
    end
    object macStartLoad_UKTZEDnew: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_UKTZEDnew
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1082#1086#1076#1086#1074' '#1059#1050#1058#1047' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1082#1086#1076#1072' '#1059#1050#1058#1047' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1059#1050#1058#1047' '#1085#1072' '#1076#1072#1090#1091
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1086#1076' '#1059#1050#1058#1047' '#1085#1072' '#1076#1072#1090#1091' '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 41
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsGroup'
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
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 368
    Top = 128
  end
  object spUpdateCodeUKTZED: TdsdStoredProc
    StoredProcName = 'gpUpdateObject_GoodsGroup_UKTZED_new'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId '
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUKTZED'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CodeUKTZED'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUKTZED_new'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CodeUKTZED_new'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateUKTZED_new'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'DateUKTZED_new'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 464
    Top = 179
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 512
    Top = 128
  end
  object spGetImportSettingId: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TGoodsGroupForm;zc_Object_ImportSetting_GoodsGroupUKTZED'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 584
    Top = 136
  end
  object spGetImportSettingId_byName: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TGoodsGroupForm;zc_Object_ImportSetting_GoodsGroupUKTZED2'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 600
    Top = 184
  end
end
