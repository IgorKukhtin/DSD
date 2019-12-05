inherited Report_PercentageOverdueSUNForm: TReport_PercentageOverdueSUNForm
  Caption = #1055#1088#1086#1094#1077#1085#1090' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1093' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' '#1087#1086' '#1057#1059#1053
  ClientHeight = 375
  ClientWidth = 730
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 746
  ExplicitHeight = 414
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 65
    Width = 730
    Height = 310
    TabOrder = 3
    ExplicitTop = 65
    ExplicitWidth = 730
    ExplicitHeight = 310
    ClientRectBottom = 310
    ClientRectRight = 730
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 730
      ExplicitHeight = 310
      inherited cxGrid: TcxGrid
        Width = 730
        Height = 310
        ExplicitWidth = 730
        ExplicitHeight = 310
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Id: TcxGridDBColumn
            Caption = #1056#1077#1081#1090#1080#1085#1075
            DataBinding.FieldName = 'Id'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 59
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 296
          end
          object CountAll: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081
            DataBinding.FieldName = 'CountAll'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object CountOverdue: TcxGridDBColumn
            Caption = #1055#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1093
            DataBinding.FieldName = 'CountOverdue'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 123
          end
          object Procent: TcxGridDBColumn
            Caption = #1055#1088#1086#1094#1077#1085#1090' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1093
            DataBinding.FieldName = 'Procent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 94
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 730
    Height = 39
    ExplicitWidth = 730
    ExplicitHeight = 39
    inherited deStart: TcxDateEdit
      Left = 99
      Top = 8
      ExplicitLeft = 99
      ExplicitTop = 8
    end
    inherited deEnd: TcxDateEdit
      Left = 308
      Top = 8
      ExplicitLeft = 308
      ExplicitTop = 8
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      Top = 9
      ExplicitLeft = 8
      ExplicitTop = 9
    end
    inherited cxLabel2: TcxLabel
      Left = 198
      Top = 9
      ExplicitLeft = 198
      ExplicitTop = 9
    end
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_PeriodDialogForm'
      FormNameParam.Value = 'TReport_PeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = ''
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 'NULL'
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 296
    Top = 152
  end
  inherited MasterCDS: TClientDataSet
    Left = 192
    Top = 144
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_PercentageOverdueSUN'
    Left = 376
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 448
    Top = 168
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
          ItemName = 'bbExecuteDialog'
        end
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Top = 104
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 80
    Top = 152
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 264
  end
end
