inherited EmployeeScheduleUserForm: TEmployeeScheduleUserForm
  Caption = #1047#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1074#1088#1077#1084#1077#1085#1080' '#1087#1088#1080#1093#1086#1076#1072' '#1085#1072' '#1088#1072#1073#1086#1090#1091' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1075#1088#1072#1092#1080#1082#1072
  ClientHeight = 423
  ClientWidth = 564
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 580
  ExplicitHeight = 462
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 564
    Height = 364
    ExplicitTop = 59
    ExplicitWidth = 374
    ExplicitHeight = 277
    ClientRectBottom = 364
    ClientRectRight = 564
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 374
      ExplicitHeight = 277
      inherited cxGrid: TcxGrid
        Width = 564
        Height = 364
        ExplicitWidth = 374
        ExplicitHeight = 159
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCash
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCard
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object PaidTypeName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidTypeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 116
          end
          object SummCash: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1085#1072#1083#1080#1095#1085#1099#1081' '#1088#1072#1089#1095#1077#1090
            DataBinding.FieldName = 'SummCash'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 105
          end
          object SummCard: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1082#1072#1088#1090#1077
            DataBinding.FieldName = 'SummCard'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 564
    Height = 33
    Align = alTop
    ShowCaption = False
    TabOrder = 5
    ExplicitWidth = 374
    object edOperDate: TcxDateEdit
      Left = 206
      Top = 3
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy'
      Properties.EditFormat = 'dd.mm.yyyy'
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 100
    end
    object cxLabel2: TcxLabel
      Left = 170
      Top = 4
      Caption = #1044#1072#1090#1072
    end
    object edCashRegisterName: TcxTextEdit
      Left = 49
      Top = 3
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 104
    end
    object cxLabel1: TcxLabel
      Left = 10
      Top = 4
      Caption = #1050#1072#1089#1089#1072
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 243
    Top = 256
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
  end
  inherited ActionList: TActionList
    Left = 119
    Top = 191
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 184
  end
  inherited MasterCDS: TClientDataSet
    Left = 32
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_EmployeeScheduleUser'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inCashRegisterName'
        Value = Null
        Component = FormParams
        ComponentItem = 'CashRegisterName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'Date'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 104
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 104
    DockControlHeights = (
      0
      0
      26
      0)
    inherited bbRefresh: TdxBarButton
      Left = 280
    end
    inherited dxBarStatic: TdxBarStatic
      Left = 208
      Top = 65528
    end
    inherited bbGridToExcel: TdxBarButton
      Left = 232
    end
    object bbOpen: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      Left = 160
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 352
    Top = 256
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'CashRegisterName'
        Value = Null
        Component = edCashRegisterName
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Date'
        Value = 'NULL'
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 104
  end
end
