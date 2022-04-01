object Report_MovementPriceList_CrossForm: TReport_MovementPriceList_CrossForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1055#1088#1072#1081#1089#1072#1084
  ClientHeight = 334
  ClientWidth = 822
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
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object DataPanel: TPanel
    Left = 0
    Top = 0
    Width = 822
    Height = 89
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object edDateStart: TcxDateEdit
      Left = 7
      Top = 20
      EditValue = 42705d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 89
    end
    object cxLabel2: TcxLabel
      Left = 7
      Top = 2
      Caption = #1044#1072#1090#1072' '#1089' :'
    end
    object edJuridical1: TcxButtonEdit
      Left = 114
      Top = 20
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 0
      Width = 194
    end
    object cxLabel4: TcxLabel
      Left = 114
      Top = 2
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' 1'
    end
    object cxLabel3: TcxLabel
      Left = 523
      Top = 2
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' 3'
    end
    object edJuridical3: TcxButtonEdit
      Left = 523
      Top = 20
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 194
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 115
    Width = 822
    Height = 219
    Align = alClient
    TabOrder = 0
    object cxGridDBBandedTableView: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = MasterDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Options = [dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoGroupsAlwaysExpanded]
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.##'
          Kind = skSum
        end
        item
          Format = ',0.##'
          Kind = skSum
        end
        item
          Format = ',0.##'
          Kind = skSum
        end
        item
          Format = ',0.##'
          Kind = skSum
        end
        item
          Format = ',0.##'
          Kind = skSum
        end
        item
          Format = ',0.##'
          Kind = skSum
        end
        item
          Format = ',0.##'
          Kind = skSum
        end
        item
          Format = #1057#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = GoodsName
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.BandHiding = True
      OptionsCustomize.BandsQuickCustomization = True
      OptionsCustomize.ColumnVertSizing = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridBandedTableViewStyleSheet
      Styles.BandHeader = dmMain.cxHeaderStyle
      Bands = <
        item
          FixedKind = fkLeft
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
          Width = 208
        end
        item
          Caption = #1055#1077#1088#1080#1086#1076
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
          Visible = False
          VisibleForCustomization = False
          Width = 174
        end>
      object ObjectCode: TcxGridDBBandedColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'ObjectCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Options.Moving = False
        Width = 44
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object GoodsName: TcxGridDBBandedColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        MinWidth = 67
        Options.Editing = False
        Options.Moving = False
        Width = 145
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object Value1p: TcxGridDBBandedColumn
        Caption = #1055#1086#1089#1090' 1'
        DataBinding.FieldName = 'Value1p'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        MinWidth = 40
        VisibleForCustomization = False
        Width = 40
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object Value2p: TcxGridDBBandedColumn
        Caption = #1055#1086#1089#1090' 2'
        DataBinding.FieldName = 'Value2p'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        MinWidth = 40
        VisibleForCustomization = False
        Width = 40
        Position.BandIndex = 1
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object Value3p: TcxGridDBBandedColumn
        Caption = #1055#1086#1089#1090' 3'
        DataBinding.FieldName = 'Value3p'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        Visible = False
        VisibleForCustomization = False
        Width = 40
        Position.BandIndex = 1
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object isErased: TcxGridDBBandedColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        Visible = False
        Options.Editing = False
        Width = 50
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBBandedTableView
    end
  end
  object deEnd: TcxDateEdit
    Left = 7
    Top = 61
    EditValue = 42736d
    Properties.ShowTime = False
    TabOrder = 4
    Width = 90
  end
  object cxLabel7: TcxLabel
    Left = 7
    Top = 43
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxLabel1: TcxLabel
    Left = 319
    Top = 2
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' 2'
  end
  object edJuridical2: TcxButtonEdit
    Left = 319
    Top = 20
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 6
    Width = 194
  end
  object cxLabel5: TcxLabel
    Left = 114
    Top = 43
    Caption = #1044#1086#1075#1086#1074#1086#1088'  ('#1087#1086#1089#1090#1072#1074#1097#1080#1082' 1)'
  end
  object edContract1: TcxButtonEdit
    Left = 114
    Top = 61
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 8
    Width = 194
  end
  object cxLabel6: TcxLabel
    Left = 319
    Top = 43
    Caption = #1044#1086#1075#1086#1074#1086#1088'  ('#1087#1086#1089#1090#1072#1074#1097#1080#1082' 2)'
  end
  object edContract2: TcxButtonEdit
    Left = 319
    Top = 61
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 10
    Width = 194
  end
  object cxLabel8: TcxLabel
    Left = 523
    Top = 43
    Caption = #1044#1086#1075#1086#1074#1086#1088'  ('#1087#1086#1089#1090#1072#1074#1097#1080#1082' 3)'
  end
  object edContract3: TcxButtonEdit
    Left = 523
    Top = 61
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 15
    Width = 194
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'JuridicalId_1'
        Value = Null
        Component = GuidesJuridical1
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName_1'
        Value = Null
        Component = GuidesJuridical1
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId_2'
        Value = Null
        Component = GuidesJuridical2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName_2'
        Value = Null
        Component = GuidesJuridical2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId_3'
        Value = Null
        Component = GuidesJuridical3
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName_3'
        Value = Null
        Component = GuidesJuridical3
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId_1'
        Value = Null
        Component = GuidesContract1
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName_1'
        Value = Null
        Component = GuidesContract1
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId_2'
        Value = Null
        Component = GuidesContract2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName_2'
        Value = Null
        Component = GuidesContract2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId_3'
        Value = Null
        Component = GuidesContract3
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName_3'
        Value = Null
        Component = GuidesContract3
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 182
    Top = 159
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Movement_PriceList_cross'
    DataSet = HeaderCDS
    DataSets = <
      item
        DataSet = HeaderCDS
      end
      item
        DataSet = MasterCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 0d
        Component = edDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId_1'
        Value = ''
        Component = GuidesJuridical1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId_2'
        Value = ''
        Component = GuidesJuridical2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId_3'
        Value = ''
        Component = GuidesJuridical3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId_1'
        Value = ''
        Component = GuidesContract1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId_2'
        Value = ''
        Component = GuidesContract2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId_3'
        Value = ''
        Component = GuidesContract3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 167
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
    Left = 30
    Top = 119
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar: TdxBar
      AllowClose = False
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 409
      FloatTop = 390
      FloatClientWidth = 51
      FloatClientHeight = 93
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
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
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbGridToExel: TdxBarButton
      Action = GridToExcel
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = edDateStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = GuidesJuridical1
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesJuridical2
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesJuridical3
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesContract1
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesContract2
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesContract3
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 41
    Top = 192
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 75
    Top = 119
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDataset'
        end>
      Params = <
        item
          Name = 'InvNumber'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'From'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 0d
          Component = edDateStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1080#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = ''
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object GridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
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
      RefreshOnTabSetChanges = False
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_MovementPriceList_DialogForm'
      FormNameParam.Value = 'TReport_MovementPriceList_DialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = edDateStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId_1'
          Value = ''
          Component = GuidesJuridical1
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName_1'
          Value = ''
          Component = GuidesJuridical1
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId_2'
          Value = ''
          Component = GuidesJuridical2
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName_2'
          Value = ''
          Component = GuidesJuridical2
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId_3'
          Value = ''
          Component = GuidesJuridical3
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName_3'
          Value = ''
          Component = GuidesJuridical3
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId_1'
          Value = Null
          Component = GuidesContract1
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName_1'
          Value = Null
          Component = GuidesContract1
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId_2'
          Value = Null
          Component = GuidesContract2
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName_2'
          Value = Null
          Component = GuidesContract2
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId_3'
          Value = Null
          Component = GuidesContract3
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName_3'
          Value = Null
          Component = GuidesContract3
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1074#1072#1088#1099' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1074#1072#1088#1099' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 478
    Top = 231
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 400
    Top = 247
  end
  object GuidesJuridical1: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical1
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical1
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 240
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 552
    Top = 152
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <>
    Left = 632
    Top = 144
  end
  object GuidesJuridical2: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical2
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical2
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 448
    Top = 65528
  end
  object GuidesJuridical3: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical3
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical3
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical3
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 648
    Top = 8
  end
  object GuidesContract1: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract1
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContract1
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContract1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 264
    Top = 48
  end
  object GuidesContract3: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract3
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContract3
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContract3
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 664
    Top = 48
  end
  object GuidesContract2: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract2
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContract2
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContract2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 456
    Top = 48
  end
  object CrossDBViewReportAddOn: TCrossDBViewReportAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    MultiplyColumnList = <>
    TemplateColumnList = <
      item
        HeaderColumnName = 'ValueName1'
        TemplateColumn = Value1p
      end
      item
        HeaderColumnName = 'ValueName2'
        TemplateColumn = Value2p
      end
      item
        HeaderColumnName = 'ValueName3'
        TemplateColumn = Value3p
      end>
    HeaderDataSet = HeaderCDS
    BаndColumnName = 'ValueBandName'
    Left = 240
    Top = 232
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 134
    Top = 117
  end
end
