inherited ContractForm: TContractForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1044#1086#1075#1086#1074#1086#1088#1072'>'
  ClientWidth = 707
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 715
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 707
    ExplicitWidth = 707
    ClientRectRight = 707
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 707
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 707
        ExplicitWidth = 707
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Width = 77
          end
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Width = 177
          end
          object clJuridicalBasisName: TcxGridDBColumn
            Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalBasisName'
            HeaderAlignmentVert = vaCenter
            Width = 132
          end
          object clJuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Width = 185
          end
          object clComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentVert = vaCenter
            Width = 122
          end
          object clisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Width = 30
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TContractEditForm'
      FormNameParam.Value = 'TContractEditForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TContractEditForm'
      FormNameParam.Value = 'TContractEditForm'
    end
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Contract'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
