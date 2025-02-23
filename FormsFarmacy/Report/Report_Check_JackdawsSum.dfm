inherited Report_Check_JackdawsSumForm: TReport_Check_JackdawsSumForm
  Caption = #1043#1072#1083#1082#1080' '#1095#1077#1082#1080' '#1079#1072' '#1087#1077#1088#1080#1086#1076
  ClientHeight = 632
  ClientWidth = 1007
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1023
  ExplicitHeight = 671
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 77
    Width = 1007
    Height = 555
    ExplicitTop = 77
    ExplicitWidth = 1007
    ExplicitHeight = 555
    ClientRectBottom = 555
    ClientRectRight = 1007
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1007
      ExplicitHeight = 555
      inherited cxGrid: TcxGrid
        Width = 1007
        Height = 306
        ExplicitWidth = 1007
        ExplicitHeight = 306
        inherited cxGridDBTableView: TcxGridDBTableView
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
              Column = SummaJackdaws1
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
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaRRO
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0.##'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaJackdaws1
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaChech
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaReturnIn
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaJackdaws2
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = RetrievedAccounting
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaReceived
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaReceivedDelta
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaOther
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UnitCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Caption = 'mactChoiceGoodsForm'
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 39
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 310
          end
          object SummaRRO: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1056#1056#1054
            DataBinding.FieldName = 'SummaRRO'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object SummaChech: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1095#1077#1082#1072#1084
            DataBinding.FieldName = 'SummaChech'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object SummaReturnIn: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1086#1074
            DataBinding.FieldName = 'SummaReturnIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object RetrievedAccounting: TcxGridDBColumn
            Caption = #1055#1086#1083#1091#1095#1077#1085#1086' '#1073#1091#1093#1075#1072#1083'.'
            DataBinding.FieldName = 'RetrievedAccounting'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object SummaReceived: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1092#1072#1082#1090#1091
            DataBinding.FieldName = 'SummaReceived'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Styles.Content = dmMain.cxRemainsContentStyle
            Width = 90
          end
          object SummaReceivedDelta: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072
            DataBinding.FieldName = 'SummaReceivedDelta'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Styles.Content = dmMain.cxRemainsContentStyle
            Width = 90
          end
          object SummaJackdaws1: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072', '#1087#1086' '#1075#1072#1083#1086#1095#1082#1077
            DataBinding.FieldName = 'SummaJackdaws1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object SummaJackdaws2: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072', '#1087#1086' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1091#1102#1097#1072#1103' '#1075#1072#1083#1086#1095#1082#1072
            DataBinding.FieldName = 'SummaJackdaws2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object SummaOther: TcxGridDBColumn
            Caption = #1041#1077#1079' '#1075#1072#1083#1082#1080' '#1080' '#1056#1056#1054
            DataBinding.FieldName = 'SummaOther'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object ColorRA_calc: TcxGridDBColumn
            DataBinding.FieldName = 'ColorRA_calc'
            Visible = False
            VisibleForCustomization = False
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 314
        Width = 1007
        Height = 241
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = JackdawsCheckDS
          DataController.Filter.Options = [fcoCaseInsensitive]
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
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = chTotalSumm
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0.##'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = chSummaReceivedFact
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object chOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object chInvNumber: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1076#1086#1082'-'#1090#1072
            DataBinding.FieldName = 'InvNumber'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Caption = 'mactChoiceGoodsForm'
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object chJackdawsChecksName: TcxGridDBColumn
            Caption = #1043#1072#1083#1082#1072
            DataBinding.FieldName = 'JackdawsChecksName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 261
          end
          object chisRetrievedAccounting: TcxGridDBColumn
            Caption = #1055#1086#1083#1091#1095#1077#1085#1086' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1077#1081
            DataBinding.FieldName = 'isRetrievedAccounting'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object chTotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object chSummaReceivedFact: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086#1083#1091#1095#1077#1085#1086' '#1087#1086' '#1092#1072#1082#1090#1091
            DataBinding.FieldName = 'SummaReceivedFact'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object CommentChecking: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1088#1086#1074#1077#1088#1103#1102#1097#1077#1081
            DataBinding.FieldName = 'CommentChecking'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 229
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 306
        Width = 1007
        Height = 8
        AlignSplitter = salBottom
        Control = cxGrid1
      end
    end
  end
  inherited Panel: TPanel
    Width = 1007
    Height = 51
    ExplicitWidth = 1007
    ExplicitHeight = 51
    inherited deStart: TcxDateEdit
      EditValue = 42491d
      TabOrder = 1
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42491d
      TabOrder = 0
    end
    object ceUnit: TcxButtonEdit
      Left = 101
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 4
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Width = 288
    end
    object cxLabel3: TcxLabel
      Left = 10
      Top = 29
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 51
    Top = 192
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 56
    Top = 256
  end
  inherited ActionList: TActionList
    Left = 127
    Top = 199
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spJackdawsCheck
        end>
    end
    object actRefreshSearch: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actRefreshSearch'
      ShortCut = 13
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormName = 'NULL'
      FormNameParam.Value = Null
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Check_JackdawsSumDialogForm'
      FormNameParam.Value = 'TReport_Check_JackdawsSumDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42491d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42491d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = UnitGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = UnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TCheckForm'
      FormNameParam.Value = 'TCheckForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = JackdawsCheckCDS
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
          Value = 42491d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      CheckIDRecords = True
      ActionType = acUpdate
      DataSource = JackdawsCheckDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate_RetrievedAccounting: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_RetrievedAccounting
      StoredProcList = <
        item
          StoredProc = spUpdate_RetrievedAccounting
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1055#1086#1083#1091#1095#1077#1085#1086' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1077#1081'>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1055#1086#1083#1091#1095#1077#1085#1086' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1077#1081'>'
      ImageIndex = 79
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1055#1086#1083#1091#1095#1077#1085#1086' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1077#1081'>?'
    end
    object actUpdateJackdawsCheckCDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_RetrievedAccountingCDC
      StoredProcList = <
        item
          StoredProc = spUpdate_RetrievedAccountingCDC
        end>
      Caption = 'actUpdateJackdawsCheckCDS'
      DataSource = JackdawsCheckDS
    end
    object actSummaReceivedToJson: TdsdDataToJsonAction
      Category = 'DSDLib'
      MoveParams = <>
      DataSource = JackdawsCheckDS
      JsonParam.Name = 'Json'
      JsonParam.Value = Null
      JsonParam.Component = FormParams
      JsonParam.ComponentItem = 'Json'
      JsonParam.DataType = ftWideString
      JsonParam.MultiSelectSeparator = ','
      PairParams = <
        item
          FieldName = 'Id'
          PairName = 'Id'
        end
        item
          FieldName = 'isRetrievedAccounting'
          PairName = 'isRetrievedAccounting'
        end
        item
          FieldName = 'TotalSumm'
          PairName = 'TotalSumm'
        end
        item
          FieldName = 'SummaReceivedFact'
          PairName = 'SummaReceivedFact'
        end>
      Caption = 'actSummaReceivedToJson'
    end
    object actSummaDialogForm: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actSummaReceivedToJson
      Caption = 'actSummaDialogForm'
      FormName = 'TSummaDialogForm'
      FormNameParam.Value = 'TSummaDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Summa'
          Value = Null
          Component = FormParams
          ComponentItem = 'SummaReceivedFact'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = Null
          Component = FormParams
          ComponentItem = 'SummaReceivedFactLabel'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_SummaReceivedFact: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'SummaReceivedFact'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'SummaAll'
          FromParam.DataType = ftFloat
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'SummaReceivedFact'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'SummaReceivedFact'
          ToParam.DataType = ftFloat
          ToParam.MultiSelectSeparator = ','
        end>
      AfterAction = actRefresh
      BeforeAction = actSummaDialogForm
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SummaReceivedFact
      StoredProcList = <
        item
          StoredProc = spUpdate_SummaReceivedFact
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1057#1091#1084#1084#1072' '#1087#1086#1083#1091#1095#1077#1085#1086' '#1087#1086' '#1092#1072#1082#1090#1091'>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1057#1091#1084#1084#1072' '#1087#1086#1083#1091#1095#1077#1085#1086' '#1087#1086' '#1092#1072#1082#1090#1091'>'
      ImageIndex = 56
    end
    object actInputCommentChecking: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actSummaDialogForm'
      FormName = 'TStringDialogForm'
      FormNameParam.Value = 'TStringDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Text'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'CommentChecking'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1057#1091#1084#1084#1072' '#1087#1086#1083#1091#1095#1077#1085#1086' '#1087#1086' '#1092#1072#1082#1090#1091
          Component = FormParams
          ComponentItem = 'CommentCheckingLabel'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_CommentChecking: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'CommentChecking'
          FromParam.Value = Null
          FromParam.Component = JackdawsCheckCDS
          FromParam.ComponentItem = 'CommentChecking'
          FromParam.DataType = ftString
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'CommentChecking'
          ToParam.Value = 0.000000000000000000
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'CommentChecking'
          ToParam.DataType = ftString
          ToParam.MultiSelectSeparator = ','
        end>
      AfterAction = actRefresh
      BeforeAction = actInputCommentChecking
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CommentChecking
      StoredProcList = <
        item
          StoredProc = spUpdate_CommentChecking
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1088#1086#1074#1077#1088#1103#1102#1097#1077#1081'>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1088#1086#1074#1077#1088#1103#1102#1097#1077#1081'>'
      ImageIndex = 43
    end
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Check_JackdawsSum'
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
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
        Name = 'inUnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 88
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
          ItemName = 'bbExecuteDialog'
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
          ItemName = 'bbGridToExcel'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
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
          ItemName = 'bbUpdate_CommentChecking'
        end>
    end
    object bbOpenDocument: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Visible = ivAlways
      ImageIndex = 28
      ShortCut = 115
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbUpdateDateCompensation: TdxBarButton
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080
      Category = 0
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080
      Visible = ivAlways
      ImageIndex = 43
    end
    object dxBarButton1: TdxBarButton
      Caption = #1053#1077#1076#1086#1082#1086#1084#1077#1085#1089#1072#1094#1080#1080' '#1087#1086' '#1044#1055
      Category = 0
      Hint = #1053#1077#1076#1086#1082#1086#1084#1077#1085#1089#1072#1094#1080#1080' '#1087#1086' '#1044#1055
      Visible = ivAlways
      ImageIndex = 29
    end
    object dxBarButton2: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actUpdate_RetrievedAccounting
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actUpdate_SummaReceivedFact
      Category = 0
    end
    object bbUpdate_CommentChecking: TdxBarButton
      Action = actUpdate_CommentChecking
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ColorColumn = RetrievedAccounting
        BackGroundValueColumn = ColorRA_calc
        ColorValueList = <>
      end>
  end
  inherited PopupMenu: TPopupMenu
    Left = 168
    Top = 248
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 32
    Top = 152
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
    Left = 128
    Top = 144
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 42491d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 42491d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaReceivedFact'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaReceivedFactLabel'
        Value = #1057#1091#1084#1084#1072' '#1087#1086#1083#1091#1095#1077#1085#1086' '#1087#1086' '#1092#1072#1082#1090#1091
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Json'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CommentChecking'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CommentCheckingLabel'
        Value = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1088#1086#1074#1077#1088#1103#1102#1097#1077#1081
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 232
    Top = 176
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 24
  end
  object spJackdawsCheck: TdsdStoredProc
    StoredProcName = 'gpReport_Check_JackdawsCheck'
    DataSet = JackdawsCheckCDS
    DataSets = <
      item
        DataSet = JackdawsCheckCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 42491d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42491d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 96
    Top = 456
  end
  object JackdawsCheckDS: TDataSource
    DataSet = JackdawsCheckCDS
    Left = 64
    Top = 456
  end
  object JackdawsCheckCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'OperDateDay;UnitID'
    MasterFields = 'OperDate;UnitID'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 32
    Top = 456
  end
  object DBViewAddOnCh: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <
      item
        Action = actUpdate
      end>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 496
    Top = 464
  end
  object spUpdate_RetrievedAccounting: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_RetrievedAccountingRevert'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = JackdawsCheckCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisRetrievedAccounting'
        Value = False
        Component = JackdawsCheckCDS
        ComponentItem = 'isRetrievedAccounting'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 658
    Top = 456
  end
  object spUpdate_SummaReceivedFact: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_SummaReceivedFact'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inSummaReceivedFact'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'SummaReceivedFact'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJson'
        Value = Null
        Component = FormParams
        ComponentItem = 'Json'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 658
    Top = 512
  end
  object spUpdate_RetrievedAccountingCDC: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_RetrievedAccounting'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = JackdawsCheckCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isisRetrievedAccounting'
        Value = Null
        Component = JackdawsCheckCDS
        ComponentItem = 'isRetrievedAccounting'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTotalSumm'
        Value = Null
        Component = JackdawsCheckCDS
        ComponentItem = 'TotalSumm'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummaReceivedFact'
        Value = Null
        Component = JackdawsCheckCDS
        ComponentItem = 'SummaReceivedFact'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioRetrievedAccounting'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RetrievedAccounting'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummaReceived'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummaReceived'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummaReceivedDelta'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummaReceivedDelta'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 842
    Top = 456
  end
  object spUpdate_CommentChecking: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_Update_CommentChecking'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = JackdawsCheckCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCommentChecking'
        Value = Null
        Component = FormParams
        ComponentItem = 'CommentChecking'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 298
    Top = 456
  end
end
