inherited CheckJournalUserForm: TCheckJournalUserForm
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    TabOrder = 2
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
    inherited ceUnit: TcxButtonEdit
      Enabled = False
    end
    inherited cxLabel3: TcxLabel
      Left = 13
      ExplicitLeft = 13
    end
  end
  inherited ActionList: TActionList
    inherited actSimpleReCompleteList: TMultiAction
      Enabled = False
    end
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
