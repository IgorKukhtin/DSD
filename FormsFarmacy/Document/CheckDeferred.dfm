inherited CheckDeferredForm: TCheckDeferredForm
  Caption = #1054#1090#1083#1086#1078#1077#1085#1085#1099#1077' '#1095#1077#1082#1080
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colCashMember: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited colBayer: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited colOperDate: TcxGridDBColumn
            Width = 59
          end
          inherited colTotalSumm: TcxGridDBColumn
            Width = 69
          end
          inherited colCashRegisterName: TcxGridDBColumn
            Width = 80
          end
          inherited colInvNumber: TcxGridDBColumn
            Width = 52
          end
          inherited colUnitName: TcxGridDBColumn
            Width = 130
          end
        end
      end
      inherited cxGrid1: TcxGrid
        inherited cxGridDBTableView1: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited actDeleteCheck: TdsdChangeMovementStatus
      StoredProcList = <
        item
          StoredProc = spMovementSetErased
        end
        item
          StoredProc = spSelect
        end>
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_CheckDeferred'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
