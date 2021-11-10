inherited TelegramProtocolForm: TTelegramProtocolForm
  Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1089#1086#1086#1073#1097#1077#1085#1080#1081' '#1074' Telegram'
  ClientHeight = 319
  ClientWidth = 930
  AddOnFormData.isSingle = False
  ExplicitWidth = 946
  ExplicitHeight = 358
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 930
    Height = 262
    ExplicitWidth = 930
    ExplicitHeight = 262
    ClientRectBottom = 262
    ClientRectRight = 930
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 930
      ExplicitHeight = 262
      inherited cxGrid: TcxGrid
        Width = 930
        Height = 262
        ExplicitWidth = 930
        ExplicitHeight = 262
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsView.CellAutoHeight = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object UserName: TcxGridDBColumn
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
            DataBinding.FieldName = 'UserName'
            Width = 109
          end
          object DateSend: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1090#1087#1088#1072#1074#1082#1080
            DataBinding.FieldName = 'DateSend'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 114
          end
          object ObjectName: TcxGridDBColumn
            Caption = #1055#1086#1083#1091#1095#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'ObjectName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object Message: TcxGridDBColumn
            Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077
            DataBinding.FieldName = 'Message'
            PropertiesClassName = 'TcxRichEditProperties'
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 505
          end
          object TelegramId: TcxGridDBColumn
            DataBinding.FieldName = 'TelegramId'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object isError: TcxGridDBColumn
            Caption = #1054#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isError'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087'.'
            DataBinding.FieldName = 'UnitCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Error: TcxGridDBColumn
            Caption = #1058#1077#1082#1089#1090' '#1086#1096#1080#1073#1082#1080
            DataBinding.FieldName = 'Error'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 177
          end
          object BranchCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1092'.'
            DataBinding.FieldName = 'BranchCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 930
    ExplicitWidth = 930
    inherited deStart: TcxDateEdit
      EditValue = 41640d
    end
    inherited deEnd: TcxDateEdit
      Left = 335
      EditValue = 41640d
      ExplicitLeft = 335
    end
    inherited cxLabel2: TcxLabel
      Left = 225
      ExplicitLeft = 225
    end
  end
  inherited MasterDS: TDataSource
    Left = 192
    Top = 159
  end
  inherited MasterCDS: TClientDataSet
    Left = 56
    Top = 87
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_TelegramProtocol'
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
        Name = 'inObjectId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 87
  end
  inherited BarManager: TdxBarManager
    Left = 312
    Top = 143
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 40
    Top = 168
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
    Left = 296
    Top = 88
  end
end
