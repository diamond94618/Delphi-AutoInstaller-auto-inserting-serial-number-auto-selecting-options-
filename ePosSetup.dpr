program ePosSetup;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ePos Setup';
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
