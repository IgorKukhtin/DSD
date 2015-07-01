inherited AlternativeGroupForm: TAlternativeGroupForm
  Caption = #1043#1088#1091#1087#1087#1099' '#1072#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074
  ClientWidth = 651
  ExplicitWidth = 659
  ExplicitHeight = 335
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 651
    ExplicitWidth = 651
    ClientRectRight = 651
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 651
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 241
        Align = alLeft
        ExplicitWidth = 241
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1043#1088#1091#1087#1087': ,0'
              Kind = skCount
              Column = colName
            end>
          OptionsData.Appending = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colId: TcxGridDBColumn
            Caption = #8470
            DataBinding.FieldName = 'Id'
            Visible = False
          end
          object colName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            Width = 202
          end
          object colisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
          end
        end
      end
      object GridGoods: TcxGrid
        Left = 241
        Top = 0
        Width = 410
        Height = 282
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 1
        object GridGoodsTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = GoodsDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1058#1086#1074#1072#1088#1086#1074' '#1074' '#1075#1088#1091#1087#1087#1077': ,0'
              Kind = skCount
              Column = GridGodsColGoodsName
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          NewItemRow.InfoText = #1065#1077#1083#1082#1085#1080#1090#1077' '#1079#1076#1077#1089#1100' '#1076#1083#1103' '#1076#1086#1073#1072#1074#1083#1077#1085#1080#1103' '#1085#1086#1074#1086#1081' '#1089#1090#1088#1086#1082#1080
          NewItemRow.Visible = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object GridGodsColAlternativeGroupId: TcxGridDBColumn
            Caption = #8470' '#1075#1088#1091#1087#1087#1099
            DataBinding.FieldName = 'AlternativeGroupId'
            Visible = False
            Options.Editing = False
          end
          object GridGodsColGoodsId: TcxGridDBColumn
            Caption = #1048#1044' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsId'
            Visible = False
            Options.Editing = False
          end
          object GridGodsColGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            Options.Editing = False
            Width = 59
          end
          object GridGodsColGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = OpenChoiceFormGoods
                Default = True
                Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1086#1074#1072#1088' '#1074' '#1075#1088#1091#1087#1087#1091
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Options.ShowEditButtons = isebAlways
            Width = 318
          end
          object GridGodsColisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            Options.Editing = False
          end
        end
        object GridGoodsLevel: TcxGridLevel
          GridView = GridGoodsTableView
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_AlternativeGroup_Goods
        end>
    end
    object actShowDel: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1075#1088#1091#1087#1087#1099' '#1072#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1075#1088#1091#1087#1087#1099' '#1072#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074
      ImageIndex = 65
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1088#1072#1073#1086#1095#1080#1077' '#1075#1088#1091#1087#1087#1099' '#1072#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1075#1088#1091#1087#1087#1099' '#1072#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1088#1072#1073#1086#1095#1080#1077' '#1075#1088#1091#1087#1087#1099' '#1072#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1075#1088#1091#1087#1087#1099' '#1072#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074
      ImageIndexTrue = 64
      ImageIndexFalse = 65
    end
    object actShowDelGoods: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect_AlternativeGroup_Goods
      StoredProcList = <
        item
          StoredProc = spSelect_AlternativeGroup_Goods
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1088#1072#1073#1086#1095#1080#1077' '#1090#1086#1074#1072#1088#1099
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1088#1072#1073#1086#1095#1080#1077' '#1090#1086#1074#1072#1088#1099
      ImageIndex = 65
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1090#1086#1074#1072#1088#1099
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1088#1072#1073#1086#1095#1080#1077' '#1090#1086#1074#1072#1088#1099
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1090#1086#1074#1072#1088#1099
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1088#1072#1073#1086#1095#1080#1077' '#1090#1086#1074#1072#1088#1099
      ImageIndexTrue = 64
      ImageIndexFalse = 65
    end
    object dsdUpdateDataSet_Object_AlternativeGroup: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_AlternativeGroup
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_AlternativeGroup
        end>
      Caption = 'dsdUpdateDataSet_Object_AlternativeGroup'
      DataSource = MasterDS
    end
    object dsdUpdateDataSet_AlternativeGroup_Goods: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_AlternativeGroup_Goods
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_AlternativeGroup_Goods
        end>
      Caption = 'dsdUpdateDataSet_AlternativeGroup_Goods'
      DataSource = GoodsDS
    end
    object OpenChoiceFormGoods: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      FormName = 'TGoodsLiteForm'
      FormNameParam.Value = 'TGoodsLiteForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'GoodsId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
        end
        item
          Name = 'Code'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'GoodsCode'
        end>
      isShowModal = False
    end
    object actDeleteDataSet: TDataSetDelete
      Category = 'Delete'
      Caption = '&Delete'
      Hint = 'Delete'
      ImageIndex = 76
      DataSource = GoodsDS
    end
    object actExecuteDeleteLinkGoods: TdsdExecStoredProc
      Category = 'Delete'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_AlternativeGroup_Goods
      StoredProcList = <
        item
          StoredProc = spDelete_AlternativeGroup_Goods
        end>
      Caption = 'actExecuteDeleteLinkGoods'
    end
    object actDeleteLink: TMultiAction
      Category = 'Delete'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecuteDeleteLinkGoods
        end
        item
          Action = actDeleteDataSet
        end>
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1090#1086#1074#1072#1088' '#1080#1079' '#1075#1088#1091#1087#1087#1099' '#1072#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074'?'
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 46
    end
    object actSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1072#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074#1085#1091#1102' '#1075#1088#1091#1087#1087#1091
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1072#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074#1085#1091#1102' '#1075#1088#1091#1087#1087#1091
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object actSetUnErased: TdsdUpdateErased
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
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Top = 64
  end
  inherited MasterCDS: TClientDataSet
    Top = 64
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_AlternativeGroup'
    Params = <
      item
        Name = 'inIsShowDel'
        Value = Null
        Component = actShowDel
        DataType = ftBoolean
        ParamType = ptInput
      end>
    Top = 64
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 64
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbChoice'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
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
          ItemName = 'bbGridToExcel'
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
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actShowDel
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1090#1086#1074#1072#1088#1099' '#1073#1077#1079' '#1075#1088#1091#1087#1087#1099
      Category = 0
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1090#1086#1074#1072#1088#1099' '#1073#1077#1079' '#1075#1088#1091#1087#1087#1099
      Visible = ivAlways
      ImageIndex = 63
    end
    object dxBarButton3: TdxBarButton
      Action = actShowDelGoods
      Category = 0
    end
    object dxBarStatic1: TdxBarStatic
      Category = 0
      Visible = ivAlways
      Width = 100
    end
    object dxBarButton4: TdxBarButton
      Action = actDeleteLink
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = actSetErased
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actSetUnErased
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 288
    Top = 160
  end
  object GoodsCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'AlternativeGroupId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 312
    Top = 72
  end
  object GoodsDS: TDataSource
    DataSet = GoodsCDS
    Left = 344
    Top = 72
  end
  object spSelect_AlternativeGroup_Goods: TdsdStoredProc
    StoredProcName = 'gpSelect_AlternativeGroup_Goods'
    DataSet = GoodsCDS
    DataSets = <
      item
        DataSet = GoodsCDS
      end>
    Params = <
      item
        Name = 'inIsShowDel'
        Value = Null
        Component = actShowDelGoods
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 376
    Top = 72
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = GridGoodsTableView
    OnDblClickActionList = <>
    ActionItemList = <
      item
        Action = ChoiceGuides
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 360
    Top = 160
  end
  object spInsertUpdate_AlternativeGroup: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_AlternativeGroup'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 96
    Top = 128
  end
  object spInsertUpdate_AlternativeGroup_Goods: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_AlternativeGroup_Goods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inAlternativeGroupId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GoodsCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inOldGoodsId'
        Value = Null
        Component = GoodsCDS
        ComponentItem = 'OldGoodsId'
        ParamType = ptInput
      end
      item
        Name = 'outAlternativeGroupId'
        Value = Null
        Component = GoodsCDS
        ComponentItem = 'AlternativeGroupId'
      end>
    PackSize = 1
    Left = 480
    Top = 72
  end
  object spDelete_AlternativeGroup_Goods: TdsdStoredProc
    StoredProcName = 'gpDelete_AlternativeGroup_Goods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inAlternativeGroupId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GoodsCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 480
    Top = 120
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 144
    Top = 128
  end
end
