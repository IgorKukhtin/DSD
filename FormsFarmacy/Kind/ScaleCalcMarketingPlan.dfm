inherited ScaleCalcMarketingPlanForm: TScaleCalcMarketingPlanForm
  Caption = #1064#1082#1072#1083#1072' '#1088#1072#1089#1095#1077#1090#1072' '#1087#1088#1077#1084#1080#1080'/'#1096#1090#1088#1072#1092#1099' '#1074' '#1087#1083#1072#1085' '#1087#1086' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1091
  ClientHeight = 286
  ClientWidth = 390
  ExplicitWidth = 406
  ExplicitHeight = 325
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 390
    Height = 260
    ExplicitWidth = 390
    ExplicitHeight = 260
    ClientRectBottom = 260
    ClientRectRight = 390
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 390
      ExplicitHeight = 260
      inherited cxGrid: TcxGrid
        Width = 390
        Height = 260
        ExplicitWidth = 390
        ExplicitHeight = 260
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 265
          end
          object Id: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
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
    Left = 24
    Top = 176
  end
  inherited ActionList: TActionList
    Left = 79
    Top = 175
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 64
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ScaleCalcMarketingPlan'
    Left = 72
    Top = 64
  end
  inherited BarManager: TdxBarManager
    Left = 104
    Top = 56
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 248
    Top = 80
  end
  inherited PopupMenu: TPopupMenu
    Left = 120
    Top = 176
  end
end
