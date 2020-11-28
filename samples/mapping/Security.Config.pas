unit Security.Config;

interface

uses

  PropertiesFile.Mapping;

type

  [PropertiesFile('security.properties')]
  TSecurityConfig = class(TPropertiesFileObject)
  private
    [NotNull]
    [PropertyItem('username')]
    fUsername: string;

    [NotNull]
    [PropertyItem('password')]
    fPassword: string;
  public
    property Username: string read fUsername write fUsername;
    property Password: string read fPassword write fPassword;
  end;

implementation

end.
