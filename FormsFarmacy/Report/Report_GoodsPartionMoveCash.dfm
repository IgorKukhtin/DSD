inherited Report_GoodsPartionMoveCashForm: TReport_GoodsPartionMoveCashForm
  Caption = 'Report_GoodsPartionMoveCashForm'
  ExplicitHeight = 414
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
    inherited edUnit: TcxButtonEdit
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Style.Color = clBtnFace
    end
  end
  inherited ActionList: TActionList
    inherited ExecuteDialog: TExecuteDialog
      FormName = 'TReport_GoodsPartionMoveCashDialogForm'
      FormNameParam.Value = 'TReport_GoodsPartionMoveCashDialogForm'
    end
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited GuidesUnit: TdsdGuides
    DisableGuidesOpen = True
  end
end
