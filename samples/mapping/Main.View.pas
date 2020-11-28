unit Main.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, PropertiesFile, PropertiesFile.Storage, Security.Config, Vcl.StdCtrls;

type

  TMainView = class(TForm)
    EdtUsername: TEdit;
    EdtPassword: TEdit;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    fSecurityConfig: TSecurityConfig;
    procedure CreateApplicationPropertiesIfNoExists;
  public
    { Public declarations }
  end;

var
  MainView: TMainView;

implementation

{$R *.dfm}

{ TMainView }

procedure TMainView.Button1Click(Sender: TObject);
begin
  if (fSecurityConfig.Username = EdtUsername.Text) and (fSecurityConfig.Password = EdtPassword.Text) then
    ShowMessage('Login successfully')
  else
    ShowMessage('Incorrect username or password');
end;

procedure TMainView.CreateApplicationPropertiesIfNoExists;
var
  propertiesFile: IPropertiesFile;
begin
  if not FileExists('security.properties') then
  begin
    propertiesFile := TPropertiesFileStorage.Create;
    propertiesFile.PropertyItem['username'] := 'admin';
    propertiesFile.PropertyItem['password'] := 'admin';
    propertiesFile.SaveToFile('security.properties');
  end;
end;

procedure TMainView.FormCreate(Sender: TObject);
begin
  CreateApplicationPropertiesIfNoExists;
  fSecurityConfig := TSecurityConfig.Create;
end;

procedure TMainView.FormDestroy(Sender: TObject);
begin
  fSecurityConfig.Free;
end;

end.
