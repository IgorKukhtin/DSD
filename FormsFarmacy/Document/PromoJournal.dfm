inherited PromoJournalForm: TPromoJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' <'#1052#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090'>'
  ClientHeight = 491
  ClientWidth = 776
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.AddOnFormRefresh.SelfList = 'Promo'
  AddOnFormData.AddOnFormRefresh.DataSet = MasterCDS
  AddOnFormData.AddOnFormRefresh.KeyField = 'Id'
  AddOnFormData.AddOnFormRefresh.KeyParam = 'inMovementId'
  AddOnFormData.AddOnFormRefresh.GetStoredProc = spGet_Movement_Promo
  ExplicitWidth = 792
  ExplicitHeight = 530
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 776
    Height = 434
    TabOrder = 3
    ExplicitWidth = 776
    ExplicitHeight = 434
    ClientRectBottom = 434
    ClientRectRight = 776
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 776
      ExplicitHeight = 434
      inherited cxGrid: TcxGrid
        Width = 776
        Height = 434
        ExplicitWidth = 776
        ExplicitHeight = 434
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Id: TcxGridDBColumn [0]
            Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
            DataBinding.FieldName = 'Id'
            Visible = False
            Width = 30
          end
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 49
          end
          object Prescribe: TcxGridDBColumn [2]
            Caption = #1057#1090#1072#1090#1091#1089' '#1087#1088#1086#1087#1080#1089#1080
            DataBinding.FieldName = 'Prescribe'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          inherited colInvNumber: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 71
          end
          inherited colOperDate: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 62
          end
          object MakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 157
          end
          object TotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'TotalCount'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = ',0.000'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 58
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object StartPromo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '#1082#1086#1085#1090#1088#1072#1082#1090#1072
            DataBinding.FieldName = 'StartPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object EndPromo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085'. '#1082#1086#1085#1090#1088#1072#1082#1090#1072
            DataBinding.FieldName = 'EndPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = ' '#9#1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1082#1086#1085#1090#1088#1072#1082#1090#1072
            Width = 82
          end
          object ChangePercent: TcxGridDBColumn
            Caption = '% '#1073#1086#1085#1091#1089#1072' '#1086#1090' '#1079#1072#1082#1091#1087#1082#1080
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 78
          end
          object Amount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1082#1086#1085#1090#1088#1072#1082#1090#1072
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PersonalName: TcxGridDBColumn
            Caption = #1054#1090#1074'. '#1084#1072#1088#1082#1077#1090#1086#1083#1086#1075
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1087#1088#1077#1076#1089#1090#1072#1074#1080#1090#1077#1083#1100' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1086#1075#1086' '#1086#1090#1076#1077#1083#1072
            Options.Editing = False
            Width = 104
          end
          object Comment: TcxGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 147
          end
          object isSupplement: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' '#1074' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053
            DataBinding.FieldName = 'isSupplement'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object isNotUseSUN: TcxGridDBColumn
            Caption = #1053#1077' '#1080#1089#1087#1086#1083#1100#1079'. '#1090#1086#1074#1072#1088' '#1074' '#1057#1059#1053
            DataBinding.FieldName = 'isNotUseSUN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 776
    ExplicitWidth = 776
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 154
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TPromoForm'
      FormNameParam.Value = 'TPromoForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TPromoForm'
      FormNameParam.Value = 'TPromoForm'
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
    object actOpenReportMinPrice_All: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1052#1080#1085'. '#1094#1077#1085#1072' '#1076#1080#1089#1090#1088'. ('#1074#1089#1077' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1080')>'
      Hint = #1054#1090#1095#1077#1090' <'#1052#1080#1085'. '#1094#1077#1085#1072' '#1076#1080#1089#1090#1088#1080#1073#1100#1102#1090#1077#1088#1072' ('#1074#1089#1077' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1080')>'
      ImageIndex = 26
      FormName = 'TReport_MinPrice_byPromoForm'
      FormNameParam.Value = 'TReport_MinPrice_byPromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inMovementId'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inInvNumber'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenReportMinPriceForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1052#1080#1085'. '#1094#1077#1085#1072' '#1076#1080#1089#1090#1088#1080#1073#1100#1102#1090#1077#1088#1072' ('#1084#1072#1088#1082#1077#1090#1080#1085#1075')>'
      Hint = #1054#1090#1095#1077#1090' <'#1052#1080#1085'. '#1094#1077#1085#1072' '#1076#1080#1089#1090#1088#1080#1073#1100#1102#1090#1077#1088#1072' ('#1084#1072#1088#1082#1077#1090#1080#1085#1075')>'
      ImageIndex = 26
      FormName = 'TReport_MinPrice_byPromoForm'
      FormNameParam.Value = 'TReport_MinPrice_byPromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inInvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
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
    object actOpenReportForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1094#1077#1085#1072#1084' '#1087#1088#1080#1093#1086#1076#1072'>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1086' '#1094#1077#1085#1072#1084' '#1087#1088#1080#1093#1086#1076#1072' '#1090#1086#1074#1072#1088#1086#1074' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072'>'
      ImageIndex = 25
      FormName = 'TReport_MovementIncome_byPromoForm'
      FormNameParam.Value = 'TReport_MovementIncome_byPromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inInvNumber'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 42132d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1078#1091#1088#1085#1072#1083#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1078#1091#1088#1085#1072#1083#1072
      ImageIndex = 7
      DataSource = MasterDS
    end
    object macUpdate_Supplement: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUpdate_Supplement
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1086#1074#1072#1088' '#1074' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'"?'
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1058#1086#1074#1072#1088' '#1074' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'"'
      Hint = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1058#1086#1074#1072#1088' '#1074' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'"'
      ImageIndex = 30
    end
    object actUpdate_Supplement: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Supplement
      StoredProcList = <
        item
          StoredProc = spUpdate_Supplement
        end>
      Caption = 'actUpdate_Supplement'
    end
    object mactUpdate_NotUseSUN: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUpdate_NotUseSUN
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1074' '#1057#1059#1053'"?'
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1053#1077' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1074' '#1057#1059#1053'"'
      Hint = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1053#1077' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1074' '#1057#1059#1053'"'
      ImageIndex = 80
    end
    object actUpdate_NotUseSUN: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_NotUseSUN
      StoredProcList = <
        item
          StoredProc = spUpdate_NotUseSUN
        end>
      Caption = 'actUpdate_NotUseSUN'
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Promo'
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
          ItemName = 'bbInsert'
        end
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
          ItemName = 'bbChoiceGuides'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenReportForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReportMinPriceForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenReportMinPrice_All'
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
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_NotUseSUN'
        end>
    end
    object bbOpenReportForm: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
    object bbReportMinPriceForm: TdxBarButton
      Action = actOpenReportMinPriceForm
      Category = 0
    end
    object bbOpenReportMinPrice_All: TdxBarButton
      Action = actOpenReportMinPrice_All
      Category = 0
      ImageIndex = 24
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = macUpdate_Supplement
      Category = 0
    end
    object bbUpdate_NotUseSUN: TdxBarButton
      Action = mactUpdate_NotUseSUN
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 256
    Top = 168
  end
  inherited PopupMenu: TPopupMenu
    Left = 8
    Top = 152
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 672
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 568
    Top = 112
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Promo'
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_Promo'
    Left = 384
    Top = 264
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_Promo'
    Left = 384
    Top = 216
  end
  inherited FormParams: TdsdFormParams
    Left = 56
    Top = 288
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_Promo'
    Left = 384
    Top = 120
  end
  object spGet_Movement_Promo: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Promo'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = 41640d
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = False
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = Null
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalCount'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 267
  end
  object spUpdate_Supplement: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Promo_Supplement'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inisSupplement'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSupplement'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 568
    Top = 200
  end
  object spUpdate_NotUseSUN: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Promo_NotUseSUN'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inisNotUseSUN'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isNotUseSUN'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 568
    Top = 272
  end
end
