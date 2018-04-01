inherited Report_Sold_DayUserForm: TReport_Sold_DayUserForm
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
    inherited tsPivot: TcxTabSheet
      inherited cxDBPivotGrid1: TcxDBPivotGrid
        ExplicitHeight = 503
        inherited pcolPlanDate: TcxDBPivotGridField
          UniqueName = #1044#1072#1090#1072
        end
        inherited pcolWeek: TcxDBPivotGridField
          UniqueName = #1053#1077#1076#1077#1083#1103
        end
        inherited pcolUnitJuridical: TcxDBPivotGridField
          UniqueName = #1070#1088#1083#1080#1094#1086
        end
        inherited pcolUnitName: TcxDBPivotGridField
          UniqueName = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        end
        inherited pcolPlanAmount: TcxDBPivotGridField
          UniqueName = #1055#1083#1072#1085
        end
        inherited pcolFactAmount: TcxDBPivotGridField
          UniqueName = #1060#1072#1082#1090
        end
        inherited pcolDiffAmount: TcxDBPivotGridField
          UniqueName = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077
        end
        inherited pcolDayOfWeek: TcxDBPivotGridField
          UniqueName = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080
        end
      end
    end
  end
  inherited Panel: TPanel
    inherited ceUnit: TcxButtonEdit
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
