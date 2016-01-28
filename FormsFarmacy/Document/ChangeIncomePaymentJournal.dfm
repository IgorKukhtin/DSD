inherited ChangeIncomePaymentJournalForm: TChangeIncomePaymentJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' <'#1048#1079#1084#1077#1085#1077#1085#1080#1103' '#1076#1086#1083#1075#1072' '#1087#1086' '#1087#1088#1080#1093#1086#1076#1072#1084'>'
  ClientHeight = 445
  ClientWidth = 740
  ExplicitWidth = 756
  ExplicitHeight = 483
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 740
    Height = 388
    TabOrder = 3
    ExplicitWidth = 740
    ExplicitHeight = 388
    ClientRectBottom = 388
    ClientRectRight = 740
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 740
      ExplicitHeight = 388
      inherited cxGrid: TcxGrid
        Width = 740
        Height = 388
        ExplicitWidth = 740
        ExplicitHeight = 388
        inherited cxGridDBTableView: TcxGridDBTableView
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
          end
          inherited colOperDate: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
          end
          object colFromName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 146
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1053#1072#1096#1077' '#1102#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 134
          end
          object colChangeIncomePaymentKindName: TcxGridDBColumn
            Caption = #1058#1080#1087
            DataBinding.FieldName = 'ChangeIncomePaymentKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 94
          end
          object colTotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'TotalSumm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object colComment: TcxGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 135
          end
          object clReturnOutInvNumber: TcxGridDBColumn
            Caption = #8470' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1053#1040#1064
            DataBinding.FieldName = 'ReturnOutInvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object clReturnOutOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1053#1040#1064
            DataBinding.FieldName = 'ReturnOutOperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object clReturnOutInvNumberPartner: TcxGridDBColumn
            Caption = #8470' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'ReturnOutInvNumberPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object clReturnOutOperDatePartner: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'ReturnOutOperDatePartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object clIncomeOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1055#1053
            DataBinding.FieldName = 'IncomeOperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object clIncomeInvNumber: TcxGridDBColumn
            Caption = #8470' '#1055#1053
            DataBinding.FieldName = 'IncomeInvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 740
    ExplicitWidth = 740
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TChangeIncomePaymentForm'
      FormNameParam.Value = 'TChangeIncomePaymentForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          ParamType = ptInput
        end
        item
          Name = 'ShowAll'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end>
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TChangeIncomePaymentForm'
      FormNameParam.Value = 'TChangeIncomePaymentForm'
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ChangeIncomePayment'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_ChangeIncomePayment'
    Left = 520
    Top = 104
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_ChangeIncomePayment'
    Left = 520
    Top = 152
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_ChangeIncomePayment'
    Left = 640
    Top = 104
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_ChangeIncomePayment'
  end
end
