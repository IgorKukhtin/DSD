inherited CheckSite_SearchForm: TCheckSite_SearchForm
  Caption = #1054#1090#1083#1086#1078#1077#1085#1085#1099#1077' '#1095#1077#1082#1080'  '#1089' '#1089#1072#1081#1090#1072' '#1058#1072#1073#1083#1077#1090#1082#1080
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
        end
      end
    end
  end
  inherited spSelect: TdsdStoredProc
    Params = <
      item
        Name = 'inType'
        Value = 2
        ParamType = ptInput
        MultiSelectSeparator = ','
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
