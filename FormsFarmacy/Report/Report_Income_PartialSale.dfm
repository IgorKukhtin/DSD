inherited Report_Income_PartialSaleForm: TReport_Income_PartialSaleForm
  Caption = #1042#1086#1079#1084#1086#1078#1085#1086#1089#1090#1100' '#1086#1087#1083#1072#1090#1099' '#1087#1088#1080#1093#1086#1076#1086#1074' '#1087#1088#1080' '#1086#1087#1083#1072#1090#1077' '#1095#1072#1089#1090#1103#1084#1080
  ClientHeight = 433
  ClientWidth = 901
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 917
  ExplicitHeight = 472
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 85
    Width = 901
    Height = 348
    TabOrder = 3
    ExplicitTop = 85
    ExplicitWidth = 759
    ExplicitHeight = 348
    ClientRectBottom = 348
    ClientRectRight = 901
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 759
      ExplicitHeight = 348
      inherited cxGrid: TcxGrid
        Width = 901
        Height = 348
        ExplicitWidth = 759
        ExplicitHeight = 348
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.DetailKeyFieldNames = 'JuridicalId;FromId'
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = Remains
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = NoPay
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = ToPay
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object FromName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 122
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1053#1072#1096#1077' '#1102#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 136
          end
          object InvNumber: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 157
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object NoPay: TcxGridDBColumn
            Caption = #1053#1077' '#1086#1087#1083#1072#1095#1077#1085#1086' '#1087#1086' '#1087#1088#1093#1086#1076#1091
            DataBinding.FieldName = 'NoPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object Remains: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1086#1089#1090#1072#1090#1082#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object ToPay: TcxGridDBColumn
            Caption = #1050' '#1086#1087#1083#1072#1090#1077
            DataBinding.FieldName = 'ToPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 901
    Height = 59
    ExplicitWidth = 759
    ExplicitHeight = 59
    inherited deStart: TcxDateEdit
      Left = 131
      Top = 8
      ExplicitLeft = 131
      ExplicitTop = 8
    end
    inherited deEnd: TcxDateEdit
      Left = 394
      Top = 8
      Visible = False
      ExplicitLeft = 394
      ExplicitTop = 8
    end
    inherited cxLabel1: TcxLabel
      Left = 7
      Top = 9
      Caption = #1044#1072#1090#1072' '#1086#1089#1090#1074#1090#1082#1072' '#1090#1086#1074#1072#1088#1072':'
      ExplicitLeft = 7
      ExplicitTop = 9
      ExplicitWidth = 117
    end
    inherited cxLabel2: TcxLabel
      Left = 284
      Top = 9
      Visible = False
      ExplicitLeft = 284
      ExplicitTop = 9
    end
    object cxLabel3: TcxLabel
      Left = 8
      Top = 33
      Caption = #1053#1072#1096#1077' '#1102#1088'. '#1083#1080#1094#1086':'
    end
    object cxLabel4: TcxLabel
      Left = 346
      Top = 35
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
    end
    object edFrom: TcxButtonEdit
      Left = 417
      Top = 32
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 6
      Width = 301
    end
    object edJuridical: TcxButtonEdit
      Left = 102
      Top = 32
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 237
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = GuidesFrom
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesJuridical
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Income_PartialSaleDialogForm'
      FormNameParam.Value = 'TReport_Income_PartialSaleDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromlName'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = GuidesJuridical
          ComponentItem = 'Key'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = GuidesJuridical
          ComponentItem = 'TextValue'
          DataType = ftString
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
    StoredProcName = 'gpReport_Income_PartialSale'
    Params = <
      item
        Name = 'inOperDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1080#1079#1084#1077#1085#1077#1085#1080#1081' '#1076#1086#1083#1075#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '#1087#1086' '#1095#1072#1089#1090#1080#1095#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077
      Category = 0
      Hint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1080#1079#1084#1077#1085#1077#1085#1080#1081' '#1076#1086#1083#1075#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '#1087#1086' '#1095#1072#1089#1090#1080#1095#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077
      Visible = ivAlways
      ImageIndex = 8
    end
    object dxBarButton2: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object dxBarButton3: TdxBarButton
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
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 528
    Top = 24
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridicalCorporateForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalCorporateForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 24
  end
end
