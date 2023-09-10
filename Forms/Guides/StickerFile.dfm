object StickerFileForm: TStickerFileForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1064#1040#1041#1051#1054#1053'>'
  ClientHeight = 335
  ClientWidth = 907
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
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 907
    Height = 309
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
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 47
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 123
      end
      object Name_70_70: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' 70x70'
        DataBinding.FieldName = 'Name_70_70'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object isDefault: TcxGridDBColumn
        Caption = #1043#1083#1072#1074#1085'.'
        DataBinding.FieldName = 'isDefault'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
        Width = 50
      end
      object isSize70: TcxGridDBColumn
        Caption = '70x70 ('#1076#1072'/'#1085#1077#1090')'
        DataBinding.FieldName = 'isSize70'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object LanguageName: TcxGridDBColumn
        Caption = #1071#1079#1099#1082
        DataBinding.FieldName = 'LanguageName'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 78
      end
      object TradeMarkName: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
        DataBinding.FieldName = 'TradeMarkName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 79
      end
      object JuridicalName: TcxGridDBColumn
        Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
        DataBinding.FieldName = 'JuridicalName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 77
      end
      object ItemName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
        DataBinding.FieldName = 'ItemName'
        Visible = False
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 101
      end
      object Comment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 69
      end
      object Width1: TcxGridDBColumn
        Caption = '1-'#1072#1103
        DataBinding.FieldName = 'Width1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 1-'#1086#1081' '#1089#1090#1088'.'
        Options.Editing = False
        Width = 27
      end
      object Width2: TcxGridDBColumn
        Caption = '2-'#1072#1103
        DataBinding.FieldName = 'Width2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 2-'#1086#1081' '#1089#1090#1088'.'
        Options.Editing = False
        Width = 26
      end
      object Width3: TcxGridDBColumn
        Caption = '3-'#1072#1103
        DataBinding.FieldName = 'Width3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 3-'#1086#1081' '#1089#1090#1088'.'
        Options.Editing = False
        Width = 26
      end
      object Width4: TcxGridDBColumn
        Caption = '4-'#1072#1103
        DataBinding.FieldName = 'Width4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 4-'#1086#1081' '#1089#1090#1088'.'
        Options.Editing = False
        Width = 26
      end
      object Width5: TcxGridDBColumn
        Caption = '5-'#1072#1103
        DataBinding.FieldName = 'Width5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 5-'#1086#1081' '#1089#1090#1088'.'
        Options.Editing = False
        Width = 26
      end
      object Width6: TcxGridDBColumn
        Caption = '6-'#1072#1103
        DataBinding.FieldName = 'Width6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 6-'#1086#1081' '#1089#1090#1088'.'
        Options.Editing = False
        Width = 27
      end
      object Width7: TcxGridDBColumn
        Caption = '7-'#1072#1103
        DataBinding.FieldName = 'Width7'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 7-'#1086#1081' '#1089#1090#1088'.'
        Options.Editing = False
        Width = 26
      end
      object Width8: TcxGridDBColumn
        Caption = '8-'#1072#1103
        DataBinding.FieldName = 'Width8'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 8-'#1086#1081' '#1089#1090#1088'.'
        Options.Editing = False
        Width = 26
      end
      object Width9: TcxGridDBColumn
        Caption = '9-'#1072#1103
        DataBinding.FieldName = 'Width9'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 9-'#1086#1081' '#1089#1090#1088'.'
        Options.Editing = False
        Width = 26
      end
      object Width10: TcxGridDBColumn
        Caption = '10-'#1072#1103
        DataBinding.FieldName = 'Width10'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 10-'#1086#1081' '#1089#1090#1088'.'
        Options.Editing = False
        Width = 27
      end
      object Level1: TcxGridDBColumn
        Caption = #1059#1088'.1'
        DataBinding.FieldName = 'Level1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 1-'#1075#1086' '#1091#1088#1086#1074#1085#1103
        Options.Editing = False
        Width = 27
      end
      object Level2: TcxGridDBColumn
        Caption = #1059#1088'.2'
        DataBinding.FieldName = 'Level2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 2-'#1075#1086' '#1091#1088#1086#1074#1085#1103
        Options.Editing = False
        Width = 30
      end
      object Left1: TcxGridDBColumn
        Caption = '1-'#1072#1103
        DataBinding.FieldName = 'Left1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1090#1089#1090#1091#1087' '#1089#1083#1077#1074#1072' 1-'#1086#1081' '#1089#1090#1088'.'
        Options.Editing = False
        Width = 23
      end
      object Left2: TcxGridDBColumn
        Caption = '2-'#1072#1103
        DataBinding.FieldName = 'Left2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1090#1089#1090#1091#1087' '#1089#1083#1077#1074#1072' 2-'#1086#1081' '#1089#1090#1088'.'
        Options.Editing = False
        Width = 23
      end
      object Width1_70_70: TcxGridDBColumn
        Caption = '1-'#1072#1103' 70*70'
        DataBinding.FieldName = 'Width1_70_70'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 1-'#1086#1081' '#1089#1090#1088'. (70*70)'
        Options.Editing = False
        Width = 42
      end
      object Width2_70_70: TcxGridDBColumn
        Caption = '2-'#1072#1103' 70*70'
        DataBinding.FieldName = 'Width2_70_70'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 2-'#1086#1081' '#1089#1090#1088'. (70*70)'
        Options.Editing = False
        Width = 42
      end
      object Width3_70_70: TcxGridDBColumn
        Caption = '3-'#1072#1103' 70*70'
        DataBinding.FieldName = 'Width3_70_70'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 3-'#1086#1081' '#1089#1090#1088'. (70*70)'
        Options.Editing = False
        Width = 42
      end
      object Width4_70_70: TcxGridDBColumn
        Caption = '4-'#1072#1103' 70*70'
        DataBinding.FieldName = 'Width4_70_70'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 4-'#1086#1081' '#1089#1090#1088'. (70*70)'
        Options.Editing = False
        Width = 42
      end
      object Width5_70_70: TcxGridDBColumn
        Caption = '5-'#1072#1103' 70*70'
        DataBinding.FieldName = 'Width5_70_70'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 5-'#1086#1081' '#1089#1090#1088'. (70*70)'
        Options.Editing = False
        Width = 42
      end
      object Width6_70_70: TcxGridDBColumn
        Caption = '6-'#1072#1103' 70*70'
        DataBinding.FieldName = 'Width6_70_70'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 6-'#1086#1081' '#1089#1090#1088'. (70*70)'
        Options.Editing = False
        Width = 42
      end
      object Width7_70_70: TcxGridDBColumn
        Caption = '7-'#1072#1103' 70*70'
        DataBinding.FieldName = 'Width7_70_70'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 7-'#1086#1081' '#1089#1090#1088'. (70*70)'
        Options.Editing = False
        Width = 42
      end
      object Width8_70_70: TcxGridDBColumn
        Caption = '8-'#1072#1103' 70*70'
        DataBinding.FieldName = 'Width8_70_70'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 8-'#1086#1081' '#1089#1090#1088'. (70*70)'
        Options.Editing = False
        Width = 42
      end
      object Width9_70_70: TcxGridDBColumn
        Caption = '9-'#1072#1103' 70*70'
        DataBinding.FieldName = 'Width9_70_70'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 9-'#1086#1081' '#1089#1090#1088'. (70*70)'
        Options.Editing = False
        Width = 42
      end
      object Width10_70_70: TcxGridDBColumn
        Caption = '10-'#1072#1103' 70*70'
        DataBinding.FieldName = 'Width10_70_70'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 10-'#1086#1081' '#1089#1090#1088'. (70*70)'
        Options.Editing = False
        Width = 42
      end
      object Level1_70_70: TcxGridDBColumn
        Caption = #1059#1088'.1 70*70'
        DataBinding.FieldName = 'Level1_70_70'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 1-'#1075#1086' '#1091#1088#1086#1074#1085#1103' (70*70)'
        Options.Editing = False
        Width = 42
      end
      object Level2_70_70: TcxGridDBColumn
        Caption = #1059#1088'.2 70*70'
        DataBinding.FieldName = 'Level2_70_70'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1064#1080#1088#1080#1085#1072' 2-'#1075#1086' '#1091#1088#1086#1074#1085#1103' (70*70)'
        Options.Editing = False
        Width = 42
      end
      object Left1_70_70: TcxGridDBColumn
        Caption = '1-'#1072#1103' 70*70'
        DataBinding.FieldName = 'Left1_70_70'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1090#1089#1090#1091#1087' '#1089#1083#1077#1074#1072' 1-'#1086#1081' '#1089#1090#1088'.'
        Options.Editing = False
        Width = 42
      end
      object Left2_70_70: TcxGridDBColumn
        Caption = '2-'#1072#1103' 70*70'
        DataBinding.FieldName = 'Left2_70_70'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1090#1089#1090#1091#1087' '#1089#1083#1077#1074#1072' 2-'#1086#1081' '#1089#1090#1088'. (70*70)'
        Options.Editing = False
        Width = 42
      end
      object isErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 58
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
          ItemName = 'bbShowAll'
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
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
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
      RefreshOnTabSetChanges = True
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TStickerFileEditForm'
      FormNameParam.Value = 'TStickerFileEditForm'
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
      FormName = 'TStickerFileEditForm'
      FormNameParam.Value = 'TStickerFileEditForm'
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
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_StickerFile'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
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
    Left = 360
    Top = 184
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
end
