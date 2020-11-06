inherited ChoiceIncomeForm: TChoiceIncomeForm
  Caption = #1042#1099#1073#1086#1088' '#1087#1088#1080#1093#1086#1076#1072' '#1076#1083#1103' '#1079#1072#1075#1088#1091#1079#1082#1080
  ClientWidth = 605
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.Params = FormParams
  ExplicitWidth = 621
  ExplicitHeight = 347
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 605
    ExplicitWidth = 605
    ClientRectRight = 605
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 605
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 605
        ExplicitWidth = 605
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
            Width = 73
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 123
          end
          object TotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
            DataBinding.FieldName = 'TotalCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 97
          end
          object TotalSummPVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1079#1072#1082#1091#1087#1082#1080' '#1074' '#1091#1089#1088#1077#1076'. '#1094#1077#1085#1072#1093' ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'TotalSummPVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 129
          end
          object TotalSummTo: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074' '#1094#1077#1085#1072#1093' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
            DataBinding.FieldName = 'TotalSummTo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 138
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 197
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
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      ImageIndex = 1
      FormName = 'TSendForm'
      FormNameParam.Value = 'TSendForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'ID'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 42005d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
    StoredProcName = 'gpSelect_Movement_ChoiceIncome'
    Params = <
      item
        Name = 'inUnitID'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
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
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actUpdate
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SearchAsFilter = False
    Left = 224
    Top = 256
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UnitID'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 72
  end
end
