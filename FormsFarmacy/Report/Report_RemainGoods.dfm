inherited AncestorReportForm2: TAncestorReportForm2
  Caption = 'AncestorReportForm2'
  ClientHeight = 364
  ClientWidth = 693
  ExplicitWidth = 701
  ExplicitHeight = 391
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 693
    Height = 307
    TabOrder = 3
    ClientRectBottom = 307
    ClientRectRight = 693
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        Width = 693
        Height = 307
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 693
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
