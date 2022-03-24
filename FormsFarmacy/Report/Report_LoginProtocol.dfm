inherited Report_LoginProtocolForm: TReport_LoginProtocolForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081'>'
  ClientHeight = 452
  ClientWidth = 638
  ExplicitWidth = 654
  ExplicitHeight = 491
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 638
    Height = 395
    TabOrder = 3
    ExplicitWidth = 638
    ExplicitHeight = 395
    ClientRectBottom = 395
    ClientRectRight = 638
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 638
      ExplicitHeight = 395
      inherited cxGrid: TcxGrid
        Width = 638
        Height = 395
        ExplicitWidth = 638
        ExplicitHeight = 395
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
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
            end>
          OptionsData.Deleting = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object operDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'operDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 147
          end
          object UserCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UserCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object UserName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 249
          end
          object UserRoleName: TcxGridDBColumn
            Caption = #1056#1086#1083#1080
            DataBinding.FieldName = 'UserRoleName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 155
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 638
    ExplicitWidth = 638
    inherited deStart: TcxDateEdit
      EditValue = 42248d
      Properties.SaveTime = False
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42248d
      Properties.SaveTime = False
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
    StoredProcName = 'gpSelect_LoginProtocol'
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
    Left = 368
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
      end>
    Left = 184
    Top = 136
  end
end
