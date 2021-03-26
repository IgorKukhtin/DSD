object Report_FinalSUAProtocolForm: TReport_FinalSUAProtocolForm
  Left = 0
  Top = 0
  Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1081' '#1087#1086' '#1057#1059#1040
  ClientHeight = 486
  ClientWidth = 1032
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
    Width = 1032
    Height = 30
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 817
    object edDateStart: TcxDateEdit
      Left = 60
      Top = 6
      EditValue = 43831d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 89
    end
    object cxLabel2: TcxLabel
      Left = 7
      Top = 7
      Caption = #1044#1072#1090#1072' '#1089' :'
    end
  end
  object deEnd: TcxDateEdit
    Left = 226
    Top = 8
    EditValue = 43831d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object cxLabel7: TcxLabel
    Left = 172
    Top = 8
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 56
    Width = 1032
    Height = 209
    Align = alTop
    TabOrder = 3
    ExplicitWidth = 817
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = MasterDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <
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
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = UserName
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
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsBehavior.FocusCellOnCycle = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.DataRowSizing = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object OperDate: TcxGridDBColumn
        Caption = #1044#1074#1090#1072' '#1080' '#1074#1088#1077#1084#1103
        DataBinding.FieldName = 'OperDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 102
      end
      object UserName: TcxGridDBColumn
        Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
        DataBinding.FieldName = 'UserName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 174
      end
      object DateStart: TcxGridDBColumn
        Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072' '#1087#1088#1086#1076#1072#1078
        DataBinding.FieldName = 'DateStart'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object DateEnd: TcxGridDBColumn
        Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072' '#1087#1088#1086#1076#1072#1078
        DataBinding.FieldName = 'DateEnd'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Threshold: TcxGridDBColumn
        Caption = #1055#1086#1088#1086#1075' '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1099#1093' '#1087#1088#1086#1076#1072#1078
        DataBinding.FieldName = 'Threshold'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object DaysStock: TcxGridDBColumn
        Caption = #1044#1085#1077#1081' '#1079#1072#1087#1072#1089#1072' '#1091' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
        DataBinding.FieldName = 'DaysStock'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object CountPharmacies: TcxGridDBColumn
        Caption = #1052#1080#1085'. '#1082#1086#1083'-'#1074#1086' '#1072#1087#1090#1077#1082' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072
        DataBinding.FieldName = 'CountPharmacies'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object ResolutionParameter: TcxGridDBColumn
        Caption = #1043#1088#1072#1085#1080#1095'. '#1087#1072#1088#1072#1084#1077#1090#1088' '#1088#1072#1079#1088#1077#1096#1077#1085#1080#1103
        DataBinding.FieldName = 'ResolutionParameter'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object isGoodsClose: TcxGridDBColumn
        Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1047#1072#1082#1088#1099#1090' '#1082#1086#1076
        DataBinding.FieldName = 'isGoodsClose'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object isMCSIsClose: TcxGridDBColumn
        Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1059#1073#1080#1090' '#1082#1086#1076' '
        DataBinding.FieldName = 'isMCSIsClose'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object isNotCheckNoMCS: TcxGridDBColumn
        Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1055#1088#1086#1076#1072#1078#1080' '#1085#1077' '#1076#1083#1103' '#1053#1058#1047
        DataBinding.FieldName = 'isNotCheckNoMCS'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 273
    Width = 1032
    Height = 213
    Align = alClient
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 8
    ExplicitWidth = 817
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 519
      Height = 211
      Align = alClient
      Caption = 'Panel2'
      ShowCaption = False
      TabOrder = 0
      ExplicitWidth = 622
      object cxLabel3: TcxLabel
        Left = 1
        Top = 1
        Align = alTop
        Caption = #1040#1087#1090#1077#1082#1080' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1080
        Properties.Alignment.Horz = taCenter
        ExplicitWidth = 405
        AnchorX = 260
      end
      object cxGridRecipient: TcxGrid
        Left = 1
        Top = 18
        Width = 517
        Height = 192
        Align = alClient
        TabOrder = 1
        ExplicitWidth = 504
        object cxGridDBTableViewRecipient: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = RecipientDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
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
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = RecipientName
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
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object RecipientCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'RecipientCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
          end
          object RecipientName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'RecipientName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 422
          end
        end
        object cxGridLevelRecipient: TcxGridLevel
          GridView = cxGridDBTableViewRecipient
        end
      end
    end
    object Panel3: TPanel
      Left = 528
      Top = 1
      Width = 503
      Height = 211
      Align = alRight
      Caption = 'Panel3'
      ShowCaption = False
      TabOrder = 1
      object cxLabel4: TcxLabel
        Left = 1
        Top = 1
        Align = alTop
        Caption = #1040#1087#1090#1077#1082#1080' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072
        Properties.Alignment.Horz = taCenter
        ExplicitWidth = 398
        AnchorX = 252
      end
      object cxGridAssortment: TcxGrid
        Left = 1
        Top = 18
        Width = 501
        Height = 192
        Align = alClient
        TabOrder = 1
        ExplicitLeft = -3
        ExplicitWidth = 402
        object cxGridDBTableViewAssortment: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = AssortmentDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
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
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = AssortmentName
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
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object AssortmentCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'AssortmentCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
          end
          object AssortmentName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'AssortmentName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 411
          end
        end
        object cxGridLevelAssortment: TcxGridLevel
          GridView = cxGridDBTableViewAssortment
        end
      end
    end
    object cxSplitter2: TcxSplitter
      Left = 520
      Top = 1
      Width = 8
      Height = 211
      AlignSplitter = salRight
      Control = Panel3
      ExplicitLeft = 408
    end
  end
  object cxSplitter1: TcxSplitter
    Left = 0
    Top = 265
    Width = 1032
    Height = 8
    AlignSplitter = salTop
    Control = Panel1
    ExplicitWidth = 817
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'JuridicalId_1'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName_1'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId_2'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName_2'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId_3'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName_3'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId_1'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName_1'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId_2'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName_2'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId_3'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName_3'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 198
    Top = 111
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_FinalSUAProtocol'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = RecipientCDS
      end
      item
        DataSet = AssortmentCDS
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
      end>
    PackSize = 1
    Left = 184
    Top = 183
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
    Left = 62
    Top = 183
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
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 57
    Top = 112
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 411
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
      FormName = 'TReport_PeriodDialogForm'
      FormNameParam.Value = 'TReport_PeriodDialogForm'
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
    Left = 502
    Top = 191
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 416
    Top = 191
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <>
    Left = 680
    Top = 128
  end
  object ChildDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 512
    Top = 120
  end
  object PeriodChoice: TPeriodChoice
    DateStart = edDateStart
    DateEnd = deEnd
    Left = 287
    Top = 119
  end
  object RecipientDS: TDataSource
    DataSet = RecipientCDS
    Left = 302
    Top = 327
  end
  object RecipientCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'Id'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 216
    Top = 327
  end
  object AssortmentDS: TDataSource
    DataSet = AssortmentCDS
    Left = 646
    Top = 327
  end
  object AssortmentCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'Id'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 560
    Top = 327
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 288
    Top = 176
  end
end
