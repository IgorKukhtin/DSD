inherited JuridicalCorporateForm: TJuridicalCorporateForm
  Caption = #1070#1088'.'#1083#1080#1094#1072' '#1082#1086#1088#1087#1086#1088#1072#1094#1080#1080
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
          inherited Name: TcxGridDBColumn
            Width = 297
          end
          inherited isCorporate: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited RetailName: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
        end
      end
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_JuridicalCorporate'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
