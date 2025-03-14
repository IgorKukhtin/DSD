inherited MarginCategoryJournalForm: TMarginCategoryJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' <'#1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1082#1080' ('#1057#1040#1059#1062')>'
  ClientHeight = 491
  ClientWidth = 979
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.AddOnFormRefresh.SelfList = 'Promo'
  AddOnFormData.AddOnFormRefresh.DataSet = MasterCDS
  AddOnFormData.AddOnFormRefresh.KeyField = 'Id'
  AddOnFormData.AddOnFormRefresh.KeyParam = 'inMovementId'
  AddOnFormData.AddOnFormRefresh.GetStoredProc = spGet_Movement_MarginCategory
  ExplicitWidth = 995
  ExplicitHeight = 529
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 979
    Height = 434
    TabOrder = 3
    ExplicitWidth = 979
    ExplicitHeight = 434
    ClientRectBottom = 434
    ClientRectRight = 979
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 979
      ExplicitHeight = 434
      inherited cxGrid: TcxGrid
        Width = 979
        Height = 434
        ExplicitWidth = 979
        ExplicitHeight = 434
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
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
          inherited colInvNumber: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 71
          end
          inherited colOperDate: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 62
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 157
          end
          object OperDateStart: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '#1085#1072#1094'-'#1082#1080
            DataBinding.FieldName = 'OperDateStart'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = ',0.000'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 58
          end
          object OperDateEnd: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085'. '#1085#1072#1094'-'#1082#1080
            DataBinding.FieldName = 'OperDateEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object StartSale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '#1086#1090#1095'.'
            DataBinding.FieldName = 'StartSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object EndSale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085'. '#1086#1090#1095'.'
            DataBinding.FieldName = 'EndSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = ' '#9#1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1082#1086#1085#1090#1088#1072#1082#1090#1072
            Width = 82
          end
          object DayCount: TcxGridDBColumn
            Caption = #1044#1085'. '#1072#1085#1072#1083#1080#1079#1072
            DataBinding.FieldName = 'DayCount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'. '#1076#1085'. '#1074' '#1087#1077#1088#1080#1086#1076#1077' '#1076#1083#1103' '#1072#1085#1072#1083#1080#1079#1072
            Options.Editing = False
            Width = 60
          end
          object ChangePercent: TcxGridDBColumn
            Caption = '% '#1086#1090#1082#1083'.'
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 78
          end
          object Amount: TcxGridDBColumn
            Caption = #1052#1080#1085' '#1082#1086#1083'-'#1074#1086' '#1087#1088'.'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PriceMax: TcxGridDBColumn
            Caption = #1052#1072#1082#1089' '#1088#1086#1079#1085'. '#1094#1077#1085#1072
            DataBinding.FieldName = 'PriceMax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object PriceMin: TcxGridDBColumn
            Caption = #1052#1080#1085' '#1088#1086#1079#1085'. '#1094#1077#1085#1072
            DataBinding.FieldName = 'PriceMin'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Comment: TcxGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 147
          end
          object InsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1089#1086#1079#1076'.'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Insertdate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076'.'
            DataBinding.FieldName = 'Insertdate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object UpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 979
    ExplicitWidth = 979
    inherited deStart: TcxDateEdit
      EditValue = 43040d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 43040d
    end
    object chbPeriodForOperDate: TcxCheckBox
      Left = 433
      Top = 5
      Action = actRefresh
      TabOrder = 4
      Width = 93
    end
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 154
    inherited actRefresh: TdsdDataSetRefresh
      Caption = #1044#1072#1090#1099' '#1086#1090#1095#1077#1090#1072
    end
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TMarginCategory_MovementForm'
      FormNameParam.Value = 'TMarginCategory_MovementForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TMarginCategory_MovementForm'
      FormNameParam.Value = 'TMarginCategory_MovementForm'
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
          Value = 'NULL'
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
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1054#1090#1095#1077#1090' <'#1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1087#1088#1086#1076#1072#1078' '#1089' '#1087#1088#1086#1096#1083#1099#1084' '#1087#1077#1088#1080#1086#1076#1086#1084'>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1054#1090#1095#1077#1090' <'#1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1087#1088#1086#1076#1072#1078' '#1089' '#1087#1088#1086#1096#1083#1099#1084' '#1087#1077#1088#1080#1086#1076#1086#1084'>'
      ImageIndex = 25
      FormName = 'TReport_SAMP_AnalysisForm'
      FormNameParam.Value = 'TReport_SAMP_AnalysisForm'
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
        end
        item
          Name = 'StartSale'
          Value = 42485d
          Component = MasterCDS
          ComponentItem = 'StartSale'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndSale'
          Value = 42485d
          Component = MasterCDS
          ComponentItem = 'EndSale'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DayCount'
          Value = 0.000000000000000000
          Component = MasterCDS
          ComponentItem = 'DayCount'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_MarginCategory'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInputOutput
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriodForOperDate'
        Value = Null
        Component = chbPeriodForOperDate
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
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
          ItemName = 'bbOpenReportForm'
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
    object bbOpenReportForm: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
    object bbReportMinPriceForm: TdxBarButton
      Action = actOpenReportMinPriceForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 488
    Top = 416
  end
  inherited PopupMenu: TPopupMenu
    Left = 8
    Top = 152
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 528
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 600
    Top = 144
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_MarginCategory'
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_MarginCategory'
    Left = 384
    Top = 264
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_MarginCategory'
    Left = 384
    Top = 216
  end
  inherited FormParams: TdsdFormParams
    Left = 32
    Top = 400
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_MarginCategory'
    Left = 384
    Top = 120
  end
  object spGet_Movement_MarginCategory: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_MarginCategory'
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
        Value = 'NULL'
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
end
