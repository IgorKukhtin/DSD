inherited SetUserDefaultsForm: TSetUserDefaultsForm
  Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1079#1085#1072#1095#1077#1085#1080#1081' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
  ClientHeight = 395
  ClientWidth = 847
  ExplicitWidth = 855
  ExplicitHeight = 422
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 847
    Height = 369
    ExplicitWidth = 847
    ExplicitHeight = 369
    ClientRectBottom = 369
    ClientRectRight = 847
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 847
      ExplicitHeight = 369
      inherited cxGrid: TcxGrid
        Width = 847
        Height = 369
        ExplicitWidth = 847
        ExplicitHeight = 369
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colDefaultKey: TcxGridDBColumn
            Caption = #1050#1083#1102#1095
            Width = 92
          end
          object cxGridDBTableViewColumn1: TcxGridDBColumn
            Width = 140
          end
          object cxGridDBTableViewColumn2: TcxGridDBColumn
            Width = 114
          end
          object colUserKey: TcxGridDBColumn
            Caption = #1056#1086#1083#1100'/'#1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            Width = 243
          end
          object colValue: TcxGridDBColumn
            Caption = #1047#1085#1072#1095#1077#1085#1080#1077
            Width = 244
          end
        end
      end
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_DefaultValue'
    Left = 88
    Top = 80
  end
  inherited BarManager: TdxBarManager
    Left = 128
    Top = 80
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
