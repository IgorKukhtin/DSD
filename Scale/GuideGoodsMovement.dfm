inherited GuideGoodsMovementForm: TGuideGoodsMovementForm
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1088#1086#1076#1091#1082#1094#1080#1080' '#1076#1083#1103' '#1079#1072#1103#1074#1082#1080
  ClientWidth = 963
  ExplicitWidth = 979
  PixelsPerInch = 96
  TextHeight = 14
  inherited GridPanel: TPanel
    Width = 963
    ExplicitWidth = 963
    inherited ButtonPanel: TPanel
      Width = 963
      ExplicitWidth = 963
    end
    inherited cxDBGrid: TcxGrid
      Width = 963
      ExplicitWidth = 963
      inherited cxDBGridDBTableView: TcxGridDBTableView
        Styles.Content = nil
        Styles.Inactive = nil
        Styles.Selection = nil
        Styles.Footer = nil
        Styles.Header = nil
        inherited GoodsCode: TcxGridDBColumn
          Width = 40
        end
        inherited GoodsName: TcxGridDBColumn
          Width = 120
        end
        inherited GoodsKindName: TcxGridDBColumn
          Visible = True
          Width = 70
        end
        inherited isPromo: TcxGridDBColumn
          Visible = True
          Width = 35
        end
        inherited Price_Return: TcxGridDBColumn
          Visible = False
          VisibleForCustomization = False
        end
        inherited Amount_Order: TcxGridDBColumn
          Visible = True
        end
        inherited Amount_Weighing: TcxGridDBColumn
          Visible = True
        end
        inherited Amount_diff: TcxGridDBColumn
          Visible = True
        end
        inherited GoodsGroupNameFull: TcxGridDBColumn
          Width = 120
        end
        inherited Amount_OrderWeight: TcxGridDBColumn
          Visible = True
        end
        inherited Amount_WeighingWeight: TcxGridDBColumn
          Visible = True
        end
        inherited Amount_diffWeight: TcxGridDBColumn
          Visible = True
        end
      end
    end
  end
  inherited ParamsPanel: TPanel
    Width = 963
    ExplicitWidth = 963
    inherited infoPanelTare: TPanel
      Left = 483
      ExplicitLeft = 483
    end
    inherited infoPanelPriceList: TPanel
      Left = 713
      ExplicitLeft = 713
    end
    inherited infoPanelGoodsKind: TPanel
      Width = 348
      ExplicitWidth = 348
      inherited rgGoodsKind: TRadioGroup
        Width = 348
        ExplicitWidth = 348
      end
      inherited gbGoodsKindCode: TGroupBox
        Width = 348
        ExplicitWidth = 348
      end
    end
  end
end
