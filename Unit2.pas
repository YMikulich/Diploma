unit Unit2;

interface

uses
  System.SysUtils, System.Classes, Vcl.Dialogs;

type
  TDataModule2 = class(TDataModule)
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule2: TDataModule2;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
