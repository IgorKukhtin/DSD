object ReceiptGoodsChoiceForm: TReceiptGoodsChoiceForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1072' '#1059#1079#1083#1086#1074'>'
  ClientHeight = 386
  ClientWidth = 1127
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
  AddOnFormData.ChoiceAction = actChoiceGuides
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object PanelMaster: TPanel
    Left = 8
    Top = 64
    Width = 1111
    Height = 322
    Align = alClient
    BevelEdges = [beLeft]
    BevelOuter = bvNone
    TabOrder = 0
    object cxGrid: TcxGrid
      Left = 0
      Top = 17
      Width = 1111
      Height = 305
      Align = alClient
      PopupMenu = PopupMenu
      TabOrder = 0
      LookAndFeel.NativeStyle = True
      LookAndFeel.SkinName = 'UserSkin'
      object cxGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = DataSource
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = 'C'#1090#1088#1086#1082': ,0'
            Kind = skCount
            Column = Name
          end>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.CellAutoHeight = True
        OptionsView.Footer = True
        OptionsView.GroupSummaryLayout = gslAlignWithColumns
        OptionsView.HeaderAutoHeight = True
        OptionsView.HeaderHeight = 40
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object isMain: TcxGridDBColumn
          Caption = #1043#1083#1072#1074#1085#1099#1081' ('#1076#1072'/'#1085#1077#1090')'
          DataBinding.FieldName = 'isMain'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1043#1083#1072#1074#1085#1099#1081' ('#1076#1072'/'#1085#1077#1090')'
          Options.Editing = False
          Width = 72
        end
        object Code: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'Code'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 43
        end
        object UserCode: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079'. '#1050#1086#1076
          DataBinding.FieldName = 'UserCode'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100#1089#1082#1080#1081' '#1050#1086#1076
          Options.Editing = False
          Width = 92
        end
        object Name: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'Name'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 189
        end
        object ModelName: TcxGridDBColumn
          Caption = #1052#1086#1076#1077#1083#1100
          DataBinding.FieldName = 'ModelName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object ColorPatternName: TcxGridDBColumn
          Caption = #1064#1072#1073#1083#1086#1085' Boat Structure '
          DataBinding.FieldName = 'ColorPatternName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 125
        end
        object MaterialOptionsName: TcxGridDBColumn
          Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1054#1087#1094#1080#1081
          DataBinding.FieldName = 'MaterialOptionsName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 100
        end
        object ProdColorName_pcp: TcxGridDBColumn
          Caption = '~Farbe'
          DataBinding.FieldName = 'ProdColorName_pcp'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = 'Farbe Boat Structure'
          Options.Editing = False
          Width = 80
        end
        object Article: TcxGridDBColumn
          Caption = 'Artikel Nr'
          DataBinding.FieldName = 'Article'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Caption = 'actChoiceFormGoods_1'
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 80
        end
        object ArticleVergl: TcxGridDBColumn
          Caption = 'Vergl. Nr'
          DataBinding.FieldName = 'ArticleVergl'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1040#1088#1090#1080#1082#1091#1083' ('#1072#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074#1085#1099#1081')'
          Options.Editing = False
          Width = 70
        end
        object Article_all: TcxGridDBColumn
          Caption = '***Artikel Nr'
          DataBinding.FieldName = 'Article_all'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object GoodsGroupNameFull: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
          DataBinding.FieldName = 'GoodsGroupNameFull'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 150
        end
        object GoodsGroupName: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072
          DataBinding.FieldName = 'GoodsGroupName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 172
        end
        object GoodsCode: TcxGridDBColumn
          Caption = 'Interne Nr'
          DataBinding.FieldName = 'GoodsCode'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076
          Options.Editing = False
          Width = 60
        end
        object GoodsName: TcxGridDBColumn
          Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
          DataBinding.FieldName = 'GoodsName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 164
        end
        object Article_group: TcxGridDBColumn
          Caption = 'Artikel Nr***'
          DataBinding.FieldName = 'Article_group'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = '***'#1041#1072#1079#1086#1074#1072#1103' '#1089#1073#1086#1088#1082#1072
          Options.Editing = False
          Width = 80
        end
        object GoodsCode_group: TcxGridDBColumn
          Caption = 'Interne Nr***'
          DataBinding.FieldName = 'GoodsCode_group'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = '***'#1041#1072#1079#1086#1074#1072#1103' '#1089#1073#1086#1088#1082#1072
          Options.Editing = False
          Width = 80
        end
        object GoodsName_group: TcxGridDBColumn
          Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'***'
          DataBinding.FieldName = 'GoodsName_group'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = '***'#1041#1072#1079#1086#1074#1072#1103' '#1089#1073#1086#1088#1082#1072
          Options.Editing = False
          Width = 80
        end
        object MeasureName: TcxGridDBColumn
          Caption = #1045#1076'. '#1080#1079#1084'.'
          DataBinding.FieldName = 'MeasureName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 40
        end
        object ProdColorName: TcxGridDBColumn
          Caption = 'Farbe ('#1050#1086#1084#1087#1083'.)'
          DataBinding.FieldName = 'ProdColorName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = 'Farbe '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
          Options.Editing = False
          Width = 80
        end
        object Comment_goods: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1050#1086#1084#1087#1083'.)'
          DataBinding.FieldName = 'Comment_goods'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
          Options.Editing = False
          Width = 100
        end
        object Comment: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          DataBinding.FieldName = 'Comment'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          HeaderHint = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080
          Options.Editing = False
          Width = 100
        end
        object InsertDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
          DataBinding.FieldName = 'InsertDate'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object InsertName: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
          DataBinding.FieldName = 'InsertName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object UpdateDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
          DataBinding.FieldName = 'UpdateDate'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object UpdateName: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
          DataBinding.FieldName = 'UpdateName'
          Visible = False
          HeaderAlignmentHorz = taCenter
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
      end
      object cxGridLevel: TcxGridLevel
        GridView = cxGridDBTableView
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 1111
      Height = 17
      Align = alTop
      Caption = #1057#1073#1086#1088#1082#1072' '#1091#1079#1083#1086#1074
      Color = clSkyBlue
      ParentBackground = False
      TabOrder = 1
    end
  end
  object cxTopSplitter: TcxSplitter
    Left = 0
    Top = 59
    Width = 1127
    Height = 5
    AlignSplitter = salTop
    Control = PanelMaster
  end
  object cxRightSplitter: TcxSplitter
    Left = 1119
    Top = 64
    Width = 8
    Height = 322
    AlignSplitter = salRight
  end
  object cxSplitter1: TcxSplitter
    Left = 0
    Top = 64
    Width = 8
    Height = 322
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1127
    Height = 33
    Align = alTop
    TabOrder = 8
    object edSearchArticle: TcxTextEdit
      Left = 124
      Top = 6
      TabOrder = 0
      DesignSize = (
        125
        21)
      Width = 125
    end
    object lbSearchArticle: TcxLabel
      Left = 3
      Top = 5
      Caption = #1055#1086#1080#1089#1082' Artikel Nr : '
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object lbSearchCode: TcxLabel
      Left = 269
      Top = 6
      Caption = #1059#1079#1077#1083' : '
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object lbSearchName: TcxLabel
      Left = 475
      Top = 5
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' : '
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchReceiptGoods: TcxTextEdit
      Left = 319
      Top = 6
      TabOrder = 5
      DesignSize = (
        150
        21)
      Width = 150
    end
    object edSearchGoodsName: TcxTextEdit
      Left = 607
      Top = 6
      TabOrder = 4
      DesignSize = (
        151
        21)
      Width = 151
    end
  end
  object DataSource: TDataSource
    DataSet = MasterCDS
    Left = 464
    Top = 96
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 560
    Top = 136
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
    Left = 64
    Top = 144
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
    Left = 144
    Top = 128
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
          ItemName = 'bbShowAllErased'
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
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Category = 0
    end
    object bbToExcel: TdxBarButton
      Action = actGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbChoice: TdxBarButton
      Action = actChoiceGuides
      Category = 0
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = actProtocol
      Category = 0
    end
    object bbShowAllErased: TdxBarButton
      Action = actShowAllErased
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 24
    Top = 96
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
      ImageIndex = 90
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName_all'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName_all'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = DataSource
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
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actShowAllErased: TBooleanStoredProcAction
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
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ReceiptGoods'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowAllErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 96
    Top = 120
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 352
    Top = 120
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = actChoiceGuides
      end
      item
      end>
    ActionItemList = <
      item
        Action = actChoiceGuides
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
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 656
    Top = 112
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 504
    Top = 120
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 344
    Top = 208
    object N1: TMenuItem
      Action = actRefresh
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
    end
    object N2: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
    end
    object N4: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ImageIndex = 1
    end
    object N3: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 46
    end
    object N5: TMenuItem
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
    end
  end
  object FieldFilter_Article: TdsdFieldFilter
    TextEdit = edSearchArticle
    DataSet = MasterCDS
    Column = Article
    ColumnList = <
      item
        Column = Article
      end
      item
        Column = Article_all
      end
      item
        Column = Name
        TextEdit = edSearchReceiptGoods
      end
      item
        Column = GoodsName
        TextEdit = edSearchGoodsName
      end>
    ActionNumber1 = actChoiceGuides
    CheckBoxList = <>
    Left = 88
    Top = 248
  end
end
