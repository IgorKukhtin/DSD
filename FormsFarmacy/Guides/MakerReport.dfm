object MakerReportForm: TMakerReportForm
  Left = 0
  Top = 0
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1086#1090#1095#1077#1090#1086#1074' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1103#1084
  ClientHeight = 431
  ClientWidth = 1062
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 1062
    Height = 397
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
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
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
        Width = 104
      end
      object Mail: TcxGridDBColumn
        Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1087#1086#1095#1090#1072' ('#1082#1086#1085#1090'. '#1083#1080#1094#1086')'
        DataBinding.FieldName = 'Mail'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
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
        Options.Editing = False
        Width = 66
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
        Width = 60
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
      object isUnPlanned: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074#1085#1077#1087#1083#1072#1085#1086#1074#1099#1077' '#1086#1090#1095#1077#1090#1099
        DataBinding.FieldName = 'isUnPlanned'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074#1085#1077#1087#1083#1072#1085#1086#1074#1099#1077' '#1086#1090#1095#1077#1090#1099
        Options.Editing = False
        Width = 92
      end
      object StartDateUnPlanned: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1076#1083#1103' '#1042#1054
        DataBinding.FieldName = 'StartDateUnPlanned'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1076#1083#1103' '#1074#1085#1077#1087#1083#1072#1085#1086#1074#1086#1075#1086' '#1086#1090#1095#1077#1090#1072
        Options.Editing = False
        Width = 91
      end
      object EndDateUnPlanned: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1076#1083#1103' '#1042#1054
        DataBinding.FieldName = 'EndDateUnPlanned'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1076#1083#1103' '#1074#1085#1077#1087#1083#1072#1085#1086#1074#1086#1075#1086' '#1086#1090#1095#1077#1090#1072
        Options.Editing = False
        Width = 84
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
        Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100'  "'#1080#1089#1090#1077#1082#1096#1080#1081' '#1089#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080'"'
        DataBinding.FieldName = 'isReport6'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 102
      end
      object isReport7: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1086#1090#1095#1077#1090' '#1087#1086' '#1086#1087#1083#1072#1090#1077' '#1087#1088#1080#1093#1086#1076#1086#1074'" '
        DataBinding.FieldName = 'isReport7'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
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
        Width = 53
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxSplitter1: TcxSplitter
    Left = 0
    Top = 423
    Width = 1062
    Height = 8
    AlignSplitter = salBottom
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
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
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
          ItemName = 'dxBarStatic'
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
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Category = 0
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Visible = ivAlways
      ImageIndex = 7
    end
    object bbInsertMakerReportReport: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1074' '#1086#1090#1087#1088#1072#1074#1082#1077
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1074' '#1086#1090#1087#1088#1072#1074#1082#1077
      Visible = ivAlways
      ImageIndex = 0
    end
    object bbUpdateMakerReportReport: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1074' '#1086#1090#1087#1088#1072#1074#1082#1077
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1074' '#1086#1090#1087#1088#1072#1074#1082#1077
      Visible = ivAlways
      ImageIndex = 1
    end
    object bbSetErasedMakerReportReport: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1074' '#1086#1090#1087#1088#1072#1074#1082#1077
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1074' '#1086#1090#1087#1088#1072#1074#1082#1077
      Visible = ivAlways
      ImageIndex = 2
      ShortCut = 46
    end
    object bbSetUnErasedMakerReportReport: TdxBarButton
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 8
      ShortCut = 46
    end
    object bbGridToExcelReport: TdxBarButton
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1103' '#1074' '#1086#1090#1087#1088#1072#1074#1082#1077
      Category = 0
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1103' '#1074' '#1086#1090#1087#1088#1072#1074#1082#1077
      Visible = ivAlways
      ImageIndex = 6
      ShortCut = 16472
    end
    object bbUpdateSendPlan: TdxBarButton
      Action = macUpdateSendPlan
      Category = 0
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = actProtocolOpenForm
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = macUpdate_UnPlanned
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = macUpdate_ClearUnPlanned
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
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
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
    object actPeriodDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1077#1088#1080#1086#1076' '#1076#1083#1103' '#1074#1085#1077#1087#1083#1072#1085#1086#1074#1099#1093' '#1086#1090#1095#1077#1090#1086#1074
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1077#1088#1080#1086#1076' '#1076#1083#1103' '#1074#1085#1077#1087#1083#1072#1085#1086#1074#1099#1093' '#1086#1090#1095#1077#1090#1086#1074
      ImageIndex = 35
      FormName = 'TReport_PeriodDialogForm'
      FormNameParam.Value = 'TReport_PeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'StartDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'EndDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_UnPlanned: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_UnPlanned
      StoredProcList = <
        item
          StoredProc = spUpdate_UnPlanned
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1077#1088#1080#1086#1076' '#1076#1083#1103' '#1074#1085#1077#1087#1083#1072#1085#1086#1074#1099#1093' '#1086#1090#1095#1077#1090#1086#1074
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1077#1088#1080#1086#1076' '#1076#1083#1103' '#1074#1085#1077#1087#1083#1072#1085#1086#1074#1099#1093' '#1086#1090#1095#1077#1090#1086#1074
      ImageIndex = 35
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macUpdate_UnPlanned: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actPeriodDialog
      ActionList = <
        item
          Action = actUpdate_UnPlanned
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1077#1088#1080#1086#1076' '#1076#1083#1103' '#1074#1085#1077#1087#1083#1072#1085#1086#1074#1099#1093' '#1086#1090#1095#1077#1090#1086#1074
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1077#1088#1080#1086#1076' '#1076#1083#1103' '#1074#1085#1077#1087#1083#1072#1085#1086#1074#1099#1093' '#1086#1090#1095#1077#1090#1086#1074
      ImageIndex = 35
    end
    object actUpdate_ClearUnPlanned: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_ClearUnPlanned
      StoredProcList = <
        item
          StoredProc = spUpdate_ClearUnPlanned
        end>
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074#1085#1077#1087#1083#1072#1085#1086#1074#1099#1077' '#1086#1090#1095#1077#1090#1099'"'
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074#1085#1077#1087#1083#1072#1085#1086#1074#1099#1077' '#1086#1090#1095#1077#1090#1099'"'
      ImageIndex = 77
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macUpdate_ClearUnPlanned: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUpdate_ClearUnPlanned
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074#1085#1077#1087#1083#1072#1085#1086#1074#1099#1077' '#1086#1090#1095#1077#1090#1099'"?'
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074#1085#1077#1087#1083#1072#1085#1086#1074#1099#1077' '#1086#1090#1095#1077#1090#1099'"'
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074#1085#1077#1087#1083#1072#1085#1086#1074#1099#1077' '#1086#1090#1095#1077#1090#1099'"'
      ImageIndex = 77
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_MakerReportSettings'
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
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
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
    Left = 424
    Top = 128
  end
  object spInsert_ContactPerson: TdsdStoredProc
    StoredProcName = 'gpInsert_Object_ContactPerson_byMakerReport'
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
        Name = 'inMakerReportId'
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
  object spUpdate_UnPlanned: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Maker_UnPlanned'
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
        Name = 'inStartDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'EndDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 642
    Top = 208
  end
  object spUpdate_ClearUnPlanned: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Maker_ClearUnPlanned'
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
      end>
    PackSize = 1
    Left = 642
    Top = 280
  end
end
