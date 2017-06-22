inherited ChangeIncomePaymentKindForm: TChangeIncomePaymentKindForm
  Caption = #1042#1080#1076#1099' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1086#1082' '#1076#1086#1083#1075#1072' '#1087#1088#1080#1093#1086#1076#1085#1099#1093' '#1086#1082#1091#1084#1077#1085#1090#1086#1074
  ClientHeight = 190
  ClientWidth = 450
  ExplicitWidth = 466
  ExplicitHeight = 229
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 450
    Height = 164
    ExplicitWidth = 450
    ExplicitHeight = 164
    ClientRectBottom = 164
    ClientRectRight = 450
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 450
      ExplicitHeight = 164
      inherited cxGrid: TcxGrid
        Width = 450
        Height = 164
        ExplicitWidth = 450
        ExplicitHeight = 164
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.Footer = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Width = 37
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            Width = 314
          end
          object isErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
          end
        end
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 195
    Top = 48
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 168
    Top = 48
  end
  inherited ActionList: TActionList
    Left = 223
    Top = 47
  end
  inherited MasterDS: TDataSource
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ChangeIncomePaymentKind'
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 88
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 128
    Top = 104
  end
  inherited PopupMenu: TPopupMenu
    Left = 264
    Top = 48
  end
end
