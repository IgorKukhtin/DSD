inherited Report_UserProtocolViewForm: TReport_UserProtocolViewForm
  Caption = 'Report_UserProtocolViewForm'
  AddOnFormData.ExecuteDialogAction = nil
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    TabOrder = 1
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
  inherited Panel: TPanel
    TabOrder = 3
  end
  inherited edBranch: TcxButtonEdit
    TabOrder = 5
  end
  inherited edUser: TcxButtonEdit
    TabOrder = 8
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
