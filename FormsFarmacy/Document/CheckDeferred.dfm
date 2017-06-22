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
          inherited CashMember: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited Bayer: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited OperDate: TcxGridDBColumn
            Width = 59
          end
          inherited TotalSumm: TcxGridDBColumn
            Width = 69
          end
          inherited CashRegisterName: TcxGridDBColumn
            Width = 80
          end
          inherited InvNumber: TcxGridDBColumn
            Width = 52
          end
          inherited UnitName: TcxGridDBColumn
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
    Left = 64
    Top = 144
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
          ItemName = 'dxBarButton3'
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
          ItemName = 'bbRefresh'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ColorValueList = <>
      end>
  end
  inherited dsdStoredProc1: TdsdStoredProc
    Left = 464
  end
  inherited dsdDBViewAddOn1: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ColorValueList = <>
      end>
  end
end
