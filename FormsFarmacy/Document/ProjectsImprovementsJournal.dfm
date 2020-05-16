inherited ProjectsImprovementsJournalForm: TProjectsImprovementsJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1088#1086#1077#1082#1090#1099'/'#1044#1086#1088#1072#1073#1086#1090#1082#1080'>'
  ClientHeight = 572
  ClientWidth = 975
  ExplicitWidth = 991
  ExplicitHeight = 611
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 975
    Height = 515
    TabOrder = 3
    ExplicitWidth = 937
    ExplicitHeight = 478
    ClientRectBottom = 515
    ClientRectRight = 975
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 937
      ExplicitHeight = 478
      inherited cxGrid: TcxGrid
        Width = 544
        Height = 515
        ExplicitWidth = 489
        ExplicitHeight = 478
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
          DataController.Filter.TranslateBetween = True
          DataController.Filter.TranslateIn = True
          DataController.Filter.TranslateLike = True
          OptionsBehavior.GoToNextCellOnEnter = False
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            Properties.Items = <
              item
                Description = #1053#1077' '#1074#1099#1087#1086#1083#1085#1077#1085#1086
                ImageIndex = 11
                Value = 1
              end
              item
                Description = #1042#1099#1087#1086#1083#1085#1077#1085#1086
                ImageIndex = 12
                Value = 2
              end
              item
                Description = #1059#1076#1072#1083#1077#1085
                ImageIndex = 13
                Value = 3
              end>
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 55
          end
          inherited colOperDate: TcxGridDBColumn [1]
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 64
          end
          inherited colInvNumber: TcxGridDBColumn [2]
            Caption = #8470' '#1076#1086#1082'.'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 55
          end
          object UserName: TcxGridDBColumn
            Caption = #1048#1085#1080#1094#1080#1072#1090#1088
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object colisApprovedBy: TcxGridDBColumn
            Caption = #1059#1090#1074#1077#1088#1078#1076#1077#1085#1086
            DataBinding.FieldName = 'isApprovedBy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object coTitle: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1088#1086#1077#1082#1090#1072
            DataBinding.FieldName = 'Title'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 136
          end
          object coDescription: TcxGridDBColumn
            Caption = #1054#1087#1080#1089#1072#1085#1080#1077
            DataBinding.FieldName = 'Description'
            PropertiesClassName = 'TcxBlobEditProperties'
            Properties.BlobEditKind = bekMemo
            Properties.BlobPaintStyle = bpsText
            HeaderAlignmentVert = vaCenter
            Width = 235
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 552
        Top = 0
        Width = 423
        Height = 515
        Align = alRight
        PopupMenu = PopupMenu
        TabOrder = 1
        ExplicitLeft = 550
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DetailDS
          DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
          DataController.Filter.TranslateBetween = True
          DataController.Filter.TranslateIn = True
          DataController.Filter.TranslateLike = True
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object detOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object detUserName: TcxGridDBColumn
            Caption = #1048#1085#1080#1094#1080#1072#1090#1088
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object detisApprovedBy: TcxGridDBColumn
            Caption = #1059#1090#1074#1077#1088#1078#1076#1077#1085#1086
            DataBinding.FieldName = 'isApprovedBy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object detPerformed: TcxGridDBColumn
            Caption = #1042#1099#1087#1086#1083#1085#1077#1085#1086
            DataBinding.FieldName = 'isPerformed'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 49
          end
          object detTitle: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1076#1086#1088#1086#1073#1086#1090#1082#1080
            DataBinding.FieldName = 'Title'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 77
          end
          object detDescription: TcxGridDBColumn
            Caption = #1054#1087#1080#1089#1072#1085#1080#1077
            DataBinding.FieldName = 'Description'
            PropertiesClassName = 'TcxBlobEditProperties'
            Properties.BlobEditKind = bekMemo
            Properties.BlobPaintStyle = bpsText
            HeaderAlignmentVert = vaCenter
            Width = 272
          end
          object dclisErased: TcxGridDBColumn
            DataBinding.FieldName = 'isErased'
            Visible = False
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 544
        Top = 0
        Width = 8
        Height = 515
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salRight
        Control = cxGrid1
        ExplicitLeft = 975
        ExplicitHeight = 478
      end
    end
  end
  inherited Panel: TPanel
    Width = 975
    Visible = False
    ExplicitWidth = 937
    inherited deStart: TcxDateEdit
      EditValue = 42005d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42005d
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 179
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 48
    Top = 211
  end
  inherited ActionList: TActionList
    Left = 503
    Top = 202
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectDetai
        end>
    end
    inherited actInsert: TdsdInsertUpdateAction
      ShortCut = 0
      FormName = 'TProjectsImprovementsForm'
    end
    inherited actInsertMask: TdsdInsertUpdateAction
      Enabled = False
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TProjectsImprovementsForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
    inherited MovementProtocolOpenForm: TdsdOpenForm
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1087#1088#1086#1077#1082#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1087#1088#1086#1077#1082#1090#1072'>'
    end
    inherited actShowErased: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectDetai
        end>
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <
        item
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDHeader'
        end
        item
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
      ReportNameParam.Value = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
      PreviewWindowMaximized = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TMovement_PeriodDialogForm'
      FormNameParam.Value = 'TMovement_PeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
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
          StoredProc = spSelectDetai
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actUpdateMainDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMovement
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end>
      Caption = 'actUpdateMainDS'
      DataSource = MasterDS
    end
    object actUpdateDetailDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIMaster
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end>
      Caption = 'actUpdateMainDS'
      DataSource = DetailDS
    end
    object actUpdateMovement_ApprovedBy: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMovement_ApprovedBy
      StoredProcList = <
        item
          StoredProc = spUpdateMovement_ApprovedBy
        end>
      Caption = #1059#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1087#1088#1086#1077#1082#1090#1072
      Hint = #1059#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1087#1088#1086#1077#1082#1090#1072
      ImageIndex = 79
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1059#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1087#1088#1086#1077#1082#1090#1072'"'
    end
    object actUpdateMovementItem_ApprovedBy: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMovementItem_ApprovedBy
      StoredProcList = <
        item
          StoredProc = spUpdateMovementItem_ApprovedBy
        end>
      Caption = #1059#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1076#1086#1088#1072#1073#1086#1090#1082#1080
      Hint = #1059#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1076#1086#1088#1072#1073#1086#1090#1082#1080
      ImageIndex = 79
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1059#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1076#1086#1088#1072#1073#1086#1090#1082#1080'"'
    end
    object dsdExecStoredProc1: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMovementItem_Performed
      StoredProcList = <
        item
          StoredProc = spUpdateMovementItem_Performed
        end>
      Caption = #1042#1099#1087#1086#1083#1085#1077#1085#1072' '#1076#1086#1088#1072#1073#1086#1090#1082#1080
      Hint = #1042#1099#1087#1086#1083#1085#1077#1085#1072' '#1076#1086#1088#1072#1073#1086#1090#1082#1080
      ImageIndex = 66
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1042#1099#1087#1086#1083#1085#1077#1085#1072' '#1076#1086#1088#1072#1073#1086#1090#1082#1080'"'
    end
    object actMISetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1044#1086#1088#1072#1073#1086#1090#1082#1091'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1044#1086#1088#1072#1073#1086#1090#1082#1091'>'
      ImageIndex = 2
      ErasedFieldName = 'isErased'
      DataSource = DetailDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1076#1086#1088#1072#1073#1086#1090#1082#1080'?'
    end
    object actMISetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end
        item
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1044#1086#1088#1072#1073#1086#1090#1082#1091
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1044#1086#1088#1072#1073#1086#1090#1082#1091
      ImageIndex = 8
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DetailDS
    end
    object MovementItemProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1083#1086#1088#1072#1073#1086#1090#1086#1082'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1083#1086#1088#1072#1073#1086#1090#1086#1082'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = DetailDCS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = DetailDCS
          ComponentItem = 'Title'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 139
  end
  inherited MasterCDS: TClientDataSet
    Top = 139
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProjectsImprovements'
    Params = <
      item
        Name = 'inShowAll'
        Value = 41640d
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 163
  end
  inherited BarManager: TdxBarManager
    Left = 224
    Top = 155
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbComplete'
        end
        item
          Visible = True
          ItemName = 'bbUnComplete'
        end
        item
          Visible = True
          ItemName = 'bbDelete'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
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
          ItemName = 'dxBarButton4'
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
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarButton9'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    object bbPrint: TdxBarButton
      Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1090#1077#1093#1085#1080#1095#1077#1089#1082#1080#1093' '#1087#1077#1088#1077#1091#1095#1077#1090#1086#1074' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      Category = 0
      Hint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1090#1077#1093#1085#1080#1095#1077#1089#1082#1080#1093' '#1087#1077#1088#1077#1091#1095#1077#1090#1086#1074' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      Visible = ivAlways
      ImageIndex = 10
    end
    object bbPrint1: TdxBarButton
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      Category = 0
      Hint = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      Visible = ivAlways
      ImageIndex = 22
    end
    object dxBarButton1: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbAddRedCheck: TdxBarButton
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1090#1077#1093#1085#1080#1095#1077#1089#1082#1080#1081' '#1087#1077#1088#1077#1091#1095#1077#1090' '#1089' '#1087#1088#1080#1079#1085#1072#1082#1086#1084' "'#1050#1088#1072#1089#1085#1099#1081' '#1095#1077#1082'"'
      Category = 0
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1090#1077#1093#1085#1080#1095#1077#1089#1082#1080#1081' '#1087#1077#1088#1077#1091#1095#1077#1090' '#1089' '#1087#1088#1080#1079#1085#1072#1082#1086#1084' "'#1050#1088#1072#1089#1085#1099#1081' '#1095#1077#1082'"'
      Visible = ivAlways
      ImageIndex = 54
    end
    object dxBarButton2: TdxBarButton
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1090#1077#1093#1085#1080#1095#1077#1089#1082#1080#1081' '#1087#1077#1088#1077#1091#1095#1077#1090' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102
      Category = 0
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1090#1077#1093#1085#1080#1095#1077#1089#1082#1080#1081' '#1087#1077#1088#1077#1091#1095#1077#1090' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102
      Visible = ivAlways
      ImageIndex = 8
    end
    object dxBarButton3: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actUpdateMovement_ApprovedBy
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = actUpdateMovementItem_ApprovedBy
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = dsdExecStoredProc1
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = actMISetErased
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = actMISetUnErased
      Category = 0
    end
    object dxBarButton9: TdxBarButton
      Action = MovementItemProtocolOpenForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
      end>
    Left = 320
    Top = 224
  end
  inherited PopupMenu: TPopupMenu
    Left = 440
    Top = 120
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 288
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
    Left = 456
    Top = 312
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_ProjectsImprovements'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = True
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 48
    Top = 296
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_ProjectsImprovements'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 368
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_ProjectsImprovements'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 360
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameProjectsImprovements'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameProjectsImprovementsTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 400
    Top = 200
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_ProjectsImprovements'
    Left = 184
    Top = 296
  end
  object spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_ProjectsImprovements'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioInvNumber'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumber'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperDate'
        Value = 42261d
        Component = MasterCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTitle'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Title'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescription'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Description'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisApprovedBy'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isApprovedBy'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStatusCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StatusCode'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStatusName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StatusName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outUserName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UserName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 322
    Top = 309
  end
  object DetailDS: TDataSource
    DataSet = DetailDCS
    Left = 712
    Top = 152
  end
  object DetailDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 624
    Top = 152
  end
  object spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_ProjectsImprovements'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperDate'
        Value = 'NULL'
        Component = DetailDCS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTitle'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Title'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescription'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Description'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisApprovedBy'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'isApprovedBy'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisPerformed'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'isPerformed'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outUserName'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'UserName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 624
    Top = 232
  end
  object spSelectDetai: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_ProjectsImprovements'
    DataSet = DetailDCS
    DataSets = <
      item
        DataSet = DetailDCS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 760
    Top = 235
  end
  object spUpdateMovement_ApprovedBy: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ProjectsImprovements_ApprovedBy'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisApprovedBy'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isApprovedBy'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 394
    Top = 373
  end
  object DBViewAddOnDetail: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
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
    Left = 656
    Top = 360
  end
  object spUpdateMovementItem_ApprovedBy: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_ProjectsImprovements_ApprovedBy'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisApprovedBy'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'isApprovedBy'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 834
    Top = 349
  end
  object spUpdateMovementItem_Performed: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_ProjectsImprovements_Performed'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPerformed'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'isPerformed'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 834
    Top = 413
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProjectsImprovements_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 846
    Top = 152
  end
  object spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProjectsImprovements_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 846
    Top = 224
  end
end
