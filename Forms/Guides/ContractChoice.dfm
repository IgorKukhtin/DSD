inherited ContractChoiceForm: TContractChoiceForm
  Caption = #1042#1099#1073#1086#1088' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
  ClientHeight = 496
  ClientWidth = 853
  ExplicitWidth = 861
  ExplicitHeight = 530
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 853
    Height = 470
    ExplicitWidth = 853
    ExplicitHeight = 470
    ClientRectBottom = 470
    ClientRectRight = 853
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 853
      ExplicitHeight = 470
      inherited cxGrid: TcxGrid
        Width = 853
        Height = 470
        ExplicitWidth = 853
        ExplicitHeight = 470
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colInvNumber: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object colStartDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1075#1086#1074#1086#1088#1072
            DataBinding.FieldName = 'StartDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
          end
          object colContractKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1076#1086#1075#1086#1074#1086#1088#1072
            DataBinding.FieldName = 'ContractKindName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 109
          end
          object colJuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1102#1088'. '#1083#1080#1094#1072
            DataBinding.FieldName = 'JuridicalCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 94
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 218
          end
          object colPaidKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 99
          end
          object colInfoMoneyName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1103' '#1079#1072#1090#1088#1072#1090
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object colisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'JuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'PaidKindId'
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
        end
        item
          Name = 'PaidKindName'
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyId'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'InfoMoneyName'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
        end>
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ContractChoice'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
