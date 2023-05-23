object GoodsGroup_ObjectForm: TGoodsGroup_ObjectForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074'>'
  ClientHeight = 376
  ClientWidth = 671
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
  object cxDBTreeList: TcxDBTreeList
    Left = 0
    Top = 26
    Width = 671
    Height = 350
    Align = alClient
    Bands = <
      item
      end>
    DataController.DataSource = DataSource
    DataController.ParentField = 'ParentId'
    DataController.KeyField = 'Id'
    Images = dmMain.TreeImageList
    Navigator.Buttons.CustomButtons = <>
    OptionsBehavior.IncSearch = True
    OptionsCustomizing.BandsQuickCustomization = True
    OptionsCustomizing.ColumnHiding = True
    OptionsCustomizing.ColumnsQuickCustomization = True
    OptionsData.Editing = False
    OptionsData.Deleting = False
    OptionsView.HeaderAutoHeight = True
    OptionsView.Indicator = True
    RootValue = -1
    Styles.StyleSheet = dmMain.cxTreeListStyleSheet
    TabOrder = 4
    object Name: TcxDBTreeListColumn
      Caption.Text = #1053#1072#1079#1074#1072#1085#1080#1077
      DataBinding.FieldName = 'Name'
      Width = 142
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object Code: TcxDBTreeListColumn
      Caption.Text = #1050#1086#1076
      DataBinding.FieldName = 'Code'
      Width = 63
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object TradeMarkName: TcxDBTreeListColumn
      Caption.Text = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
      DataBinding.FieldName = 'TradeMarkName'
      Width = 126
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object GoodsTagName: TcxDBTreeListColumn
      Caption.Text = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072
      DataBinding.FieldName = 'GoodsTagName'
      Width = 87
      Position.ColIndex = 3
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object GoodsGroupAnalystName: TcxDBTreeListColumn
      Caption.Text = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074' ('#1072#1085#1072#1083#1080#1090#1080#1082#1072')'
      DataBinding.FieldName = 'GoodsGroupAnalystName'
      Width = 88
      Position.ColIndex = 4
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object GoodsPlatformName: TcxDBTreeListColumn
      Caption.Text = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' '#1087#1083#1086#1097#1072#1076#1082#1072
      DataBinding.FieldName = 'GoodsPlatformName'
      Width = 86
      Position.ColIndex = 5
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object InfoMoneyName: TcxDBTreeListColumn
      Caption.Text = #1059#1055' '#1089#1090#1072#1090#1100#1103
      DataBinding.FieldName = 'InfoMoneyName'
      Width = 87
      Position.ColIndex = 6
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object isAsset: TcxDBTreeListColumn
      Caption.Text = #1055#1088#1080#1079#1085#1072#1082' - '#1054#1057
      DataBinding.FieldName = 'isAsset'
      Width = 90
      Position.ColIndex = 8
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object isErased: TcxDBTreeListColumn
      PropertiesClassName = 'TcxCheckBoxProperties'
      Caption.Text = #1059#1076#1072#1083#1077#1085
      DataBinding.FieldName = 'isErased'
      Width = 35
      Position.ColIndex = 7
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 64
    Top = 96
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 144
    Top = 176
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
    Left = 232
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
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
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
      ImageIndex = 4
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object dxBarStatic1: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 280
    Top = 208
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
      ShortCut = 116
      RefreshOnTabSetChanges = False
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
          Name = 'TradeMarkId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'TradeMarkId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TradeMarkName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'TradeMarkName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsTagId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsTagId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsTagName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsTagName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupAnalystId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsGroupAnalystId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupAnalystName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsGroupAnalystName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsPlatformId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsPlatformId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsPlatformName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsPlatformName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = DataSource
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
    Left = 200
    Top = 232
  end
  object dsdDBTreeAddOn: TdsdDBTreeAddOn
    ErasedFieldName = 'isErased'
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    DBTreeList = cxDBTreeList
    Left = 72
    Top = 240
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 304
    Top = 152
  end
end
