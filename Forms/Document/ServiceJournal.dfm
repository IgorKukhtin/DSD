inherited ServiceJournalForm: TServiceJournalForm
  Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1091#1089#1083#1091#1075
  ClientWidth = 884
  ExplicitWidth = 892
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 884
    TabOrder = 3
    ExplicitLeft = 0
    ClientRectRight = 884
    inherited tsMain: TcxTabSheet
      ExplicitTop = 0
      inherited cxGrid: TcxGrid
        Width = 884
        ExplicitTop = 0
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            Width = 77
          end
          inherited colInvNumber: TcxGridDBColumn
            Width = 64
          end
          inherited colOperDate: TcxGridDBColumn
            Width = 54
          end
          object clAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1086#1087#1077#1088#1072#1094#1080#1080
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentVert = vaCenter
            Width = 121
          end
          object clFrom: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086'.'
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Width = 93
          end
          object clTo: TcxGridDBColumn
            Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'MainJuridicalName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 86
          end
          object clPosition: TcxGridDBColumn
            Caption = #1041#1080#1079#1085#1077#1089
            DataBinding.FieldName = 'BusinessName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 77
          end
          object clPaidKind: TcxGridDBColumn
            Caption = #1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object clInfoMoney: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1080' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 63
          end
          object clUnit: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 58
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 884
  end
  inherited MainDataDS: TDataSource
    Left = 56
    Top = 96
  end
  inherited MainDataCDS: TClientDataSet
    Left = 24
    Top = 104
  end
  inherited spMainData: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Service'
    Left = 96
    Top = 96
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 120
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 472
    Top = 248
  end
end
