inherited GoodsAllRetailForm: TGoodsAllRetailForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1058#1086#1074#1072#1088#1086#1074' ('#1090#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100')'
  ClientHeight = 492
  ClientWidth = 1079
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 1095
  ExplicitHeight = 530
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1079
    Height = 466
    ExplicitWidth = 1079
    ExplicitHeight = 466
    ClientRectBottom = 466
    ClientRectRight = 1079
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1079
      ExplicitHeight = 466
      inherited cxGrid: TcxGrid
        Width = 1079
        Height = 153
        Align = alTop
        LookAndFeel.NativeStyle = True
        LookAndFeel.SkinName = ''
        ExplicitWidth = 1079
        ExplicitHeight = 153
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsBehavior.IncSearch = True
          OptionsView.ColumnAutoWidth = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colId: TcxGridDBColumn
            Caption = 'MainId'
            DataBinding.FieldName = 'GoodsMainId'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
          end
          object cxGridDBTableViewColumn1: TcxGridDBColumn
            Caption = 'GoodsId'
            DataBinding.FieldName = 'Id'
            Options.Editing = False
          end
          object clCodeInt: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 36
          end
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 166
          end
          object colMeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object colNDSKindName: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDSKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object clGoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object colisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object ObjectDescName: TcxGridDBColumn
            DataBinding.FieldName = 'ObjectDescName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object ObjectName: TcxGridDBColumn
            DataBinding.FieldName = 'ObjectName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object MakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 109
          end
          object MinimumLot: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'MinimumLot'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object isClose: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090
            DataBinding.FieldName = 'isClose'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 21
          end
          object isTOP: TcxGridDBColumn
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'isTOP'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 29
          end
          object isPromo: TcxGridDBColumn
            Caption = #1040#1082#1094#1080#1103' '
            DataBinding.FieldName = 'isPromo'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 29
          end
          object PercentMarkup: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'PercentMarkup'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079'.'
            DataBinding.FieldName = 'Price'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 44
          end
        end
      end
      object cxGridGChild1: TcxGrid
        Left = 0
        Top = 161
        Width = 1079
        Height = 162
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 1
        LookAndFeel.NativeStyle = True
        LookAndFeel.SkinName = ''
        object cxGridDBTableViewChild1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS_1
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.IncSearch = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object clGoodsMainId: TcxGridDBColumn
            Caption = 'MainId'
            DataBinding.FieldName = 'Id'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object clId: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object clCode1: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object clName1: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 140
          end
          object clMeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 32
          end
          object clNDSKindName: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDSKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object colGoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object clObjectDescName: TcxGridDBColumn
            DataBinding.FieldName = 'ObjectDescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object clObjectName: TcxGridDBColumn
            DataBinding.FieldName = 'ObjectName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object colMakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 109
          end
          object clMinimumLot: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'MinimumLot'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object clisClose: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090
            DataBinding.FieldName = 'isClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 21
          end
          object clisTOP: TcxGridDBColumn
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'isTOP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 29
          end
          object ClisPromo: TcxGridDBColumn
            Caption = #1040#1082#1094#1080#1103' '
            DataBinding.FieldName = 'isPromo'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 29
          end
          object clPercentMarkup: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'PercentMarkup'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object clPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079'.'
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 44
          end
        end
        object cxGridLevelChild1: TcxGridLevel
          GridView = cxGridDBTableViewChild1
        end
      end
      object cxSplitter: TcxSplitter
        Left = 0
        Top = 153
        Width = 1079
        Height = 8
        AlignSplitter = salTop
        Control = cxGrid
      end
      object cxGrid2: TcxGrid
        Left = 0
        Top = 331
        Width = 1079
        Height = 135
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        PopupMenu = PopupMenu
        TabOrder = 2
        LookAndFeel.Kind = lfFlat
        LookAndFeel.NativeStyle = True
        object cxGridDBTableViewChild2: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS_2
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.IncSearch = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object cxGoodsMainId: TcxGridDBColumn
            Caption = 'MainId'
            DataBinding.FieldName = 'GoodsMainId'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object cxGoodsId: TcxGridDBColumn
            AlternateCaption = '40'
            DataBinding.FieldName = 'GoodsId'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object cxCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object cxGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 221
          end
          object cxMeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 32
          end
          object cxNDSKindName: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDSKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object cxGoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object cxObjectDescName: TcxGridDBColumn
            DataBinding.FieldName = 'ObjectDescName'
            Options.Editing = False
            Width = 70
          end
          object cxObjectName: TcxGridDBColumn
            DataBinding.FieldName = 'ObjectName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object cxMakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 112
          end
          object cxMinimumLot: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'MinimumLot'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object cxisClose: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090
            DataBinding.FieldName = 'isClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 27
          end
          object cxisTOP: TcxGridDBColumn
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'isTOP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 37
          end
          object cxisPromo: TcxGridDBColumn
            Caption = #1040#1082#1094#1080#1103' '
            DataBinding.FieldName = 'isPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 29
          end
          object cxPercentMarkup: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'PercentMarkup'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
          object cxPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079'.'
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBTableViewChild2
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 323
        Width = 1079
        Height = 8
        AlignSplitter = salBottom
        Control = cxGrid2
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 467
    Top = 65528
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 624
    Top = 16
  end
  inherited ActionList: TActionList
    Left = 783
    Top = 15
    object DataSetDelete: TDataSetDelete [0]
      Category = 'Delete'
      Caption = '&Delete'
      Hint = 'Delete'
      DataSource = ChildDS_1
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spGoodsRetail
        end
        item
          StoredProc = spGoodsJuridicalChild_2
        end>
    end
    object mactListDelete: TMultiAction [2]
      Category = 'Delete'
      MoveParams = <>
      ActionList = <
        item
          Action = dsdExecStoredProc1
        end>
      DataSource = ChildDS_1
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1089#1074#1079#1080'? '
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1082#1086#1076#1086#1074
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      WithoutNext = True
    end
    inherited actInsert: TInsertUpdateChoiceAction
      Enabled = False
      ShortCut = 0
      FormName = 'TGoodsMainEditForm'
      FormNameParam.Value = 'TGoodsMainEditForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      Enabled = False
      ShortCut = 0
      FormName = 'TGoodsMainEditForm'
      FormNameParam.Value = 'TGoodsMainEditForm'
      isShowModal = True
    end
    inherited dsdSetUnErased: TdsdUpdateErased
      Enabled = False
      ShortCut = 0
    end
    inherited dsdSetErased: TdsdUpdateErased
      Category = 'Delete'
      StoredProc = dsdStoredProc1
      StoredProcList = <
        item
          StoredProc = dsdStoredProc1
        end>
      ImageIndex = -1
      ShortCut = 0
    end
    inherited dsdChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
        end>
    end
    object actGoodsLinkRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGoodsRetail
      StoredProcList = <
        item
          StoredProc = spGoodsRetail
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object mactDelete: TMultiAction
      Category = 'Delete'
      MoveParams = <>
      ActionList = <
        item
          Action = dsdExecStoredProc1
        end
        item
          Action = DataSetDelete
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1089#1074#1079#1080'? '
      Caption = #1059#1076#1072#1083#1077#1085#1080#1077
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
    end
    object dsdExecStoredProc1: TdsdExecStoredProc
      Category = 'Delete'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = dsdStoredProc1
      StoredProcList = <
        item
          StoredProc = dsdStoredProc1
        end>
      Caption = 'dsdExecStoredProc1'
    end
  end
  inherited MasterDS: TDataSource
    Left = 104
    Top = 64
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    IndexFieldNames = 'Id'
    MasterFields = 'Id'
    Left = 32
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods_Common'
    DataSet = ChildCDS_1
    DataSets = <
      item
        DataSet = ChildCDS_1
      end>
    Left = 336
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 736
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
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
          ItemName = 'bbRefresh'
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
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited bbInsert: TdxBarButton
      Visible = ivNever
    end
    inherited bbEdit: TdxBarButton
      Visible = ivNever
    end
    inherited bbErased: TdxBarButton
      Action = mactDelete
    end
    inherited bbUnErased: TdxBarButton
      Visible = ivNever
    end
    object bbLabel: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object bbJuridical: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
      end
      item
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
    SearchAsFilter = False
    Left = 200
    Top = 72
  end
  inherited PopupMenu: TPopupMenu
    Left = 680
    Top = 8
    object N9: TMenuItem [5]
      Action = mactListDelete
    end
    object N8: TMenuItem [6]
      Caption = '-'
    end
  end
  inherited spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_LinkGoods'
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ChildCDS_1
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 776
    Top = 96
  end
  object spGoodsRetail: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsAll_Retail'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <>
    PackSize = 1
    Left = 344
    Top = 80
  end
  object ChildCDS_1: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'Id'
    MasterFields = 'GoodsMainId'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 432
    Top = 264
  end
  object ChildDS_1: TDataSource
    DataSet = ChildCDS_1
    Left = 744
    Top = 136
  end
  object DBViewAddOnChild1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewChild1
    OnDblClickActionList = <
      item
      end
      item
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
    SearchAsFilter = False
    Left = 208
    Top = 256
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    RefreshAction = actGoodsLinkRefresh
    ComponentList = <
      item
      end>
    Left = 568
  end
  object dsdStoredProc1: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_LinkGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ChildCDS_1
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 856
    Top = 64
  end
  object ChildCDS_2: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'GoodsMainId'
    MasterFields = 'GoodsMainId'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 440
    Top = 408
  end
  object ChildDS_2: TDataSource
    DataSet = ChildCDS_2
    Left = 368
    Top = 384
  end
  object dsdDBViewAddOnChild2: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewChild2
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
    SearchAsFilter = False
    Left = 544
    Top = 384
  end
  object spGoodsJuridicalChild_2: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsAll_Juridical'
    DataSet = ChildCDS_2
    DataSets = <
      item
        DataSet = ChildCDS_2
      end>
    Params = <>
    PackSize = 1
    Left = 256
    Top = 384
  end
end
