inherited ServiceItemUpdateForm: TServiceItemUpdateForm
  Left = 8
  Top = 8
  Caption = #1048#1089#1090#1086#1088#1080#1103' <'#1059#1089#1083#1086#1074#1080#1103' '#1072#1088#1077#1085#1076#1099'>'
  ClientHeight = 341
  ClientWidth = 1071
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1087
  ExplicitHeight = 380
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1071
    Height = 284
    TabOrder = 3
    ExplicitWidth = 1071
    ExplicitHeight = 284
    ClientRectBottom = 284
    ClientRectRight = 1071
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1071
      ExplicitHeight = 284
      inherited cxGrid: TcxGrid
        Width = 1071
        Height = 284
        ExplicitWidth = 1071
        ExplicitHeight = 284
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Month_diff_before
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Month_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Month_diff_after
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Area
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_after
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Area_after
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_before
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Area_before
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Month_diff_before
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Month_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Month_diff_after
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = UnitName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Area
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_after
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Area_after
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_before
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Area_before
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
            DataBinding.FieldName = 'OperDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090
            Options.Editing = False
            Width = 70
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090
            Options.Editing = False
            Width = 55
          end
          object UnitGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'UnitGroupNameFull'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UnitCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object UnitName: TcxGridDBColumn
            Caption = #1054#1090#1076#1077#1083
            DataBinding.FieldName = 'UnitName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object CommentInfoMoneyName: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'CommentInfoMoneyName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 174
          end
          object Amount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1079#1072' '#1087#1083#1086#1097#1072#1076#1100
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1042#1099#1073#1088#1072#1085#1085#1099#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 80
          end
          object Area: TcxGridDBColumn
            Caption = #1055#1083#1086#1097#1072#1076#1100', '#1082#1074'.'#1084'.'
            DataBinding.FieldName = 'Area'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1073#1088#1072#1085#1085#1099#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 80
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079#1072' '#1082#1074'.'#1084'.'
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1073#1088#1072#1085#1085#1099#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 80
          end
          object DateStart_month: TcxGridDBColumn
            Caption = #1052#1077#1089#1103#1094' '#1089
            DataBinding.FieldName = 'DateStart_month'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'mmmm yyyy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1073#1088#1072#1085#1085#1099#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 80
          end
          object DateEnd_month: TcxGridDBColumn
            Caption = #1052#1077#1089#1103#1094' '#1087#1086
            DataBinding.FieldName = 'DateEnd_month'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'mmmm yyyy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1073#1088#1072#1085#1085#1099#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 80
          end
          object DateStart: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089
            DataBinding.FieldName = 'DateStart'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1073#1088#1072#1085#1085#1099#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 70
          end
          object EndDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1086
            DataBinding.FieldName = 'DateEnd'
            PropertiesClassName = 'TcxDateEditProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1073#1088#1072#1085#1085#1099#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 70
          end
          object Month_diff: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1084#1077#1089'.'
            DataBinding.FieldName = 'Month_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1073#1088#1072#1085#1085#1099#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 55
          end
          object Amount_after: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1079#1072' '#1087#1083#1086#1097#1072#1076#1100
            DataBinding.FieldName = 'Amount_after'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1089#1083#1077#1076#1091#1102#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 80
          end
          object Area_after: TcxGridDBColumn
            Caption = '***'#1055#1083#1086#1097#1072#1076#1100', '#1082#1074'.'#1084'.'
            DataBinding.FieldName = 'Area_after'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1089#1083#1077#1076#1091#1102#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 80
          end
          object Price_after: TcxGridDBColumn
            Caption = '***'#1062#1077#1085#1072' '#1079#1072' '#1082#1074'.'#1084'.'
            DataBinding.FieldName = 'Price_after'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1089#1083#1077#1076#1091#1102#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 80
          end
          object Month_diff_after: TcxGridDBColumn
            Caption = '***'#1050#1086#1083'-'#1074#1086' '#1084#1077#1089'.'
            DataBinding.FieldName = 'Month_diff_after'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1089#1083#1077#1076#1091#1102#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 55
          end
          object DateStart_after_month: TcxGridDBColumn
            Caption = '***'#1052#1077#1089#1103#1094' '#1089
            DataBinding.FieldName = 'DateStart_after_month'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'mmmm yyyy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1089#1083#1077#1076#1091#1102#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 80
          end
          object DateEnd_after_month: TcxGridDBColumn
            Caption = '***'#1052#1077#1089#1103#1094' '#1087#1086
            DataBinding.FieldName = 'DateEnd_after_month'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'mmmm yyyy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1089#1083#1077#1076#1091#1102#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 80
          end
          object DateStart_after: TcxGridDBColumn
            Caption = '***'#1044#1072#1090#1072' '#1089
            DataBinding.FieldName = 'DateStart_after'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1089#1083#1077#1076#1091#1102#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 70
          end
          object DateEnd_after: TcxGridDBColumn
            Caption = '***'#1044#1072#1090#1072' '#1087#1086
            DataBinding.FieldName = 'DateEnd_after'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1089#1083#1077#1076#1091#1102#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 70
          end
          object Amount_before: TcxGridDBColumn
            Caption = '*'#1057#1091#1084#1084#1072' '#1079#1072' '#1087#1083#1086#1097#1072#1076#1100
            DataBinding.FieldName = 'Amount_before'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1087#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 80
          end
          object Area_before: TcxGridDBColumn
            Caption = '*'#1055#1083#1086#1097#1072#1076#1100', '#1082#1074'.'#1084'.'
            DataBinding.FieldName = 'Area_before'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1087#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 80
          end
          object Price_before: TcxGridDBColumn
            Caption = '*'#1062#1077#1085#1072' '#1079#1072' '#1082#1074'.'#1084'.'
            DataBinding.FieldName = 'Price_before'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1087#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 80
          end
          object Month_diff_before: TcxGridDBColumn
            Caption = '*'#1050#1086#1083'-'#1074#1086' '#1084#1077#1089'.'
            DataBinding.FieldName = 'Month_diff_before'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1087#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 55
          end
          object DateStart_before_month: TcxGridDBColumn
            Caption = '*'#1052#1077#1089#1103#1094' '#1089
            DataBinding.FieldName = 'DateStart_before_month'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'mmmm yyyy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1087#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 80
          end
          object DateEnd_before_month: TcxGridDBColumn
            Caption = '*'#1052#1077#1089#1103#1094' '#1087#1086
            DataBinding.FieldName = 'DateEnd_before_month'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'mmmm yyyy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1087#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 80
          end
          object DateStart_before: TcxGridDBColumn
            Caption = '*'#1044#1072#1090#1072' '#1089
            DataBinding.FieldName = 'DateStart_before'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1087#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 70
          end
          object DateEnd_before: TcxGridDBColumn
            Caption = '*'#1044#1072#1090#1072' '#1087#1086
            DataBinding.FieldName = 'DateEnd_before'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1087#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 70
          end
          object InsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            Options.Editing = False
            Width = 101
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            Options.Editing = False
            Width = 78
          end
          object UpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            Options.Editing = False
            Width = 101
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            Options.Editing = False
            Width = 78
          end
          object IsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1071
    ExplicitWidth = 1071
    inherited deStart: TcxDateEdit
      Left = 78
      EditValue = 44562d
      Properties.SaveTime = False
      ExplicitLeft = 78
    end
    inherited deEnd: TcxDateEdit
      Left = 962
      EditValue = 44197d
      Properties.SaveTime = False
      Visible = False
      ExplicitLeft = 962
    end
    inherited cxLabel1: TcxLabel
      Left = 25
      Caption = #1053#1072' '#1076#1072#1090#1091':'
      ExplicitLeft = 25
      ExplicitWidth = 49
    end
    inherited cxLabel2: TcxLabel
      Left = 846
      Visible = False
      ExplicitLeft = 846
    end
  end
  object edSearchUnitName: TcxTextEdit [2]
    Left = 291
    Top = 5
    TabOrder = 6
    DesignSize = (
      126
      21)
    Width = 126
  end
  object lbSearchName: TcxLabel [3]
    Left = 182
    Top = 4
    Caption = #1055#1086#1080#1089#1082' '#1054#1090#1076#1077#1083' : '
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 315
    Top = 144
  end
  inherited ActionList: TActionList
    object actOpenFormServiceItemHistory: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1080#1089#1090#1086#1088#1080#1080' <'#1059#1089#1083#1086#1074#1080#1103' '#1072#1088#1077#1085#1076#1099'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1080#1089#1090#1086#1088#1080#1080' <'#1059#1089#1083#1086#1074#1080#1103' '#1072#1088#1077#1085#1076#1099'>'
      ImageIndex = 47
      FormName = 'TServiceItemJournal_historyForm'
      FormNameParam.Value = 'TServiceItemJournal_historyForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName_Full'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsAll'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
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
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actInsertAction: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
      FormName = 'TServiceItemMovementForm'
      FormNameParam.Value = 'TServiceItemMovementForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdateAction: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ImageIndex = 1
      FormName = 'TServiceItemMovementForm'
      FormNameParam.Value = 'TServiceItemMovementForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_Value'
          Value = '0'
          Component = MasterCDS
          ComponentItem = 'MovementId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actOpenServiceItemAdd_history: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1080#1089#1090#1086#1088#1080#1080' <'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1103' '#1082' '#1091#1089#1083#1086#1074#1080#1103#1084' '#1072#1088#1077#1085#1076#1099'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1080#1089#1090#1086#1088#1080#1080' <'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1103' '#1082' '#1091#1089#1083#1086#1074#1080#1103#1084' '#1072#1088#1077#1085#1076#1099'>'
      ImageIndex = 48
      FormName = 'TServiceItemAddJournal_historyForm'
      FormNameParam.Value = 'TServiceItemAddJournal_historyForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DateStart'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName_Full'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
    StoredProcName = 'gpSelect_MovementItem_ServiceItem_onDate'
    Params = <
      item
        Name = 'inOperDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 192
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
          ItemName = 'bbInsertUAction'
        end
        item
          Visible = True
          ItemName = 'bbUpdateAction'
        end
        item
          BeginGroup = True
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenFormServiceItemHistory'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenServiceItemAdd_history'
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
    object bbInsertUAction: TdxBarButton
      Action = actInsertAction
      Category = 0
    end
    object bbUpdateAction: TdxBarButton
      Action = actUpdateAction
      Category = 0
    end
    object bbOpenFormServiceItemHistory: TdxBarButton
      Action = actOpenFormServiceItemHistory
      Category = 0
    end
    object bbOpenServiceItemAdd_history: TdxBarButton
      Action = actOpenServiceItemAdd_history
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 400
    Top = 240
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 80
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = deStart
      end>
    Left = 168
    Top = 144
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'OperDate'
        Value = 43101d
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 200
  end
  object FieldFilter_UnitName: TdsdFieldFilter
    TextEdit = edSearchUnitName
    DataSet = MasterCDS
    Column = UnitName
    CheckBoxList = <>
    Left = 560
    Top = 136
  end
end
