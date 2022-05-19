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
      inherited infoPanelTareFix: TPanel
        inherited infoPanelTare1: TPanel
          inherited PanelTare1: TPanel
            inherited LabelTare1: TLabel
              Width = 120
            end
            inherited EditTare1: TcxCurrencyEdit
              ExplicitHeight = 22
            end
          end
          inherited infoPanelWeightTare1: TPanel
            inherited LabelWeightTare1: TLabel
              Width = 108
            end
          end
        end
        inherited infoPanelTare0: TPanel
          inherited PanelTare0: TPanel
            inherited LabelTare0: TLabel
              Width = 120
            end
            inherited EditTare0: TcxCurrencyEdit
              ExplicitHeight = 22
            end
          end
          inherited infoPanelWeightTare0: TPanel
            inherited LabelWeightTare0: TLabel
              Width = 108
            end
          end
        end
        inherited infoPanelTare2: TPanel
          inherited PanelTare2: TPanel
            inherited LabelTare2: TLabel
              Width = 120
            end
            inherited EditTare2: TcxCurrencyEdit
              ExplicitHeight = 22
            end
          end
          inherited infoPanelWeightTare2: TPanel
            inherited LabelWeightTare2: TLabel
              Width = 108
            end
          end
        end
        inherited infoPanelTare5: TPanel
          inherited PanelTare5: TPanel
            inherited LabelTare5: TLabel
              Width = 120
            end
            inherited EditTare5: TcxCurrencyEdit
              ExplicitHeight = 22
            end
          end
          inherited infoPanelWeightTare5: TPanel
            inherited LabelWeightTare5: TLabel
              Width = 108
            end
          end
        end
        inherited infoPanelTare4: TPanel
          inherited PanelTare4: TPanel
            inherited LabelTare4: TLabel
              Width = 120
            end
            inherited EditTare4: TcxCurrencyEdit
              ExplicitHeight = 22
            end
          end
          inherited infoPanelWeightTare4: TPanel
            inherited LabelWeightTare4: TLabel
              Width = 108
            end
          end
        end
        inherited infoPanelTare3: TPanel
          inherited PanelTare3: TPanel
            inherited LabelTare3: TLabel
              Width = 120
            end
            inherited EditTare3: TcxCurrencyEdit
              ExplicitHeight = 22
            end
          end
          inherited infoPanelWeightTare3: TPanel
            inherited LabelWeightTare3: TLabel
              Width = 108
            end
          end
        end
        inherited infoPanelTare6: TPanel
          inherited PanelTare6: TPanel
            inherited LabelTare6: TLabel
              Width = 120
            end
            inherited EditTare6: TcxCurrencyEdit
              ExplicitHeight = 22
            end
          end
          inherited infoPanelWeightTare6: TPanel
            inherited LabelWeightTare6: TLabel
              Width = 108
            end
          end
        end
      end
    end
    inherited infoPanelPriceList: TPanel
      Left = 713
      ExplicitLeft = 713
    end
    inherited infoPanelGoods: TPanel
      inherited gbWeightValue: TGroupBox
        inherited EditWeightValue: TcxCurrencyEdit
          ExplicitHeight = 22
        end
      end
      inherited gbPrice: TGroupBox
        inherited EditPrice: TcxCurrencyEdit
          ExplicitHeight = 22
        end
      end
      inherited gbPartionGoods_20103: TGroupBox
        inherited EditPartionGoods_20103: TcxCurrencyEdit
          ExplicitHeight = 22
        end
      end
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
      inherited gbPriceIncome: TGroupBox
        Width = 348
        ExplicitWidth = 348
        inherited EditPriceIncome: TcxCurrencyEdit
          ExplicitHeight = 22
        end
      end
    end
  end
end
