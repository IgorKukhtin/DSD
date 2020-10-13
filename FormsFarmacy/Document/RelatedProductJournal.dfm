inherited RelatedProductJournalForm: TRelatedProductJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' <'#1057#1086#1087#1091#1090#1089#1090#1074#1091#1102#1097#1080#1077' '#1090#1086#1074#1072#1088#1099'>'
  ClientHeight = 491
  ClientWidth = 769
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.AddOnFormRefresh.SelfList = 'Promo'
  AddOnFormData.AddOnFormRefresh.DataSet = MasterCDS
  AddOnFormData.AddOnFormRefresh.KeyField = 'Id'
  AddOnFormData.AddOnFormRefresh.KeyParam = 'inMovementId'
  AddOnFormData.AddOnFormRefresh.GetStoredProc = spGet_Movement_RelatedProduct
  ExplicitWidth = 785
  ExplicitHeight = 530
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 769
    Height = 434
    TabOrder = 3
    ExplicitWidth = 769
    ExplicitHeight = 434
    ClientRectBottom = 434
    ClientRectRight = 769
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 769
      ExplicitHeight = 434
      inherited cxGrid: TcxGrid
        Width = 769
        Height = 434
        ExplicitWidth = 769
        ExplicitHeight = 434
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
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
          inherited colInvNumber: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 71
          end
          inherited colOperDate: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 62
          end
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 89
          end
          object PriceMin: TcxGridDBColumn
            Caption = #1054#1090' '#1094#1077#1085#1099
            DataBinding.FieldName = 'PriceMin'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
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
    Width = 769
    ExplicitWidth = 769
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 154
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TRelatedProductForm'
      FormNameParam.Value = 'TRelatedProductForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TRelatedProductForm'
      FormNameParam.Value = 'TRelatedProductForm'
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
          Value = 'NULL'
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
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_RelatedProduct'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
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
    Left = 424
    Top = 8
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 456
    Top = 8
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_RelatedProduct'
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_RelatedProduct'
    Left = 384
    Top = 264
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_RelatedProduct'
    Left = 384
    Top = 216
  end
  inherited FormParams: TdsdFormParams
    Left = 32
    Top = 400
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_RelatedProduct'
    Left = 384
    Top = 120
  end
  object spGet_Movement_RelatedProduct: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_RelatedProduct'
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
