inherited ContactPersonForm: TContactPersonForm
  Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1099#1077' '#1083#1080#1094#1072
  ClientHeight = 335
  ClientWidth = 936
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 944
  ExplicitHeight = 362
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 936
    Height = 309
    ExplicitWidth = 936
    ExplicitHeight = 309
    ClientRectBottom = 309
    ClientRectRight = 936
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 936
      ExplicitHeight = 309
      inherited cxGrid: TcxGrid
        Width = 936
        Height = 309
        ExplicitWidth = 936
        ExplicitHeight = 309
        inherited cxGridDBTableView: TcxGridDBTableView
          OnDblClick = nil
          OnKeyDown = nil
          OnKeyPress = nil
          OnCustomDrawCell = nil
          DataController.Filter.OnChanged = nil
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          OnColumnHeaderClick = nil
          OnCustomDrawColumnHeader = nil
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentVert = vaCenter
            Width = 53
          end
          object clName: TcxGridDBColumn
            Caption = #1060#1048#1054
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Width = 208
          end
          object clPhone: TcxGridDBColumn
            Caption = #1058#1077#1083#1077#1092#1086#1085
            DataBinding.FieldName = 'Phone'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 109
          end
          object clMail: TcxGridDBColumn
            Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1087#1086#1095#1090#1072
            DataBinding.FieldName = 'Mail'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 114
          end
          object clPartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 105
          end
          object clJuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Width = 133
          end
          object clContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentVert = vaCenter
            Width = 83
          end
          object clContactPersonKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1082#1086#1085#1090#1072#1082#1090#1072
            DataBinding.FieldName = 'ContactPersonKindName'
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited actInsert: TInsertUpdateChoiceAction
      FormName = 'TContactPersonEditForm'
      FormNameParam.Value = 'TContactPersonEditForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TContactPersonEditForm'
      FormNameParam.Value = 'TContactPersonEditForm'
    end
  end
  inherited MasterCDS: TClientDataSet
    AfterInsert = nil
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ContactPerson'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
