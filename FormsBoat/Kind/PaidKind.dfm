inherited PaidKindForm: TPaidKindForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1060#1086#1088#1084#1099' '#1086#1087#1083#1072#1090'>'
  ClientWidth = 350
  ExplicitWidth = 366
  ExplicitHeight = 347
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 350
    ExplicitWidth = 336
    ClientRectRight = 350
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 336
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 350
        Height = 241
        ExplicitWidth = 336
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsView.Footer = False
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
            Width = 55
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 252
          end
        end
      end
      object Panel_btn: TPanel
        Left = 0
        Top = 241
        Width = 350
        Height = 41
        Align = alBottom
        TabOrder = 1
        ExplicitTop = 335
        ExplicitWidth = 633
        object btnChoiceGuides: TcxButton
          Left = 51
          Top = 8
          Width = 90
          Height = 25
          Action = ChoiceGuides
          TabOrder = 0
        end
        object btnFormClose: TcxButton
          Left = 169
          Top = 8
          Width = 90
          Height = 25
          Action = actFormClose
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
        end
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 184
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
    Top = 200
  end
  inherited ActionList: TActionList
    Left = 103
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
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1054#1050
      ImageIndex = 80
    end
    object actFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1054#1090#1084#1077#1085#1072
      ImageIndex = 52
    end
  end
  inherited MasterDS: TDataSource
    Left = 96
    Top = 24
  end
  inherited MasterCDS: TClientDataSet
    Left = 32
    Top = 72
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_PaidKind'
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
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChoice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 256
    Top = 256
  end
  inherited PopupMenu: TPopupMenu
    Left = 104
    Top = 168
  end
end
