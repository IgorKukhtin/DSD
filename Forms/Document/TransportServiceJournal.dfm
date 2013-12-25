inherited TransportServiceJournalForm: TTransportServiceJournalForm
  Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1085#1072#1077#1084#1085#1099#1081' '#1090#1088#1072#1085#1089#1087#1086#1088#1090
  ClientWidth = 884
  ExplicitWidth = 892
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 884
    TabOrder = 3
    ExplicitWidth = 884
    ClientRectRight = 884
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 884
      inherited cxGrid: TcxGrid
        Width = 884
        ExplicitWidth = 884
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Position = spFooter
              Column = clAmount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = clAmount
            end>
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            Options.Editing = False
            Width = 77
          end
          inherited colInvNumber: TcxGridDBColumn
            Options.Editing = False
            Width = 63
          end
          inherited colOperDate: TcxGridDBColumn
            Options.Editing = False
            Width = 54
          end
          object clAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1086#1087#1077#1088#1072#1094#1080#1080
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 121
          end
          object clDistance: TcxGridDBColumn
            Caption = #1055#1088#1086#1073#1077#1075' '#1092#1072#1082#1090', '#1082#1084
            DataBinding.FieldName = 'Distance'
            Width = 63
          end
          object clPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' ('#1090#1086#1087#1083#1080#1074#1072')'
            DataBinding.FieldName = 'Price'
            Width = 63
          end
          object clCountPoint: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1090#1086#1095#1077#1082
            DataBinding.FieldName = 'CountPoint'
            Width = 63
          end
          object clTrevelTime: TcxGridDBColumn
            Caption = #1042#1088#1077#1084#1103' '#1074' '#1087#1091#1090#1080', '#1095#1072#1089#1086#1074
            DataBinding.FieldName = 'TrevelTime'
            Width = 63
          end
          object clComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 93
          end
          object clInfoMoney: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1080' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object clPaidKind: TcxGridDBColumn
            Caption = #1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object clRouteName: TcxGridDBColumn
            Caption = #1052#1072#1088#1096#1088#1091#1090
            DataBinding.FieldName = 'RouteName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object clCarName: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
            DataBinding.FieldName = 'CarName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object clCarModelName: TcxGridDBColumn
            Caption = #1052#1072#1088#1082#1072' '#1072#1074#1090#1086
            DataBinding.FieldName = 'CarModelName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object clContractConditionKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1091#1089#1083#1086#1074#1080#1081' '#1076#1086#1075#1086#1074#1086#1088#1072
            DataBinding.FieldName = 'ContractConditionKindName'
            Width = 50
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 884
    ExplicitWidth = 884
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 75
    Top = 211
  end
  inherited ActionList: TActionList
    Left = 47
    Top = 274
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TTransportServiceForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TTransportServiceForm'
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 112
  end
  inherited MasterCDS: TClientDataSet
    Left = 24
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TransportService'
    Params = <
      item
        Name = 'instartdate'
        Value = 41579d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inenddate'
        Value = 41608d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 120
    Top = 120
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 112
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
  inherited PeriodChoice: TPeriodChoice
    Left = 232
    Top = 104
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 328
    Top = 104
  end
  inherited spMovementUnComplete: TdsdStoredProc
    Left = 72
    Top = 176
  end
  inherited spMovementSetErased: TdsdStoredProc
    Left = 160
    Top = 168
  end
end
