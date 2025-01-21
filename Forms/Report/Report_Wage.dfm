inherited Report_WageForm: TReport_WageForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1088#1072#1089#1095#1077#1090#1091' '#1079#1072#1088#1086#1073#1086#1090#1085#1086#1081' '#1087#1083#1072#1090#1099
  ClientHeight = 401
  ClientWidth = 991
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1007
  ExplicitHeight = 440
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 115
    Width = 991
    Height = 286
    TabOrder = 3
    ExplicitTop = 115
    ExplicitWidth = 991
    ExplicitHeight = 286
    ClientRectBottom = 286
    ClientRectRight = 991
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 991
      ExplicitHeight = 286
      inherited cxGrid: TcxGrid
        Width = 991
        Height = 286
        ExplicitWidth = 991
        ExplicitHeight = 286
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = GrossOnOneMember
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountOnOneMember
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SheetWorkTime_Amount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountOnOneMember
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = GrossOnOneMember
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SheetWorkTime_Amount
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = MemberName
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object StaffListCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1096#1090'.'#1088'.'
            DataBinding.FieldName = 'StaffListCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object StaffListName: TcxGridDBColumn
            Caption = #1064#1090#1072#1090#1085#1086#1077' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077
            DataBinding.FieldName = 'StaffListName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 130
          end
          object DocumentKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'DocumentKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object PersonalGroupName: TcxGridDBColumn
            Caption = #1041#1088#1080#1075#1072#1076#1072
            DataBinding.FieldName = 'PersonalGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PositionName: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 106
          end
          object PositionLevelName: TcxGridDBColumn
            Caption = #1056#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'PositionLevelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 98
          end
          object MemberName: TcxGridDBColumn
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 102
          end
          object Count_Member: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1083#1086#1074#1077#1082' ('#1074#1089#1077')'
            DataBinding.FieldName = 'Count_Member'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object Count_Day: TcxGridDBColumn
            Caption = #1054#1090#1088#1072#1073'. '#1076#1085'. 1 '#1095#1077#1083' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'Count_Day'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SheetWorkTime_Amount: TcxGridDBColumn
            Caption = #1054#1090#1088#1072#1073'. '#1095#1072#1089#1086#1074' 1 '#1095#1077#1083
            DataBinding.FieldName = 'SheetWorkTime_Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SUM_MemberHours: TcxGridDBColumn
            Caption = #1054#1090#1088#1072#1073'. '#1095#1072#1089#1086#1074' ('#1074#1089#1077')'
            DataBinding.FieldName = 'SUM_MemberHours'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Price: TcxGridDBColumn
            Caption = #1075#1088#1085'./'#1079#1072' '#1082#1075' '#1048#1051#1048' '#1075#1088#1085'./'#1089#1090#1072#1074#1082#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object PriceName: TcxGridDBColumn
            Caption = #1080#1085#1092#1086' ('#1089#1090#1072#1074#1082#1072')'
            DataBinding.FieldName = 'PriceName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object ServiceModelName: TcxGridDBColumn
            Caption = #1052#1086#1076#1077#1083#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' / '#1058#1080#1087' '#1089#1091#1084#1084#1099
            DataBinding.FieldName = 'ServiceModelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 131
          end
          object FromName: TcxGridDBColumn
            Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099': '#1086#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 129
          end
          object ToName: TcxGridDBColumn
            Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099': '#1082#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 132
          end
          object MovementDescName: TcxGridDBColumn
            Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099': '#1090#1080#1087
            DataBinding.FieldName = 'MovementDescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 118
          end
          object ModelServiceItemChild_FromCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088': '#1088#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'ModelServiceItemChild_FromCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ModelServiceItemChild_FromName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088': '#1088#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'ModelServiceItemChild_FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 105
          end
          object StorageLineName_From: TcxGridDBColumn
            Caption = #1051#1080#1085#1080#1103' '#1087#1088'-'#1074#1072': '#1088#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'StorageLineName_From'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object StorageLineName_To: TcxGridDBColumn
            Caption = #1051#1080#1085#1080#1103' '#1087#1088'-'#1074#1072': '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'StorageLineName_To'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object GoodsKind_FromName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074': '#1088#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'GoodsKind_FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object GoodsKindComplete_FromName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074' ('#1043#1055'): '#1088#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'GoodsKindComplete_FromName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ModelServiceItemChild_ToCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088': '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'ModelServiceItemChild_ToCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 53
          end
          object ModelServiceItemChild_ToName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088': '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'ModelServiceItemChild_ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 112
          end
          object GoodsKind_ToName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074': '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'GoodsKind_ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object GoodsKindComplete_ToName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074' ('#1043#1055'): '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'GoodsKindComplete_ToName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object MonthDate: TcxGridDBColumn
            Caption = #1052#1077#1089#1103#1094
            DataBinding.FieldName = 'OperDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DisplayFormat = 'mmmm yyyy '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object Count_MemberInDay: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1083#1086#1074#1077#1082' ('#1079#1072' 1 '#1076'.)'
            DataBinding.FieldName = 'Count_MemberInDay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Gross: TcxGridDBColumn
            Caption = #1041#1072#1079#1072' '#1080#1090#1086#1075#1086', '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Gross'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 92
          end
          object GrossOnOneMember: TcxGridDBColumn
            Caption = #1041#1072#1079#1072' '#1085#1072' 1-'#1075#1086' '#1095#1077#1083', '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'GrossOnOneMember'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object Amount: TcxGridDBColumn
            Caption = #1054#1073#1097#1072#1103' '#1089#1091#1084#1084#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object AmountOnOneMember: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1085#1072' 1 '#1095#1077#1083', '#1075#1088#1085
            DataBinding.FieldName = 'AmountOnOneMember'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object KoeffHoursWork_car: TcxGridDBColumn
            Caption = #1050#1086#1101#1092#1092'. '#1076#1083#1103' '#1084#1086#1076#1077#1083#1080' '#1088'.'#1074#1088'.'
            DataBinding.FieldName = 'KoeffHoursWork_car'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1101#1092#1092'. '#1076#1083#1103' '#1084#1086#1076#1077#1083#1080' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080' ('#1040#1074#1090#1086')'
            Width = 80
          end
          object PersonalServiceListName: TcxGridDBColumn
            Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'PersonalServiceListName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 164
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 991
    Height = 89
    ExplicitWidth = 991
    ExplicitHeight = 89
    inherited deStart: TcxDateEdit
      Left = 10
      Top = 23
      ExplicitLeft = 10
      ExplicitTop = 23
      ExplicitWidth = 91
      Width = 91
    end
    inherited deEnd: TcxDateEdit
      Left = 144
      Top = 23
      ExplicitLeft = 144
      ExplicitTop = 23
      ExplicitWidth = 97
      Width = 97
    end
    inherited cxLabel2: TcxLabel
      Left = 144
      ExplicitLeft = 144
    end
    object cxLabel4: TcxLabel
      Left = 281
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object ceUnit: TcxButtonEdit
      Left = 281
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 256
    end
    object cxLabel3: TcxLabel
      Left = 543
      Top = 6
      Caption = #1052#1086#1076#1077#1083#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
    end
    object ceModelService: TcxButtonEdit
      Left = 543
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 256
    end
    object cxLabel5: TcxLabel
      Left = 10
      Top = 50
      Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100':'
    end
    object cePosition: TcxButtonEdit
      Left = 10
      Top = 67
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 256
    end
    object cxLabel7: TcxLabel
      Left = 281
      Top = 50
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082':'
    end
    object ceMember: TcxButtonEdit
      Left = 281
      Top = 67
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 256
    end
    object chkDetailDay: TcxCheckBox
      Left = 543
      Top = 50
      Caption = #1055#1086' '#1076#1085#1103#1084
      TabOrder = 12
      Width = 66
    end
    object chkDetailModelService: TcxCheckBox
      Left = 802
      Top = 50
      Caption = #1055#1086' '#1084#1086#1076#1077#1083#1103#1084
      TabOrder = 13
      Width = 82
    end
    object chkDetailModelServiceItemMaster: TcxCheckBox
      Left = 641
      Top = 50
      Caption = #1055#1086' '#1090#1080#1087#1072#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      TabOrder = 14
      Width = 138
    end
    object chkDetailModelServiceItemChild: TcxCheckBox
      Left = 641
      Top = 67
      Caption = #1055#1086' '#1058#1086#1074#1072#1088#1091' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077
      TabOrder = 15
      Width = 146
    end
    object chkDetailMonth: TcxCheckBox
      Left = 543
      Top = 67
      Cursor = crDrag
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Caption = #1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      TabOrder = 16
      Width = 88
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = chkDetailDay
        Properties.Strings = (
          'Checked')
      end
      item
        Component = chkDetailModelService
        Properties.Strings = (
          'Checked')
      end
      item
        Component = chkDetailModelServiceItemChild
        Properties.Strings = (
          'Checked')
      end
      item
        Component = chkDetailModelServiceItemMaster
        Properties.Strings = (
          'Checked')
      end
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
        Component = MemberGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = ModelServiceGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = PositionGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = UnitGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    inherited actGridToExcel: TdsdGridToExcel
      ExportType = cxegExportToXlsx
    end
    object actPrint1: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1062#1077#1093' '#1076#1077#1083#1080#1082'.'
      Hint = #1055#1077#1095#1072#1090#1100' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' ('#1062#1077#1093' '#1076#1077#1083#1080#1082#1072#1090#1077#1089#1086#1074')'
      ImageIndex = 3
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxMasterCDS'
          IndexFieldNames = 'UnitId;PersonalServiceListId;MemberName'
        end>
      Params = <
        item
          Name = 'DateStart'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'dateEnd'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = UnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1042#1077#1076#1086#1084#1086#1089#1090#1100'_'#1087#1086'_'#1079#1072#1088#1087#1083#1072#1090#1077'_1'
      ReportNameParam.Value = #1042#1077#1076#1086#1084#1086#1089#1090#1100'_'#1087#1086'_'#1079#1072#1088#1087#1083#1072#1090#1077'_1'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint2: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1062#1077#1093' '#1089'/'#1082
      Hint = #1055#1077#1095#1072#1090#1100' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' ('#1062#1077#1093' '#1089'/'#1082')'
      ImageIndex = 3
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxMasterCDS'
          IndexFieldNames = 
            'UnitId;PersonalServiceListId;PositionName;PositionLevelName;Memb' +
            'erName'
        end>
      Params = <
        item
          Name = 'DateStart'
          Value = 41395d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'dateEnd'
          Value = 41395d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = UnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1042#1077#1076#1086#1084#1086#1089#1090#1100'_'#1087#1086'_'#1079#1072#1088#1087#1083#1072#1090#1077'_2'
      ReportNameParam.Value = #1042#1077#1076#1086#1084#1086#1089#1090#1100'_'#1087#1086'_'#1079#1072#1088#1087#1083#1072#1090#1077'_2'
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
      FormName = 'TReport_WageDialogForm'
      FormNameParam.Value = 'TReport_WageDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = UnitGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = UnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'chkDetailDay'
          Value = Null
          Component = chkDetailDay
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'chkDetailModelService'
          Value = Null
          Component = chkDetailModelService
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'chkDetailModelServiceItemChild'
          Value = Null
          Component = chkDetailModelServiceItemChild
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'chkDetailModelServiceItemMaster'
          Value = Null
          Component = chkDetailModelServiceItemMaster
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ModelServiceId'
          Value = Null
          Component = ModelServiceGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ModelServiceName'
          Value = Null
          Component = ModelServiceGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionId'
          Value = Null
          Component = PositionGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionName'
          Value = Null
          Component = PositionGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberId'
          Value = Null
          Component = MemberGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberName'
          Value = Null
          Component = MemberGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'chkDetailMonth'
          Value = Null
          Component = chkDetailMonth
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPersonalService: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spPersonalService
      StoredProcList = <
        item
          StoredProc = spPersonalService
        end>
      Caption = 'actPersonalService'
    end
    object macPersonalService: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actPersonalService
        end>
      View = cxGridDBTableView
      Caption = 
        #1058#1086#1083#1100#1082#1086' '#1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087 +
        #1083#1072#1090#1099'>'
      Hint = 
        #1058#1086#1083#1100#1082#1086' '#1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087 +
        #1083#1072#1090#1099'>'
    end
    object actPersonalServiceErased: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spPersonalServiceErased
      StoredProcList = <
        item
          StoredProc = spPersonalServiceErased
        end>
      Caption = 'actPersonalService'
    end
    object macPersonalServiceErased: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actPersonalServiceErased
        end>
      View = cxGridDBTableView
      Caption = #1058#1086#1083#1100#1082#1086' '#1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
      Hint = #1058#1086#1083#1100#1082#1086' '#1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
    end
    object macPersonalServiceAll: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macPersonalServiceErased
        end
        item
          Action = macPersonalService
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085 +
        #1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'> '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
      ImageIndex = 41
    end
  end
  inherited MasterDS: TDataSource
    Left = 48
    Top = 192
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 192
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Report_Wage'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inModelServiceId'
        Value = Null
        Component = ModelServiceGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = Null
        Component = MemberGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = PositionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDetailDay'
        Value = Null
        Component = chkDetailDay
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDetailMonth'
        Value = Null
        Component = chkDetailMonth
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDetailModelService'
        Value = Null
        Component = chkDetailModelService
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDetailModelServiceItemMaster'
        Value = Null
        Component = chkDetailModelServiceItemMaster
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDetailModelServiceItemChild'
        Value = Null
        Component = chkDetailModelServiceItemChild
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 192
  end
  inherited BarManager: TdxBarManager
    Left = 272
    Top = 232
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
          UserDefine = [udPaintStyle]
          UserPaintStyle = psCaptionGlyph
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          UserDefine = [udPaintStyle]
          UserPaintStyle = psCaptionGlyph
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPersonalService'
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
    object dxBarButton1: TdxBarButton
      Action = actPrint1
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actPrint2
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPersonalService: TdxBarButton
      Action = macPersonalServiceAll
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 184
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 112
    Top = 232
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnitForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 392
    Top = 13
  end
  object ModelServiceGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceModelService
    FormNameParam.Value = 'TModelService_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TModelService_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ModelServiceGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ModelServiceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 656
    Top = 5
  end
  object PositionGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 53
  end
  object MemberGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMember
    FormNameParam.Value = 'TMemberForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 352
    Top = 53
  end
  object spPersonalService: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_PersonalService_Child_Auto'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalServiceListId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalServiceListId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MemberId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionLevelId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionLevelId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaffListId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StaffListId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inModelServiceId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ModelServiceId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaffListSummKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StaffListSummKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountOnOneMember'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Count_Member'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDayCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Count_Day'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWorkTimeHoursOne'
        Value = 30.000000000000000000
        Component = MasterCDS
        ComponentItem = 'SheetWorkTime_Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWorkTimeHours'
        Value = 12.000000000000000000
        Component = MasterCDS
        ComponentItem = 'SUM_MemberHours'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHoursPlan'
        Value = Null
        Component = MasterCDS
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHoursDay'
        Value = Null
        Component = MasterCDS
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalCount'
        Value = Null
        Component = MasterCDS
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGrossOne'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GrossOnOneMember'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'KoeffHoursWork_car'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 192
    Top = 296
  end
  object spPersonalServiceErased: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_PersonalService_Child_Erased'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalServiceListId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalServiceListId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = PositionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 304
    Top = 288
  end
end
