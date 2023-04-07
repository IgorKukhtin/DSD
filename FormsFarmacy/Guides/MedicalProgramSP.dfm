object MedicalProgramSPForm: TMedicalProgramSPForm
  Left = 0
  Top = 0
  Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1080#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1089#1086#1094'. '#1087#1088#1086#1077#1082#1090#1086#1074
  ClientHeight = 344
  ClientWidth = 637
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 62
    Width = 637
    Height = 282
    Align = alClient
    PopupMenu = pmGrid
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
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taRightJustify
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 59
      end
      object Name: TcxGridDBColumn
        Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1072#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1072
        DataBinding.FieldName = 'Name'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 197
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
      object SPKindName: TcxGridDBColumn
        Caption = #1057#1086#1094'.  '#1087#1088#1086#1077#1082#1090
        DataBinding.FieldName = 'SPKindName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 135
      end
      object GroupMedicalProgramSPName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1084#1077#1076#1080#1094#1080#1085#1089#1082#1080#1093' '#1087#1088#1086#1075#1088#1072#1084#1084' '#1089#1086#1094'. '#1087#1088#1086#1077#1082#1090#1086#1074
        DataBinding.FieldName = 'GroupMedicalProgramSPName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 109
      end
      object isFree: TcxGridDBColumn
        Caption = #1041#1077#1079#1087#1083#1072#1090#1085#1086
        DataBinding.FieldName = 'isFree'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object isElectronicPrescript: TcxGridDBColumn
        Caption = #1069#1083#1077#1082#1090#1088'. '#1088#1077#1094#1077#1087#1090
        DataBinding.FieldName = 'isElectronicPrescript'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 64
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 637
    Height = 35
    Align = alTop
    TabOrder = 5
    object cxLabel6: TcxLabel
      Left = 6
      Top = 9
      AutoSize = False
      Caption = #1057#1086#1094'. '#1087#1088#1086#1077#1082#1090
      Height = 17
      Width = 141
    end
    object edSPKind: TcxButtonEdit
      Left = 75
      Top = 8
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 450
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
    Font.Height = -15
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
      27
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
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
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
      Caption = '     '
      Category = 0
      Hint = '     '
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
    object bbStartLoad: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1060#1048#1054' '#1074#1088#1072#1095#1072' ('#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090')'
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1060#1048#1054' '#1074#1088#1072#1095#1072' ('#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090')'
      Visible = ivAlways
      ImageIndex = 41
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
      FormName = 'TMedicalProgramSPEditForm'
      FormNameParam.Value = 'TMedicalProgramSPEditForm'
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
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TMedicalProgramSPEditForm'
      FormNameParam.Value = 'TMedicalProgramSPEditForm'
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
          Name = 'SPKindId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'SPKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'SPKindName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'SPKindName'
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
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_MedicalProgramSP'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inSPKindId'
        Value = Null
        Component = SPKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 144
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
    Left = 312
    Top = 272
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
    PropertiesCellList = <>
    Left = 48
    Top = 216
  end
  object pmGrid: TPopupMenu
    Images = dmMain.ImageList
    Left = 368
    Top = 128
    object pmAdd: TMenuItem
      Action = actInsert
    end
    object N1: TMenuItem
      Action = actUpdate
    end
    object N2: TMenuItem
      Action = actRefresh
    end
    object N3: TMenuItem
      Action = dsdSetErased
    end
    object N4: TMenuItem
      Action = dsdSetUnErased
    end
  end
  object SPKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edSPKind
    FormNameParam.Value = 'TSPKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSPKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = SPKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = SPKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 296
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'SPKindId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 512
    Top = 136
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = SPKindGuides
      end>
    Left = 440
    Top = 112
  end
end
