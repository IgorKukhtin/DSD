inherited ConfirmedDialogForm: TConfirmedDialogForm
  BorderStyle = bsDialog
  Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1087#1088#1080#1079#1085#1072#1082#1072' <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
  ClientHeight = 253
  ClientWidth = 294
  ExplicitWidth = 300
  ExplicitHeight = 282
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 294
    Height = 227
    ExplicitWidth = 294
    ExplicitHeight = 227
    ClientRectBottom = 227
    ClientRectRight = 294
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 294
      ExplicitHeight = 227
      inherited cxGrid: TcxGrid
        Width = 294
        Height = 227
        ExplicitWidth = 294
        ExplicitHeight = 227
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 252
          end
        end
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 168
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
    Top = 168
  end
  inherited ActionList: TActionList
    Left = 87
    Top = 167
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isConfirmed'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'isConfirmed'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_ConfirmedDialog'
    Left = 120
    Top = 72
  end
  inherited BarManager: TdxBarManager
    Left = 176
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited PopupMenu: TPopupMenu
    Left = 128
    Top = 168
  end
end
