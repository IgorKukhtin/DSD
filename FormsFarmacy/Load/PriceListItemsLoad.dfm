inherited PriceListItemsForm: TPriceListItemsForm
  Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
  ClientHeight = 410
  ClientWidth = 763
  ExplicitWidth = 771
  ExplicitHeight = 437
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 91
    Width = 763
    Height = 319
    ClientRectBottom = 319
    ClientRectRight = 763
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 575
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 763
        Height = 319
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
      end
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 763
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
  end
  inherited MasterDS: TDataSource
    Top = 104
  end
  inherited MasterCDS: TClientDataSet
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_LoadPriceListItem'
    Params = <
      item
        Name = 'inLoadPriceListId'
        Value = Null
        ParamType = ptInput
      end>
    Top = 104
  end
  inherited BarManager: TdxBarManager
    Top = 104
    DockControlHeights = (
      0
      0
      26
      0)
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 160
    Top = 104
  end
end
