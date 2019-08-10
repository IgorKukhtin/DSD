object GoodsPropertyValueVMSForm: TGoodsPropertyValueVMSForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1047#1085#1072#1095#1077#1085#1080#1103' '#1076#1083#1103' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1086#1074' ('#1042#1052#1057')>'
  ClientHeight = 430
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
    Height = 404
    Align = alClient
    TabOrder = 1
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
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object GroupName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1075#1088#1091#1087#1087#1099
        DataBinding.FieldName = 'GroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
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
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object clisOrder: TcxGridDBColumn
        Caption = #1048#1089#1087#1086#1083#1100#1079'. '#1074' '#1079#1072#1103#1074#1082'.'
        DataBinding.FieldName = 'isOrder'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103' '#1074' '#1079#1072#1103#1074#1082#1072#1093
        Options.Editing = False
        Width = 70
      end
      object isWeigth: TcxGridDBColumn
        Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1074#1077#1089' '#1074' '#1087#1077#1095'. '#1085#1072#1082#1083'.'
        DataBinding.FieldName = 'isWeigth'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 110
      end
      object clGoodsGroupNameFull: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
        DataBinding.FieldName = 'GoodsGroupNameFull'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object clGoodsGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072
        DataBinding.FieldName = 'GoodsGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object CodeSticker: TcxGridDBColumn
        Caption = #1050#1086#1076' PLU'
        DataBinding.FieldName = 'CodeSticker'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object colCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
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
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object ceName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
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
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object colMeasureName: TcxGridDBColumn
        Caption = #1045#1076'. '#1080#1079#1084'.'
        DataBinding.FieldName = 'MeasureName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object ceAmount: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1096#1090'. '#1087#1088#1080' '#1089#1082#1072#1085'.'
        DataBinding.FieldName = 'Amount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object BoxCount: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1077#1076'. '#1074' '#1103#1097'.'
        DataBinding.FieldName = 'BoxCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1074' '#1103#1097#1080#1082#1077
        Options.Editing = False
        Width = 70
      end
      object ceAmountDoc: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1096#1090'. '#1074#1083#1086#1078'.'
        DataBinding.FieldName = 'AmountDoc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1096#1090'. '#1074#1083#1086#1078#1077#1085#1080#1077' - '#1087#1088#1086#1074#1077#1088#1082#1072' '#1074#1077#1089#1072' '#1103#1097#1080#1082#1072
        Options.Editing = False
        Width = 63
      end
      object BarCodeShort: TcxGridDBColumn
        Caption = #1064#1090#1088#1080#1093' '#1082#1086#1076' ('#1087#1086#1080#1089#1082')'
        DataBinding.FieldName = 'BarCodeShort'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object ceBarCode: TcxGridDBColumn
        Caption = #1064#1090#1088#1080#1093' '#1082#1086#1076
        DataBinding.FieldName = 'BarCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object clArticle: TcxGridDBColumn
        Caption = #1040#1088#1090#1080#1082#1091#1083
        DataBinding.FieldName = 'Article'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object clBarCodeGLN: TcxGridDBColumn
        Caption = #1064#1090#1088#1080#1093' '#1082#1086#1076' GLN'
        DataBinding.FieldName = 'BarCodeGLN'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object clArticleGLN: TcxGridDBColumn
        Caption = #1040#1088#1090#1080#1082#1091#1083' GLN'
        DataBinding.FieldName = 'ArticleGLN'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object GoodsBoxCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1075#1086#1092#1088'.'
        DataBinding.FieldName = 'GoodsBoxCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1076' '#1075#1086#1092#1088#1086#1103#1097#1080#1082
        Options.Editing = False
        Width = 45
      end
      object GoodsBoxName: TcxGridDBColumn
        Caption = #1043#1086#1092#1088#1086#1103#1097#1080#1082
        DataBinding.FieldName = 'GoodsBoxName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Caption = 'GoodsBoxChoiceForm'
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Quality: TcxGridDBColumn
        Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1043#1054#1057#1058', '#1044#1057#1058#1059','#1058#1059' ('#1050#1059')'
        DataBinding.FieldName = 'Quality'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 110
      end
      object Quality2: TcxGridDBColumn
        Caption = #1057#1090#1088#1086#1082' '#1087#1088#1080#1076#1072#1090#1085#1086#1089#1090#1110' ('#1050#1059')'
        DataBinding.FieldName = 'Quality2'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 110
      end
      object Quality10: TcxGridDBColumn
        Caption = #1059#1084#1086#1074#1080' '#1079#1073#1077#1088#1110#1075#1072#1085#1085#1103' ('#1050#1059')'
        DataBinding.FieldName = 'Quality10'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 110
      end
      object GoodsBrandName: TcxGridDBColumn
        Caption = #1041#1088#1077#1085#1076
        DataBinding.FieldName = 'GoodsBrandName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1041#1088#1077#1085#1076' '#1090#1086#1074#1072#1088#1072
        Options.Editing = False
        Width = 70
      end
      object isGoodsTypeKind_Sh: TcxGridDBColumn
        Caption = #1064#1090#1091#1095#1085#1099#1081
        DataBinding.FieldName = 'isGoodsTypeKind_Sh'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1090#1086#1074#1072#1088#1072' "'#1064#1090#1091#1095#1085#1099#1081'"'
        Width = 60
      end
      object isGoodsTypeKind_Nom: TcxGridDBColumn
        Caption = #1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081
        DataBinding.FieldName = 'isGoodsTypeKind_Nom'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1090#1086#1074#1072#1088#1072' "'#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081'"'
        Width = 60
      end
      object isGoodsTypeKind_Ves: TcxGridDBColumn
        Caption = #1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081
        DataBinding.FieldName = 'isGoodsTypeKind_Ves'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1090#1086#1074#1072#1088#1072' "'#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081'"'
        Width = 60
      end
      object BoxName: TcxGridDBColumn
        Caption = #1071#1097#1080#1082
        DataBinding.FieldName = 'BoxName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object WeightOnBox: TcxGridDBColumn
        Caption = #1082#1086#1083'. '#1082#1075'. '#1074' '#1103#1097'.'
        DataBinding.FieldName = 'WeightOnBox'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1082#1075'. '#1074' '#1103#1097'.'
        Options.Editing = False
        Width = 82
      end
      object CountOnBox: TcxGridDBColumn
        Caption = #1082#1086#1083'. '#1077#1076'. '#1074' '#1103#1097'.'
        DataBinding.FieldName = 'CountOnBox'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object isErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxLabel6: TcxLabel
    Left = 501
    Top = 126
    Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1086#1074':'
  end
  object ceGoodsProperty: TcxButtonEdit
    Left = 682
    Top = 125
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 6
    Width = 199
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
        Component = dsdGoodsPropertyGuides
        Properties.Strings = (
          'Key'
          'TextValue')
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
          ItemName = 'bbShowAll'
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
        end
        item
          Visible = True
          ItemName = 'bbBarCCItem1'
        end
        item
          Visible = True
          ItemName = 'bbBarCCItem2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbUpdateSh_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdateSh_No'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbUpdateNom_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdateNom_No'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbUpdateVes_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdateVes_No'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
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
          ItemName = 'bbProtocolOpenForm'
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
      ShowCaption = False
    end
    object bbBarCCItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel6
    end
    object bbBarCCItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = ceGoodsProperty
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbUpdateSh_Yes: TdxBarButton
      Action = macUpdateSh_Yes
      Category = 0
    end
    object bbUpdateSh_No: TdxBarButton
      Action = macUpdateSh_No
      Category = 0
    end
    object bbUpdateNom_Yes: TdxBarButton
      Action = macUpdateNom_Yes
      Category = 0
    end
    object bbUpdateNom_No: TdxBarButton
      Action = macUpdateNom_No
      Category = 0
    end
    object bbUpdateVes_Yes: TdxBarButton
      Action = macUpdateVes_Yes
      Category = 0
    end
    object bbUpdateVes_No: TdxBarButton
      Action = macUpdateVes_No
      Category = 0
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
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
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
    object GoodsPropertyChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PriceListPromoChoiceForm'
      FormName = 'TGoodsPropertyForm'
      FormNameParam.Value = 'TGoodsPropertyForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsPropertyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsPropertyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object GoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsChoiceForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object GoodsKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindChoiceForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = 'TGoodsKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
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
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = DataSource
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1090#1086#1074#1072#1088#1086#1074
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1090#1086#1074#1072#1088#1086#1074
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
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
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
    end
    object actUpdateSh_Yes: TdsdDataSetRefresh
      Category = 'UpdateDate'
      MoveParams = <>
      StoredProc = spUpdateSh_Yes
      StoredProcList = <
        item
          StoredProc = spUpdateSh_Yes
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 76
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object actUpdateSh_No: TdsdDataSetRefresh
      Category = 'UpdateDate'
      MoveParams = <>
      StoredProc = spUpdateSh_No
      StoredProcList = <
        item
          StoredProc = spUpdateSh_No
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 58
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object actUpdateNom_Yes: TdsdDataSetRefresh
      Category = 'UpdateDate'
      MoveParams = <>
      StoredProc = spUpdateNom_Yes
      StoredProcList = <
        item
          StoredProc = spUpdateNom_Yes
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 76
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object actUpdateNom_No: TdsdDataSetRefresh
      Category = 'UpdateDate'
      MoveParams = <>
      StoredProc = spUpdateNom_No
      StoredProcList = <
        item
          StoredProc = spUpdateNom_No
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 58
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object actUpdateVes_Yes: TdsdDataSetRefresh
      Category = 'UpdateDate'
      MoveParams = <>
      StoredProc = spUpdateVes_Yes
      StoredProcList = <
        item
          StoredProc = spUpdateVes_Yes
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 76
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object actUpdateVes_No: TdsdDataSetRefresh
      Category = 'UpdateDate'
      MoveParams = <>
      StoredProc = spUpdateVes_No
      StoredProcList = <
        item
          StoredProc = spUpdateVes_No
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 58
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macListUpdateSh_Yes: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateSh_Yes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 76
    end
    object macListUpdateSh_No: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateSh_No
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 58
    end
    object macListUpdateNom_Yes: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateNom_Yes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 76
    end
    object macListUpdateNom_No: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateNom_No
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 58
    end
    object macListUpdateVes_Yes: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateVes_Yes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 76
    end
    object macListUpdateVes_No: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateVes_No
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 58
    end
    object macUpdateSh_Yes: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = macListUpdateSh_Yes
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093'?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 76
    end
    object macUpdateSh_No: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = macListUpdateSh_No
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093'?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 58
    end
    object macUpdateNom_Yes: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = macListUpdateNom_Yes
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093'?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 76
    end
    object macUpdateNom_No: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = macListUpdateNom_No
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093'?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 58
    end
    object macUpdateVes_Yes: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = macListUpdateVes_Yes
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093'?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 76
    end
    object macUpdateVes_No: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = macListUpdateVes_No
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093'?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 58
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsPropertyValue'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inGoodsPropertyId'
        Value = Null
        Component = dsdGoodsPropertyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
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
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
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
    StoredProcName = 'gpUpdate_Object_GoodsPropertyValue_VMS'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsTypeKind_Sh'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isGoodsTypeKind_Sh'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsTypeKind_Nom'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isGoodsTypeKind_Nom'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsTypeKind_Ves'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isGoodsTypeKind_Ves'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 112
    Top = 328
  end
  object dsdGoodsPropertyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsProperty
    FormNameParam.Value = 'TGoodsPropertyForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsPropertyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdGoodsPropertyGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdGoodsPropertyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 760
    Top = 115
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = dsdGoodsPropertyGuides
      end
      item
        Component = actShowAll
      end>
    Left = 528
    Top = 152
  end
  object spUpdateSh_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsPropertyValue_Sh'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsTypeKind'
        Value = 'TRUE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 640
    Top = 192
  end
  object spUpdateSh_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsPropertyValue_Sh'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsTypeKind_Sh'
        Value = 'FALSE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 736
    Top = 240
  end
  object spUpdateNom_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsPropertyValue_Nom'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsTypeKind_Nom'
        Value = 'TRUE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 288
  end
  object spUpdateNom_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsPropertyValue_Nom'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsTypeKind_Nom'
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 728
    Top = 296
  end
  object spUpdateVes_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsPropertyValue_Ves'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsTypeKind_Ves'
        Value = 'TRUE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    AutoWidth = True
    Left = 648
    Top = 336
  end
  object spUpdateVes_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsPropertyValue_Ves'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsTypeKind_Ves'
        Value = 'FALSE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    AutoWidth = True
    Left = 720
    Top = 344
  end
end
