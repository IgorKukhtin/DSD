object BarCodeBoxForm: TBarCodeBoxForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1064'/'#1050' '#1076#1083#1103' '#1103#1097#1080#1082#1086#1074
  ClientHeight = 376
  ClientWidth = 828
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
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 828
    Height = 350
    Align = alClient
    TabOrder = 0
    LookAndFeel.NativeStyle = True
    LookAndFeel.SkinName = 'UserSkin'
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1057#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = BarCode
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taRightJustify
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 49
      end
      object BarCode: TcxGridDBColumn
        Caption = #1064#1090#1088#1080#1093#1082#1086#1076
        DataBinding.FieldName = 'BarCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 110
      end
      object BoxCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1103#1097'.'
        DataBinding.FieldName = 'BoxCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 58
      end
      object BarCode_Value: TcxGridDBColumn
        Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1074' '#1064'/'#1050
        DataBinding.FieldName = 'BarCode_Value'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 91
      end
      object BoxName: TcxGridDBColumn
        Caption = #1071#1097#1080#1082
        DataBinding.FieldName = 'BoxName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 110
      end
      object Weight: TcxGridDBColumn
        Caption = #1058#1086#1095#1085#1099#1081' '#1074#1077#1089' '#1103#1097#1080#1082#1072
        DataBinding.FieldName = 'Weight'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 91
      end
      object AmountPrint: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1087#1077#1095'.'
        DataBinding.FieldName = 'AmountPrint'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080' '#1064'/'#1050
        Width = 37
      end
      object clErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 78
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
    Left = 368
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
    Left = 264
    Top = 80
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
          BeginGroup = True
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
          ItemName = 'bbInsert_BarCodeBox'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsert_Object_PrintGrid'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbBarCodeBox_onlyPrint'
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
      Caption = '       '
      Category = 0
      Hint = '       '
      Visible = ivAlways
    end
    object bbChoice: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbInsert_BarCodeBox: TdxBarButton
      Action = macInsert_BarCodeBox
      Category = 0
    end
    object bbProtocol: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbPrint2: TdxBarButton
      Action = actPrint_2
      Category = 0
    end
    object bbInsert_Object_PrintGrid: TdxBarButton
      Action = macInsert_Object_PrintGrid
      Category = 0
    end
    object bbBarCodeBox_onlyPrint: TdxBarButton
      Action = macBarCodeBox_onlyPrint
      Caption = #1055#1077#1095#1072#1090#1100' '#1085#1086#1074#1099#1093' '#1096'/'#1082
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 304
    Top = 112
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
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TBarCodeBoxEditForm'
      FormNameParam.Value = 'TBarCodeBoxEditForm'
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
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TBarCodeBoxEditForm'
      FormNameParam.Value = 'TBarCodeBoxEditForm'
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
    object ExecuteBarCodePrintDialog: TExecuteDialog
      Category = 'OnlyPrint'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1053#1072#1087#1077#1095#1072#1090#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1096'/'#1082
      Hint = #1053#1072#1087#1077#1095#1072#1090#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1096'/'#1082
      ImageIndex = 23
      FormName = 'TBarCodeBoxPrintDialogForm'
      FormNameParam.Value = 'TBarCodeBoxPrintDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inBarCode1'
          Value = '0'
          Component = FormParams
          ComponentItem = 'inBarCode1'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inAmount'
          Value = '0'
          Component = FormParams
          ComponentItem = 'inAmount'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
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
          ComponentItem = 'BarCode'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Code'
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
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = actUpdate_Print
      StoredProcList = <
        item
          StoredProc = actUpdate_Print
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
    end
    object actDelete_Object_Print: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_Object_Print
      StoredProcList = <
        item
          StoredProc = spDelete_Object_Print
        end>
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1074#1088'. '#1090#1072#1073#1083#1080#1094#1091
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1074#1088'. '#1090#1072#1073#1083#1080#1094#1091
      ImageIndex = 23
    end
    object actInsert_Object_Print: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_Object_Print
      StoredProcList = <
        item
          StoredProc = spInsert_Object_Print
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1096'/'#1082' '#1074#1086' '#1074#1088#1077#1084' '#1090#1072#1073#1083#1080#1094#1091
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1096'/'#1082' '#1074#1086' '#1074#1088#1077#1084' '#1090#1072#1073#1083#1080#1094#1091
      ImageIndex = 23
    end
    object actBarCodeBox_onlyPrint: TdsdExecStoredProc
      Category = 'OnlyPrint'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spBarCodeBox_onlyPrint
      StoredProcList = <
        item
          StoredProc = spBarCodeBox_onlyPrint
        end>
      Caption = #1053#1072#1087#1077#1095#1072#1090#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1096'/'#1082
      Hint = #1053#1072#1087#1077#1095#1072#1090#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1096'/'#1082
      ImageIndex = 23
    end
    object actInsert_BarCodeBox: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_BarCodeBox
      StoredProcList = <
        item
          StoredProc = spInsert_BarCodeBox
        end>
      Caption = 'C'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1096'/'#1082
      Hint = 'C'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1096'/'#1082
      ImageIndex = 50
    end
    object macBarCodeBox_onlyPrint: TMultiAction
      Category = 'OnlyPrint'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteBarCodePrintDialog
        end
        item
          Action = actOnlyPrint
        end
        item
          Action = actRefresh
        end>
      Caption = #1053#1072#1087#1077#1095#1072#1090#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1096'/'#1082
      Hint = #1053#1072#1087#1077#1095#1072#1090#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1096'/'#1082
      ImageIndex = 23
    end
    object ExecuteBarCodeBoxDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = 'C'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1096'/'#1082
      Hint = 'C'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1096'/'#1082
      ImageIndex = 50
      FormName = 'TBarCodeBoxDialogForm'
      FormNameParam.Value = 'TBarCodeBoxDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inBarCodePref'
          Value = Null
          Component = FormParams
          ComponentItem = 'inBarCodePref'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBarCode1'
          Value = '0'
          Component = FormParams
          ComponentItem = 'inBarCode1'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBarCode2'
          Value = '0'
          Component = FormParams
          ComponentItem = 'inBarCode2'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBoxId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'inBoxId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBoxName'
          Value = Null
          Component = FormParams
          ComponentItem = 'inBoxName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BoxName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BoxName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BoxId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BoxId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macInsert_BarCodeBox: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteBarCodeBoxDialog
        end
        item
          Action = actInsert_BarCodeBox
        end
        item
          Action = actRefresh
        end>
      Caption = 'C'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1096'/'#1082
      Hint = 'C'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1096'/'#1082
      ImageIndex = 50
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
          ComponentItem = 'BarCode'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrint_Grid: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrintByGrid
      StoredProcList = <
        item
          StoredProc = spSelectPrintByGrid
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1096'/'#1082' '#1103#1097#1080#1082#1086#1074' ('#1082#1086#1083'-'#1074#1086' '#1087#1077#1095')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1096'/'#1082' '#1103#1097#1080#1082#1086#1074
      ImageIndex = 21
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <>
      ReportName = 'Print_Object_BarCodeBox'
      ReportNameParam.Value = 'Print_Object_BarCodeBox'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_2: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1096'/'#1082' '#1103#1097#1080#1082#1086#1074' ('#1082#1086#1083'-'#1074#1086' '#1087#1077#1095')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1096'/'#1082' '#1103#1097#1080#1082#1086#1074
      ImageIndex = 21
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <>
      ReportName = 'Print_Object_BarCodeBox'
      ReportNameParam.Value = 'Print_Object_BarCodeBox'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1096'/'#1082' '#1103#1097#1080#1082#1086#1074' (1 '#1101#1082#1079#1077#1084#1087#1083#1103#1088')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1096'/'#1082' '#1103#1097#1080#1082#1086#1074' (1 '#1101#1082#1079#1077#1084#1087#1083#1103#1088')'
      ImageIndex = 22
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42186d
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42186d
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = 'Print_Object_BarCodeBox'
      ReportNameParam.Value = 'Print_Object_BarCodeBox'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actOnlyPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spBarCodeBox_onlyPrint
      StoredProcList = <
        item
          StoredProc = spBarCodeBox_onlyPrint
        end>
      Caption = #1053#1072#1087#1077#1095#1072#1090#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1096'/'#1082
      Hint = #1053#1072#1087#1077#1095#1072#1090#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1096'/'#1082
      ImageIndex = 23
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <>
      ReportName = 'Print_Object_BarCodeBox'
      ReportNameParam.Value = 'Print_Object_BarCodeBox'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macInsert_Object_Print_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsert_Object_Print
        end>
      View = cxGridDBTableView
      Caption = 'macInsert_Object_Print_list'
    end
    object macInsert_Object_PrintGrid: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actDelete_Object_Print
        end
        item
          Action = macInsert_Object_Print_list
        end
        item
          Action = actPrint_Grid
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1096'/'#1082' '#1103#1097#1080#1082#1086#1074' ('#1074#1099#1073#1088#1072#1085#1085#1099#1077')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1096'/'#1082' '#1103#1097#1080#1082#1086#1074' ('#1074#1099#1073#1088#1072#1085#1085#1099#1077')'
      ImageIndex = 15
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_BarCodeBox'
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
    Left = 144
    Top = 104
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
    Left = 40
    Top = 208
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 288
    Top = 200
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
    PropertiesCellList = <>
    Left = 136
    Top = 168
  end
  object actUpdate_Print: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_BarCodeBox_Print'
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
        Name = 'inAmountPrint'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'AmountPrint'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 456
    Top = 115
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 125
    Top = 226
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 564
    Top = 81
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 564
    Top = 134
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_BarCodeBox_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end>
    Params = <>
    PackSize = 1
    Left = 639
    Top = 240
  end
  object spInsert_BarCodeBox: TdsdStoredProc
    StoredProcName = 'gpInsert_Object_BarCodeBox'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inBoxId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inBoxId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCode1'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inBarCode1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCode2'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inBarCode2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCodePref'
        Value = Null
        Component = FormParams
        ComponentItem = 'inBarCodePref'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 464
    Top = 203
  end
  object spInsert_Object_Print: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Print'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = '0'
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = '0'
        Component = ClientDataSet
        ComponentItem = 'AmountPrint'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 448
    Top = 275
  end
  object spDelete_Object_Print: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_Print'
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 552
    Top = 227
  end
  object spSelectPrintByGrid: TdsdStoredProc
    StoredProcName = 'gpSelect_ObjectPrint_BarCodeBox_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end>
    Params = <>
    PackSize = 1
    Left = 639
    Top = 160
  end
  object spBarCodeBox_onlyPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_BarCodeBox_onlyPrint'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end>
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
        Name = 'inBarCode1'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inBarCode1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inAmount'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 304
    Top = 267
  end
end
