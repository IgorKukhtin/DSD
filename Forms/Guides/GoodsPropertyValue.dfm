object GoodsPropertyValueForm: TGoodsPropertyValueForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1047#1085#1072#1095#1077#1085#1080#1103' '#1076#1083#1103' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1086#1074'>'
  ClientHeight = 464
  ClientWidth = 986
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
    Width = 986
    Height = 438
    Align = alClient
    TabOrder = 4
    ExplicitWidth = 927
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clGoodsPropertyName: TcxGridDBColumn
        Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088
        DataBinding.FieldName = 'GoodsPropertyName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = GoodsPropertyChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object colCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object clGoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = GoodsChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object clGoodsKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsKindName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = GoodsKindChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object colMeasureName: TcxGridDBColumn
        Caption = #1045#1076'. '#1080#1079#1084'.'
        DataBinding.FieldName = 'MeasureName'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 30
      end
      object ceName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
        DataBinding.FieldName = 'Name'
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object ceAmount: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1096#1090#1091#1082' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077
        DataBinding.FieldName = 'Amount'
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object ceBarCode: TcxGridDBColumn
        Caption = #1064#1090#1088#1080#1093' '#1082#1086#1076
        DataBinding.FieldName = 'BarCode'
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object clArticle: TcxGridDBColumn
        Caption = #1040#1088#1090#1080#1082#1091#1083
        DataBinding.FieldName = 'Article'
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object clBarCodeGLN: TcxGridDBColumn
        Caption = #1064#1090#1088#1080#1093' '#1082#1086#1076' GLN'
        DataBinding.FieldName = 'BarCodeGLN'
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object clArticleGLN: TcxGridDBColumn
        Caption = #1040#1088#1090#1080#1082#1091#1083' GLN'
        DataBinding.FieldName = 'ArticleGLN'
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object ceisErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 40
    Top = 120
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 152
    Top = 192
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
    Left = 296
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
    Top = 112
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
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
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
    object bbGridToExel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
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
    Left = 232
    Top = 144
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
      RefreshOnTabSetChanges = False
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TGoodsPropertyValueEditForm'
      FormNameParam.Value = 'TGoodsPropertyValueEditForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
        end>
      isShowModal = False
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
      FormName = 'TGoodsPropertyValueEditForm'
      FormNameParam.Value = 'TGoodsPropertyValueEditForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
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
      StoredProcList = <>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DataSource
    end
    object GoodsPropertyChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'PriceListPromoChoiceForm'
      FormName = 'TGoodsPropertyForm'
      FormNameParam.Value = 'TGoodsPropertyForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = ClientDataSet
          ComponentItem = 'GoodsPropertyId'
        end
        item
          Name = 'TextValue'
          Component = ClientDataSet
          ComponentItem = 'GoodsPropertyName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object GoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'GoodsChoiceForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = ClientDataSet
          ComponentItem = 'GoodsId'
        end
        item
          Name = 'TextValue'
          Component = ClientDataSet
          ComponentItem = 'GoodsName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object GoodsKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'GoodsKindChoiceForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = 'TGoodsKindForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = ClientDataSet
          ComponentItem = 'GoodsKindId'
        end
        item
          Name = 'TextValue'
          Component = ClientDataSet
          ComponentItem = 'GoodsKindName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Component = ClientDataSet
          ComponentItem = 'Id'
          DataType = ftString
        end
        item
          Name = 'TextValue'
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = DataSource
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsPropertyValue'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    Left = 80
    Top = 216
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 424
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
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 464
    Top = 288
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 424
    Top = 152
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsPropertyValue'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inName'
        Component = ClientDataSet
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Component = ClientDataSet
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inBarCode'
        Component = ClientDataSet
        ComponentItem = 'BarCode'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inArticle'
        Component = ClientDataSet
        ComponentItem = 'Article'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inBarCodeGLN'
        Component = ClientDataSet
        ComponentItem = 'BarCodeGLN'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inArticleGLN'
        Component = ClientDataSet
        ComponentItem = 'ArticleGLN'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsPropertyId'
        Component = ClientDataSet
        ComponentItem = 'GoodsPropertyId'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Component = ClientDataSet
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Component = ClientDataSet
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
      end>
    Left = 112
    Top = 328
  end
end
