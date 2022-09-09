inherited Report_CheckMobileForm: TReport_CheckMobileForm
  Caption = #1054#1090#1095#1077#1090' <'#1052#1086#1073#1080#1083#1100#1085#1086#1077' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077'>'
  ClientHeight = 480
  ClientWidth = 1170
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1186
  ExplicitHeight = 519
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 1170
    Height = 421
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 1170
    ExplicitHeight = 421
    ClientRectBottom = 421
    ClientRectRight = 1170
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1170
      ExplicitHeight = 421
      inherited cxGrid: TcxGrid
        Width = 1170
        Height = 421
        ExplicitWidth = 1170
        ExplicitHeight = 421
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = #1047#1072#1082#1072#1079#1086#1074' 0'
              Kind = skCount
            end
            item
              Kind = skSum
              Column = colTotalCount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSumm
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = MobileDiscount
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = ApplicationAward
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colStatus: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089
            DataBinding.FieldName = 'StatusCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
                Value = 1
              end
              item
                Description = #1055#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 12
                Value = 2
              end
              item
                Description = #1059#1076#1072#1083#1077#1085
                ImageIndex = 13
                Value = 3
              end>
            HeaderAlignmentVert = vaCenter
          end
          object colInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentVert = vaCenter
            Width = 47
          end
          object colUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 111
          end
          object colTotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'TotalCount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object colTotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object colSummCard: TcxGridDBColumn
            Caption = #1055#1088#1077#1076#1086#1087#1083#1072#1090#1072' ('#1092#1072#1082#1090#1080#1095#1077#1089#1082#1072#1103')'
            DataBinding.FieldName = 'SummCard'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object colBayer: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'Bayer'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object BayerPhone: TcxGridDBColumn
            Caption = #1058#1077#1083'. ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103')'
            DataBinding.FieldName = 'BayerPhone'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1085#1090#1072#1082#1090#1085#1099#1081' '#1090#1077#1083#1077#1092#1086#1085' ('#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103')'
            Options.Editing = False
            Width = 102
          end
          object colCashMember: TcxGridDBColumn
            Caption = #1052#1077#1085#1077#1076#1078#1077#1088
            DataBinding.FieldName = 'CashMember'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object isSite: TcxGridDBColumn
            Caption = #1063#1077#1088#1077#1079' '#1089#1072#1081#1090
            DataBinding.FieldName = 'isSite'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object InvNumberOrder: TcxGridDBColumn
            Caption = #8470' '#1079#1072#1082#1072#1079#1072' ('#1089#1072#1081#1090')'
            DataBinding.FieldName = 'InvNumberOrder'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1084#1077#1088' '#1079#1072#1082#1072#1079#1072' ('#1089' '#1089#1072#1081#1090#1072')'
            Options.Editing = False
            Width = 90
          end
          object ConfirmedKindName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072
            DataBinding.FieldName = 'ConfirmedKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1057#1086#1089#1090#1086#1103#1085#1080#1077' VIP-'#1095#1077#1082#1072')'
            Options.Editing = False
            Width = 80
          end
          object ConfirmedKindClientName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' '#1057#1052#1057
            DataBinding.FieldName = 'ConfirmedKindClientName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1054#1090#1087#1088#1072#1074#1083#1077#1085' '#1082#1083#1080#1077#1085#1090#1091')'
            Options.Editing = False
            Width = 102
          end
          object CancelReason: TcxGridDBColumn
            Caption = #1055#1088#1080#1095#1080#1085#1072' '#1086#1090#1082#1072#1079#1072
            DataBinding.FieldName = 'CancelReason'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 114
          end
          object isDeliverySite: TcxGridDBColumn
            Caption = 'H'#1072#1096#1072' '#1076#1086#1089#1090#1072#1074#1082#1072
            DataBinding.FieldName = 'isDeliverySite'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object SummaDelivery: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1076#1086#1089#1090#1072#1074#1082#1080
            DataBinding.FieldName = 'SummaDelivery'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object isCallOrder: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079' '#1087#1086' '#1079#1074#1086#1085#1082#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' ('#1055#1086#1095#1090#1072')'
            DataBinding.FieldName = 'isCallOrder'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object CommentCustomer: TcxGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '#1082#1083#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'CommentCustomer'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 103
          end
          object isMobileApplication: TcxGridDBColumn
            Caption = #1052#1086#1073'. '#1087#1088#1080#1083'.'
            DataBinding.FieldName = 'isMobileApplication'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object UserReferalsName: TcxGridDBColumn
            Caption = #1059#1095#1072#1089#1090#1080#1077' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
            DataBinding.FieldName = 'UserReferalsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Styles.Content = dmMain.cxContentStyle
            Width = 83
          end
          object UserUnitReferalsName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1085#1080#1077' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
            DataBinding.FieldName = 'UserUnitReferalsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object ApplicationAward: TcxGridDBColumn
            Caption = #1044#1086#1087#1083#1072#1090#1072' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091' '#1079#1072' '#1084#1086#1073' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
            DataBinding.FieldName = 'ApplicationAward'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 99
          end
          object isConfirmByPhone: TcxGridDBColumn
            Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1090#1077#1083#1077#1092#1086#1085#1085#1099#1084' '#1079#1074#1086#1085#1082#1086#1084
            DataBinding.FieldName = 'isConfirmByPhone'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object DateComing: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076#1072' '#1074' '#1072#1087#1090#1077#1082#1091
            DataBinding.FieldName = 'DateComing'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object MobileDiscount: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' '#1089' '#1084#1086#1073#1080#1083#1100#1085#1086#1075#1086' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103
            DataBinding.FieldName = 'MobileDiscount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 92
          end
          object Color_UserReferals: TcxGridDBColumn
            DataBinding.FieldName = 'Color_UserReferals'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
          end
          object isEmployeeMessage: TcxGridDBColumn
            Caption = #1054#1057' '#1086#1090' '#1072#1087#1090#1077#1082#1080
            DataBinding.FieldName = 'isEmployeeMessage'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isMobileFirstOrder: TcxGridDBColumn
            Caption = #1055#1077#1088#1074#1072#1103' '#1087#1086#1082#1091#1087#1082#1072
            DataBinding.FieldName = 'isMobileFirstOrder'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 62
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1170
    Height = 33
    ExplicitWidth = 1170
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 109
      Top = 4
      ExplicitLeft = 109
      ExplicitTop = 4
    end
    inherited deEnd: TcxDateEdit
      Left = 316
      Top = 4
      ExplicitLeft = 316
      ExplicitTop = 4
    end
    inherited cxLabel1: TcxLabel
      Top = 5
      ExplicitTop = 5
    end
    inherited cxLabel2: TcxLabel
      Top = 5
      ExplicitTop = 5
    end
    object cxLabel3: TcxLabel
      Left = 409
      Top = 5
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object ceUnit: TcxButtonEdit
      Left = 503
      Top = 4
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 5
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Width = 229
    end
    object cbIsUnComplete: TcxCheckBox
      Left = 738
      Top = 5
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1087#1088#1086#1074#1077#1076#1077#1085#1085#1099#1077
      TabOrder = 6
      Width = 161
    end
    object cbIsErased: TcxCheckBox
      Left = 900
      Top = 5
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      TabOrder = 7
      Width = 145
    end
    object cbEmployeeMessage: TcxCheckBox
      Left = 1033
      Top = 5
      Caption = #1058#1086#1083#1100#1082#1086' '#1054#1057' '#1086#1090' '#1072#1087#1090#1077#1082#1080
      TabOrder = 8
      Width = 135
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
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
        Component = cbIsUnComplete
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbIsErased
        Properties.Strings = (
          'Checked')
      end
      item
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = cbEmployeeMessage
        Properties.Strings = (
          'Checked')
      end>
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_CheckMobileDialogForm'
      FormNameParam.Value = 'TReport_CheckMobileDialogForm'
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
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsUnComplete'
          Value = Null
          Component = cbIsUnComplete
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsErased'
          Value = Null
          Component = cbIsErased
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isEmployeeMessage'
          Value = Null
          Component = cbEmployeeMessage
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'JuridicalName;GoodsName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TCheckForm'
      FormNameParam.Value = 'TCheckForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
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
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      CheckIDRecords = True
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate_EmployeeMessage: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_EmployeeMessage
      StoredProcList = <
        item
          StoredProc = spUpdate_EmployeeMessage
        end>
      Caption = 'actUpdate_EmployeeMessage'
    end
    object mactUpdate_EmployeeMessage: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUpdate_EmployeeMessage
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1057' '#1086#1090' '#1072#1087#1090#1077#1082#1080'"?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086'.'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1057' '#1086#1090' '#1072#1087#1090#1077#1082#1080'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1057' '#1086#1090' '#1072#1087#1090#1077#1082#1080'"'
      ImageIndex = 79
    end
  end
  inherited MasterDS: TDataSource
    Left = 48
    Top = 160
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 160
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_CheckMobile'
    Params = <
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
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsUnComplete'
        Value = Null
        Component = cbIsUnComplete
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = Null
        Component = cbIsErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisEmployeeMessage'
        Value = Null
        Component = cbEmployeeMessage
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 120
    Top = 160
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
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbtUpdate_EmployeeMessage'
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
      Caption = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Category = 0
      Hint = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Visible = ivAlways
      ImageIndex = 38
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbMoneyBoxSun: TdxBarButton
      Caption = #1050#1086#1087#1080#1083#1082#1091' '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1085#1099#1093' '#1090#1086#1074#1072#1088#1086#1074' '#1057#1059#1053'1'
      Category = 0
      Visible = ivAlways
      ImageIndex = 56
    end
    object dxBarButton2: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object bbtUpdate_EmployeeMessage: TdxBarButton
      Action = mactUpdate_EmployeeMessage
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actUpdate
      end>
    ColorRuleList = <
      item
        ColorColumn = UserReferalsName
        BackGroundValueColumn = Color_UserReferals
        ColorValueList = <>
      end>
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 272
    Top = 0
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = cbIsErased
      end
      item
        Component = GuidesUnit
      end
      item
        Component = cbIsUnComplete
      end
      item
        Component = cbEmployeeMessage
      end>
    Left = 432
    Top = 216
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 344
  end
  object spUpdate_Price_MCSIsClose: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Price_MCSIsClose'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCSIsClose'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MCSIsClose'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 688
    Top = 240
  end
  object spUpdate_EmployeeMessage: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_EmployeeMessage'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisEmployeeMessage'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isEmployeeMessage'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 424
    Top = 336
  end
end
