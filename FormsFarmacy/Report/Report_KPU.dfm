inherited Report_KPUForm: TReport_KPUForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1050#1055#1059
  ClientHeight = 504
  ClientWidth = 940
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 956
  ExplicitHeight = 543
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 940
    Height = 447
    ExplicitWidth = 940
    ExplicitHeight = 447
    ClientRectBottom = 447
    ClientRectRight = 940
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 940
      ExplicitHeight = 447
      inherited cxGrid: TcxGrid
        Width = 940
        Height = 447
        ExplicitWidth = 940
        ExplicitHeight = 447
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
        object cxGridDBBandedTableView1: TcxGridDBBandedTableView [1]
          Navigator.Buttons.CustomButtons = <>
          Navigator.Buttons.First.Visible = True
          Navigator.Buttons.PriorPage.Visible = True
          Navigator.Buttons.Prior.Visible = True
          Navigator.Buttons.Next.Visible = True
          Navigator.Buttons.NextPage.Visible = True
          Navigator.Buttons.Last.Visible = True
          Navigator.Buttons.Insert.Visible = True
          Navigator.Buttons.Append.Visible = False
          Navigator.Buttons.Delete.Visible = True
          Navigator.Buttons.Edit.Visible = True
          Navigator.Buttons.Post.Visible = True
          Navigator.Buttons.Cancel.Visible = True
          Navigator.Buttons.Refresh.Visible = True
          Navigator.Buttons.SaveBookmark.Visible = True
          Navigator.Buttons.GotoBookmark.Visible = True
          Navigator.Buttons.Filter.Visible = True
          DataController.DataSource = MasterDS
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
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = UserName
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsBehavior.IncSearch = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          Bands = <
            item
              Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
              Width = 481
            end
            item
              Caption = #1042#1099#1087#1086#1083#1085#1077#1085#1080#1077' '#1087#1083#1072#1085#1072' '#1087#1086' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1091
              Width = 256
            end
            item
              Caption = #1057#1088#1077#1076#1085#1080#1081' '#1095#1077#1082
            end
            item
              Caption = #1042#1088#1077#1084#1103
              Width = 66
            end
            item
              Caption = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1087#1083#1072#1085
              Width = 153
            end
            item
              Caption = #1069#1082#1079#1072#1084#1077#1085' IT'
            end
            item
              Caption = #1046#1072#1083#1086#1073#1099' '#1086#1090' '#1082#1083#1080#1077#1085#1090#1086#1074
              Width = 202
            end
            item
              Caption = #1044#1080#1088#1077#1082#1090#1086#1088
            end
            item
              Caption = #1050#1086#1083#1083#1077#1075#1080#1103' IT'
              Width = 353
            end
            item
              Caption = 'VIP '#1086#1090#1076#1077#1083
            end
            item
              Caption = #1050#1086#1085#1090#1088#1086#1083#1100' '#1058'.'#1042'. '#1080' '#1058'.'#1040'.'
            end>
          object UserCode: TcxGridDBBandedColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UserCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 28
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object UserName: TcxGridDBBandedColumn
            Caption = #1060#1072#1084#1080#1083#1080#1103' '#1048'.'#1054'.'
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 137
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object PositionName: TcxGridDBBandedColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object DateIn: TcxGridDBBandedColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1080#1077#1084#1072
            DataBinding.FieldName = 'DateIn'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 69
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object UnitName: TcxGridDBBandedColumn
            Caption = #1040#1087#1090#1077#1082#1072' ('#1086#1089#1085#1086#1074#1085#1072#1103')'
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 148
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object KPU: TcxGridDBBandedColumn
            Caption = #1050#1055#1059
            DataBinding.FieldName = 'KPU'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 32
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object FactOfManDays: TcxGridDBBandedColumn
            Caption = #1054#1090#1088'. '#1076#1085#1077#1081
            DataBinding.FieldName = 'FactOfManDays'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object BonusAmountTab: TcxGridDBBandedColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1077#1084#1080#1080
            DataBinding.FieldName = 'BonusAmountTab'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
            Position.BandIndex = 1
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object AmountTheFineTab: TcxGridDBBandedColumn
            Caption = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072
            DataBinding.FieldName = 'AmountTheFineTab'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 79
            Position.BandIndex = 1
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object MarkRatio: TcxGridDBBandedColumn
            Caption = #1050#1086#1101#1092'.'
            DataBinding.FieldName = 'MarkRatio'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taRightJustify
            Width = 45
            Position.BandIndex = 1
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object PrevAverageCheck: TcxGridDBBandedColumn
            Caption = #1087#1088#1086#1096#1083#1099#1081' '#1084#1077#1089#1103#1094
            DataBinding.FieldName = 'PrevAverageCheck'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Position.BandIndex = 2
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object AverageCheck: TcxGridDBBandedColumn
            Caption = #1090#1077#1082#1091#1097#1080#1081' '#1084#1077#1089#1103#1094
            DataBinding.FieldName = 'AverageCheck'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 2
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object AverageCheckRatio: TcxGridDBBandedColumn
            Caption = #1050#1086#1101#1092'.'
            DataBinding.FieldName = 'AverageCheckRatio'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 1
            Properties.DisplayFormat = ',0.0'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
            Position.BandIndex = 2
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object LateTimeRatio: TcxGridDBBandedColumn
            Caption = #1086#1087#1086#1079#1076#1072#1085#1080#1103
            DataBinding.FieldName = 'LateTimeRatio'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 61
            Position.BandIndex = 3
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object FinancPlan: TcxGridDBBandedColumn
            Caption = #1055#1083#1072#1085
            DataBinding.FieldName = 'FinancPlan'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
            Position.BandIndex = 4
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object FinancPlanFact: TcxGridDBBandedColumn
            Caption = #1060#1072#1082#1090
            DataBinding.FieldName = 'FinancPlanFact'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
            Position.BandIndex = 4
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object FinancPlanRatio: TcxGridDBBandedColumn
            Caption = #1050#1086#1101#1092'.'
            DataBinding.FieldName = 'FinancPlanRatio'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 37
            Position.BandIndex = 4
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object CorrectAnswers: TcxGridDBBandedColumn
            Caption = #1055#1088#1072#1074'. '#1086#1090#1074#1077#1090#1086#1074
            DataBinding.FieldName = 'CorrectAnswers'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
            Position.BandIndex = 5
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object ExamPercentage: TcxGridDBBandedColumn
            Caption = #1055#1088#1086#1094#1077#1085#1090' '#1087#1088#1072#1074#1077#1083#1085'.'
            DataBinding.FieldName = 'ExamPercentage'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
            Position.BandIndex = 5
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object NumberAttempts: TcxGridDBBandedColumn
            Caption = #1050#1086#1083#1074#1086' '#1087#1086#1087#1099#1090#1086#1082
            DataBinding.FieldName = 'NumberAttempts'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
            Position.BandIndex = 5
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object ExamResult: TcxGridDBBandedColumn
            Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090' '#1101#1082#1079#1072#1084'.'
            DataBinding.FieldName = 'ExamResult'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
            Position.BandIndex = 5
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object IT_ExamRatio: TcxGridDBBandedColumn
            Caption = #1050#1086#1101#1092'.'
            DataBinding.FieldName = 'IT_ExamRatio'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 39
            Position.BandIndex = 5
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object ComplaintsRatio: TcxGridDBBandedColumn
            Caption = #1050#1086#1101#1092'.'
            DataBinding.FieldName = 'ComplaintsRatio'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 39
            Position.BandIndex = 6
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object ComplaintsNote: TcxGridDBBandedColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'ComplaintsNote'
            PropertiesClassName = 'TcxMemoProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 162
            Position.BandIndex = 6
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object DirectorRatio: TcxGridDBBandedColumn
            Caption = #1050#1086#1101#1092'.'
            DataBinding.FieldName = 'DirectorRatio'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 39
            Position.BandIndex = 7
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object DirectorNote: TcxGridDBBandedColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'DirectorNote'
            PropertiesClassName = 'TcxMemoProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 178
            Position.BandIndex = 7
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object YuriIT: TcxGridDBBandedColumn
            Caption = #1070#1088#1080#1081' IT'
            DataBinding.FieldName = 'YuriIT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 36
            Position.BandIndex = 8
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object OlegIT: TcxGridDBBandedColumn
            Caption = #1054#1083#1077#1075' IT'
            DataBinding.FieldName = 'OlegIT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 34
            Position.BandIndex = 8
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object MaximIT: TcxGridDBBandedColumn
            Caption = #1052#1072#1082#1089#1080#1084' IT'
            DataBinding.FieldName = 'MaximIT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
            Position.BandIndex = 8
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object CollegeITRatio: TcxGridDBBandedColumn
            Caption = #1050#1086#1101#1092'.'
            DataBinding.FieldName = 'CollegeITRatio'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 36
            Position.BandIndex = 8
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object CollegeITNote: TcxGridDBBandedColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'CollegeITNote'
            PropertiesClassName = 'TcxMemoProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 206
            Position.BandIndex = 8
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object VIPDepartRatio: TcxGridDBBandedColumn
            Caption = #1050#1086#1101#1092'.'
            DataBinding.FieldName = 'VIPDepartRatio'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 38
            Position.BandIndex = 9
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object VIPDepartRatioNote: TcxGridDBBandedColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'VIPDepartRatioNote'
            PropertiesClassName = 'TcxMemoProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 190
            Position.BandIndex = 9
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object Romanova: TcxGridDBBandedColumn
            Caption = #1056#1086#1084#1072#1085#1086#1074#1072' '#1058'.'#1042'.'
            DataBinding.FieldName = 'Romanova'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
            Position.BandIndex = 10
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object Golovko: TcxGridDBBandedColumn
            Caption = #1043#1086#1083#1086#1074#1082#1086' '#1058'.'#1040'.'
            DataBinding.FieldName = 'Golovko'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
            Position.BandIndex = 10
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object ControlRGRatio: TcxGridDBBandedColumn
            Caption = #1050#1086#1101#1092'.'
            DataBinding.FieldName = 'ControlRGRatio'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 46
            Position.BandIndex = 10
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object ControlRGNote: TcxGridDBBandedColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'ControlRGNote'
            PropertiesClassName = 'TcxMemoProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 183
            Position.BandIndex = 10
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
        end
        inherited cxGridLevel: TcxGridLevel
          GridView = cxGridDBBandedTableView1
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 940
    ExplicitWidth = 940
    inherited deStart: TcxDateEdit
      EditValue = 42736d
      Properties.DisplayFormat = 'mmmm yyyy'
      Properties.EditFormat = 'dd.mm.yyyy'
      TabOrder = 1
      ExplicitWidth = 116
      Width = 116
    end
    inherited deEnd: TcxDateEdit
      Left = 535
      Top = 6
      EditValue = 42736d
      TabOrder = 0
      Visible = False
      ExplicitLeft = 535
      ExplicitTop = 6
    end
    inherited cxLabel1: TcxLabel
      Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090' '#1079#1072':'
      ExplicitWidth = 75
    end
    inherited cxLabel2: TcxLabel
      Left = 419
      Top = 7
      Visible = False
      ExplicitLeft = 419
      ExplicitTop = 7
    end
    object edRecount: TcxCheckBox
      Left = 243
      Top = 5
      Caption = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1076#1072#1085#1085#1099#1077
      TabOrder = 4
      Width = 142
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 75
    Top = 200
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 72
    Top = 248
  end
  inherited ActionList: TActionList
    Left = 175
    Top = 199
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
      FormNameParam.Value = ''
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
          Value = 'NULL'
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGetForm'
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TDataDialogForm'
      FormNameParam.Value = 'TDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 42736d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actUpdateMainDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMovementItem
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovementItem
        end>
      Caption = 'actUpdateMainDS'
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Left = 96
    Top = 96
  end
  inherited MasterCDS: TClientDataSet
    Left = 32
    Top = 96
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_KPU'
    Params = <
      item
        Name = 'inStartDate'
        Value = 'NULL'
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRecount'
        Value = Null
        Component = edRecount
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 96
  end
  inherited BarManager: TdxBarManager
    Left = 216
    Top = 96
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
        end>
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
      end>
  end
  inherited PopupMenu: TPopupMenu
    Left = 176
    Top = 248
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 72
    Top = 152
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 176
    Top = 152
  end
  object spInsertUpdateMovementItem: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_KPU'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ID'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outKPU'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'KPU'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMarkRatio'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MarkRatio'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAverageCheckRatio'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AverageCheckRatio'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLateTimeRatio'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'LateTimeRatio'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFinancPlanRatio'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FinancPlanRatio'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIT_ExamRatio'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IT_ExamRatio'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComplaintsRatio'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ComplaintsRatio'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComplaintsNote'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ComplaintsNote'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDirectorRatio'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DirectorRatio'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDirectorNote'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DirectorNote'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inYuriIT'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'YuriIT'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOlegIT'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OlegIT'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMaximIT'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MaximIT'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCollegeITRatio'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CollegeITRatio'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCollegeITNote'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CollegeITNote'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inVIPDepartRatio'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'VIPDepartRatio'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inVIPDepartRatioNote'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'VIPDepartRatioNote'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRomanova'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Romanova'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGolovko'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Golovko'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inControlRGRatio'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ControlRGRatio'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inControlRGNote'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ControlRGNote'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 338
    Top = 96
  end
end
