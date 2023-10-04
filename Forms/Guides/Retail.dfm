object RetailForm: TRetailForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100'>'
  ClientHeight = 390
  ClientWidth = 695
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
    Width = 695
    Height = 364
    Align = alClient
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
      OptionsData.Inserting = False
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 44
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 129
      end
      object OKPO: TcxGridDBColumn
        Caption = #1054#1050#1055#1054
        DataBinding.FieldName = 'OKPO'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1050#1055#1054' '#1076#1083#1103' '#1085#1072#1083#1086#1075'. '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
        Width = 102
      end
      object GLNCode: TcxGridDBColumn
        Caption = #1050#1086#1076' GLN '#1055#1086#1083#1091#1095#1072#1090#1077#1083#1100
        DataBinding.FieldName = 'GLNCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 102
      end
      object GLNCodeCorporate: TcxGridDBColumn
        Caption = #1050#1086#1076' GLN '#1055#1086#1089#1090#1072#1074#1097#1080#1082' '
        DataBinding.FieldName = 'GLNCodeCorporate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 103
      end
      object GoodsPropertyName: TcxGridDBColumn
        Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsPropertyName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceGoodsProperty
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 105
      end
      object PersonalMarketingName: TcxGridDBColumn
        Caption = #1054#1090#1074'.'#1089#1086#1090#1088#1091#1076#1085#1080#1082' '#1084#1072#1088#1082#1077#1090'. '#1086#1090#1076#1077#1083#1072
        DataBinding.FieldName = 'PersonalMarketingName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoicePersonalMarketing
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object PersonalTradeName: TcxGridDBColumn
        Caption = #1054#1090#1074'.'#1089#1086#1090#1088#1091#1076#1085#1080#1082' '#1082#1086#1084#1084#1077#1088#1095'. '#1086#1090#1076#1077#1083#1072
        DataBinding.FieldName = 'PersonalTradeName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoicePersonalTrade
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 113
      end
      object OperDateOrder: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1087#1086' '#1076#1072#1090#1077' '#1079#1072#1103#1074#1082#1080
        DataBinding.FieldName = 'OperDateOrder'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 79
      end
      object ClientKindName: TcxGridDBColumn
        Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081
        DataBinding.FieldName = 'ClientKindName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object RoundWeight: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1085'. '#1086#1082#1088'. '#1074#1077#1089#1072
        DataBinding.FieldName = 'RoundWeight'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1079#1085#1072#1082#1086#1074' '#1076#1083#1103' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1103' '#1074#1077#1089#1072
        Options.Editing = False
        Width = 70
      end
      object isOrderMin: TcxGridDBColumn
        Caption = #1056#1072#1079#1088#1077#1096#1077#1085' '#1084#1080#1085'. '#1079#1072#1082#1072#1079
        DataBinding.FieldName = 'isOrderMin'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1056#1072#1079#1088#1077#1096#1077#1085' '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1079#1072#1082#1072#1079' < 5 '#1082#1075'.'
        Options.Editing = False
        Width = 86
      end
      object isWMS: TcxGridDBColumn
        Caption = #1054#1090#1087'. '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' '#1042#1052#1057
        DataBinding.FieldName = 'isWMS'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1090#1087#1088#1072#1074#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' '#1042#1052#1057
        Options.Editing = False
        Width = 86
      end
      object StickerHeaderName: TcxGridDBColumn
        Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082' '#1076#1083#1103' '#1089#1077#1090#1080
        DataBinding.FieldName = 'StickerHeaderName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1047#1072#1075#1086#1083#1086#1074#1086#1082' '#1076#1083#1103' '#1089#1077#1090#1080' ('#1087#1077#1095#1072#1090#1100' '#1101#1090#1080#1082#1077#1090#1082#1080')'
        Options.Editing = False
        Width = 90
      end
      object isErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 68
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
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
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_ClientKind_Retai'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_ClientKind_Null'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_IsOrderMin'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isWMS'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_StickerHeader'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbRefresh'
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
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbChoice'
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
    end
    object bbChoice: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbUpdate_ClientKind_Retai: TdxBarButton
      Action = macUpdate_ClientKind_Retai
      Category = 0
    end
    object bbUpdate_ClientKind_Null: TdxBarButton
      Action = macUpdate_ClientKind_Null
      Category = 0
    end
    object bbUpdate_IsOrderMin: TdxBarButton
      Action = actUpdate_IsOrderMin
      Category = 0
    end
    object bbUpdate_isWMS: TdxBarButton
      Action = actUpdate_isWMS
      Category = 0
    end
    object bbUpdate_StickerHeader: TdxBarButton
      Action = macUpdate_StickerHeader
      Category = 0
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
      FormName = 'TRetailEditForm'
      FormNameParam.Value = 'TRetailEditForm'
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
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TRetailEditForm'
      FormNameParam.Value = 'TRetailEditForm'
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
          Name = 'PartnerId'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsPropertyId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsPropertyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsPropertyName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsPropertyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OrderExternalId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'OrderExternalInvNumber'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = DataSource
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateGLNCode
      StoredProcList = <
        item
          StoredProc = spUpdateGLNCode
        end>
      Caption = 'actUpdateDataSet'
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
    object actChoicePersonalTrade: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoicePersonalTrade'
      FormName = 'TPersonal_ObjectForm'
      FormNameParam.Value = 'TPersonal_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PersonalTradeId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PersonalTradeName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoicePersonalMarketing: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoicePersonalMarketing'
      FormName = 'TPersonal_ObjectForm'
      FormNameParam.Value = 'TPersonal_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PersonalMarketingId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PersonalMarketingName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceGoodsProperty: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceGoodsProperty'
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
    object actUpdate_ClientKind_Null: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_ClientKind_Null
      StoredProcList = <
        item
          StoredProc = spUpdate_ClientKind_Null
        end>
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1091' '#1074#1089#1077#1093' '#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1087#1086#1082#1091#1087'.'
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1091' '#1074#1089#1077#1093' '#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1087#1086#1082#1091#1087'.'
      ImageIndex = 58
    end
    object actUpdate_ClientKind_Retail: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_ClientKind_Retail
      StoredProcList = <
        item
          StoredProc = spUpdate_ClientKind_Retail
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1089#1077#1084' '#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1087#1086#1082#1091#1087'. - '#1057#1077#1090#1077#1074#1080#1082
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1089#1077#1084' '#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1087#1086#1082#1091#1087'. - '#1057#1077#1090#1077#1074#1080#1082
      ImageIndex = 77
    end
    object macUpdate_ClientKind_Retai: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_ClientKind_Retail_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1089#1077#1084' '#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1087#1086#1082#1091#1087'. - '#1057#1077#1090#1077#1074#1080#1082'?'
      InfoAfterExecute = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' '#1057#1077#1090#1077#1074#1080#1082' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1072
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1089#1077#1084' '#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1087#1086#1082#1091#1087'. - '#1057#1077#1090#1077#1074#1080#1082
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1089#1077#1084' '#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1087#1086#1082#1091#1087'. - '#1057#1077#1090#1077#1074#1080#1082
      ImageIndex = 77
    end
    object macUpdate_ClientKind_Retail_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_ClientKind_Retail
        end>
      View = cxGridDBTableView
      Caption = 'macUpdate_ClientKind_Null_List'
      ImageIndex = 77
    end
    object macUpdate_ClientKind_Null: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_ClientKind_Null_List
        end
        item
          Action = actRefresh
        end>
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1091' '#1074#1089#1077#1093' '#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1087#1086#1082#1091#1087'.'
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1091' '#1074#1089#1077#1093' '#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1087#1086#1082#1091#1087'.'
      ImageIndex = 58
    end
    object macUpdate_ClientKind_Null_List: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_ClientKind_Null
        end>
      View = cxGridDBTableView
      Caption = 'macUpdate_ClientKind_Null_List'
      ImageIndex = 58
    end
    object actUpdate_isWMS: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isWMS
      StoredProcList = <
        item
          StoredProc = spUpdate_isWMS
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1087#1088#1072#1074#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' '#1042#1052#1057' '#1044#1072'/'#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1087#1088#1072#1074#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' '#1042#1052#1057' '#1044#1072'/'#1053#1077#1090
      ImageIndex = 52
    end
    object actUpdate_IsOrderMin: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_IsOrderMin
      StoredProcList = <
        item
          StoredProc = spUpdate_IsOrderMin
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1056#1072#1079#1088#1077#1096#1077#1085' '#1084#1080#1085'. '#1079#1072#1082#1072#1079' '#1044#1072'/'#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1056#1072#1079#1088#1077#1096#1077#1085' '#1084#1080#1085'. '#1079#1072#1082#1072#1079' '#1044#1072'/'#1053#1077#1090
      ImageIndex = 76
    end
    object macUpdate_StickerHeader: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenChoiceStickerHeader
        end
        item
          Action = actUpdate_StickerHeader
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1047#1072#1075#1086#1083#1086#1074#1086#1082' '#1076#1083#1103' '#1089#1077#1090#1080'>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1047#1072#1075#1086#1083#1086#1074#1086#1082' '#1076#1083#1103' '#1089#1077#1090#1080'>'
      ImageIndex = 39
    end
    object actOpenChoiceStickerHeader: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenChoiceStickerHeader'
      FormName = 'TStickerHeaderForm'
      FormNameParam.Value = 'TStickerHeaderForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'StickerHeaderId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = FormParams
          ComponentItem = 'StickerHeaderName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdate_StickerHeader: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      StoredProc = spUpdate_StickerHeader
      StoredProcList = <
        item
          StoredProc = spUpdate_StickerHeader
        end>
      Caption = 'actUpdate_StickerHeader'
      ImageIndex = 39
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Retail'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
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
    Left = 296
    Top = 216
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 176
    Top = 256
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
  object spUpdateGLNCode: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Retail_GLNCode'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGLNCode'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GLNCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGLNCodeCorporate'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GLNCodeCorporate'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOKPO'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'OKPO'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsPropertyId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsPropertyId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalMarketingId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PersonalMarketingId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalTradeId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PersonalTradeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 464
    Top = 80
  end
  object spUpdate_ClientKind_Retail: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Retail_ClientKind'
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
        Name = 'inClientKindId'
        Value = '3651651'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 600
    Top = 112
  end
  object spUpdate_ClientKind_Null: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Retail_ClientKind'
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
        Name = 'inClientKindId'
        Value = 'Null'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 600
    Top = 176
  end
  object spUpdate_IsOrderMin: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Retail_IsOrderMin'
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
        Name = 'inIsOrderMin'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'IsOrderMin'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsOrderMin'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'IsOrderMin'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 464
    Top = 184
  end
  object spUpdate_isWMS: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Retail_isWMS'
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
        Name = 'inisWMS'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isWMS'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisWMS'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isWMS'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 424
    Top = 248
  end
  object spUpdate_StickerHeader: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Retail_StickerHeader'
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
        Name = 'inStickerHeaderId'
        Value = Null
        Component = FormParams
        ComponentItem = 'StickerHeaderId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStickerHeaderName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'StickerHeaderName'
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 528
    Top = 248
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StickerHeaderId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 152
  end
end
