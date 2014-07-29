inherited JuridicalForm: TJuridicalForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072'>'
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 591
  ExplicitHeight = 347
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    ExplicitTop = 28
    ExplicitHeight = 280
    inherited tsMain: TcxTabSheet
      ExplicitLeft = 4
      ExplicitTop = 4
      ExplicitWidth = 567
      ExplicitHeight = 272
      inherited cxGrid: TcxGrid
        Width = 567
        Height = 272
        ExplicitWidth = 567
        ExplicitHeight = 272
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
            Width = 58
          end
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            Width = 221
          end
          object clisCorporate: TcxGridDBColumn
            Caption = #1043#1083'.'#1102#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'isCorporate'
            Width = 75
          end
          object clRetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            Width = 150
          end
          object clisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Width = 57
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
    inherited actInsert: TdsdInsertUpdateAction
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
      28
      0)
    inherited dxBarStatic: TdxBarStatic
      Left = 24
      Top = 72
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 472
    Top = 80
  end
  inherited PopupMenu: TPopupMenu
    Left = 224
    Top = 208
  end
end
