inherited SaleJournalForm: TSaleJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1087#1088#1086#1076#1072#1078
  ClientHeight = 491
  ClientWidth = 663
  AddOnFormData.AddOnFormRefresh.SelfList = 'Sale'
  AddOnFormData.AddOnFormRefresh.DataSet = MasterCDS
  AddOnFormData.AddOnFormRefresh.KeyField = 'Id'
  AddOnFormData.AddOnFormRefresh.KeyParam = 'inMovementId'
  AddOnFormData.AddOnFormRefresh.GetStoredProc = spGet_Movement_Sale
  ExplicitWidth = 679
  ExplicitHeight = 529
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 663
    Height = 434
    TabOrder = 3
    ExplicitWidth = 663
    ExplicitHeight = 434
    ClientRectBottom = 434
    ClientRectRight = 663
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 663
      ExplicitHeight = 434
      inherited cxGrid: TcxGrid
        Width = 663
        Height = 434
        ExplicitWidth = 663
        ExplicitHeight = 434
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSummPrimeCost
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object cxGridDBTableViewColumn1: TcxGridDBColumn [0]
            Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
            DataBinding.FieldName = 'Id'
            Visible = False
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
          object colUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 108
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 98
          end
          object colPaidKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 79
          end
          object colTotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'TotalCount'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = ',0.000'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 46
          end
          object colTotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object colTotalSummPrimeCost: TcxGridDBColumn
            AlternateCaption = #1057#1091#1084#1084#1072' '#1089#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1080
            Caption = #1057#1091#1084#1084#1072' '#1089#1077#1073'-'#1090#1080
            DataBinding.FieldName = 'TotalSummPrimeCost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1089#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1080
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 663
    ExplicitWidth = 663
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 154
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TSaleForm'
      FormNameParam.Value = 'TSaleForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TSaleForm'
      FormNameParam.Value = 'TSaleForm'
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
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
    StoredProcName = 'gpComplete_Movement_Sale'
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_Sale'
    Left = 384
    Top = 264
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_Sale'
    Left = 384
    Top = 216
  end
  inherited FormParams: TdsdFormParams
    Left = 32
    Top = 400
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_Sale'
    Left = 384
    Top = 120
  end
  object spGet_Movement_Sale: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Sale'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = 41640d
        ParamType = ptInputOutput
      end
      item
        Name = 'inOperDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'Id'
        Value = False
      end
      item
        Name = 'InvNumber'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'OperDate'
        Value = Null
        DataType = ftDateTime
      end
      item
        Name = 'StatusCode'
        Value = Null
      end
      item
        Name = 'StatusName'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'TotalCount'
        Value = Null
        DataType = ftFloat
      end
      item
        Name = 'TotalSumm'
        Value = Null
        DataType = ftFloat
      end
      item
        Name = 'TotalSummPrimeCost'
        Value = Null
        DataType = ftFloat
      end
      item
        Name = 'UnitId'
        Value = Null
      end
      item
        Name = 'UnitName'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'JuridicalId'
        Value = Null
      end
      item
        Name = 'JuridicalName'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'PaidKindId'
        Value = Null
      end
      item
        Name = 'PaidKindName'
        Value = Null
        DataType = ftString
      end>
    PackSize = 1
    Left = 168
    Top = 99
  end
end
