# Properties File For Delphi #

PropertiesFile4Delphi is a library that helps in handling files with type structure key-value. Makes use of Spring4D for use of concepts of Dependency Injection.

The PropertiesFile4Delphi API was developed and tested in Delphi XE5.

# Examples #

    procedure LoadFile;
    var
      FFile: IPropertiesFile;
    begin
      FFile.Properties.Clear;
      FFile.LoadFromFile('file.infra');
      ShowMessage(FFile.PropertyItem['Test']);
    end;

    procedure SaveFile;
    var
      FFile: IPropertiesFile;
    begin
      FFile.Properties.Clear;
      FFile.PropertyItem['Test'] := 'Test';
      FFile.SaveToFile('file.infra');
    end;

# Using PropertiesFile4Delphi #

Using this library will is very simple, you simply add the Search Path of your IDE or your project the following directories:

- PropertiesFile4Delphi\src\

Then just add your implementation to PropertiesFile4D.pas.

Analyze the unit tests they will assist you.