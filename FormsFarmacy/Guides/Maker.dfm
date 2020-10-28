object MakerForm: TMakerForm
  Left = 0
  Top = 0
  Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
  ClientHeight = 431
  ClientWidth = 753
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
    Width = 753
    Height = 268
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
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = Name
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = Name
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 60
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 56
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 168
      end
      object CountryName: TcxGridDBColumn
        Caption = #1057#1090#1088#1072#1085#1072
        DataBinding.FieldName = 'CountryName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 147
      end
      object ContactPersonName: TcxGridDBColumn
        Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1086#1077' '#1083#1080#1094#1086
        DataBinding.FieldName = 'ContactPersonName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceFormContactPerson
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object Phone: TcxGridDBColumn
        Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1082#1086#1085#1090'. '#1083#1080#1094#1086')'
        DataBinding.FieldName = 'Phone'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 109
      end
      object Mail: TcxGridDBColumn
        Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1087#1086#1095#1090#1072' ('#1082#1086#1085#1090'. '#1083#1080#1094#1086')'
        DataBinding.FieldName = 'Mail'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 114
      end
      object AmountMonth: TcxGridDBColumn
        Caption = #1055#1077#1088#1080#1086#1076'. '#1084#1077#1089#1103#1094#1077#1074
        DataBinding.FieldName = 'AmountMonth'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1087#1077#1088#1080#1086#1076#1080#1095#1085#1086#1089#1090#1100' '#1086#1090#1087#1088#1072#1074#1082#1080'  '#1074' '#1084#1077#1089#1103#1094#1072#1093
        Width = 70
      end
      object AmountDay: TcxGridDBColumn
        Caption = #1055#1077#1088#1080#1086#1076'. '#1076#1085#1077#1081
        DataBinding.FieldName = 'AmountDay'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1087#1077#1088#1080#1086#1076#1080#1095#1085#1086#1089#1090#1100' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1074' '#1076#1085#1103#1093
        Options.Editing = False
        Width = 70
      end
      object SendPlan: TcxGridDBColumn
        Caption = #1050#1086#1075#1076#1072' '#1087#1083#1072#1085#1080#1088#1091#1077#1084' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' ('#1076#1072#1090#1072'/'#1074#1088#1077#1084#1103')'
        DataBinding.FieldName = 'SendPlan'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1075#1076#1072' '#1087#1083#1072#1085#1080#1088#1091#1077#1084' '#1086#1090#1087#1088#1072#1074#1080#1090#1100'('#1076#1072#1090#1072'/'#1074#1088#1077#1084#1103')'
        Options.Editing = False
        Width = 96
      end
      object SendReal: TcxGridDBColumn
        Caption = #1050#1086#1075#1076#1072' '#1091#1089#1087#1077#1096#1085#1086' '#1087#1088#1086#1096#1083#1072' '#1086#1090#1087#1088#1072#1074#1082#1072' ('#1076#1072#1090#1072'/'#1074#1088#1077#1084#1103')'
        DataBinding.FieldName = 'SendReal'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1075#1076#1072' '#1091#1089#1087#1077#1096#1085#1086' '#1087#1088#1086#1096#1083#1072' '#1086#1090#1087#1088#1072#1074#1082#1072' ('#1076#1072#1090#1072' / '#1074#1088#1077#1084#1103')'
        Options.Editing = False
        Width = 97
      end
      object SendLast: TcxGridDBColumn
        Caption = #1057#1083'. '#1086#1090#1087#1088#1072#1074#1082#1072' ('#1076#1072#1090#1072'/'#1074#1088#1077#1084#1103')'
        DataBinding.FieldName = 'SendLast'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1076#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1089#1083#1077#1076#1091#1102#1097#1077#1081' '#1086#1090#1087#1088#1072#1074#1082#1080
        Options.Editing = False
        Width = 85
      end
      object isReport1: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1086#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1080#1093#1086#1076#1072#1084'"'
        DataBinding.FieldName = 'isReport1'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1086#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1080#1093#1086#1076#1072#1084'"'
        Options.Editing = False
        Width = 80
      end
      object isReport2: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1086#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084'"'
        DataBinding.FieldName = 'isReport2'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1086#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084'"'
        Options.Editing = False
        Width = 80
      end
      object isReport3: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1088#1077#1072#1083#1080#1079#1072#1094#1080#1103' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1086#1089#1090#1072#1090#1082#1072#1084#1080' '#1085#1072' '#1082#1086#1085#1077#1094' '#1087#1077#1088#1080#1086#1076#1072'"'
        DataBinding.FieldName = 'isReport3'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1088#1077#1072#1083#1080#1079#1072#1094#1080#1103' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1086#1089#1090#1072#1090#1082#1072#1084#1080' '#1085#1072' '#1082#1086#1085#1077#1094' '#1087#1077#1088#1080#1086#1076#1072'"'
        Options.Editing = False
        Width = 132
      end
      object isReport4: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1087#1088#1080#1093#1086#1076' '#1088#1072#1089#1093#1086#1076' '#1086#1089#1090#1072#1090#1086#1082'"'
        DataBinding.FieldName = 'isReport4'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1087#1088#1080#1093#1086#1076' '#1088#1072#1089#1093#1086#1076' '#1086#1089#1090#1072#1090#1086#1082'"'
        Options.Editing = False
        Width = 80
      end
      object isReport5: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1086#1090#1095#1077#1090' '#1087#1086' '#1089#1088#1086#1082#1072#1084'"'
        DataBinding.FieldName = 'isReport5'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 87
      end
      object isReport6: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100'  "'#1086#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1085#1072' '#1074#1080#1088#1090'. '#1089#1082#1083#1072#1076#1077'"'
        DataBinding.FieldName = 'isReport6'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaBottom
        Options.Editing = False
        Width = 102
      end
      object isQuarter: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086' '#1082#1074#1072#1088#1090#1072#1083#1100#1085#1099#1077' '#1086#1090#1095#1077#1090#1099
        DataBinding.FieldName = 'isQuarter'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object is4Month: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1095#1077#1090#1099' '#1079#1072' 4 '#1084#1077#1089#1103#1094#1072
        DataBinding.FieldName = 'is4Month'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
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
        Width = 53
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxSplitter1: TcxSplitter
    Left = 0
    Top = 294
    Width = 753
    Height = 8
    AlignSplitter = salBottom
    Control = cxGridReport
  end
  object cxGridReport: TcxGrid
    Left = 0
    Top = 302
    Width = 753
    Height = 129
    Align = alBottom
    TabOrder = 6
    object cxGridDBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ReportDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.####'
        end
        item
          Kind = skSum
          Position = spFooter
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = MakerName
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsBehavior.FocusCellOnCycle = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.DataRowSizing = True
      OptionsData.CancelOnExit = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object MakerName: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        DataBinding.FieldName = 'MakerName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 336
      end
      object JuridicalName: TcxGridDBColumn
        Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 373
      end
      object colisErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        Visible = False
        Options.Editing = False
        Width = 50
      end
    end
    object cxGridLevel1: TcxGridLevel
      GridView = cxGridDBTableView1
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 48
    Top = 96
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 40
    Top = 152
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
    Left = 280
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
    Left = 160
    Top = 96
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertMakerReport'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMakerReport'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedMakerReport'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedMakerReport'
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
          ItemName = 'bbUpdateSendPlan'
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
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcelReport'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbInsertMakerReport: TdxBarButton
      Action = actInsertMakerReport
      Category = 0
    end
    object bbUpdateMakerReport: TdxBarButton
      Action = actUpdateMakerReport
      Category = 0
    end
    object bbSetErasedMakerReport: TdxBarButton
      Action = dsdSetErasedMakerReport
      Category = 0
    end
    object bbSetUnErasedMakerReport: TdxBarButton
      Action = dsdSetUnErasedMakerReport
      Category = 0
    end
    object bbGridToExcelReport: TdxBarButton
      Action = actGridToExcelReport
      Category = 0
    end
    object bbUpdateSendPlan: TdxBarButton
      Action = macUpdateSendPlan
      Category = 0
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = actProtocolOpenForm
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 280
    Top = 152
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end
        item
          StoredProc = spSelectReport
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsertMakerReport: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1074' '#1086#1090#1087#1088#1072#1074#1082#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1074' '#1086#1090#1087#1088#1072#1074#1082#1077
      ImageIndex = 0
      FormName = 'TMakerReportEditForm'
      FormNameParam.Value = 'TMakerReportEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = ReportDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TMakerEditForm'
      FormNameParam.Value = 'TMakerEditForm'
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
    object actUpdateMakerReport: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1074' '#1086#1090#1087#1088#1072#1074#1082#1077
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1074' '#1086#1090#1087#1088#1072#1074#1082#1077
      ImageIndex = 1
      FormName = 'TMakerReportEditForm'
      FormNameParam.Value = 'TMakerReportEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ReportCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSource = ReportDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TMakerEditForm'
      FormNameParam.Value = 'TMakerEditForm'
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
      isShowModal = True
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object dsdSetErasedMakerReport: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1074' '#1086#1090#1087#1088#1072#1074#1082#1077
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1074' '#1086#1090#1087#1088#1072#1074#1082#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ReportDS
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
    object dsdSetUnErasedMakerReport: TdsdUpdateErased
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
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ReportDS
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
          ComponentItem = 'Name'
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
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
    object actGridToExcelReport: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGridReport
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1103' '#1074' '#1086#1090#1087#1088#1072#1074#1082#1077
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1103' '#1074' '#1086#1090#1087#1088#1072#1074#1082#1077
      ImageIndex = 6
      ShortCut = 16472
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_ContactPerson
      StoredProcList = <
        item
          StoredProc = spInsert_ContactPerson
        end
        item
          StoredProc = dsdStoredProc
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
    end
    object actChoiceFormContactPerson: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContactPersonChoiceForm'
      FormName = 'TContactPersonForm'
      FormNameParam.Value = 'TContactPersonForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'ContactPersonName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Mail'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Mail'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Phone'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Phone'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macUpdateSendPlanList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateSendPlan
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1090#1091', '#1082#1086#1075#1076#1072' '#1087#1083#1072#1085#1080#1088#1091#1077#1084' '#1086#1090#1087#1088#1072#1074#1080#1090#1100
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1090#1091', '#1082#1086#1075#1076#1072' '#1087#1083#1072#1085#1080#1088#1091#1077#1084' '#1086#1090#1087#1088#1072#1074#1080#1090#1100
      ImageIndex = 67
    end
    object macUpdateSendPlan: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogUpdateSendPlan
        end
        item
          Action = macUpdateSendPlanList
        end
        item
          Action = actRefresh
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1090#1091', '#1082#1086#1075#1076#1072' '#1087#1083#1072#1085#1080#1088#1091#1077#1084' '#1086#1090#1087#1088#1072#1074#1080#1090#1100
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1090#1091', '#1082#1086#1075#1076#1072' '#1087#1083#1072#1085#1080#1088#1091#1077#1084' '#1086#1090#1087#1088#1072#1074#1080#1090#1100
      ImageIndex = 67
    end
    object actUpdateSendPlan: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_SendPlan
      StoredProcList = <
        item
          StoredProc = spUpdate_SendPlan
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1090#1091'/'#1074#1088#1077#1084#1103
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1090#1091'/'#1074#1088#1077#1084#1103
      ImageIndex = 67
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object ExecuteDialogUpdateSendPlan: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1090#1091', '#1082#1086#1075#1076#1072' '#1087#1083#1072#1085#1080#1088#1091#1077#1084' '#1086#1090#1087#1088#1072#1074#1080#1090#1100
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1090#1091', '#1082#1086#1075#1076#1072' '#1087#1083#1072#1085#1080#1088#1091#1077#1084' '#1086#1090#1087#1088#1072#1074#1080#1090#1100
      ImageIndex = 67
      FormName = 'TDataTimeDialogForm'
      FormNameParam.Value = 'TDataTimeDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 42261d
          Component = FormParams
          ComponentItem = 'inSendPlan'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actProtocolOpenForm: TdsdOpenForm
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
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Maker'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 40
    Top = 208
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 160
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
    Left = 288
    Top = 208
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
    Left = 424
    Top = 128
  end
  object ReportDS: TDataSource
    DataSet = ReportCDS
    Left = 376
    Top = 336
  end
  object ReportCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 440
    Top = 320
  end
  object spSelectReport: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_MakerReport'
    DataSet = ReportCDS
    DataSets = <
      item
        DataSet = ReportCDS
      end>
    Params = <>
    PackSize = 1
    Left = 192
    Top = 320
  end
  object dsdDBViewAddOnReport: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <
      item
        Action = actUpdateMakerReport
      end>
    ActionItemList = <
      item
        Action = actUpdateMakerReport
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    PropertiesCellList = <>
    Left = 288
    Top = 344
  end
  object spInsert_ContactPerson: TdsdStoredProc
    StoredProcName = 'gpInsert_Object_ContactPerson_byMaker'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'ContactPersonId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMakerId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'ContactPersonName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhone'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Phone'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMail'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Mail'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 576
    Top = 123
  end
  object spUpdate_SendPlan: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Maker_SendPlan'
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
        Name = 'inSendPlan'
        Value = 42261d
        Component = FormParams
        ComponentItem = 'inSendPlan'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 482
    Top = 208
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 160
    Top = 221
  end
end
