inherited Report_Movement_Send_RemainsSun_Supplement_v2Form: TReport_Movement_Send_RemainsSun_Supplement_v2Form
  Caption = #1054#1090#1095#1077#1090' <'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1103' '#1074' '#1057#1059#1053' v.2>'
  ClientHeight = 673
  ClientWidth = 960
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 976
  ExplicitHeight = 712
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 960
    Height = 614
    TabOrder = 2
    ExplicitTop = 59
    ExplicitWidth = 960
    ExplicitHeight = 614
    ClientRectBottom = 614
    ClientRectRight = 960
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 960
      ExplicitHeight = 614
      inherited cxGrid: TcxGrid
        Width = 960
        Height = 614
        ExplicitWidth = 960
        ExplicitHeight = 614
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
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
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = Summa_From
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = Summa_To
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Position = spFooter
              Column = Summa_From
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Position = spFooter
              Column = Summa_To
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = Summa_From
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = Summa_To
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsView.Footer = True
          OptionsView.HeaderHeight = 50
          Bands = <
            item
              Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
            end
            item
              Caption = #1056#1072#1089#1095#1077#1090' '#1086#1090#1082#1091#1076#1072
            end
            item
              Caption = #1056#1072#1089#1095#1077#1090' '#1082#1091#1076#1072
            end>
          object GoodsCode: TcxGridDBBandedColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object GoodsName: TcxGridDBBandedColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 137
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object UnitName_From: TcxGridDBBandedColumn
            Caption = #1054#1090#1082#1091#1076#1072
            DataBinding.FieldName = 'UnitName_From'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 127
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object UnitName_To: TcxGridDBBandedColumn
            Caption = #1050#1091#1076#1072
            DataBinding.FieldName = 'UnitName_To'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 155
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object Amount: TcxGridDBBandedColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object Summa_From: TcxGridDBBandedColumn
            Caption = #1057#1091#1084#1084#1072' '#1074' '#1094#1077#1085#1072#1093' '#1086#1090#1087#1088#1072#1074#1080#1077#1083#1103
            DataBinding.FieldName = 'Summa_From'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1074' '#1094#1077#1085#1072#1093' '#1086#1090#1087#1088#1072#1074#1080#1077#1083#1103
            Options.Editing = False
            Width = 82
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
          object Summa_To: TcxGridDBBandedColumn
            Caption = #1057#1091#1084#1084#1072' '#1074' '#1094#1077#1085#1072#1093' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
            DataBinding.FieldName = 'Summa_To'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1074' '#1094#1077#1085#1072#1093' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
            Options.Editing = False
            Width = 79
            Position.BandIndex = 0
            Position.ColIndex = 7
            Position.RowIndex = 0
          end
          object MinExpirationDate: TcxGridDBBandedColumn
            Caption = #1052#1080#1085' '#1089#1088#1086#1082' '#1086#1089#1090#1072#1090#1082#1072
            DataBinding.FieldName = 'MinExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
            Position.BandIndex = 0
            Position.ColIndex = 8
            Position.RowIndex = 0
          end
          object MCS_From: TcxGridDBBandedColumn
            Caption = #1053#1058#1047
            DataBinding.FieldName = 'MCS_From'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 46
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object isClose: TcxGridDBBandedColumn
            Caption = #1047#1072#1082#1088#1099#1090' '#1087#1086' '#1089#1077#1090#1080
            DataBinding.FieldName = 'isClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object Layout_From: TcxGridDBBandedColumn
            Caption = #1042#1099#1082#1083#1072#1076#1082#1072
            DataBinding.FieldName = 'Layout_From'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
            Position.BandIndex = 1
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object PromoUnit_From: TcxGridDBBandedColumn
            Caption = #1052#1072#1088#1082'. '#1087#1083#1072#1085' '#1090#1086#1095#1082#1080
            DataBinding.FieldName = 'PromoUnit_From'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 56
            Position.BandIndex = 1
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object AmountRemains_From: TcxGridDBBandedColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'AmountRemains_From'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
            Position.BandIndex = 1
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object AmountSalesDey_From: TcxGridDBBandedColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072' '#1076#1085#1077#1081' '#1086#1090#1082#1091#1076#1072
            DataBinding.FieldName = 'AmountSalesDey_From'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 1
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object Give_From: TcxGridDBBandedColumn
            Caption = #1042#1086#1079#1084#1086#1078#1085#1086' '#1086#1090#1076#1072#1090#1100
            DataBinding.FieldName = 'Give_From'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 1
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
          object isCloseMCS_From: TcxGridDBBandedColumn
            Caption = #1059#1073#1080#1090#1100' '#1082#1086#1076
            DataBinding.FieldName = 'isCloseMCS_From'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
            Position.BandIndex = 1
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object MCS_To: TcxGridDBBandedColumn
            Caption = #1053#1058#1047
            DataBinding.FieldName = 'MCS_To'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 2
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object AmountRemains_To: TcxGridDBBandedColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'AmountRemains_To'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 2
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object AmountSalesDey_To: TcxGridDBBandedColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072' '#1076#1085#1077#1081' '#1082#1091#1076#1072
            DataBinding.FieldName = 'AmountSalesDey_To'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 2
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object Need_To: TcxGridDBBandedColumn
            Caption = #1055#1086#1090#1088#1077#1073#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'Need_To'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 2
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object isCloseMCS_To: TcxGridDBBandedColumn
            Caption = #1059#1073#1080#1090#1100' '#1082#1086#1076
            DataBinding.FieldName = 'isCloseMCS_To'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
            Position.BandIndex = 2
            Position.ColIndex = 1
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
    Width = 960
    Height = 33
    TabOrder = 4
    ExplicitWidth = 960
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 29
      EditValue = 43466d
      ExplicitLeft = 29
    end
    inherited deEnd: TcxDateEdit
      Left = 173
      EditValue = 43466d
      TabOrder = 2
      Visible = False
      ExplicitLeft = 173
    end
    inherited cxLabel1: TcxLabel
      Caption = #1057':'
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 149
      Caption = #1087#1086':'
      Visible = False
      ExplicitLeft = 149
      ExplicitWidth = 20
    end
    object ceDeySupplOutSUN2: TcxCurrencyEdit
      Left = 436
      Top = 5
      TabStop = False
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 121
    end
    object cxLabel27: TcxLabel
      Left = 316
      Top = 6
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1076#1085#1077#1081' '#1086#1090#1082#1091#1076#1072
    end
    object ceDeySupplInSUN2: TcxCurrencyEdit
      Left = 707
      Top = 5
      TabStop = False
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 121
    end
    object cxLabel26: TcxLabel
      Left = 595
      Top = 6
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1076#1085#1077#1081' '#1082#1091#1076#1072
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 91
    Top = 256
  end
  inherited ActionList: TActionList
    Left = 103
    Top = 287
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end>
    end
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
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
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actRefreshOnDay: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1044#1085#1103#1084
      Hint = #1087#1086' '#1044#1085#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actSendSUN: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSendSUN
      StoredProcList = <
        item
          StoredProc = spSendSUN
        end>
      Caption = 'actSendSUN'
      ImageIndex = 41
    end
    object macSendSUN: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSendSUN
        end>
      QuestionBeforeExecute = 
        #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' '#1044#1086#1087#1086#1083#1085#1077#1085#1080#1103' '#1074' '#1057 +
        #1059#1053' v.1>? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' <'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1103' '#1074' '#1057#1059#1053' v.2> '#1089#1086#1079#1076#1072#1085#1099
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1103' '#1074' '#1057#1059#1053' v.2>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1103' '#1074' '#1057#1059#1053' v.2>'
      ImageIndex = 41
    end
    object actOpenReportPartionDateForm: TdsdOpenForm
      Category = 'Report'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1089#1088#1086#1082#1086#1074#1099#1093' '#1090#1086#1074#1072#1088#1086#1074'>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1089#1088#1086#1082#1086#1074#1099#1093' '#1090#1086#1074#1072#1088#1086#1074'>'
      ImageIndex = 24
      FormName = 'TReport_GoodsPartionDateForm'
      FormNameParam.Value = 'TReport_GoodsPartionDateForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'UnitId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsDetail'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenReportPartionHistoryForm: TdsdOpenForm
      Category = 'Report'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1076#1074#1080#1078#1077#1085#1080#1102' '#1087#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1072'>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1086' '#1076#1074#1080#1078#1077#1085#1080#1102' '#1087#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1072'>'
      ImageIndex = 25
      FormName = 'TReport_GoodsPartionHistoryForm'
      FormNameParam.Value = 'TReport_GoodsPartionHistoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'UnitId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartion'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyId'
          Value = '0'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenReportPartionDateChild: TdsdOpenForm
      Category = 'Report'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1089#1088#1086#1082#1086#1074#1099#1093' '#1090#1086#1074#1072#1088#1086#1074'> ('#1089#1088#1086#1082#1080')'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1089#1088#1086#1082#1086#1074#1099#1093' '#1090#1086#1074#1072#1088#1086#1074'> ('#1089#1088#1086#1082#1080')'
      ImageIndex = 24
      FormName = 'TReport_GoodsPartionDateForm'
      FormNameParam.Value = 'TReport_GoodsPartionDateForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsDetail'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenReportPartionHistoryChild: TdsdOpenForm
      Category = 'Report'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1076#1074#1080#1078#1077#1085#1080#1102' '#1087#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1072'> ('#1089#1088#1086#1082#1080')'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1086' '#1076#1074#1080#1078#1077#1085#1080#1102' '#1087#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1072'> ('#1089#1088#1086#1082#1080')'
      ImageIndex = 25
      FormName = 'TReport_GoodsPartionHistoryForm'
      FormNameParam.Value = 'TReport_GoodsPartionHistoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartion'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyId'
          Value = '0'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReportSendSUN: TdsdOpenForm
      Category = 'Report'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1086#1073#1085#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053
      Hint = #1055#1086#1076#1088#1086#1073#1085#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053
      ImageIndex = 26
      FormName = 'TReport_GoodsSendSUNForm'
      FormNameParam.Value = 'TReport_GoodsSendSUNForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42132d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42132d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'UnitId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 120
    Top = 168
  end
  inherited MasterCDS: TClientDataSet
    Left = 48
    Top = 160
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Movement_Send_RemainsSun_Supplement_v2'
    Params = <
      item
        Name = 'inOperDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 216
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
          ItemName = 'bbSendSUN'
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
    object dxBarButton1: TdxBarButton
      Caption = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Category = 0
      Hint = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Visible = ivAlways
      ImageIndex = 38
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      Category = 0
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      Visible = ivAlways
      ImageIndex = 3
      ShortCut = 16464
    end
    object bbSendSUN: TdxBarButton
      Action = macSendSUN
      Category = 0
    end
    object bbReportPartionDate: TdxBarButton
      Action = actOpenReportPartionDateForm
      Category = 0
    end
    object bbReportPartionHistory: TdxBarButton
      Action = actOpenReportPartionHistoryForm
      Category = 0
    end
    object bbOpenReportPartionHistoryChild: TdxBarButton
      Action = actOpenReportPartionHistoryChild
      Category = 0
    end
    object bbOpenReportPartionDateChild: TdxBarButton
      Action = actOpenReportPartionDateChild
      Category = 0
    end
    object bbReportSendSUN: TdxBarButton
      Action = actReportSendSUN
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    View = cxGridDBBandedTableView1
    Left = 272
    Top = 184
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
  end
  inherited PeriodChoice: TPeriodChoice
    DateStart = nil
    DateEnd = nil
    Left = 408
    Top = 168
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 464
    Top = 216
  end
  object rdUnit: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
      end>
    Left = 560
    Top = 32
  end
  object spGet_UserUnit: TdsdStoredProc
    StoredProcName = 'gpGet_UserUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 472
    Top = 24
  end
  object spSendSUN: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_Send_RemainsSun_Supplement_v2'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 184
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_CashSettings'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ShareFromPriceName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShareFromPriceCode'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGetHardwareData'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateBanSUN'
        Value = 42993d
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaFormSendVIP'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaUrgentlySendVIP'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DaySaleForSUN'
        Value = 0.000000000000000000
        MultiSelectSeparator = ','
      end
      item
        Name = 'DayNonCommoditySUN'
        Value = 0.000000000000000000
        MultiSelectSeparator = ','
      end
      item
        Name = 'isBlockVIP'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPairedOnlyPromo'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AttemptsSub'
        Value = 0.000000000000000000
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpperLimitPromoBonus'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LowerLimitPromoBonus'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MinPercentPromoBonus'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DayCompensDiscount'
        Value = 0.000000000000000000
        MultiSelectSeparator = ','
      end
      item
        Name = 'MethodsAssortmentId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MethodsAssortmentName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AssortmentGeograph'
        Value = 0.000000000000000000
        MultiSelectSeparator = ','
      end
      item
        Name = 'AssortmentSales'
        Value = 0.000000000000000000
        MultiSelectSeparator = ','
      end
      item
        Name = 'CustomerThreshold'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceCorrectionDay'
        Value = 0.000000000000000000
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRequireUkrName'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRemovingPrograms'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceSamples'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Samples21'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Samples22'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Samples3'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TelegramBotToken'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentIC'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentUntilNextSUN'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEliminateColdSUN'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'TurnoverMoreSUN2'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DeySupplOutSUN2'
        Value = 0.000000000000000000
        Component = ceDeySupplOutSUN2
        MultiSelectSeparator = ','
      end
      item
        Name = 'DeySupplInSUN2'
        Value = 0.000000000000000000
        Component = ceDeySupplInSUN2
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 280
    Top = 256
  end
end
