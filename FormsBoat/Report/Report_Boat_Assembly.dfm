inherited Report_Boat_AssemblyForm: TReport_Boat_AssemblyForm
  Caption = #1051#1086#1076#1082#1072' - '#1069#1090#1072#1087#1099' '#1089#1073#1086#1088#1082#1080
  ClientHeight = 346
  ClientWidth = 1071
  AddOnFormData.Params = FormParams
  ExplicitLeft = -177
  ExplicitWidth = 1087
  ExplicitHeight = 385
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 80
    Width = 1071
    Height = 266
    TabOrder = 3
    ExplicitTop = 80
    ExplicitWidth = 1071
    ExplicitHeight = 266
    ClientRectBottom = 266
    ClientRectRight = 1071
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1071
      ExplicitHeight = 266
      inherited cxGrid: TcxGrid
        Width = 1071
        Height = 266
        ExplicitWidth = 1071
        ExplicitHeight = 266
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_111
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_112
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = InvNumberFull_OrderClient
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_111
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_112
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object NPP_OrderClient: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087' '#1060#1072#1082#1090
            DataBinding.FieldName = 'NPP_OrderClient'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1074' '#1086#1095#1077#1088#1077#1076#1080' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1089#1073#1086#1088#1082#1080' ('#1060#1072#1082#1090')'
            Options.Editing = False
            Width = 55
          end
          object StateText: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
            DataBinding.FieldName = 'StateText'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object OperDate_OrderClient: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'OperDate_OrderClient'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
            Width = 70
          end
          object InvNumberFull_OrderClient: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'InvNumberFull_OrderClient'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 109
          end
          object ClientName: TcxGridDBColumn
            Caption = 'Kunden'
            DataBinding.FieldName = 'ClientName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1083#1080#1077#1085#1090
            Options.Editing = False
            Width = 130
          end
          object ProductName: TcxGridDBColumn
            Caption = 'Boat'
            DataBinding.FieldName = 'ProductName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 100
          end
          object TaxKindName_Client: TcxGridDBColumn
            Caption = '% '#1053#1044#1057' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'TaxKindName_Client'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ObjectCode: TcxGridDBColumn
            Caption = 'Interne Nr'
            DataBinding.FieldName = 'ObjectCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Article_all: TcxGridDBColumn
            Caption = '***Artikel Nr'
            DataBinding.FieldName = 'Article_all'
            Visible = False
            Options.Editing = False
            Width = 70
          end
          object ObjectName: TcxGridDBColumn
            Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
            DataBinding.FieldName = 'ObjectName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object NPP_2: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087' '#1055#1083#1072#1085
            DataBinding.FieldName = 'NPP_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1074' '#1086#1095#1077#1088#1077#1076#1080' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1089#1073#1086#1088#1082#1080' ('#1055#1083#1072#1085')'
            Options.Editing = False
            Width = 55
          end
          object DateBegin: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1083#1072#1085
            DataBinding.FieldName = 'DateBegin'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1075#1076#1072' '#1087#1083#1072#1085#1080#1088#1091#1077#1090#1089#1103' '#1079#1072#1074#1077#1088#1096#1080#1090#1100' '#1089#1073#1086#1088#1082#1091' '#1083#1086#1076#1082#1080
            Options.Editing = False
            Width = 66
          end
          object TotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1082#1086#1084#1087#1083'. '#1074' '#1079#1072#1082#1072#1079#1077
            DataBinding.FieldName = 'TotalCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Remains_111: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' ('#1057#1082#1083#1072#1076' '#1054#1089#1085#1086#1074#1085#1086#1081')'
            DataBinding.FieldName = 'Remains_111'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072' <'#1057#1082#1083#1072#1076' '#1054#1089#1085#1086#1074#1085#1086#1081'>'
            Width = 80
          end
          object Remains_112: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' ('#1057#1090#1077#1082#1083#1086#1087#1083#1072#1089#1090#1080#1082' '#1055#1060')'
            DataBinding.FieldName = 'Remains_112'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072' <'#1059#1095#1072#1089#1090#1086#1082' '#1080#1079#1075#1086#1090#1086#1074#1083#1077#1085#1080#1077' '#1057#1090#1077#1082#1083#1086#1087#1083#1072#1089#1090#1080#1082' '#1055#1060'>'
            Width = 80
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1086#1089#1085'.'#1089#1082#1083#1072#1076#1077
            Width = 80
          end
          object Amount_111: TcxGridDBColumn
            Caption = '1.1.1 '#1054#1089#1090'. '#1057#1082#1083#1072#1076' '#1054#1089#1085#1086#1074#1085#1086#1081
            DataBinding.FieldName = 'Amount_111'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082' '#1076#1077#1090#1072#1083#1077#1081' '#1085#1072' <'#1057#1082#1083#1072#1076' '#1054#1089#1085#1086#1074#1085#1086#1081'>'
            Options.Editing = False
            Width = 80
          end
          object Amount_112: TcxGridDBColumn
            Caption = '1.1.2. '#1054#1089#1090'. '#1059#1095#1072#1089#1090#1086#1082' '#1055#1060
            DataBinding.FieldName = 'Amount_112'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1082#1080' '#1089#1099#1088#1100#1103' '#1085#1072' <'#1059#1095#1072#1089#1090#1086#1082' '#1080#1079#1075#1086#1090#1086#1074#1083#1077#1085#1080#1077' '#1057#1090#1077#1082#1083#1086#1087#1083#1072#1089#1090#1080#1082' '#1055#1060'>'
            Width = 85
          end
          object Amount_12: TcxGridDBColumn
            Caption = '1.2. '#1055#1077#1088#1077#1084#1077#1097'. '#1076#1077#1090#1072#1083#1077#1081
            DataBinding.FieldName = 'Amount_12'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1076#1077#1090#1072#1083#1077#1081' '#1089' '#1086#1089#1090#1072#1090#1082#1072' '#1057#1082#1083#1072#1076' '#1054#1089#1085#1086#1074#1085#1086#1081' -> '#1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080' '#1054 +
              #1089#1085#1086#1074#1085#1086#1081
            Width = 70
          end
          object Amount_13: TcxGridDBColumn
            Caption = '1.3. '#1055#1077#1088#1077#1084#1077#1097'. '#1059#1079#1083#1099' '#1055#1060
            DataBinding.FieldName = 'Amount_13'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1089' '#1086#1089#1090#1072#1090#1082#1072' '#1057#1082#1083#1072#1076' '#1054#1089#1085#1086#1074#1085#1086#1081' -> '#1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080' '#1054#1089#1085#1086#1074#1085#1086#1081
            Width = 70
          end
          object Amount_14: TcxGridDBColumn
            Caption = '1.4. '#1055#1077#1088#1077#1084#1077#1097'. '#1059#1079#1083#1099' '#1057#1090#1077#1082#1083#1086#1087#1083#1072#1089#1090#1080#1082
            DataBinding.FieldName = 'Amount_14'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1089' '#1086#1089#1090#1072#1090#1082#1072' '#1057#1082#1083#1072#1076' '#1054#1089#1085#1086#1074#1085#1086#1081' -> '#1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080' '#1054#1089#1085#1086#1074#1085#1086#1081
            Width = 70
          end
          object Amount_15: TcxGridDBColumn
            Caption = '1.5. '#1055#1077#1088#1077#1084#1077#1097'. '#1059#1079#1077#1083' Hypalon'
            DataBinding.FieldName = 'Amount_15'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1089' '#1086#1089#1090#1072#1090#1082#1072' '#1057#1082#1083#1072#1076' '#1054#1089#1085#1086#1074#1085#1086#1081' -> '#1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080' '#1054#1089#1085#1086#1074#1085#1086#1081
            Width = 85
          end
          object Amount_16: TcxGridDBColumn
            Caption = '1.6. '#1055#1077#1088#1077#1084#1077#1097'. Teak'
            DataBinding.FieldName = 'Amount_16'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1089' '#1086#1089#1090#1072#1090#1082#1072' '#1057#1082#1083#1072#1076' '#1054#1089#1085#1086#1074#1085#1086#1081' -> '#1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080' '#1054#1089#1085#1086#1074#1085#1086#1081
            Options.Editing = False
            Width = 70
          end
          object Amount_17: TcxGridDBColumn
            Caption = '1.7. '#1055#1077#1088#1077#1084#1077#1097'. '#1059#1079#1077#1083' Upholstery'
            DataBinding.FieldName = 'Amount_17'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1089' '#1086#1089#1090#1072#1090#1082#1072' '#1057#1082#1083#1072#1076' '#1054#1089#1085#1086#1074#1085#1086#1081' -> '#1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080' '#1054#1089#1085#1086#1074#1085#1086#1081
            Options.Editing = False
            Width = 90
          end
          object Amount_18: TcxGridDBColumn
            Caption = '1.8. '#1055#1077#1088#1077#1084#1077#1097'. '#1084#1086#1090#1086#1088
            DataBinding.FieldName = 'Amount_18'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1089' '#1086#1089#1090#1072#1090#1082#1072' '#1057#1082#1083#1072#1076' '#1054#1089#1085#1086#1074#1085#1086#1081' -> '#1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080' '#1054#1089#1085#1086#1074#1085#1086#1081
            Options.Editing = False
            Width = 70
          end
          object Amount_19: TcxGridDBColumn
            Caption = '1.9. '#1055#1077#1088#1077#1084#1077#1097'. '#1086#1087#1094#1080#1080
            DataBinding.FieldName = 'Amount_19'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1089' '#1086#1089#1090#1072#1090#1082#1072' '#1057#1082#1083#1072#1076' '#1054#1089#1085#1086#1074#1085#1086#1081' -> '#1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080' '#1054#1089#1085#1086#1074#1085#1086#1081
            Options.Editing = False
            Width = 70
          end
        end
      end
      object cbisGoods: TcxCheckBox
        Left = 434
        Top = 100
        Hint = #1056#1072#1079#1074#1077#1088#1085#1091#1090#1100' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' ('#1076#1072') / '#1042#1089#1077' ('#1053#1077#1090')'
        Action = actRefreshEmpty
        Properties.ReadOnly = False
        TabOrder = 1
        Width = 233
      end
    end
  end
  inherited Panel: TPanel
    Width = 1071
    Height = 54
    Visible = False
    ExplicitWidth = 1071
    ExplicitHeight = 54
    inherited deStart: TcxDateEdit
      Left = 974
      Top = 4
      Properties.SaveTime = False
      Visible = False
      ExplicitLeft = 974
      ExplicitTop = 4
    end
    inherited deEnd: TcxDateEdit
      Left = 974
      Top = 30
      Properties.SaveTime = False
      Visible = False
      ExplicitLeft = 974
      ExplicitTop = 30
    end
    inherited cxLabel1: TcxLabel
      Left = 877
      Top = 7
      Visible = False
      ExplicitLeft = 877
      ExplicitTop = 7
    end
    inherited cxLabel2: TcxLabel
      Left = 862
      Top = 31
      Visible = False
      ExplicitLeft = 862
      ExplicitTop = 31
    end
    object cxLabel3: TcxLabel
      Left = 219
      Top = 31
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077':'
    end
    object edGoods: TcxButtonEdit
      Left = 315
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 209
    end
    object cxLabel8: TcxLabel
      Left = 263
      Top = 7
      Caption = #1050#1083#1080#1077#1085#1090':'
    end
    object edPartner: TcxButtonEdit
      Left = 315
      Top = 4
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 209
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
        Component = GuidesGoods
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesPartner
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object actRefreshEmpty: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1056#1072#1079#1074#1077#1088#1085#1091#1090#1100' ('#1076#1072'/'#1085#1077#1090')'
      Hint = #1056#1072#1079#1074#1077#1088#1085#1091#1090#1100' ('#1076#1072'/'#1085#1077#1090')'
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'MovementDescName_order;OperDate;ObjectByName;InvNumber'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = Null
          Component = GuidesPartner
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isSumm_branch'
          Value = Null
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Boat_AssemblyDialogForm'
      FormNameParam.Value = 'TReport_Boat_AssemblyDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'Key'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isEmpty'
          Value = ''
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementForm
      StoredProcList = <
        item
          StoredProc = getMovementForm
        end>
      Caption = 'actGetForm'
    end
    object actOpenFormClient: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1047#1072#1082#1072#1079' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1047#1072#1082#1072#1079' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      ImageIndex = 28
      FormName = 'TOrderClientForm'
      FormNameParam.Value = 'TOrderClientForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_OrderClient'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate_OrderClient'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenFormPartner: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1047#1072#1082#1072#1079' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1047#1072#1082#1072#1079' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      ImageIndex = 28
      FormName = 'TOrderPartnerForm'
      FormNameParam.Value = 'TOrderPartnerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_OrderPartner'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate_OrderPartner'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          DataType = ftString
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
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Boat_Assembly'
    Params = <
      item
        Name = 'inisGoods'
        Value = Null
        Component = cbisGoods
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 144
    Top = 208
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
          ItemName = 'bbedSearchArticle'
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
          ItemName = 'bbOpenFormClient'
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
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbSumm_branch: TdxBarControlContainerItem
      Caption = 'bbSumm_branch'
      Category = 0
      Hint = 'bbSumm_branch'
      Visible = ivAlways
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbOpenFormClient: TdxBarButton
      Action = actOpenFormClient
      Category = 0
    end
    object bbOpenFormPartner: TdxBarButton
      Action = actOpenFormPartner
      Category = 0
    end
    object bbedSearchArticle: TdxBarControlContainerItem
      Caption = 'edSearchArticle'
      Category = 0
      Hint = 'edSearchArticle'
      Visible = ivAlways
      Control = cbisGoods
    end
    object bblbSearchArticle: TdxBarControlContainerItem
      Caption = 'lbSearchArticle'
      Category = 0
      Hint = 'lbSearchArticle'
      Visible = ivAlways
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 368
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 216
    Top = 256
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesPartner
      end
      item
      end
      item
      end
      item
        Component = GuidesGoods
      end>
    Left = 176
    Top = 192
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 440
    Top = 11
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    FormNameParam.Value = 'TPartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 344
  end
  object getMovementForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 632
    Top = 200
  end
  object TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 536
    Top = 240
  end
  object TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 480
    Top = 232
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 43101d
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 43101d
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitGroupId'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitGroupName'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 200
  end
  object FieldFilter_Article: TdsdFieldFilter
    DataSet = MasterCDS
    Column = Article_all
    ColumnList = <
      item
        Column = Article_all
      end>
    ActionNumber1 = actChoiceGuides
    CheckBoxList = <>
    Left = 352
    Top = 184
  end
end
