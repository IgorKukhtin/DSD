inherited ChoiceRelatedProductForm: TChoiceRelatedProductForm
  Caption = #1042#1089#1103#1079#1072#1090#1100' '#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1084' <'#1057#1086#1087#1091#1090#1089#1090#1074#1091#1102#1097#1080#1077' '#1090#1086#1074#1072#1088#1099'>'
  ClientWidth = 449
  AddOnFormData.isAlwaysRefresh = True
  ExplicitWidth = 465
  ExplicitHeight = 347
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 449
    ExplicitWidth = 449
    ClientRectRight = 449
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 449
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 449
        ExplicitWidth = 449
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsBehavior.IncSearch = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object InvNumber: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 58
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 93
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 251
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
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Comment'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1084' <'#1057#1086#1087#1091#1090#1089#1090#1074#1091#1102#1097#1080#1077' '#1090#1086#1074#1072#1088#1099'>'
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1084' <'#1057#1086#1087#1091#1090#1089#1090#1074#1091#1102#1097#1080#1077' '#1090#1086#1074#1072#1088#1099'>'
      ImageIndex = 1
      FormName = 'TRelatedProductForm'
      FormNameParam.Value = 'TRelatedProductForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'ID'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ID'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      CheckIDRecords = True
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 64
  end
  inherited MasterCDS: TClientDataSet
    Left = 24
    Top = 64
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ChoiceRelatedProduct'
    Left = 88
    Top = 64
  end
  inherited BarManager: TdxBarManager
    Left = 128
    Top = 64
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
          ItemName = 'bbUpdate'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    object bbUpdate: TdxBarButton
      Action = actUpdate
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SearchAsFilter = False
    Left = 224
    Top = 256
  end
end
