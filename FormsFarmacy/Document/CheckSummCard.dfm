inherited CheckSummCardForm: TCheckSummCardForm
  Caption = #1047#1072#1087#1086#1083#1077#1085#1080#1077' '#1087#1088#1077#1076#1086#1087#1083#1072#1090#1099' '#1085#1072' '#1082#1072#1088#1090#1091
  ClientHeight = 554
  ClientWidth = 925
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 941
  ExplicitHeight = 593
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 925
    Height = 495
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 925
    ExplicitHeight = 495
    ClientRectBottom = 495
    ClientRectRight = 925
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 925
      ExplicitHeight = 495
      inherited cxGrid: TcxGrid
        Width = 925
        Height = 495
        ExplicitWidth = 925
        ExplicitHeight = 495
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalCount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalCount
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colSummCard
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaDelivery
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = ApplicationAward
            end>
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
          end
          inherited colInvNumber: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 99
          end
          inherited colOperDate: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
          end
          object colUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 111
          end
          object colTotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'TotalCount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object colTotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object colSummCard: TcxGridDBColumn
            Caption = #1055#1088#1077#1076#1086#1087#1083#1072#1090#1072' ('#1092#1072#1082#1090#1080#1095#1077#1089#1082#1072#1103')'
            DataBinding.FieldName = 'SummCard'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Styles.Content = dmMain.cxHeaderL1Style
            Styles.Header = dmMain.cxHeaderL1Style
            Width = 104
          end
          object colBayer: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'Bayer'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object BayerPhone: TcxGridDBColumn
            Caption = #1058#1077#1083'. ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103')'
            DataBinding.FieldName = 'BayerPhone'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1085#1090#1072#1082#1090#1085#1099#1081' '#1090#1077#1083#1077#1092#1086#1085' ('#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103')'
            Options.Editing = False
            Width = 102
          end
          object colCashMember: TcxGridDBColumn
            Caption = #1052#1077#1085#1077#1076#1078#1077#1088
            DataBinding.FieldName = 'CashMember'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object isSite: TcxGridDBColumn
            Caption = #1063#1077#1088#1077#1079' '#1089#1072#1081#1090
            DataBinding.FieldName = 'isSite'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object InvNumberOrder: TcxGridDBColumn
            Caption = #8470' '#1079#1072#1082#1072#1079#1072' ('#1089#1072#1081#1090')'
            DataBinding.FieldName = 'InvNumberOrder'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1084#1077#1088' '#1079#1072#1082#1072#1079#1072' ('#1089' '#1089#1072#1081#1090#1072')'
            Options.Editing = False
            Width = 90
          end
          object ConfirmedKindName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072
            DataBinding.FieldName = 'ConfirmedKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1057#1086#1089#1090#1086#1103#1085#1080#1077' VIP-'#1095#1077#1082#1072')'
            Options.Editing = False
            Width = 80
          end
          object ConfirmedKindClientName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' '#1057#1052#1057
            DataBinding.FieldName = 'ConfirmedKindClientName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1054#1090#1087#1088#1072#1074#1083#1077#1085' '#1082#1083#1080#1077#1085#1090#1091')'
            Options.Editing = False
            Width = 102
          end
          object CheckSourceKindName: TcxGridDBColumn
            Caption = #1048#1089#1090#1086#1095#1085#1080#1082' '#1095#1077#1082#1072
            DataBinding.FieldName = 'CheckSourceKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object CancelReason: TcxGridDBColumn
            Caption = #1055#1088#1080#1095#1080#1085#1072' '#1086#1090#1082#1072#1079#1072
            DataBinding.FieldName = 'CancelReason'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 114
          end
          object isDeliverySite: TcxGridDBColumn
            Caption = 'H'#1072#1096#1072' '#1076#1086#1089#1090#1072#1074#1082#1072
            DataBinding.FieldName = 'isDeliverySite'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object SummaDelivery: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1076#1086#1089#1090#1072#1074#1082#1080
            DataBinding.FieldName = 'SummaDelivery'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object isCallOrder: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079' '#1087#1086' '#1079#1074#1086#1085#1082#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' ('#1055#1086#1095#1090#1072')'
            DataBinding.FieldName = 'isCallOrder'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object CommentCustomer: TcxGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '#1082#1083#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'CommentCustomer'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 103
          end
          object isMobileApplication: TcxGridDBColumn
            Caption = #1052#1086#1073'. '#1087#1088#1080#1083'.'
            DataBinding.FieldName = 'isMobileApplication'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object isConfirmByPhone: TcxGridDBColumn
            Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1090#1077#1083#1077#1092#1086#1085#1085#1099#1084' '#1079#1074#1086#1085#1082#1086#1084
            DataBinding.FieldName = 'isConfirmByPhone'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object DateComing: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076#1072' '#1074' '#1072#1087#1090#1077#1082#1091
            DataBinding.FieldName = 'DateComing'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object MobileDiscount: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' '#1089' '#1084#1086#1073#1080#1083#1100#1085#1086#1075#1086' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103
            DataBinding.FieldName = 'MobileDiscount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 92
          end
          object isMobileFirstOrder: TcxGridDBColumn
            Caption = #1055#1077#1088#1074#1072#1103' '#1087#1086#1082#1091#1087#1082#1072' '#1089' '#1084#1086#1073'. '#1087#1088#1080#1083'.'
            DataBinding.FieldName = 'isMobileFirstOrder'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object UserReferalsName: TcxGridDBColumn
            Caption = #1056#1077#1082#1086#1084'. '#1089#1086#1090#1088
            DataBinding.FieldName = 'UserReferalsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object UserUnitReferalsName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1085#1080#1077' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
            DataBinding.FieldName = 'UserUnitReferalsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 99
          end
          object ApplicationAward: TcxGridDBColumn
            Caption = #1044#1086#1087#1083#1072#1090#1072' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091' '#1079#1072' '#1084#1086#1073' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
            DataBinding.FieldName = 'ApplicationAward'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 94
          end
          object SiteWhoUpdate: TcxGridDBColumn
            Caption = #1050#1090#1086' '#1080#1079#1084#1077#1085#1080#1083' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'SiteWhoUpdate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object SiteDateUpdate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'SiteDateUpdate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 925
    Height = 33
    ExplicitWidth = 925
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      EditValue = 42370d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42370d
    end
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      Enabled = False
      FormName = 'TCheckForm'
      FormNameParam.Value = 'TCheckForm'
    end
    inherited actInsertMask: TdsdInsertUpdateAction
      Enabled = False
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TCheckForm'
      FormNameParam.Value = 'TCheckForm'
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
    inherited actComplete: TdsdChangeMovementStatus
      Enabled = False
    end
    inherited actUnComplete: TdsdChangeMovementStatus
      Enabled = False
    end
    inherited actSetErased: TdsdChangeMovementStatus
      Enabled = False
    end
    inherited mactReCompleteList: TMultiAction
      Enabled = False
    end
    inherited mactCompleteList: TMultiAction
      Enabled = False
    end
    inherited mactUnCompleteList: TMultiAction
      Enabled = False
    end
    inherited mactSetErasedList: TMultiAction
      Enabled = False
    end
    inherited mactSimpleReCompleteList: TMultiAction
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1087#1088#1086#1094#1077#1076#1091#1088#1091' '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1086#1090#1086#1073#1088#1072#1085#1085#1099#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'?'
    end
    inherited mactSimpleCompleteList: TMultiAction
      Enabled = False
    end
    inherited mactSimpleUncompleteList: TMultiAction
      Enabled = False
    end
    inherited mactSimpleErasedList: TMultiAction
      Enabled = False
    end
    inherited spCompete: TdsdExecStoredProc
      Enabled = False
    end
    inherited spUncomplete: TdsdExecStoredProc
      Enabled = False
    end
    inherited spErased: TdsdExecStoredProc
      Enabled = False
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
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
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
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMovement
      StoredProcList = <
        item
          StoredProc = spUpdateMovement
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object actCheckSiteInsert: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1047#1072#1082#1072#1079#1099' '#1089' '#1089#1072#1081#1090#1086#1074' '#1087#1086' '#1076#1072#1090#1077' '#1079#1072#1082#1072#1079#1072
      Hint = #1047#1072#1082#1072#1079#1099' '#1089' '#1089#1072#1081#1090#1086#1074' '#1087#1086' '#1076#1072#1090#1077' '#1079#1072#1082#1072#1079#1072
      ImageIndex = 29
      FormName = 'TCheckSiteInsertForm'
      FormNameParam.Value = 'TCheckSiteInsertForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_CheckSummCard'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
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
          ItemName = 'bbMovementItemContainer'
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
          ItemName = 'bbMovementProtocol'
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
    inherited bbInsert: TdxBarButton
      Visible = ivNever
    end
    inherited bbInsertMask: TdxBarButton
      Visible = ivNever
    end
    inherited bbComplete: TdxBarButton
      Visible = ivNever
    end
    inherited bbUnComplete: TdxBarButton
      Visible = ivNever
    end
    inherited bbDelete: TdxBarButton
      Visible = ivNever
    end
    object bbPrint: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      Visible = ivAlways
      ImageIndex = 3
    end
    object dxBarButton1: TdxBarButton
      Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1089#1091#1084#1084' '#1087#1086' '#1082#1072#1089#1089#1086#1074#1086#1084#1091' '#1072#1087#1087#1072#1088#1072#1090#1091
      Category = 0
      Hint = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1089#1091#1084#1084' '#1087#1086' '#1082#1072#1089#1089#1086#1074#1086#1084#1091' '#1072#1087#1087#1072#1088#1072#1090#1091
      Visible = ivAlways
      ImageIndex = 56
    end
    object dxBarButton2: TdxBarButton
      Action = actCheckSiteInsert
      Category = 0
    end
  end
  inherited PopupMenu: TPopupMenu
    object N13: TMenuItem [11]
    end
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    RefreshAction = actRefreshStart
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
  end
  inherited spMovementComplete: TdsdStoredProc
    Left = 88
    Top = 296
  end
  inherited spMovementUnComplete: TdsdStoredProc
    Left = 88
    Top = 344
  end
  inherited spMovementSetErased: TdsdStoredProc
    Left = 88
    Top = 448
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
        Name = 'UnitId'
        Value = Null
        MultiSelectSeparator = ','
      end>
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_Check'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 392
  end
  object spGet_UserUnit: TdsdStoredProc
    StoredProcName = 'gpGet_UserUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'UnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 424
  end
  object spReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_Income'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsLastComplete'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 249
    Top = 314
  end
  object spUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_SummCard'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummCard'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummCard'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 250
    Top = 381
  end
end
