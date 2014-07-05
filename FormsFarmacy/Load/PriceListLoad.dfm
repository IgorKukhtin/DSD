inherited PriceListLoadForm: TPriceListLoadForm
  Caption = #1060#1086#1088#1084#1072' '#1079#1072#1075#1088#1091#1079#1082#1080' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1086#1074
  ClientHeight = 399
  ClientWidth = 671
  ExplicitWidth = 679
  ExplicitHeight = 426
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 671
    Height = 373
    ClientRectBottom = 373
    ClientRectRight = 671
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        Width = 671
        Height = 373
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
      end
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_LoadPriceList'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
