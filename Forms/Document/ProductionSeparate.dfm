inherited ProductionSeparateForm: TProductionSeparateForm
  Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    TabOrder = 2
    inherited tsMain: TcxTabSheet
      ExplicitLeft = 2
      inherited cxGrid: TcxGrid
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
      end
    end
    inherited tsEntry: TcxTabSheet
      inherited cxGridEntry: TcxGrid
        inherited cxGridEntryDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
      end
    end
  end
  inherited cxGridChild: TcxGrid
    TabOrder = 4
  end
  inherited DataPanel: TPanel
    inherited ceStatus: TcxButtonEdit
      ExplicitHeight = 24
    end
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      28
      0)
  end
end
