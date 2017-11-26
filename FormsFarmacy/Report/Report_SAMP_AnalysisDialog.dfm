object Report_SAMP_AnalysisDialogForm: TReport_SAMP_AnalysisDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <C'#1088#1072#1074#1085#1077#1085#1080#1077' '#1089' '#1087#1088#1086#1096#1083#1099#1084' '#1087#1077#1088#1080#1086#1076#1086#1084'>'
  ClientHeight = 126
  ClientWidth = 327
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 46
    Top = 78
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 220
    Top = 78
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deYear2: TcxDateEdit
    Left = 179
    Top = 27
    EditValue = 42400d
    Properties.DisplayFormat = 'YYYY'
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object deYear1: TcxDateEdit
    Left = 40
    Top = 27
    EditValue = 42370d
    Properties.DisplayFormat = 'YYYY'
    Properties.ShowTime = False
    TabOrder = 3
    Width = 90
  end
  object cxLabel6: TcxLabel
    Left = 40
    Top = 7
    Caption = #1055#1077#1088#1080#1086#1076' 1 ('#1075#1086#1076'):'
  end
  object cxLabel7: TcxLabel
    Left = 179
    Top = 7
    Caption = #1055#1077#1088#1080#1086#1076' 2 ('#1075#1086#1076'):'
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Year1'
        Value = 41579d
        Component = deYear1
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Year2'
        Value = 41608d
        Component = deYear2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 254
    Top = 14
  end
end
