inherited Report_JuridicalSoldForm: TReport_JuridicalSoldForm
  Caption = #1054#1073#1088#1086#1090#1082#1072' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084
  ClientHeight = 389
  ClientWidth = 830
  ExplicitWidth = 838
  ExplicitHeight = 416
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 830
    Height = 332
    TabOrder = 3
    ExplicitWidth = 830
    ExplicitHeight = 332
    ClientRectBottom = 332
    ClientRectRight = 830
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 830
      ExplicitHeight = 332
      inherited cxGrid: TcxGrid
        Top = 0
        Width = 830
        Height = 332
        ExplicitTop = 0
        ExplicitWidth = 830
        ExplicitHeight = 332
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 830
    ExplicitWidth = 830
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
