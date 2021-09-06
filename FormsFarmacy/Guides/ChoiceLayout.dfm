inherited ChoiceLayoutForm: TChoiceLayoutForm
  Caption = #1042#1099#1073#1086#1088' '#1074#1099#1082#1083#1072#1076#1082#1080
  ClientWidth = 492
  AddOnFormData.isAlwaysRefresh = True
  ExplicitWidth = 508
  ExplicitHeight = 347
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 492
    ExplicitWidth = 449
    ClientRectRight = 492
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 449
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 492
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
          object isPharmacyItem: TcxGridDBColumn
            Caption = #1040#1072#1087#1090'. '#1087#1091#1085#1082#1090
            DataBinding.FieldName = 'isPharmacyItem'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 49
          end
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
          object LayoutName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'LayoutName'
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
          ComponentItem = 'LayoutName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1084' <'#1042#1099#1082#1083#1072#1076#1082#1080'>'
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1084' <'#1042#1099#1082#1083#1072#1076#1082#1080'>'
      ImageIndex = 1
      FormName = 'TLayout_MovementForm'
      FormNameParam.Value = 'TLayout_MovementForm'
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
    StoredProcName = 'gpSelect_Movement_ChoiceLayout'
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
