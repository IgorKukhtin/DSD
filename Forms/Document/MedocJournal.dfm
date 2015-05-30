inherited MedocJournalForm: TMedocJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1052#1045#1044#1054#1050
  ExplicitWidth = 858
  ExplicitHeight = 702
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    TabOrder = 3
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            Options.Editing = False
          end
          inherited colInvNumber: TcxGridDBColumn
            Options.Editing = False
          end
          inherited colOperDate: TcxGridDBColumn
            Options.Editing = False
          end
          object cxGridDBTableViewColumn1: TcxGridDBColumn
            DataBinding.FieldName = 'InvNumberPartner'
            Options.Editing = False
            Width = 70
          end
          object cxGridDBTableViewColumn2: TcxGridDBColumn
            DataBinding.FieldName = 'InvNumberBranch'
            Options.Editing = False
            Width = 70
          end
          object cxGridDBTableViewColumn3: TcxGridDBColumn
            DataBinding.FieldName = 'InvNumberRegistered'
            Options.Editing = False
            Width = 70
          end
          object cxGridDBTableViewColumn4: TcxGridDBColumn
            DataBinding.FieldName = 'DateRegistered'
            Options.Editing = False
            Width = 70
          end
          object cxGridDBTableViewColumn5: TcxGridDBColumn
            DataBinding.FieldName = 'FromINN'
            Options.Editing = False
            Width = 70
          end
          object cxGridDBTableViewColumn6: TcxGridDBColumn
            DataBinding.FieldName = 'ToINN'
            Options.Editing = False
            Width = 70
          end
          object cxGridDBTableViewColumn7: TcxGridDBColumn
            DataBinding.FieldName = 'DescName'
            Options.Editing = False
            Width = 70
          end
          object cxGridDBTableViewColumn8: TcxGridDBColumn
            DataBinding.FieldName = 'TotalSumm'
            Options.Editing = False
            Width = 70
          end
          object cxGridDBTableViewColumn9: TcxGridDBColumn
            DataBinding.FieldName = 'isIncome'
            Options.Editing = False
            Width = 70
          end
          object cxGridDBTableViewColumn10: TcxGridDBColumn
            DataBinding.FieldName = 'MovementInvNumber'
            Options.Editing = False
            Width = 70
          end
          object cxGridDBTableViewColumn11: TcxGridDBColumn
            DataBinding.FieldName = 'MovementOperDate'
            Options.Editing = False
            Width = 70
          end
        end
      end
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Medoc'
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
end
