inherited LoadSaleFrom1CForm: TLoadSaleFrom1CForm
  Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' '#1087#1088#1086#1076#1072#1078' '#1080#1079' 1'#1057
  ClientHeight = 408
  ClientWidth = 853
  ExplicitWidth = 861
  ExplicitHeight = 435
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 853
    Height = 351
    TabOrder = 3
    ExplicitWidth = 739
    ExplicitHeight = 342
    ClientRectBottom = 351
    ClientRectRight = 853
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 739
      ExplicitHeight = 342
      inherited cxGrid: TcxGrid
        Width = 853
        Height = 351
        ExplicitWidth = 739
        ExplicitHeight = 342
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colInvNumber: TcxGridDBColumn
            DataBinding.FieldName = 'InvNumber'
            Options.Editing = False
            Width = 69
          end
          object colOperDate: TcxGridDBColumn
            DataBinding.FieldName = 'OperDate'
            Options.Editing = False
            Width = 68
          end
          object colClientCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1082#1083#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'ClientCode'
            Options.Editing = False
            Width = 57
          end
          object colClientName: TcxGridDBColumn
            DataBinding.FieldName = 'ClientName'
            Options.Editing = False
            Width = 69
          end
          object colDeliveryPoint: TcxGridDBColumn
            Caption = #1058#1086#1095#1082#1080' '#1076#1086#1089#1090#1072#1074#1082#1080
            DataBinding.FieldName = 'DeliveryPointName'
            Width = 63
          end
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            Options.Editing = False
            Width = 58
          end
          object colGoodsName: TcxGridDBColumn
            DataBinding.FieldName = 'GoodsName'
            Options.Editing = False
            Width = 67
          end
          object colGoodsGoodsKind: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsGoodsKindName'
            Width = 54
          end
          object colOperCount: TcxGridDBColumn
            DataBinding.FieldName = 'OperCount'
            Options.Editing = False
            Width = 67
          end
          object colOperPrice: TcxGridDBColumn
            DataBinding.FieldName = 'OperPrice'
            Options.Editing = False
            Width = 65
          end
          object colClientINN: TcxGridDBColumn
            DataBinding.FieldName = 'ClientINN'
            Options.Editing = False
            Width = 65
          end
          object colClientOKPO: TcxGridDBColumn
            DataBinding.FieldName = 'ClientOKPO'
            Options.Editing = False
            Width = 68
          end
          object colSuma: TcxGridDBColumn
            DataBinding.FieldName = 'Suma'
            Options.Editing = False
            Width = 69
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 853
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
