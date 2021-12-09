object UnitAutoSUAForm: TUnitAutoSUAForm
  Left = 0
  Top = 0
  Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1072#1074#1090#1086' '#1088#1072#1089#1095#1077#1090#1072' '#1057#1059#1040
  ClientHeight = 380
  ClientWidth = 986
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 2
    Top = 26
    Width = 984
    Height = 354
    Align = alClient
    TabOrder = 0
    LookAndFeel.NativeStyle = True
    LookAndFeel.SkinName = 'UserSkin'
    ExplicitWidth = 662
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
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object ORD: TcxGridDBColumn
        Caption = #8470' '#1087'.'#1087'.'
        DataBinding.FieldName = 'ORD'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 36
      end
      object UnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'UnitName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 166
      end
      object JuridicalName: TcxGridDBColumn
        Caption = #1070#1088#1102'. '#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 167
      end
      object DateAuto: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1072#1074#1090#1086#1088#1072#1089#1095#1077#1090#1072
        DataBinding.FieldName = 'DateAuto'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 108
      end
      object Latitude: TcxGridDBColumn
        Caption = #1064#1080#1088#1086#1090#1072
        DataBinding.FieldName = 'Latitude'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 82
      end
      object Longitude: TcxGridDBColumn
        Caption = #1044#1086#1083#1075#1086#1090#1072
        DataBinding.FieldName = 'Longitude'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 76
      end
      object Calculation: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1088#1072#1073#1086#1090#1099' '#1057#1059#1040
        DataBinding.FieldName = 'Calculation'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 91
      end
      object CountFinalSUA: TcxGridDBColumn
        Caption = #1059#1095#1072#1089#1090#1080#1081' '#1074' '#1057#1059#1040
        DataBinding.FieldName = 'CountFinalSUA'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 61
      end
      object AssortmentName1: TcxGridDBColumn
        Caption = #1040#1087#1090#1077#1082#1072' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072' 1'
        DataBinding.FieldName = 'AssortmentName1'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 130
      end
      object AssortmentName2: TcxGridDBColumn
        Caption = #1040#1087#1090#1077#1082#1072' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072' 2'
        DataBinding.FieldName = 'AssortmentName2'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 130
      end
      object AssortmentName3: TcxGridDBColumn
        Caption = #1040#1087#1090#1077#1082#1072' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072' 3'
        DataBinding.FieldName = 'AssortmentName3'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 130
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxSplitter: TcxSplitter
    Left = 0
    Top = 26
    Width = 2
    Height = 354
    Control = cxGrid
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
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
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 0
      ShortCut = 45
    end
    object bbEdit: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 1
      ShortCut = 115
    end
    object bbSetErased: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 2
      ShortCut = 46
    end
    object bbSetUnErased: TdxBarButton
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 8
      ShortCut = 32776
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
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Category = 0
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Visible = ivAlways
      ImageIndex = 7
    end
    object bbProtocolOpen: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
      Visible = ivAlways
      ImageIndex = 34
    end
    object bbProtocolRole: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1056#1086#1083#1080
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1056#1086#1083#1080
      Visible = ivAlways
      ImageIndex = 34
    end
    object dxBarButton1: TdxBarButton
      Action = actChangeAutoUnit
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
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
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
    object actChangeAutoUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAutoUnit
      StoredProcList = <
        item
          StoredProc = spUpdateAutoUnit
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1076#1083#1103' '#1089#1083#1077#1076#1091#1102#1097#1077#1075#1086' '#1072#1074#1090#1086#1088#1072#1089#1095#1077#1090#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1076#1083#1103' '#1089#1083#1077#1076#1091#1102#1097#1077#1075#1086' '#1072#1074#1090#1086#1088#1072#1089#1095#1077#1090#1072
      ImageIndex = 8
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1076#1083#1103' '#1089#1083#1077#1076#1091#1102#1097#1077#1075#1086' '#1072#1074#1090#1086#1088#1072#1089#1095#1077#1090#1072'?'
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_UnitAutoSUA'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 88
    Top = 104
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
      end
      item
      end>
    ActionItemList = <
      item
        ShortCut = 13
      end
      item
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
    Left = 136
    Top = 224
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 272
    Top = 216
  end
  object spUpdateAutoUnit: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_AutoSUA'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 384
    Top = 112
  end
end
