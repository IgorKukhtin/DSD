inherited Report_OrderClient_byBoatChoiceForm: TReport_OrderClient_byBoatChoiceForm
  Caption = #1054#1090#1095#1077#1090' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072' '#1082#1083#1080#1077#1085#1090#1072'> '#1076#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1047#1072#1082#1072#1079#1072#1084
  ClientHeight = 341
  ClientWidth = 1071
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1087
  ExplicitHeight = 380
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 1071
    Height = 258
    TabOrder = 3
    ExplicitTop = 83
    ExplicitWidth = 1071
    ExplicitHeight = 258
    ClientRectBottom = 258
    ClientRectRight = 1071
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1071
      ExplicitHeight = 258
      inherited cxGrid: TcxGrid
        Width = 1071
        Height = 258
        ExplicitWidth = 1071
        ExplicitHeight = 258
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount8
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount9
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount10
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount11
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount12
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = ObjectName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount8
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount9
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount10
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount11
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount12
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
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'OperDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 88
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'InvNumber'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 99
          end
          object CIN: TcxGridDBColumn
            Caption = 'CIN Nr. (boat)'
            DataBinding.FieldName = 'CIN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ProductName: TcxGridDBColumn
            Caption = 'Boat'
            DataBinding.FieldName = 'ProductName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object Article: TcxGridDBColumn
            Caption = 'Artikel Nr'
            DataBinding.FieldName = 'Article'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Article_all: TcxGridDBColumn
            Caption = '***Artikel Nr'
            DataBinding.FieldName = 'Article_all'
            Visible = False
            Options.Editing = False
            Width = 70
          end
          object ReceiptLevelName: TcxGridDBColumn
            Caption = 'Level'
            DataBinding.FieldName = 'ReceiptLevelName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
          end
          object ObjectName: TcxGridDBColumn
            Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
            DataBinding.FieldName = 'ObjectName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object GoodsName_basis: TcxGridDBColumn
            Caption = #1059#1079#1083#1099
            DataBinding.FieldName = 'GoodsName_basis'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 150
          end
          object ProdColorName: TcxGridDBColumn
            Caption = 'Farbe'
            DataBinding.FieldName = 'ProdColorName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object GoodsCode: TcxGridDBColumn
            Caption = 'Interne Nr ('#1091#1079#1083#1099')'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object GoodsName: TcxGridDBColumn
            Caption = '***'#1059#1079#1083#1099
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object Article_goods: TcxGridDBColumn
            Caption = 'Artikel Nr ('#1091#1079#1083#1099')'
            DataBinding.FieldName = 'Article_goods'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object Comment_goods: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1091#1079#1083#1099')'
            DataBinding.FieldName = 'Comment_goods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
            Options.Editing = False
            Width = 80
          end
          object Comment_Object: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1050#1086#1084#1087#1083'.)'
            DataBinding.FieldName = 'Comment_Object'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
            Options.Editing = False
            Width = 80
          end
          object Remains: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1086#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1054#1089#1090#1072#1090#1086#1082' '#1090#1077#1082#1091#1097#1080#1081
            Width = 70
          end
          object MonthRemains: TcxGridDBColumn
            Caption = #1052#1077#1089#1103#1094' '#1086#1089#1090'.'
            DataBinding.FieldName = 'MonthRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1077#1089#1103#1094' '#1086#1089#1090#1072#1090#1082#1072
            Options.Editing = False
            Width = 70
          end
          object Amount: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount1: TcxGridDBColumn
            Caption = '01'
            DataBinding.FieldName = 'Amount1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1085#1074#1072#1088#1100
            Width = 43
          end
          object Amount2: TcxGridDBColumn
            Caption = '02'
            DataBinding.FieldName = 'Amount2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1077#1074#1088#1072#1083#1100
            Width = 43
          end
          object Amount3: TcxGridDBColumn
            Caption = '03'
            DataBinding.FieldName = 'Amount3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1084#1072#1088#1090
            Width = 43
          end
          object Amount4: TcxGridDBColumn
            Caption = '04'
            DataBinding.FieldName = 'Amount4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1072#1087#1088#1077#1083#1100
            Width = 43
          end
          object Amount5: TcxGridDBColumn
            Caption = '05'
            DataBinding.FieldName = 'Amount5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1084#1072#1081
            Width = 43
          end
          object Amount6: TcxGridDBColumn
            Caption = '06'
            DataBinding.FieldName = 'Amount6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1080#1102#1085#1100
            Width = 43
          end
          object Amount7: TcxGridDBColumn
            Caption = '07'
            DataBinding.FieldName = 'Amount7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1080#1102#1083#1100
            Width = 43
          end
          object Amount8: TcxGridDBColumn
            Caption = '08'
            DataBinding.FieldName = 'Amount8'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1072#1074#1075#1091#1089#1090
            Width = 43
          end
          object Amount9: TcxGridDBColumn
            Caption = '09'
            DataBinding.FieldName = 'Amount9'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1089#1077#1085#1090#1103#1073#1088#1100
            Width = 43
          end
          object Amount10: TcxGridDBColumn
            Caption = '10'
            DataBinding.FieldName = 'Amount10'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1082#1090#1103#1073#1088#1100
            Width = 43
          end
          object Amount11: TcxGridDBColumn
            Caption = '11'
            DataBinding.FieldName = 'Amount11'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1086#1103#1073#1088#1100
            Width = 43
          end
          object Amount12: TcxGridDBColumn
            Caption = '12'
            DataBinding.FieldName = 'Amount12'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1077#1082#1072#1073#1088#1100
            Width = 43
          end
          object MonthName1: TcxGridDBColumn
            Caption = '*01'
            DataBinding.FieldName = 'MonthName1'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MonthName2: TcxGridDBColumn
            Caption = '*02'
            DataBinding.FieldName = 'MonthName2'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MonthName3: TcxGridDBColumn
            Caption = '*03'
            DataBinding.FieldName = 'MonthName3'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MonthName4: TcxGridDBColumn
            Caption = '*04'
            DataBinding.FieldName = 'MonthName4'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MonthName5: TcxGridDBColumn
            Caption = '*05'
            DataBinding.FieldName = 'MonthName5'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MonthName6: TcxGridDBColumn
            Caption = '*06'
            DataBinding.FieldName = 'MonthName6'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MonthName7: TcxGridDBColumn
            Caption = '*07'
            DataBinding.FieldName = 'MonthName7'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MonthName8: TcxGridDBColumn
            Caption = '*08'
            DataBinding.FieldName = 'MonthName8'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MonthName9: TcxGridDBColumn
            Caption = '*09'
            DataBinding.FieldName = 'MonthName9'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MonthName10: TcxGridDBColumn
            Caption = '*10'
            DataBinding.FieldName = 'MonthName10'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MonthName11: TcxGridDBColumn
            Caption = '*11'
            DataBinding.FieldName = 'MonthName11'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MonthName12: TcxGridDBColumn
            Caption = '*12'
            DataBinding.FieldName = 'MonthName12'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1071
    Height = 57
    ExplicitWidth = 1071
    ExplicitHeight = 57
    inherited deStart: TcxDateEdit
      Left = 118
      Top = 4
      EditValue = 44927d
      Properties.SaveTime = False
      ExplicitLeft = 118
      ExplicitTop = 4
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 31
      EditValue = 44927d
      Properties.SaveTime = False
      ExplicitLeft = 118
      ExplicitTop = 31
    end
    inherited cxLabel1: TcxLabel
      Left = 25
      Top = 5
      ExplicitLeft = 25
      ExplicitTop = 5
    end
    inherited cxLabel2: TcxLabel
      Left = 2
      Top = 32
      ExplicitLeft = 2
      ExplicitTop = 32
    end
    object cbisDetail: TcxCheckBox
      Left = 209
      Top = 31
      Action = actRefreshEmpty
      Properties.ReadOnly = True
      State = cbsChecked
      TabOrder = 4
      Width = 128
    end
    object cxLabel3: TcxLabel
      Left = 754
      Top = 5
      Caption = #1055#1077#1088#1074#1099#1081' '#1084#1077#1089#1103#1094' '#1089#1086#1086#1090#1074#1077#1090#1089#1090#1074#1091#1077#1090' '#1084#1077#1089#1103#1094#1091' '#1053#1072#1095#1072#1083#1072' '#1087#1077#1088#1080#1086#1076#1072
      Style.BorderColor = clHighlightText
      Style.TextColor = cl3DDkShadow
    end
    object cxLabel4: TcxLabel
      Left = 209
      Top = 5
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077':'
    end
    object edGoods: TcxButtonEdit
      Left = 308
      Top = 4
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 346
    end
  end
  object lbSearchArticle: TcxLabel [2]
    Left = 155
    Top = 221
    Caption = #1055#1086#1080#1089#1082' Artikel Nr : '
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
  end
  object edSearchArticle: TcxTextEdit [3]
    Left = 152
    Top = 247
    TabOrder = 7
    DesignSize = (
      125
      21)
    Width = 125
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
        Component = cbisDetail
        Properties.Strings = (
          'Checked')
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
      Caption = #1055#1086' '#1083#1086#1076#1082#1072#1084' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_OrderClient_byBoatDialogForm'
      FormNameParam.Value = 'TReport_OrderClient_byBoatDialogForm'
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
          Name = 'isProduct'
          Value = ''
          Component = cbisDetail
          DataType = ftBoolean
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
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
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
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1048#1090#1086#1075#1086
      Hint = #1055#1077#1095#1072#1090#1100' '#1048#1090#1086#1075#1086
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;ObjectName'
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
          Name = 'isReceiptGoods'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintReport_OrderClientByBoat'
      ReportNameParam.Value = 'PrintReport_OrderClientByBoat'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint2: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint3
      StoredProcList = <
        item
          StoredProc = spSelectPrint3
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1091#1079#1083#1072#1084
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1091#1079#1083#1072#1084
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsName;ReceiptLevelName;ObjectName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 44927d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 44927d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'isReceiptGoods'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintReport_OrderClientByBoat'
      ReportNameParam.Value = 'PrintReport_OrderClientByBoat'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint3: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint3
      StoredProcList = <
        item
          StoredProc = spSelectPrint3
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      ImageIndex = 17
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'OperDate;InvNumber;GoodsName;ReceiptLevelName;ObjectName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintReport_OrderClientByBoatMov'
      ReportNameParam.Value = 'PrintReport_OrderClientByBoatMov'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
      PictureFields.Strings = (
        'photo1')
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
    StoredProcName = 'gpReport_OrderClient_byBoat'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_OrderClient'
        Value = ''
        Component = FormParams
        ComponentItem = 'inMovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = '0'
        Component = GuidesObject
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDetail'
        Value = Null
        Component = cbisDetail
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 208
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
          ItemName = 'bblbSearchArticle'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbPrint2'
        end
        item
          Visible = True
          ItemName = 'bbPrint3'
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
      Control = edSearchArticle
    end
    object bblbSearchArticle: TdxBarControlContainerItem
      Caption = 'lbSearchArticle'
      Category = 0
      Hint = 'lbSearchArticle'
      Visible = ivAlways
      Control = lbSearchArticle
    end
    object bbPrint2: TdxBarButton
      Action = actPrint2
      Category = 0
    end
    object bbPrint3: TdxBarButton
      Action = actPrint3
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 384
    Top = 248
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 80
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 168
    Top = 144
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
    Left = 616
    Top = 256
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
    Left = 680
    Top = 256
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
        Name = 'ObjectId'
        Value = Null
        Component = GuidesObject
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectName'
        Value = Null
        Component = GuidesObject
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDetail'
        Value = True
        Component = cbisDetail
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 200
  end
  object FieldFilter_Article: TdsdFieldFilter
    TextEdit = edSearchArticle
    DataSet = MasterCDS
    Column = Article_all
    ColumnList = <
      item
        Column = Article_all
      end>
    ActionNumber1 = actChoiceGuides
    CheckBoxList = <>
    Left = 256
    Top = 136
  end
  object spSelectPrint3: TdsdStoredProc
    StoredProcName = 'gpReport_OrderClient_byBoat'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 44927d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 44927d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = '0'
        Component = GuidesObject
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDetail'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 464
    Top = 176
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1028
    Top = 86
  end
  object GuidesObject: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    DisableGuidesOpen = True
    FormNameParam.Value = 'TGoodsForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 456
    Top = 3
  end
end
