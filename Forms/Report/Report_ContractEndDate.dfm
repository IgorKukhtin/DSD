inherited Report_ContractEndDateForm: TReport_ContractEndDateForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1076#1086#1075#1086#1074#1086#1088#1072#1084' "'#1087#1086#1076#1093#1086#1076#1103#1090' '#1089#1088#1086#1082#1080' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103'"'
  ClientHeight = 341
  ClientWidth = 1174
  ExplicitLeft = -184
  ExplicitWidth = 1182
  ExplicitHeight = 375
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1174
    Height = 284
    TabOrder = 3
    ExplicitWidth = 1174
    ExplicitHeight = 284
    ClientRectBottom = 284
    ClientRectRight = 1174
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1174
      ExplicitHeight = 284
      inherited cxGrid: TcxGrid
        Width = 1174
        Height = 284
        ExplicitWidth = 1174
        ExplicitHeight = 284
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clInfoMoneyDestinationName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clInfoMoneyName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clPersonalTradeName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAreaName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clInfoMoneyDestinationCode
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clInfoMoneyCode
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clPersonalName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clPersonalCollationName
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clContractStateKindCode: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractStateKindCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
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
                Description = #1047#1072#1074#1077#1096#1077#1085
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
            Width = 25
          end
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 26
          end
          object clInvNumberArchive: TcxGridDBColumn
            Caption = #1055#1086#1088#1103#1076#1082'. '#8470
            DataBinding.FieldName = 'InvNumberArchive'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 31
          end
          object clInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 31
          end
          object clContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object clJuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1102#1088'.'#1083'.'
            DataBinding.FieldName = 'JuridicalCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 25
          end
          object clJuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object clOKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 25
          end
          object colPaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 46
          end
          object clSigningDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1079#1072#1082#1083#1102#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'SigningDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 47
          end
          object clStartDate: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1089
            DataBinding.FieldName = 'StartDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 44
          end
          object clEndDate: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1076#1086
            DataBinding.FieldName = 'EndDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
          object clContractKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 23
          end
          object clInfoMoneyGroupCode: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1091#1087#1072#1082#1086#1074#1082#1080
            DataBinding.FieldName = 'InfoMoneyGroupCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 33
          end
          object clInfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 27
          end
          object clInfoMoneyDestinationCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055' '#1085#1072#1079#1085#1072#1095'.'
            DataBinding.FieldName = 'InfoMoneyDestinationCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 32
          end
          object clInfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 34
          end
          object clInfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 33
          end
          object clInfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 33
          end
          object clPersonalName: TcxGridDBColumn
            Caption = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalName'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 33
          end
          object clPersonalTradeName: TcxGridDBColumn
            Caption = #1058#1055' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalTradeName'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 33
          end
          object clPersonalCollationName: TcxGridDBColumn
            Caption = #1041#1091#1093#1075'.'#1089#1074#1077#1088#1082#1072' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalCollationName'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 34
          end
          object clAreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085
            DataBinding.FieldName = 'AreaName'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 33
          end
          object clContractArticleName: TcxGridDBColumn
            Caption = #1055#1088#1077#1076#1084#1077#1090' '#1076#1086#1075#1086#1074#1086#1088#1072
            DataBinding.FieldName = 'ContractArticleName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 32
          end
          object clJuridicalBasisName: TcxGridDBColumn
            Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalBasisName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 33
          end
          object clBankAccountName: TcxGridDBColumn
            Caption = #1056'.'#1089#1095#1077#1090' ('#1074#1093'.'#1087#1083#1072#1090#1077#1078')'
            DataBinding.FieldName = 'BankAccountName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 33
          end
          object clBankAccountExternal: TcxGridDBColumn
            Caption = #1056'.'#1089#1095#1077#1090' ('#1080#1089#1093'.'#1087#1083#1072#1090#1077#1078')'
            DataBinding.FieldName = 'BankAccountExternal'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 34
          end
          object clBankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082' ('#1080#1089#1093'.'#1087#1083#1072#1090#1077#1078')'
            DataBinding.FieldName = 'BankName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 32
          end
          object clInsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 33
          end
          object clUpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 33
          end
          object clComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 33
          end
          object clisStandart: TcxGridDBColumn
            Caption = #1058#1080#1087#1086#1074#1086#1081
            DataBinding.FieldName = 'isStandart'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 34
          end
          object clisPersonal: TcxGridDBColumn
            Caption = 'C'#1083#1091#1078'. '#1079#1072#1087'.'
            DataBinding.FieldName = 'isPersonal'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 33
          end
          object clisDefault: TcxGridDBColumn
            Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
            DataBinding.FieldName = 'isDefault'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 33
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1174
    ExplicitLeft = -8
    ExplicitTop = -24
    ExplicitWidth = 1174
    inherited deStart: TcxDateEdit
      EditValue = 41852d
      Properties.SaveTime = False
    end
    inherited deEnd: TcxDateEdit
      EditValue = 41852d
      Properties.SaveTime = False
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited cxLabel2: TcxLabel
      Left = 198
      ExplicitLeft = 198
    end
    object ceinFlag: TcxCheckBox
      Left = 424
      Top = 5
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072' '#1084#1077#1085#1100#1096#1077' '#1080#1083#1080' '#1088#1072#1074#1085#1072' '#1087#1077#1088#1080#1086#1076#1091
      TabOrder = 4
      Width = 305
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
    StoredProcName = 'gpReport_ContractEndDate'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41852d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41852d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inFlag'
        Value = 'False'
        Component = ceinFlag
        DataType = ftBoolean
        ParamType = ptInput
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
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 360
    Top = 232
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 296
    Top = 192
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = ceinFlag
      end
      item
      end>
    Left = 232
    Top = 216
  end
end
