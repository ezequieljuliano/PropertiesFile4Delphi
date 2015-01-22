# Properties File For Delphi #

Many times, for various reasons, it is necessary to parameterize the application starting from a configuration mechanism. In Delphi is common to use INI files to store the settings, but working with these files is a bit repetitive and unproductive.

The API PropertiesFile4Delphi facilitates this work with configuration files replacing the use of INI files. It is an API to manage simple text files, which are written with the **key=value** syntax, storing a unique key per line.

# Saving Properties File #

    uses PropertiesFile4D;
    
    procedure Save;
    var
      vPropFile: IPropertiesFile;
    begin
      vPropFile := TPropertiesFileFactory.Build();
      vPropFile.PropertyItem['Config.App.Title'] := 'App Title';
      vPropFile.PropertyItem['Config.App.Version'] := '1.0';
      vPropFile.SaveToFile('AppConfig.properties');
    end;

# Loading Properties File #

    uses PropertiesFile4D;
    
    procedure Load;
    var
      vPropFile: IPropertiesFile;
    begin
      vPropFile := TPropertiesFileFactory.Build();
      vPropFile.LoadFromFile('AppConfig.properties');
      Self.Caption := vPropFile.PropertyItem['Config.App.Title'];
    end;

# Mapping Support And Configuration Classes #

To further facilitate its use, PropertiesFile4Delphi API provides a set of mapping classes. This way you can work directly with classes rather than getting manipulating files in your source code.

The first step to using the configuration mechanism in an application is to create a specific class to store the desired parameters and write it down with **[PropertiesFile]** and inherit **TMappedPropertiesFile** class. Here's an example:
    
    uses PropertiesFile4D.Mapping 
    
    // File name
    [PropertiesFile('UserConfig.properties')]
    TPropFileConfig = class(TMappedPropertiesFile)
    private
       FName: string;
       FPass: string;
    public
       property Name: string read FName write FName;
       property Pass: string read FPass write FPass;
    end;

To save only use the class:

    procedure Save;
    var
       vPropConfig: TPropFileConfig;
    begin
       vPropConfig := TPropFileConfig.Create;
       try
         vPropConfig.Name := 'admin';
         vPropConfig.Pass := 'admin';
      finally
         vPropConfig.Free;
      end;
    end;

To load use only the class:

    procedure Access;
    var
       vPropConfig: TPropFileConfig;
    begin
       vPropConfig := TPropFileConfig.Create;
       try
         Login(vPropConfig.Name, vPropConfig.Pass);
      finally
         vPropConfig.Free;
      end;
    end;

In certain situations a common key **prefix** to all parameters of a configuration class is used. In this case, you can specify this prefix in the annotation
**[PropertiesFile]**. This allows, for example, that a same file resources to be shared by several configuration classes.

There are also other annotations that can be used in the configuration classes. Here is an example describing these annotations:

    uses PropertiesFile4D.Mapping 
    
    // File name and common key prefix
    [PropertiesFile('UserConfig.properties', 'User')]
    // Specifies that will be a read-only configuration class
    [ReadOnly] 
    TPropFileConfig = class(TMappedPropertiesFile)
    private
       //Specifies what will be the name of the property in the file
       [PropertyItem('Name')] 
       //Specifies that this property can not be null
	   [NotNull]
       FName: string;
    
       [PropertyItem('Pass')]
       [NotNull]
       FPass: string;
    
	   //Specifies that this property is ignored not being saved in the file       
       [Ignore] 
       FKey: string;
    public
       property Name: string read FName;
       property Pass: string read FPass;
       property Key: string read FKey;
    end;

The PropertiesFile4Delphi allows the use of any primitive data type (Integer, String, Boolean, Double ...) in the properties of the mapped configuration classes.

The PropertiesFile4Delphi requires Delphi XE or greater and use it just add to the search path of the IDE or your project **PropertiesFile4Delphi\src** and then give **Uses** of sources.