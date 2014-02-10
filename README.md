# Properties File For Delphi #

PropertiesFile4Delphi is a library that helps in handling files with type structure key-value. Makes use of Spring4D for use of concepts of Dependency Injection.

The PropertiesFile4Delphi API was developed and tested in Delphi XE5.

# External Dependencies #

This library requires the following external dependencies that are already included in their sources:

- Delphi Spring Framework (https://bitbucket.org/sglienke/spring4d);

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

- PropertiesFile4Delphi\dependencies\Spring4D\Source\Base
- PropertiesFile4Delphi\dependencies\Spring4D\Source\Base\Collections
- PropertiesFile4Delphi\dependencies\Spring4D\Source\Base\Reflection
- PropertiesFile4Delphi\dependencies\Spring4D\Source\Core\Container
- PropertiesFile4Delphi\dependencies\Spring4D\Source\Core\Services
- PropertiesFile4Delphi\src\

Then you should add to your DPR a Unit responsible for making the records to be used in Dependency Injection.:

Add Uses of DPR, preferably at the end of the next row.:

- PropertiesFile4D.Module.Register.pas

Analyze the unit tests they will assist you.