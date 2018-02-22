inherited JuridicalForm: TJuridicalForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072'>'
  ClientWidth = 761
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 777
  ExplicitHeight = 346
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 761
    ExplicitWidth = 761
    ClientRectRight = 761
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 761
      inherited cxGrid: TcxGrid
        Width = 761
        ExplicitWidth = 761
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsBehavior.IncSearch = True
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Width = 58
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Width = 221
          end
          object OKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isCorporate: TcxGridDBColumn
            Caption = #1053#1072#1096#1077' '#1102#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'isCorporate'
            HeaderAlignmentVert = vaCenter
            Width = 98
          end
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentVert = vaCenter
            Width = 133
          end
          object PayOrder: TcxGridDBColumn
            Caption = #1054#1095#1077#1088#1077#1076#1100' '#1087#1083#1072#1090#1077#1078#1072
            DataBinding.FieldName = 'PayOrder'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object Percent: TcxGridDBColumn
            Caption = '% '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080' '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'Percent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object isLoadBarcode: TcxGridDBColumn
            Caption = #1048#1084#1087#1086#1088#1090' '#1096#1090#1088#1080#1093'-'#1082#1086#1076#1086#1074
            DataBinding.FieldName = 'isLoadBarcode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object isDeferred: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079' '#1074#1089#1077#1075#1076#1072' "'#1054#1090#1083#1086#1078#1077#1085'"'
            DataBinding.FieldName = 'isDeferred'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' - '#1079#1072#1082#1072#1079' '#1074#1089#1077#1075#1076#1072' "'#1054#1090#1083#1086#1078#1077#1085'"'
            Options.Editing = False
            Width = 84
          end
          object isErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 51
          end
        end
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 51
    Top = 176
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 432
    Top = 128
  end
  inherited ActionList: TActionList
    Left = 87
    Top = 215
    inherited actInsert: TInsertUpdateChoiceAction
      FormName = 'TJuridicalEditForm'
      FormNameParam.Value = 'TJuridicalEditForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TJuridicalEditForm'
      FormNameParam.Value = 'TJuridicalEditForm'
    end
  end
  inherited MasterDS: TDataSource
    Left = 88
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Left = 200
    Top = 72
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Juridical'
    Left = 216
    Top = 128
  end
  inherited BarManager: TdxBarManager
    Left = 272
    Top = 88
    DockControlHeights = (
      0
      0
      26
      0)
    inherited dxBarStatic: TdxBarStatic
      Left = 24
      Top = 72
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SearchAsFilter = False
    Left = 472
    Top = 80
  end
  inherited PopupMenu: TPopupMenu
    Left = 224
    Top = 208
  end
end
