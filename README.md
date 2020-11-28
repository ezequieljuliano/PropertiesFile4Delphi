# Properties File For Delphi
The PropertiesFile4Delphi consists of a library for handling **key=value** format configuration files. 

## About The Project
Many times, for various reasons, it is necessary to parameterize the application starting from a configuration mechanism. In Delphi is common to use INI files to store the settings, but working with these files is a bit repetitive and unproductive. The API PropertiesFile4Delphi facilitates this work with configuration files replacing the use of INI files. It is an API to manage simple text files, which are written with the **key=value** syntax, storing a unique key per line.

### Key Features
* Store and load data via simplified interface;
* Map configuration files to simplified classes.

### Built With
* [Delphi Community Edition](https://www.embarcadero.com/br/products/delphi/starter) - The IDE used 

## Getting Started
To get a local copy up and running follow these simple steps.

### Prerequisites
To use this library an updated version of Delphi IDE (XE or higher) is required.

### Installation
Clone the repo
```
git clone https://github.com/ezequieljuliano/PropertiesFile4Delphi.git
```

Add the "Search Path" of your IDE or your project the following directories:
```
PropertiesFile4Delphi\src
```

## Usage
Create or edit configuration files by declaring a variable of type IPropertiesFile and using the TPropertiesFileStorage implementation:

### Saving a Properties File
```
uses
  
  PropertiesFile,
  PropertiesFile.Storage;

procedure Save;
var
  propertiesFile: IPropertiesFile;
begin
  propertiesFile := TPropertiesFileStorage.Create;
  propertiesFile.PropertyItem['app.title'] := 'Properties File For Delphi';
  propertiesFile.PropertyItem['app.version'] := '1.0.0';
  propertiesFile.SaveToFile('application.properties');
end;

```

### Loading a Properties File
```
uses
  
  PropertiesFile,
  PropertiesFile.Storage;

procedure Load;
var
  propertiesFile: IPropertiesFile;
begin
  propertiesFile := TPropertiesFileStorage.Create;
  propertiesFile.LoadFromFile('application.properties');
  Self.Caption := propertiesFile.PropertyItem['app.title'] + '-' + propertiesFile.PropertyItem['app.version'];
end;

```

### Mapping Support and Configuration Classes
PropertiesFile4Delphi library provides a set of mapping classes. This way you can work directly with classes rather than getting manipulating files in your source code. The first step to using the configuration mechanism in an application is to create a specific class to store the desired parameters and write it down with **[PropertiesFile]** and inherit **TPropertiesFileObject** class.

Mapping example:
```
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

```

When the class is destroyed the file is automatically saved:
```
procedure Load;
var
  securityConfig: TSecurityConfig;
begin
  securityConfig := TSecurityConfig.Create;
  try
    securityConfig.Username := 'admin';
    securityConfig.Password := 'admin';
  finally
    securityConfig.Free;
  end;
end;

```

When instantiating the class the data is loaded:
```
procedure Login;
var
  securityConfig: TSecurityConfig;
begin
  securityConfig := TSecurityConfig.Create;
  try
    Login(securityConfig.Username, securityConfig.Password);
  finally
    securityConfig.Free;
  end;
end;

```

Supported field mappings:
* PropertyItem: alias field definition;
* NotNull: mandatory field definition;
* Ignore: Fields that should be ignored;
* ReadOnly: Fields that are read-only (can be applied at class level).  

## Roadmap
See the [open issues](https://github.com/ezequieljuliano/PropertiesFile4Delphi/issues) for a list of proposed features (and known issues).

## Contributing
Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License
Distributed under the APACHE LICENSE. See `LICENSE` for more information.

## Contact
To contact us use the options:
* E-mail  : ezequieljuliano@gmail.com
* Twitter : [@ezequieljuliano](https://twitter.com/ezequieljuliano)
* Linkedin: [ezequiel-juliano-müller](https://www.linkedin.com/in/ezequiel-juliano-müller-43988a4a)

## Project Link
[https://github.com/ezequieljuliano/PropertiesFile4Delphi](https://github.com/ezequieljuliano/PropertiesFile4Delphi)