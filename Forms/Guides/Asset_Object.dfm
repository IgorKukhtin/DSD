object Asset_ObjectForm: TAsset_ObjectForm
  Left = 0
  Top = 0
  Caption = #1054#1089#1085#1086#1074#1085#1099#1077' '#1089#1088#1077#1076#1089#1090#1074#1072
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
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  AddOnFormData.Params = FormParams
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
      DataController.Summary.FooterSummaryItems = <>
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
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object ItemName: TcxGridDBColumn
        Caption = #1069#1083#1077#1084#1077#1085#1090
        DataBinding.FieldName = 'ItemName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentVert = vaCenter
        Width = 58
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentVert = vaCenter
        Width = 110
      end
      object AmountRemains: TcxGridDBColumn
        Caption = #1054#1089#1090#1072#1090#1086#1082
        DataBinding.FieldName = 'AmountRemains'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object InvNumber: TcxGridDBColumn
        Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1085#1099#1081' '#1085#1086#1084#1077#1088
        DataBinding.FieldName = 'InvNumber'
        HeaderAlignmentVert = vaCenter
        Width = 142
      end
      object SerialNumber: TcxGridDBColumn
        Caption = #1047#1072#1074#1086#1076#1089#1082#1086#1081' '#1085#1086#1084#1077#1088
        DataBinding.FieldName = 'SerialNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 68
      end
      object PassportNumber: TcxGridDBColumn
        Caption = #1053#1086#1084#1077#1088' '#1087#1072#1089#1087#1086#1088#1090#1072
        DataBinding.FieldName = 'PassportNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 66
      end
      object Release: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1074#1099#1087#1091#1089#1082#1072
        DataBinding.FieldName = 'Release'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 66
      end
      object FullName: TcxGridDBColumn
        Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'FullName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 111
      end
      object AssetGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1099' '#1086#1089#1085#1086#1074#1085#1099#1093' '#1089#1088#1077#1076#1089#1090#1074
        DataBinding.FieldName = 'AssetGroupName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 138
      end
      object MakerName: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        DataBinding.FieldName = 'MakerName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 111
      end
      object CarName: TcxGridDBColumn
        Caption = #1043#1086#1089'. '#1085#1086#1084#1077#1088' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
        DataBinding.FieldName = 'CarName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object CarModelName: TcxGridDBColumn
        Caption = #1052#1072#1088#1082#1072' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
        DataBinding.FieldName = 'CarModelName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object PartionModelName: TcxGridDBColumn
        Caption = #1052#1086#1076#1077#1083#1100' ('#1087#1072#1088#1090#1080#1103')'
        DataBinding.FieldName = 'PartionModelName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object AssetTypeName: TcxGridDBColumn
        Caption = #1058#1080#1087' '#1054#1057
        DataBinding.FieldName = 'AssetTypeName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object PeriodUse: TcxGridDBColumn
        Caption = #1055#1077#1088#1080#1086#1076' '#1101#1082#1089#1087'. ('#1083#1077#1090')'
        DataBinding.FieldName = 'PeriodUse'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1077#1088#1080#1086#1076' '#1101#1082#1089#1087#1083#1091#1072#1090#1072#1094#1080#1080' ('#1083#1077#1090')'
        Width = 100
      end
      object Production: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076'-'#1090#1100', '#1082#1075
        DataBinding.FieldName = 'Production'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100', '#1082#1075
        Options.Editing = False
        Width = 86
      end
      object KW: TcxGridDBColumn
        Caption = #1052#1086#1097#1085#1086#1089#1090#1100', '#1082#1042#1090
        DataBinding.FieldName = 'KW'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100', '#1082#1075
        Options.Editing = False
        Width = 86
      end
      object Comment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 120
      end
      object ContainerId: TcxGridDBColumn
        Caption = #1055#1072#1088#1090#1080#1103' '#1054#1057
        DataBinding.FieldName = 'ContainerId'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object StorageName: TcxGridDBColumn
        Caption = #1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103
        DataBinding.FieldName = 'StorageName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object UnitName_Storage: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103')'
        DataBinding.FieldName = 'UnitName_Storage'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 126
      end
      object BranchName_Storage: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083' ('#1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103')'
        DataBinding.FieldName = 'BranchName_Storage'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 76
      end
      object AreaUnitName_Storage: TcxGridDBColumn
        Caption = #1059#1095#1072#1089#1090#1086#1082' ('#1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103')'
        DataBinding.FieldName = 'AreaUnitName_Storage'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 81
      end
      object Room_Storage: TcxGridDBColumn
        Caption = #1050#1072#1073#1080#1085#1077#1090' ('#1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103')'
        DataBinding.FieldName = 'Room_Storage'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 72
      end
      object Address_Storage: TcxGridDBColumn
        Caption = #1040#1076#1088#1077#1089' ('#1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103')'
        DataBinding.FieldName = 'Address_Storage'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 127
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
  object cxLabel6: TcxLabel
    Left = 489
    Top = 78
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object edUnit: TcxButtonEdit
    Left = 583
    Top = 77
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 245
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
          ItemName = 'bbLabel6'
        end
        item
          Visible = True
          ItemName = 'bbUnit'
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
    object bbLabel6: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel6
    end
    object bbUnit: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edUnit
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 280
    Top = 152
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
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TAssetEditForm'
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
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TAssetEditForm'
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
        end
        item
          Name = 'Code'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AmountRemains'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'AmountRemains'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContainerId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'ContainerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'SerialNumber'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'SerialNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PassportNumber'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PassportNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Release'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Release'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'MakerName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'MakerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'CarName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'CarName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'CarModelName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'CarModelName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodUse'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PeriodUse'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'StorageId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'StorageId'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StorageIName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'StorageName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName_Storage'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'UnitName_Storage'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName_Storage'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BranchName_Storage'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AreaUnitName_Storage'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'AreaUnitName_Storage'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Room_Storage'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Room_Storage'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Address_Storage'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Address_Storage'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Production'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Production'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'KW'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'KW'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionModelId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PartionModelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionModelName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PartionModelName'
          DataType = ftString
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
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_AssetChoice'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
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
    Left = 448
    Top = 112
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 712
    Top = 88
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MasterUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 408
    Top = 176
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesUnit
      end>
    Left = 600
    Top = 128
  end
end
