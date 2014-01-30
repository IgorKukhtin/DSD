inherited LoadSaleFrom1CForm: TLoadSaleFrom1CForm
  Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' '#1087#1088#1086#1076#1072#1078' '#1080#1079' 1'#1057
  ClientHeight = 399
  ClientWidth = 739
  ExplicitWidth = 747
  ExplicitHeight = 426
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 739
    Height = 342
    TabOrder = 3
    ExplicitWidth = 739
    ExplicitHeight = 342
    ClientRectBottom = 342
    ClientRectRight = 739
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 739
      ExplicitHeight = 342
      inherited cxGrid: TcxGrid
        Width = 739
        Height = 342
        ExplicitWidth = 739
        ExplicitHeight = 342
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colInvNumber: TcxGridDBColumn
            DataBinding.FieldName = 'InvNumber'
            Width = 81
          end
          object colOperDate: TcxGridDBColumn
            DataBinding.FieldName = 'OperDate'
            Width = 80
          end
          object colClientName: TcxGridDBColumn
            DataBinding.FieldName = 'ClientName'
            Width = 81
          end
          object colGoodsName: TcxGridDBColumn
            DataBinding.FieldName = 'GoodsName'
            Width = 80
          end
          object colOperCount: TcxGridDBColumn
            DataBinding.FieldName = 'OperCount'
            Width = 81
          end
          object colOperPrice: TcxGridDBColumn
            DataBinding.FieldName = 'OperPrice'
            Width = 80
          end
          object colClientINN: TcxGridDBColumn
            DataBinding.FieldName = 'ClientINN'
            Width = 77
          end
          object colClientOKPO: TcxGridDBColumn
            DataBinding.FieldName = 'ClientOKPO'
            Width = 82
          end
          object colSuma: TcxGridDBColumn
            DataBinding.FieldName = 'Suma'
            Width = 83
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 739
    ExplicitWidth = 739
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 64
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 64
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_1CSaleLoad'
    Left = 104
    Top = 64
  end
  inherited BarManager: TdxBarManager
    Left = 136
    Top = 64
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
