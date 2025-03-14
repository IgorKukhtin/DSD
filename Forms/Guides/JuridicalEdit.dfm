inherited JuridicalEditForm: TJuridicalEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086'>'
  ClientHeight = 599
  ClientWidth = 1127
  ExplicitWidth = 1133
  ExplicitHeight = 628
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 32
    Top = 568
    Action = InsertUpdateGuides
    TabOrder = 7
    ExplicitLeft = 32
    ExplicitTop = 568
  end
  inherited bbCancel: TcxButton
    Left = 150
    Top = 566
    Action = actFormClose
    TabOrder = 8
    ExplicitLeft = 150
    ExplicitTop = 566
  end
  object edName: TcxTextEdit [2]
    Left = 5
    Top = 58
    TabOrder = 0
    Width = 272
  end
  object cxLabel1: TcxLabel [3]
    Left = 5
    Top = 41
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1075#1086' '#1083#1080#1094#1072
  end
  object Код: TcxLabel [4]
    Left = 5
    Top = 0
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit [5]
    Left = 5
    Top = 19
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 6
    Width = 134
  end
  object cxLabel2: TcxLabel [6]
    Left = 8
    Top = 197
    Caption = #1050#1086#1076' GLN - '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1100' '#1080'/'#1080#1083#1080' '#1055#1086#1083#1091#1095#1072#1090#1077#1083#1100' '
  end
  object edGLNCode: TcxTextEdit [7]
    Left = 6
    Top = 215
    TabOrder = 1
    Width = 272
  end
  object cbisCorporate: TcxCheckBox [8]
    Left = 154
    Top = 6
    Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088'.'#1083#1080#1094#1086
    TabOrder = 2
    Width = 116
  end
  object cxLabel3: TcxLabel [9]
    Left = 8
    Top = 237
    Caption = #1043#1088#1091#1087#1087#1072' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1093' '#1083#1080#1094
  end
  object cxLabel4: TcxLabel [10]
    Left = 8
    Top = 279
    Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1072
  end
  object ceJuridicalGroup: TcxButtonEdit [11]
    Left = 5
    Top = 255
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 272
  end
  object ceGoodsProperty: TcxButtonEdit [12]
    Left = 5
    Top = 296
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 272
  end
  object cxLabel5: TcxLabel [13]
    Left = 5
    Top = 318
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object ceInfoMoney: TcxButtonEdit [14]
    Left = 5
    Top = 335
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 272
  end
  object Panel: TPanel [15]
    Left = 284
    Top = 0
    Width = 843
    Height = 599
    Align = alRight
    BevelEdges = [beLeft]
    BevelKind = bkTile
    BevelOuter = bvNone
    TabOrder = 15
    object PageControl: TcxPageControl
      Left = 0
      Top = 0
      Width = 841
      Height = 599
      Align = alClient
      TabOrder = 0
      Properties.ActivePage = JuridicalDetailTS
      Properties.CustomButtons.Buttons = <>
      ClientRectBottom = 599
      ClientRectRight = 841
      ClientRectTop = 24
      object JuridicalDetailTS: TcxTabSheet
        Caption = #1056#1077#1082#1074#1080#1079#1080#1090#1099
        ImageIndex = 0
        object edFullName: TcxDBTextEdit
          Left = 16
          Top = 19
          DataBinding.DataField = 'FullName'
          DataBinding.DataSource = JuridicalDetailsDS
          TabOrder = 0
          Width = 425
        end
        object edJuridicalAddress: TcxDBTextEdit
          Left = 16
          Top = 109
          DataBinding.DataField = 'JuridicalAddress'
          DataBinding.DataSource = JuridicalDetailsDS
          TabOrder = 1
          Width = 425
        end
        object edOKPO: TcxDBTextEdit
          Left = 16
          Top = 156
          DataBinding.DataField = 'OKPO'
          DataBinding.DataSource = JuridicalDetailsDS
          TabOrder = 2
          Width = 193
        end
        object JuridicalDetailsGrid: TcxGrid
          Left = 456
          Top = 0
          Width = 385
          Height = 575
          Align = alRight
          TabOrder = 8
          ExplicitLeft = 200
          ExplicitTop = 66
          object JuridicalDetailsGridDBTableView: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = JuridicalDetailsDS
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsData.Appending = True
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Inserting = False
            OptionsView.GroupByBox = False
            Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
            object StartDate: TcxGridDBColumn
              Caption = #1044#1072#1090#1072
              DataBinding.FieldName = 'StartDate'
              PropertiesClassName = 'TcxDateEditProperties'
              Properties.InputKind = ikRegExpr
              Properties.SaveTime = False
              Properties.ShowTime = False
              Properties.WeekNumbers = True
              Width = 101
            end
          end
          object JuridicalDetailsGridLevel: TcxGridLevel
            GridView = JuridicalDetailsGridDBTableView
          end
        end
        object edINN: TcxDBTextEdit
          Left = 248
          Top = 156
          DataBinding.DataField = 'INN'
          DataBinding.DataSource = JuridicalDetailsDS
          TabOrder = 3
          Width = 193
        end
        object edAccounterName: TcxDBTextEdit
          Left = 248
          Top = 204
          DataBinding.DataField = 'AccounterName'
          DataBinding.DataSource = JuridicalDetailsDS
          TabOrder = 5
          Width = 193
        end
        object edNumberVAT: TcxDBTextEdit
          Left = 16
          Top = 204
          DataBinding.DataField = 'NumberVAT'
          DataBinding.DataSource = JuridicalDetailsDS
          TabOrder = 4
          Width = 193
        end
        object edInvNumberBranch: TcxDBTextEdit
          Left = 18
          Top = 294
          DataBinding.DataField = 'InvNumberBranch'
          DataBinding.DataSource = JuridicalDetailsDS
          TabOrder = 9
          Width = 193
        end
        object cxLabel23: TcxLabel
          Left = 18
          Top = 275
          Caption = #8470' '#1092#1080#1083#1080#1072#1083#1072
        end
        object edBankAccount: TcxDBTextEdit
          Left = 248
          Top = 294
          DataBinding.DataField = 'BankAccount'
          DataBinding.DataSource = JuridicalDetailsDS
          TabOrder = 7
          Width = 193
        end
        object cxLabel6: TcxLabel
          Left = 16
          Top = -1
          Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1075#1086' '#1083#1080#1094#1072
        end
        object cxLabel7: TcxLabel
          Left = 16
          Top = 90
          Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1081' '#1072#1076#1088#1077#1089
        end
        object cxLabel8: TcxLabel
          Left = 16
          Top = 134
          Caption = #1054#1050#1055#1054
        end
        object cxLabel9: TcxLabel
          Left = 248
          Top = 134
          Caption = #1048#1053#1053
        end
        object cxLabel10: TcxLabel
          Left = 16
          Top = 183
          Caption = #8470' '#1089#1074#1080#1076#1077#1090#1077#1083#1100#1089#1090#1074#1072' '#1053#1044#1057
        end
        object cxLabel11: TcxLabel
          Left = 248
          Top = 183
          Caption = #1060#1048#1054' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1072
        end
        object edBank: TcxDBButtonEdit
          Left = 18
          Top = 246
          DataBinding.DataField = 'BankName'
          DataBinding.DataSource = JuridicalDetailsDS
          Properties.Buttons = <
            item
              Action = actChoiceBank
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 6
          Width = 193
        end
        object cxLabel12: TcxLabel
          Left = 16
          Top = 228
          Caption = #1041#1072#1085#1082
        end
        object cxLabel13: TcxLabel
          Left = 248
          Top = 275
          Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
        end
        object cxLabel18: TcxLabel
          Left = 248
          Top = 323
          Caption = #1058#1077#1083#1077#1092#1086#1085
        end
        object edPhone: TcxDBTextEdit
          Left = 248
          Top = 343
          DataBinding.DataField = 'Phone'
          DataBinding.DataSource = JuridicalDetailsDS
          TabOrder = 18
          Width = 193
        end
        object cxLabel22: TcxLabel
          Left = 248
          Top = 228
          Caption = #1060#1048#1054' '#1076#1080#1088#1077#1082#1090#1086#1088#1072
        end
        object edMainName: TcxDBTextEdit
          Left = 248
          Top = 248
          DataBinding.DataField = 'MainName'
          DataBinding.DataSource = JuridicalDetailsDS
          TabOrder = 20
          Width = 193
        end
        object cxLabel24: TcxLabel
          Left = 16
          Top = 43
          Caption = #1050#1088#1072#1090#1082#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1075#1086' '#1083#1080#1094#1072
        end
        object edName_history: TcxDBTextEdit
          Left = 16
          Top = 63
          DataBinding.DataField = 'Name'
          DataBinding.DataSource = JuridicalDetailsDS
          TabOrder = 24
          Width = 425
        end
      end
      object PartnerTS: TcxTabSheet
        Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
        ImageIndex = 1
        object PartnerDockControl: TdxBarDockControl
          Left = 0
          Top = 0
          Width = 841
          Height = 26
          Align = dalTop
          BarManager = dxBarManager
        end
        object PartnerGrid: TcxGrid
          Left = 0
          Top = 26
          Width = 841
          Height = 549
          Align = alClient
          TabOrder = 0
          object PartnerGridDBTableView: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = PartnerDS
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Editing = False
            OptionsData.Inserting = False
            OptionsView.ColumnAutoWidth = True
            OptionsView.GroupByBox = False
            Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
            object Code: TcxGridDBColumn
              Caption = #1050#1086#1076
              DataBinding.FieldName = 'Code'
              Options.Editing = False
            end
            object Address: TcxGridDBColumn
              Caption = #1040#1076#1088#1077#1089
              DataBinding.FieldName = 'Address'
              Options.Editing = False
              Width = 423
            end
            object isErased: TcxGridDBColumn
              Caption = #1059#1076#1072#1083#1077#1085
              DataBinding.FieldName = 'isErased'
              Visible = False
              Options.Editing = False
            end
          end
          object PartnerGridLevel: TcxGridLevel
            GridView = PartnerGridDBTableView
          end
        end
      end
      object ContractTS: TcxTabSheet
        Caption = #1044#1086#1075#1086#1074#1086#1088#1072
        ImageIndex = 2
        object ContractDockControl: TdxBarDockControl
          Left = 0
          Top = 0
          Width = 841
          Height = 26
          Align = dalTop
          BarManager = dxBarManager
        end
        object ContractGrid: TcxGrid
          Left = 0
          Top = 26
          Width = 841
          Height = 549
          Align = alClient
          TabOrder = 0
          object ContractGridDBTableView: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = ContractDS
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsCustomize.ColumnHiding = True
            OptionsCustomize.ColumnsQuickCustomization = True
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Editing = False
            OptionsData.Inserting = False
            OptionsView.ColumnAutoWidth = True
            OptionsView.GroupByBox = False
            OptionsView.HeaderAutoHeight = True
            OptionsView.Indicator = True
            Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
            object ContractStateKindCode: TcxGridDBColumn
              Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
              DataBinding.FieldName = 'ContractStateKindCode'
              PropertiesClassName = 'TcxImageComboBoxProperties'
              Properties.Alignment.Horz = taLeftJustify
              Properties.Alignment.Vert = taVCenter
              Properties.Images = dmMain.ImageList
              Properties.Items = <
                item
                  Description = #1055#1086#1076#1087#1080#1089#1072#1085
                  ImageIndex = 12
                  Value = 1
                end
                item
                  Description = #1053#1077' '#1087#1086#1076#1087#1080#1089#1072#1085
                  ImageIndex = 11
                  Value = 2
                end
                item
                  Description = #1047#1072#1074#1077#1088#1096#1077#1085
                  ImageIndex = 13
                  Value = 3
                end
                item
                  Description = #1059' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
                  ImageIndex = 66
                  Value = 4
                end>
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 60
            end
            object clCode: TcxGridDBColumn
              Caption = #1050#1086#1076
              DataBinding.FieldName = 'Code'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 40
            end
            object InvNumberArchive: TcxGridDBColumn
              Caption = #1055#1086#1088#1103#1076#1082'. '#8470
              DataBinding.FieldName = 'InvNumberArchive'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 50
            end
            object InvNumber: TcxGridDBColumn
              Caption = #8470' '#1076#1086#1075'.'
              DataBinding.FieldName = 'InvNumber'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 55
            end
            object ContractTagName: TcxGridDBColumn
              Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
              DataBinding.FieldName = 'ContractTagName'
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 80
            end
            object clStartDate: TcxGridDBColumn
              Caption = #1044#1077#1081#1089#1090#1074'. '#1089
              DataBinding.FieldName = 'StartDate'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 60
            end
            object EndDate: TcxGridDBColumn
              Caption = #1044#1077#1081#1089#1090#1074'. '#1076#1086
              DataBinding.FieldName = 'EndDate'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 60
            end
            object ContractKindName: TcxGridDBColumn
              Caption = #1042#1080#1076' '#1076#1086#1075#1086#1074#1086#1088#1072
              DataBinding.FieldName = 'ContractKindName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object PaidKindName: TcxGridDBColumn
              Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
              DataBinding.FieldName = 'PaidKindName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 40
            end
            object InfoMoneyCode: TcxGridDBColumn
              Caption = #1050#1086#1076' '#1059#1055
              DataBinding.FieldName = 'InfoMoneyCode'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 40
            end
            object InfoMoneyName: TcxGridDBColumn
              Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
              DataBinding.FieldName = 'InfoMoneyName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 80
            end
            object PersonalName: TcxGridDBColumn
              Caption = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
              DataBinding.FieldName = 'PersonalName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 60
            end
            object AreaName: TcxGridDBColumn
              Caption = #1056#1077#1075#1080#1086#1085
              DataBinding.FieldName = 'AreaName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 60
            end
            object ContractArticleName: TcxGridDBColumn
              Caption = #1055#1088#1077#1076#1084#1077#1090
              DataBinding.FieldName = 'ContractArticleName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 60
            end
            object IsStandart: TcxGridDBColumn
              Caption = #1058#1080#1087#1086#1074#1086#1081
              DataBinding.FieldName = 'isStandart'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 40
            end
            object IsPersonal: TcxGridDBColumn
              Caption = 'C'#1083#1091#1078'. '#1079#1072#1087'.'
              DataBinding.FieldName = 'isPersonal'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 40
            end
            object IsDefault: TcxGridDBColumn
              Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
              DataBinding.FieldName = 'isDefault'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 40
            end
            object IsDefaultOut: TcxGridDBColumn
              Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1080#1089#1093'. '#1087#1083'.)'
              DataBinding.FieldName = 'isDefaultOut'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1080#1089#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
              Options.Editing = False
              Width = 40
            end
            object IsUnique: TcxGridDBColumn
              Caption = #1056#1072#1089#1095#1077#1090' '#1076#1086#1083#1075#1072
              DataBinding.FieldName = 'isUnique'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 40
            end
            object isNotTareReturning: TcxGridDBColumn
              Caption = #1053#1077#1090' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1090#1072#1088#1099
              DataBinding.FieldName = 'isNotTareReturning'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object Comment: TcxGridDBColumn
              Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
              DataBinding.FieldName = 'Comment'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 100
            end
            object clIsErased: TcxGridDBColumn
              Caption = #1059#1076#1072#1083#1077#1085
              DataBinding.FieldName = 'isErased'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 30
            end
          end
          object ContractGridLevel: TcxGridLevel
            GridView = ContractGridDBTableView
          end
        end
      end
    end
  end
  object cxLabel14: TcxLabel [16]
    Left = 8
    Top = 440
    Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
  end
  object cePriceList: TcxButtonEdit [17]
    Left = 5
    Top = 457
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 18
    Width = 136
  end
  object cxLabel15: TcxLabel [18]
    Left = 148
    Top = 440
    Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' ('#1040#1082#1094#1080#1086#1085#1085#1099#1081')'
  end
  object cePriceListPromo: TcxButtonEdit [19]
    Left = 148
    Top = 457
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 129
  end
  object cxLabel16: TcxLabel [20]
    Left = 8
    Top = 481
    Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1072#1082#1094#1080#1080
  end
  object cxLabel17: TcxLabel [21]
    Left = 150
    Top = 481
    Caption = #1044#1072#1090#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1072#1082#1094#1080#1080
  end
  object edEndPromo: TcxDateEdit [22]
    Left = 150
    Top = 499
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    Properties.ValidateOnEnter = False
    TabOrder = 22
    Width = 128
  end
  object edStartPromo: TcxDateEdit [23]
    Left = 5
    Top = 499
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    Properties.ValidateOnEnter = False
    TabOrder = 24
    Width = 120
  end
  object cxLabel19: TcxLabel [24]
    Left = 5
    Top = 399
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' ('#1087#1088#1086#1089#1088#1086#1095#1082#1072')'
  end
  object ceRetailReport: TcxButtonEdit [25]
    Left = 5
    Top = 417
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 26
    Width = 272
  end
  object cxLabel20: TcxLabel [26]
    Left = 8
    Top = 357
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
  end
  object ceRetail: TcxButtonEdit [27]
    Left = 5
    Top = 376
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 27
    Width = 272
  end
  object cbisTaxSummary: TcxCheckBox [28]
    Left = 8
    Top = 91
    Caption = #1057#1074#1086#1076#1085#1072#1103' '#1053#1053
    TabOrder = 28
    Width = 90
  end
  object edDayTaxSummary: TcxCurrencyEdit [29]
    Left = 110
    Top = 97
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 30
    Width = 167
  end
  object cxLabel21: TcxLabel [30]
    Left = 110
    Top = 79
    Caption = #1055#1077#1088#1080#1086#1076' '#1074' '#1076#1085'. '#1076#1083#1103' '#1089#1074#1086#1076#1085#1086#1081' '#1053#1053
  end
  object cbisDiscountPrice: TcxCheckBox [31]
    Left = 8
    Top = 116
    Caption = #1055#1077#1095#1072#1090#1072#1090#1100' '#1094#1077#1085#1091' '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080' '#1074' '#1085#1072#1082#1083'.'
    TabOrder = 31
    Width = 225
  end
  object cbisPriceWithVAT: TcxCheckBox [32]
    Left = 8
    Top = 135
    Caption = #1055#1077#1095#1072#1090#1100' '#1074' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1094#1077#1085#1091' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 32
    Width = 241
  end
  object cbisNotRealGoods: TcxCheckBox [33]
    Left = 8
    Top = 154
    Caption = #1053#1077#1090' c'#1093#1077#1084#1099' '#1089' '#1079#1072#1084#1077#1085#1086#1081' '#1092#1072#1082#1090'/'#1073#1091#1093#1075' '#1086#1090#1075#1088'.) ('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 34
    Width = 272
  end
  object cxLabel25: TcxLabel [34]
    Left = 8
    Top = 521
    Caption = #1057#1077#1075#1084#1077#1085#1090
  end
  object edSection: TcxButtonEdit [35]
    Left = 5
    Top = 537
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 39
    Width = 272
  end
  object cbVchasnoEdi: TcxCheckBox [36]
    Left = 8
    Top = 173
    Caption = #1054#1073#1088#1072#1073#1086#1090#1082#1072' '#1085#1072' '#1087#1083#1072#1090#1092#1086#1088#1084#1077' '#1042#1095#1072#1089#1085#1086' EDI'
    TabOrder = 40
    Width = 217
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 499
    Top = 144
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 112
    Top = 330
  end
  inherited ActionList: TActionList
    Left = 375
    Top = 103
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spJuridicalDetails
        end
        item
          StoredProc = spClearDefaluts
        end
        item
          StoredProc = spContract
        end
        item
          StoredProc = spPartner
        end>
    end
    object InsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spCheckOKPO
      StoredProcList = <
        item
          StoredProc = spCheckOKPO
        end
        item
          StoredProc = spInsertUpdate
        end
        item
          StoredProc = spJuridicalDetailsIU
        end>
      Caption = 'Ok'
    end
    object actFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
    object actContractInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TContractEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = ''
          Component = edName
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = ContractDS
      DataSetRefresh = actContractRefresh
      IdFieldName = 'Id'
    end
    object actContractUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TContractEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ContractCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = ''
          Component = edName
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = ContractDS
      DataSetRefresh = actContractRefresh
      IdFieldName = 'Id'
    end
    object actPartnerInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TPartnerEditForm'
      FormNameParam.Value = 'TPartnerEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'MaskId'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = PartnerDS
      DataSetRefresh = actPartnerRefresh
      IdFieldName = 'Id'
    end
    object actPartnerUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TPartnerEditForm'
      FormNameParam.Value = 'TPartnerEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MaskId'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = PartnerDS
      DataSetRefresh = actPartnerRefresh
      IdFieldName = 'Id'
    end
    object actShowErasedPartner: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPartner
      StoredProcList = <
        item
          StoredProc = spPartner
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1101#1083#1077#1084#1077#1085#1090#1099
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1101#1083#1077#1084#1077#1085#1090#1099
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actShowErasedContract: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spContract
      StoredProcList = <
        item
          StoredProc = spContract
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1101#1083#1077#1084#1077#1085#1090#1099
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1101#1083#1077#1084#1077#1085#1090#1099
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actPartnerRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      TabSheet = PartnerTS
      MoveParams = <>
      Enabled = False
      StoredProc = spPartner
      StoredProcList = <
        item
          StoredProc = spPartner
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actContractRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      TabSheet = ContractTS
      MoveParams = <>
      Enabled = False
      StoredProc = spContract
      StoredProcList = <
        item
          StoredProc = spContract
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object JuridicalDetailsUDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spJuridicalDetailsIU
      StoredProcList = <
        item
          StoredProc = spJuridicalDetailsIU
        end>
      DataSource = JuridicalDetailsDS
    end
    object actSave: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spCheckOKPO
      StoredProcList = <
        item
          StoredProc = spCheckOKPO
        end
        item
          StoredProc = spInsertUpdate
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ImageIndex = 14
      ShortCut = 113
    end
    object actChoiceBank: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceBank'
      FormName = 'TBankForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = JuridicalDetailsCDS
          ComponentItem = 'BankId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = JuridicalDetailsCDS
          ComponentItem = 'BankName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actMultiContractInsert: TMultiAction
      Category = 'DSDLib'
      TabSheet = ContractTS
      MoveParams = <>
      Enabled = False
      ActionList = <
        item
          Action = actSave
        end
        item
          Action = actContractInsert
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
      ShortCut = 45
    end
    object actMultiPartnerInsert: TMultiAction
      Category = 'DSDLib'
      TabSheet = PartnerTS
      MoveParams = <>
      Enabled = False
      ActionList = <
        item
          Action = actSave
        end
        item
          Action = actPartnerInsert
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
      ShortCut = 45
    end
    object dsdSetUnErasedContract: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedContract
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedContract
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
    end
    object dsdSetErasedContract: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedContract
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedContract
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
    end
    object dsdSetErasedPartner: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
    end
    object dsdSetUnErasedPartner: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedPartner
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedPartner
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
    end
    object ProtocolOpenFormContract: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ContractCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ContractCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object ProtocolOpenFormPartner: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupId'
        Value = ''
        Component = JuridicalGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupName'
        Value = ''
        Component = JuridicalGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OKPO'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 290
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Juridical'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGLNCode'
        Value = ''
        Component = edGLNCode
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCorporate'
        Value = False
        Component = cbisCorporate
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisTaxSummary'
        Value = Null
        Component = cbisTaxSummary
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDiscountPrice'
        Value = Null
        Component = cbisDiscountPrice
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPriceWithVAT'
        Value = Null
        Component = cbisPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotRealGoods'
        Value = Null
        Component = cbisNotRealGoods
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisVchasnoEdi'
        Value = Null
        Component = cbVchasnoEdi
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDayTaxSummary'
        Value = Null
        Component = edDayTaxSummary
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalGroupId'
        Value = ''
        Component = JuridicalGroupGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsPropertyId'
        Value = ''
        Component = GoodsPropertyGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = RetailGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailReportId'
        Value = ''
        Component = RetailReportGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId'
        Value = ''
        Component = dsdPriceListGuides
        ComponentItem = 'PriceListId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListPromoId'
        Value = ''
        Component = dsdPriceListPromoGuides
        ComponentItem = 'PriceListPromoId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSectionId'
        Value = Null
        Component = GuidesSection
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartPromo'
        Value = 0d
        Component = edStartPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndPromo'
        Value = 0d
        Component = edEndPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 352
    Top = 120
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Juridical'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = Null
        Component = FormParams
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'GLNCode'
        Value = ''
        Component = edGLNCode
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCorporate'
        Value = 'False'
        Component = cbisCorporate
        MultiSelectSeparator = ','
      end
      item
        Name = 'isTaxSummary'
        Value = Null
        Component = cbisTaxSummary
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalGroupId'
        Value = ''
        Component = JuridicalGroupGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalGroupName'
        Value = ''
        Component = JuridicalGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPropertyId'
        Value = ''
        Component = GoodsPropertyGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPropertyName'
        Value = ''
        Component = GoodsPropertyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailId'
        Value = Null
        Component = RetailGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailName'
        Value = Null
        Component = RetailGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailReportId'
        Value = ''
        Component = RetailReportGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailReportName'
        Value = ''
        Component = RetailReportGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId'
        Value = ''
        Component = dsdPriceListGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName'
        Value = ''
        Component = dsdPriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListPromoId'
        Value = ''
        Component = dsdPriceListPromoGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListPromoName'
        Value = ''
        Component = dsdPriceListPromoGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartPromo'
        Value = 0d
        Component = edStartPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndPromo'
        Value = 0d
        Component = edEndPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DayTaxSummary'
        Value = Null
        Component = edDayTaxSummary
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDiscountPrice'
        Value = Null
        Component = cbisDiscountPrice
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPriceWithVAT'
        Value = Null
        Component = cbisPriceWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNotRealGoods'
        Value = Null
        Component = cbisNotRealGoods
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isVchasnoEdi'
        Value = Null
        Component = cbVchasnoEdi
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 210
  end
  object JuridicalGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridicalGroup
    FormNameParam.Value = 'TJuridicalGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 144
    Top = 210
  end
  object GoodsPropertyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsProperty
    FormNameParam.Value = 'TGoodsPropertyForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsPropertyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsPropertyGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsPropertyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 184
    Top = 258
  end
  object InfoMoneyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 298
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 608
    Top = 104
    DockControlHeights = (
      0
      0
      0
      0)
    object PartnerBar: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockControl = PartnerDockControl
      DockedDockControl = PartnerDockControl
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 528
      FloatTop = 285
      FloatClientWidth = 51
      FloatClientHeight = 22
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPartnerInsert'
        end
        item
          Visible = True
          ItemName = 'bbPartnerEdit'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedPartner'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedPartner'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPartnerRefresh'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErasedPartner'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenFormPartner'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object ContractBar: TdxBar
      Caption = 'ContractBar'
      CaptionButtons = <>
      DockControl = ContractDockControl
      DockedDockControl = ContractDockControl
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 877
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbContractInsert'
        end
        item
          Visible = True
          ItemName = 'bbContractUpdate'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedContract'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedContract'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbContractRefresh'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErasedContract'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenFormContract'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbPartnerRefresh: TdxBarButton
      Action = actPartnerRefresh
      Category = 0
    end
    object bbPartnerInsert: TdxBarButton
      Action = actMultiPartnerInsert
      Category = 0
    end
    object bbPartnerEdit: TdxBarButton
      Action = actPartnerUpdate
      Category = 0
    end
    object bbContractRefresh: TdxBarButton
      Action = actContractRefresh
      Category = 0
    end
    object bbStatic: TdxBarStatic
      Caption = '   '
      Category = 0
      Hint = '   '
      Visible = ivAlways
    end
    object bbContractInsert: TdxBarButton
      Action = actMultiContractInsert
      Category = 0
    end
    object bbContractUpdate: TdxBarButton
      Action = actContractUpdate
      Category = 0
    end
    object bbShowErasedContract: TdxBarButton
      Action = actShowErasedContract
      Category = 0
    end
    object bbShowErasedPartner: TdxBarButton
      Action = actShowErasedPartner
      Category = 0
    end
    object bbSetErasedContract: TdxBarButton
      Action = dsdSetErasedContract
      Category = 0
    end
    object bbSetErasedPartner: TdxBarButton
      Action = dsdSetErasedPartner
      Category = 0
    end
    object bbSetUnErasedContract: TdxBarButton
      Action = dsdSetUnErasedContract
      Category = 0
    end
    object bbSetUnErasedPartner: TdxBarButton
      Action = dsdSetUnErasedPartner
      Category = 0
    end
    object bbProtocolOpenFormContract: TdxBarButton
      Action = ProtocolOpenFormContract
      Category = 0
    end
    object bbProtocolOpenFormPartner: TdxBarButton
      Action = ProtocolOpenFormPartner
      Category = 0
    end
  end
  object JuridicalDetailsDS: TDataSource
    DataSet = JuridicalDetailsCDS
    Left = 88
    Top = 56
  end
  object JuridicalDetailsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 296
    Top = 472
  end
  object PartnerDS: TDataSource
    DataSet = PartnerCDS
    Left = 360
    Top = 304
  end
  object PartnerCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 320
    Top = 312
  end
  object ContractDS: TDataSource
    DataSet = ContractCDS
    Left = 488
    Top = 360
  end
  object ContractCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 416
    Top = 368
  end
  object spJuridicalDetails: TdsdStoredProc
    StoredProcName = 'gpSelect_ObjectHistory_JuridicalDetails'
    DataSet = JuridicalDetailsCDS
    DataSets = <
      item
        DataSet = JuridicalDetailsCDS
      end>
    Params = <
      item
        Name = 'injuridicalid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFullName'
        Value = Null
        Component = FormParams
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOKPO'
        Value = Null
        Component = FormParams
        ComponentItem = 'OKPO'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 480
    Top = 506
  end
  object spPartner: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_PartnerJuridical'
    DataSet = PartnerCDS
    DataSets = <
      item
        DataSet = PartnerCDS
      end>
    Params = <
      item
        Name = 'injuridicalid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisErased'
        Value = Null
        Component = actShowErasedPartner
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 376
  end
  object spContract: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ContractJuridical'
    DataSet = ContractCDS
    DataSets = <
      item
        DataSet = ContractCDS
      end>
    Params = <
      item
        Name = 'injuridicalid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisErased'
        Value = Null
        Component = actShowErasedContract
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 424
    Top = 224
  end
  object JuridicalDetailsAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = JuridicalDetailsGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 288
    Top = 520
  end
  object PartnerAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = PartnerGridDBTableView
    OnDblClickActionList = <
      item
        Action = actPartnerUpdate
      end>
    ActionItemList = <
      item
        Action = actPartnerUpdate
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 384
    Top = 304
  end
  object ContractAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = ContractGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 480
    Top = 296
  end
  object spJuridicalDetailsIU: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_ObjectHistory_JuridicalDetails'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioid'
        Value = Null
        Component = JuridicalDetailsCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'injuridicalid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inoperdate'
        Value = Null
        Component = JuridicalDetailsCDS
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inbankid'
        Value = Null
        Component = JuridicalDetailsCDS
        ComponentItem = 'BankId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = Null
        Component = JuridicalDetailsCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'infullname'
        Value = Null
        Component = JuridicalDetailsCDS
        ComponentItem = 'FullName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'injuridicaladdress'
        Value = Null
        Component = JuridicalDetailsCDS
        ComponentItem = 'JuridicalAddress'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inokpo'
        Value = Null
        Component = JuridicalDetailsCDS
        ComponentItem = 'OKPO'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ininn'
        Value = Null
        Component = JuridicalDetailsCDS
        ComponentItem = 'INN'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'innumbervat'
        Value = Null
        Component = JuridicalDetailsCDS
        ComponentItem = 'NumberVAT'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inaccountername'
        Value = Null
        Component = JuridicalDetailsCDS
        ComponentItem = 'AccounterName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMainName'
        Value = Null
        Component = JuridicalDetailsCDS
        ComponentItem = 'MainName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inbankaccount'
        Value = Null
        Component = JuridicalDetailsCDS
        ComponentItem = 'BankAccount'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inphone'
        Value = Null
        Component = JuridicalDetailsCDS
        ComponentItem = 'Phone'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberBranch'
        Value = Null
        Component = JuridicalDetailsCDS
        ComponentItem = 'InvNumberBranch'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 392
    Top = 520
  end
  object dsdPriceListGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePriceList
    FormNameParam.Value = 'TPriceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdPriceListGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdPriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 617
    Top = 462
  end
  object dsdPriceListPromoGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePriceListPromo
    FormNameParam.Value = 'TPriceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdPriceListPromoGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdPriceListPromoGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 632
    Top = 414
  end
  object spClearDefaluts: TdsdStoredProc
    StoredProcName = 'gpGet_JuridicalDetails_ClearDefault'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'FullName'
        Value = Null
        Component = FormParams
        ComponentItem = 'Name'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OKPO'
        Value = Null
        Component = FormParams
        ComponentItem = 'OKPO'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 304
    Top = 410
  end
  object RetailReportGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRetailReport
    FormNameParam.Value = 'TRetailReportForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailReportForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = RetailReportGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RetailReportGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 392
    Top = 453
  end
  object RetailGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRetail
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 472
    Top = 437
  end
  object spCheckOKPO: TdsdStoredProc
    StoredProcName = 'gpCheckRight_ObjectHistory_JuridicalDetails_OKPO'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOKPO'
        Value = ''
        Component = JuridicalDetailsCDS
        ComponentItem = 'OKPO'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 568
    Top = 344
  end
  object GuidesSection: TdsdGuides
    KeyField = 'Id'
    LookupControl = edSection
    FormNameParam.Value = 'TSectionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSectionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesSection
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesSection
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 527
  end
  object spErasedUnErasedContract: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_Contract'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ContractCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 840
    Top = 128
  end
  object spErasedUnErasedPartner: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 840
    Top = 176
  end
end
