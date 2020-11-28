unit Main.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, PropertiesFile, PropertiesFile.Storage;

type

  TMainView = class(TForm)
    EdtUsername: TEdit;
    EdtPassword: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainView: TMainView;

implementation

{$R *.dfm}

procedure TMainView.Button1Click(Sender: TObject);
var
  propertiesFile: IPropertiesFile;
begin
  propertiesFile := TPropertiesFileStorage.Create;
  propertiesFile.PropertyItem['username'] := EdtUsername.Text;
  propertiesFile.PropertyItem['password'] := EdtPassword.Text;
  propertiesFile.SaveToFile('application.properties');

  EdtUsername.Text := '';
  EdtPassword.Text := '';
end;

procedure TMainView.Button2Click(Sender: TObject);
var
  propertiesFile: IPropertiesFile;
begin
  propertiesFile := TPropertiesFileStorage.Create;
  propertiesFile.LoadFromFile('application.properties');

  EdtUsername.Text := propertiesFile.PropertyItem['username'];
  EdtPassword.Text := propertiesFile.PropertyItem['password'];
end;

procedure TMainView.FormShow(Sender: TObject);
begin
  EdtUsername.SetFocus;
end;

end.
