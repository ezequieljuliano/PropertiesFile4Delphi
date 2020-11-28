program MappingApp;

uses
  Vcl.Forms,
  Main.View in 'Main.View.pas' {MainView} ,
  Security.Config in 'Security.Config.pas';

{$R *.res}

begin

  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  Application.Run;

end.
