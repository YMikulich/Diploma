object Form1: TForm1
  Left = 0
  Top = 0
  Anchors = []
  AutoSize = True
  BorderStyle = bsSingle
  Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1085#1080#1077' '#1083#1086#1075#1080#1095#1077#1089#1082#1080#1093' '#1092#1086#1088#1084#1091#1083
  ClientHeight = 305
  ClientWidth = 561
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 561
    Height = 305
    ActivePage = TabSheet2
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #1051#1086#1075#1080#1095#1077#1089#1082#1080#1077' '#1092#1086#1088#1084#1091#1083#1099' '#1074' '#1092#1091#1085#1082#1094#1080#1086#1085#1072#1083#1100#1085#1099#1077
      object Label2: TLabel
        Left = 96
        Top = 61
        Width = 206
        Height = 13
        Caption = #1042#1093#1086#1076#1085#1086#1081' '#1092#1072#1081#1083' '#1089' '#1083#1086#1075#1080#1095#1077#1089#1082#1080#1084#1080' '#1092#1086#1088#1084#1091#1083#1072#1084#1080
      end
      object Label3: TLabel
        Left = 96
        Top = 125
        Width = 236
        Height = 13
        Caption = #1042#1093#1086#1076#1085#1086#1081' '#1092#1072#1081#1083' '#1089' '#1092#1091#1085#1082#1094#1080#1086#1085#1072#1083#1100#1085#1099#1084#1080' '#1092#1086#1088#1084#1091#1083#1072#1084#1080
      end
      object Edit1: TEdit
        Left = 96
        Top = 80
        Width = 289
        Height = 21
        TabOrder = 0
      end
      object Edit2: TEdit
        Left = 96
        Top = 144
        Width = 289
        Height = 21
        TabOrder = 1
      end
      object Button2: TButton
        Left = 408
        Top = 78
        Width = 75
        Height = 25
        Caption = #1042#1099#1073#1086#1088
        TabOrder = 2
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 408
        Top = 142
        Width = 75
        Height = 25
        Caption = #1042#1099#1073#1086#1088
        TabOrder = 3
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 200
        Top = 192
        Width = 137
        Height = 25
        Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1090#1100
        TabOrder = 4
        OnClick = Button4Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1060#1091#1085#1082#1094#1080#1086#1085#1072#1083#1100#1085#1099#1077' '#1092#1086#1088#1084#1091#1083#1099' '#1085#1072' '#1103#1079#1099#1082' FBD'
      ImageIndex = 1
      object Label4: TLabel
        Left = 96
        Top = 93
        Width = 102
        Height = 13
        Caption = #1042#1099#1093#1086#1076#1085#1086#1081' '#1092#1072#1081#1083' FBD'
      end
      object Edit3: TEdit
        Left = 96
        Top = 112
        Width = 289
        Height = 21
        TabOrder = 0
      end
      object Button5: TButton
        Left = 400
        Top = 110
        Width = 75
        Height = 25
        Caption = #1042#1099#1073#1086#1088
        TabOrder = 1
        OnClick = Button5Click
      end
      object Button1: TButton
        Left = 200
        Top = 160
        Width = 137
        Height = 25
        Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1090#1100
        TabOrder = 2
        OnClick = Button1Click
      end
    end
  end
end
