inherited Report_Promo_DetailErrorForm: TReport_Promo_DetailErrorForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1040#1082#1094#1080#1103#1084' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#1088#1072#1089#1095#1077#1090#1072' '#1060#1072#1082#1090#1072' '#1087#1088#1086#1076#1072#1078'>'
  ClientHeight = 347
  ClientWidth = 776
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 792
  ExplicitHeight = 386
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 56
    Width = 776
    Height = 291
    TabOrder = 3
    ExplicitTop = 56
    ExplicitWidth = 776
    ExplicitHeight = 324
    ClientRectBottom = 291
    ClientRectRight = 776
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 776
      ExplicitHeight = 324
      inherited cxGrid: TcxGrid
        Width = 776
        Height = 291
        ExplicitLeft = 16
        ExplicitTop = -20
        ExplicitWidth = 776
        ExplicitHeight = 291
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRealWeight_det
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOutWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOutWeight_det
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRealWeight_det
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOutWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOutWeight_det
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = InvNumber
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRealWeight
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object MovementDescName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'.'
            DataBinding.FieldName = 'MovementDescName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 118
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 130
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 142
          end
          object isOut: TcxGridDBColumn
            Caption = #1054#1090#1082#1083'. '#1087#1086' '#1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078#1077
            DataBinding.FieldName = 'isOut'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1087#1086' '#1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078#1077
            Width = 103
          end
          object isReal: TcxGridDBColumn
            Caption = #1054#1090#1082#1083'. '#1087#1086' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076#1091
            DataBinding.FieldName = 'isReal'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1087#1086' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076#1091
            Width = 82
          end
          object isOperDate: TcxGridDBColumn
            Caption = #1040#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076' '#1087#1086#1089#1083#1077' '#1076#1072#1090#1099' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'isOperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076' '#1087#1086#1089#1083#1077' '#1076#1072#1090#1099' '#1086#1090#1075#1088#1091#1079#1082#1080
            Width = 121
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 252
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1087#1088#1080' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080' '#1072#1082#1094#1080#1080')'
            Options.Editing = False
            Width = 90
          end
          object GoodsKindCompleteName: TcxGridDBColumn
            Caption = #1042#1080#1076' ('#1087#1088#1080#1084#1077#1095#1072#1085#1080#1077')'
            DataBinding.FieldName = 'GoodsKindCompleteName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1087#1088#1080#1084#1077#1095#1072#1085#1080#1077')'
            Options.Editing = False
            Width = 85
          end
          object GoodsWeight: TcxGridDBColumn
            Caption = #1042#1077#1089
            DataBinding.FieldName = 'GoodsWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object AmountRealWeight: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1084' '#1087#1088#1086#1076#1072#1078' '#1074' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076', '#1074#1077#1089
            DataBinding.FieldName = 'AmountRealWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1073#1098#1077#1084' '#1087#1088#1086#1076#1072#1078' '#1074' '#1072#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1087#1077#1088#1080#1086#1076', '#1074#1077#1089' ('#1080#1090#1086#1075#1086')'
            Options.Editing = False
            Width = 104
          end
          object AmountRealWeight_det: TcxGridDBColumn
            Caption = '*'#1054#1073#1098#1077#1084' '#1087#1088#1086#1076#1072#1078' '#1074' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076', '#1074#1077#1089
            DataBinding.FieldName = 'AmountRealWeight_det'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1073#1098#1077#1084' '#1087#1088#1086#1076#1072#1078' '#1074' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076', '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
            Options.Editing = False
            Width = 104
          end
          object AmountOutWeight: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1103' ('#1092#1072#1082#1090'), '#1074#1077#1089
            DataBinding.FieldName = 'AmountOutWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1073#1098#1077#1084' '#1087#1088#1086#1076#1072#1078' '#1074' '#1072#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1087#1077#1088#1080#1086#1076', '#1074#1077#1089' ('#1080#1090#1086#1075#1086')'
            Options.Editing = False
            Width = 104
          end
          object AmountOutWeight_det: TcxGridDBColumn
            Caption = '*'#1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1103' ('#1092#1072#1082#1090'), '#1074#1077#1089
            DataBinding.FieldName = 'AmountOutWeight_det'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1087#1086' '#1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1103' ('#1092#1072#1082#1090'), '#1084#1077#1089#1103#1094#1072#1084
            Options.Editing = False
            Width = 104
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 776
    Height = 30
    ExplicitWidth = 776
    ExplicitHeight = 30
    inherited deStart: TcxDateEdit
      Left = 118
      EditValue = 43101d
      Properties.SaveTime = False
      ExplicitLeft = 118
    end
    inherited deEnd: TcxDateEdit
      Left = 334
      EditValue = 43101d
      Properties.SaveTime = False
      ExplicitLeft = 334
    end
    inherited cxLabel1: TcxLabel
      Left = 25
      ExplicitLeft = 25
    end
    inherited cxLabel2: TcxLabel
      Left = 220
      ExplicitLeft = 220
    end
    object cbGoods: TcxCheckBox
      Left = 443
      Top = 6
      Action = actRefreshGoods
      Caption = #1087#1086' '#1090#1086#1074#1072#1088#1072#1084
      TabOrder = 4
      Width = 94
    end
  end
  inherited ActionList: TActionList
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'MovementDescName_order;OperDate;ObjectByName;InvNumber'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isSumm_branch'
          Value = Null
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TDatePeriodDialogForm'
      FormNameParam.Value = 'TDatePeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inStartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
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
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementForm
      StoredProcList = <
        item
          StoredProc = getMovementForm
        end>
      Caption = 'actGetForm'
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
        end
        item
          Name = 'inChangePercentAmount'
          Value = 0.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetForm
        end
        item
          Action = actOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 28
    end
    object actOpenFormPromo_MI_Detail: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      ImageIndex = 24
      FormName = 'TPromo_MI_DetailForm'
      FormNameParam.Value = 'TPromo_MI_DetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          Component = MasterCDS
          ComponentItem = 'MovementId'
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
          Value = 42132d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMask'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsertUpdate_MI_Promo_Detail: TdsdExecStoredProc
      Category = 'Update_MI_Detail'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_MI_Promo_Detail
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_MI_Promo_Detail
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      ImageIndex = 38
    end
    object macInsertUpdate_list: TMultiAction
      Category = 'Update_MI_Detail'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdate_MI_Promo_Detail
        end>
      View = cxGridDBTableView
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      ImageIndex = 38
    end
    object macInsertUpdate: TMultiAction
      Category = 'Update_MI_Detail'
      MoveParams = <>
      ActionList = <
        item
          Action = macInsertUpdate_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1087#1086' '#1042#1057#1045#1052' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' '#1076#1072#1085#1085#1099#1077' '#1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      InfoAfterExecute = #1076#1072#1085#1085#1099#1077' '#1087#1077#1088#1077#1089#1095#1080#1090#1072#1085#1099
      Caption = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      Hint = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      ImageIndex = 38
    end
    object actRefreshGoods: TdsdDataSetRefresh
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
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Promo_DetailError'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoods'
        Value = False
        Component = cbGoods
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 144
    Top = 208
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenDocument'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenFormPromo_MI_Detail'
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
          ItemName = 'bbInsertUpdate'
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
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbOpenDocument: TdxBarButton
      Action = actOpenDocument
      Category = 0
    end
    object bbOpenFormPromo_MI_Detail: TdxBarButton
      Action = actOpenFormPromo_MI_Detail
      Category = 0
    end
    object bbInsertUpdate: TdxBarButton
      Action = macInsertUpdate
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 368
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 80
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 184
    Top = 136
  end
  object getMovementForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 456
    Top = 152
  end
  object TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 120
  end
  object TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 120
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'FormName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate'
        Value = 43101d
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 43101d
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitGroupId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitGroupName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LocationId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'LocationName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsPartner'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 200
  end
  object spInsertUpdate_MI_Promo_Detail: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Promo_Detail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 488
    Top = 227
  end
end
