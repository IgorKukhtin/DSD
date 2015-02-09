inherited LossDebtJournalForm: TLossDebtJournalForm
  Caption = 
    #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1079#1072#1076#1086#1083#1078#1077#1085#1085#1086#1089#1090#1080' ('#1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072 +
    ')>'
  ClientHeight = 427
  ClientWidth = 460
  ExplicitWidth = 468
  ExplicitHeight = 454
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 460
    Height = 370
    TabOrder = 3
    ExplicitWidth = 460
    ExplicitHeight = 370
    ClientRectBottom = 370
    ClientRectRight = 460
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 460
      ExplicitHeight = 370
      inherited cxGrid: TcxGrid
        Width = 460
        Height = 370
        ExplicitWidth = 460
        ExplicitHeight = 370
        inherited cxGridDBTableView: TcxGridDBTableView
          OnDblClick = nil
          OnKeyDown = nil
          OnKeyPress = nil
          OnCustomDrawCell = nil
          DataController.Filter.OnChanged = nil
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          OnColumnHeaderClick = nil
          OnCustomDrawColumnHeader = nil
          inherited colStatus: TcxGridDBColumn
            Options.Editing = False
          end
          inherited colInvNumber: TcxGridDBColumn
            Options.Editing = False
          end
          inherited colOperDate: TcxGridDBColumn
            Options.Editing = False
          end
          object colJuridicalBasisName: TcxGridDBColumn
            Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalBasisName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 138
          end
          object colTotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 93
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 460
    TabOrder = 4
    ExplicitWidth = 460
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TLossDebtForm'
      FormNameParam.Value = 'TLossDebtForm'
    end
    inherited actInsertMask: TdsdInsertUpdateAction
      FormName = 'TLossDebtForm'
      FormNameParam.Value = 'TLossDebtForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TLossDebtForm'
      FormNameParam.Value = 'TLossDebtForm'
    end
  end
  inherited MasterCDS: TClientDataSet
    AfterInsert = nil
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_LossDebt'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInputOutput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 312
    Top = 128
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_LossDebt'
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_LossDebt'
    Left = 336
    Top = 72
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_LossDebt'
    Left = 240
    Top = 88
  end
  inherited spMovementReComplete: TdsdStoredProc
    Left = 424
    Top = 88
  end
end
