inherited PersonalServiceForm: TPersonalServiceForm
  Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1079#1072#1088#1087#1083#1072#1090#1099
  ClientHeight = 381
  ClientWidth = 982
  AddOnFormData.isAlwaysRefresh = False
  ExplicitWidth = 990
  ExplicitHeight = 408
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 982
    Height = 324
    ExplicitWidth = 982
    ExplicitHeight = 324
    ClientRectBottom = 324
    ClientRectRight = 982
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 982
      ExplicitHeight = 324
      inherited cxGrid: TcxGrid
        Width = 982
        Height = 324
        ExplicitWidth = 982
        ExplicitHeight = 324
        inherited cxGridDBTableView: TcxGridDBTableView
          OnDblClick = nil
          OnKeyDown = nil
          OnKeyPress = nil
          OnCustomDrawCell = nil
          DataController.Filter.OnChanged = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          OnColumnHeaderClick = nil
          OnCustomDrawColumnHeader = nil
          inherited colStatus: TcxGridDBColumn
            Width = 55
          end
          inherited colInvNumber: TcxGridDBColumn
            Width = 89
          end
          inherited colOperDate: TcxGridDBColumn
            Width = 56
          end
          object clAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1086#1087#1077#1088#1072#1094#1080#1080
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object clPaidKind: TcxGridDBColumn
            Caption = #1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object clInfoMoney: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1080' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 86
          end
          object clUnit: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 63
          end
          object clPosition: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 83
          end
          object clServiceDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'ServiceDate'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 89
          end
          object clErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 982
    ExplicitWidth = 982
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TPersonalServiceEditForm'
      FormNameParam.Value = 'TPersonalServiceEditForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TPersonalServiceEditForm'
      FormNameParam.Value = 'TPersonalServiceEditForm'
    end
  end
  inherited MasterCDS: TClientDataSet
    AfterInsert = nil
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PersonalService'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited PeriodChoice: TPeriodChoice
    Top = 96
  end
end
