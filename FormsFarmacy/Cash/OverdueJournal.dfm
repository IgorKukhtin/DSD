object OverdueJournalForm: TOverdueJournalForm
  Left = 0
  Top = 0
  Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1088#1086#1082#1072' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1093' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1086#1074' Ctrl+S - '#1050#1072#1090#1077#1075#1086#1088#1080#1103' 4'
  ClientHeight = 407
  ClientWidth = 707
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
    Left = 0
    Top = 26
    Width = 707
    Height = 381
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
      DataController.Summary.FooterSummaryItems = <
        item
          Kind = skSum
          Column = Amount
          DisplayText = ',0.###'
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = GoodsName
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object ORD: TcxGridDBColumn
        Caption = #8470' '#1087'/'#1087
        DataBinding.FieldName = 'ORD'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 48
      end
      object Cat_5: TcxGridDBColumn
        Caption = '5 '#1082#1072#1090'.'
        DataBinding.FieldName = 'Cat_5'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 50
      end
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1072
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 192
      end
      object Amount: TcxGridDBColumn
        Caption = #1054#1089#1090#1072#1090#1086#1082
        DataBinding.FieldName = 'Amount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.###'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 76
      end
      object Price: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1086#1090#1087#1091#1089#1082#1085#1072#1103' '#1087#1086' '#1087#1088#1072#1081#1089#1091
        DataBinding.FieldName = 'Price'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 78
      end
      object ExpirationDate: TcxGridDBColumn
        Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
        DataBinding.FieldName = 'ExpirationDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 93
      end
      object BranchDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076#1072
        DataBinding.FieldName = 'BranchDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 86
      end
      object Invnumber: TcxGridDBColumn
        Caption = #1055#1088#1080#1093#1086#1076
        DataBinding.FieldName = 'Invnumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 89
      end
      object FromName: TcxGridDBColumn
        Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
        DataBinding.FieldName = 'FromName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 173
      end
      object ContractName: TcxGridDBColumn
        Caption = #1044#1086#1075#1086#1074#1086#1088
        DataBinding.FieldName = 'ContractName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 172
      end
      object DatePartionGoodsCat5: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1087#1077#1088#1077#1074#1086#1076#1072' '#1074' 5 '#1082#1072#1090#1077#1075#1086#1088#1080#1102
        DataBinding.FieldName = 'DatePartionGoodsCat5'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 127
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 48
    Top = 104
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 160
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
    Left = 312
    Top = 104
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
    Left = 168
    Top = 104
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
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSendPartionDateChange'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
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
      Visible = ivAlways
      ImageIndex = 0
      ShortCut = 45
    end
    object bbEdit: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      ShortCut = 115
    end
    object bbErased: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 2
      ShortCut = 46
    end
    object bbUnErased: TdxBarButton
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 8
      ShortCut = 32776
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
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Category = 0
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Visible = ivAlways
      ImageIndex = 7
    end
    object bbProtocolOpenForm: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Visible = ivAlways
      ImageIndex = 34
    end
    object dxBarButton1: TdxBarButton
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Category = 0
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Visible = ivAlways
      ImageIndex = 63
    end
    object dxBarButton2: TdxBarButton
      Action = actOverdue
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actUpdate_Cat_5
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actUpdateRangeCat5
      Category = 0
    end
    object bbSendPartionDateChange: TdxBarButton
      Action = actSendPartionDateChange
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
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actOverdue: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecuteOverdueDialog
        end
        item
          Action = actTransfer_SendPartionDate
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1087#1072#1088#1090#1080#1080
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1087#1072#1088#1090#1080#1080
      ImageIndex = 35
    end
    object actExecuteOverdueDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteOverdueDialog'
      FormName = 'TOverdueDialogForm'
      FormNameParam.Value = 'TOverdueDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Amount'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'AmountDialog'
          DataType = ftFloat
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 'NULL'
          Component = ClientDataSet
          ComponentItem = 'ExpirationDateDialog'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actTransfer_SendPartionDate: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spTransfer_SendPartionDate
      StoredProcList = <
        item
          StoredProc = spTransfer_SendPartionDate
        end>
      Caption = 'actTransfer_SendPartionDate'
    end
    object actUpdate_Cat_5: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Cat_5
      StoredProcList = <
        item
          StoredProc = spUpdate_Cat_5
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' 5 '#1082#1072#1090' ('#1087#1088#1086#1089#1088#1086#1095#1082#1072' '#1073#1077#1079' '#1085#1072#1094#1077#1085#1082#1080')'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' 5 '#1082#1072#1090' ('#1087#1088#1086#1089#1088#1086#1095#1082#1072' '#1073#1077#1079' '#1085#1072#1094#1077#1085#1082#1080')'
      ImageIndex = 12
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' 5 '#1082#1072#1090' ('#1087#1088#1086#1089#1088#1086#1095#1082#1072' '#1073#1077#1079' '#1085#1072#1094#1077#1085#1082#1080') ?'
    end
    object actUpdateRangeCat5: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecuteDialogUpdateRangeCat5
        end
        item
          Action = actExecUpdateRangeCat5
        end
        item
          Action = actRefresh
        end>
      Caption = #1055#1077#1088#1077#1074#1086#1076' '#1090#1086#1074#1072#1088#1072' '#1074' 5 '#1082#1072#1090#1077#1075#1086#1088#1080#1102' '#1087#1086' '#1094#1077#1085#1077
      Hint = #1055#1077#1088#1077#1074#1086#1076' '#1090#1086#1074#1072#1088#1072' '#1074' 5 '#1082#1072#1090#1077#1075#1086#1088#1080#1102' '#1087#1086' '#1094#1077#1085#1077
      ImageIndex = 38
    end
    object actExecuteDialogUpdateRangeCat5: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDialogUpdateRangeCat5'
      FormName = 'TOverdue_UpdateRangeCat5DialogForm'
      FormNameParam.Value = 'TOverdue_UpdateRangeCat5DialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'PriceMax'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'PriceMax'
          DataType = ftFloat
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceMin'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'PriceMin'
          DataType = ftFloat
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actExecUpdateRangeCat5: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateRangeCat5
      StoredProcList = <
        item
          StoredProc = spUpdateRangeCat5
        end>
      Caption = 'actExecUpdateRangeCat5'
    end
    object actSendPartionDateChange: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecuteOverdueDialog
        end
        item
          Action = actTransfer_SendPartionDateChange
        end
        item
          Action = actRefresh
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1079#1072#1103#1074#1082#1091' '#1085#1072' '#1080#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1087#1072#1088#1090#1080#1102
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1079#1072#1103#1074#1082#1091' '#1085#1072' '#1080#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1087#1072#1088#1090#1080#1102
      ImageIndex = 30
    end
    object actTransfer_SendPartionDateChange: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spTransfer_SendPartionDateChange
      StoredProcList = <
        item
          StoredProc = spTransfer_SendPartionDateChange
        end>
      Caption = 'actTransfer_SendPartionDateChange'
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Cash_Overdue'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 48
    Top = 224
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 168
    Top = 160
  end
  object spTransfer_SendPartionDate: TdsdStoredProc
    StoredProcName = 'gpInsert_MovementTransfer_SendPartionDate'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inContainerID'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inExpirationDate'
        Value = 'NULL'
        Component = ClientDataSet
        ComponentItem = 'ExpirationDateDialog'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'AmountDialog'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 312
    Top = 232
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
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    PropertiesCellList = <>
    Left = 168
    Top = 224
  end
  object spUpdate_Cat_5: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_PartionGoods_Cat_5'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inPartionGoodsId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PartionGoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCat_5'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Cat_5'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCat_5'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Cat_5'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 472
    Top = 160
  end
  object spUpdateRangeCat5: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Range_Cat_5'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inPriceMin'
        Value = Null
        Component = FormParams
        ComponentItem = 'PriceMin'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceMax'
        Value = Null
        Component = FormParams
        ComponentItem = 'PriceMax'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 472
    Top = 232
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'PriceMax'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceMin'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 470
    Top = 97
  end
  object spTransfer_SendPartionDateChange: TdsdStoredProc
    StoredProcName = 'gpInsert_MovementTransfer_SendPartionDateChange'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inContainerID'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inExpirationDate'
        Value = 'NULL'
        Component = ClientDataSet
        ComponentItem = 'ExpirationDateDialog'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'AmountDialog'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 312
    Top = 296
  end
end
