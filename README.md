# Properties File For Delphi #

Many times, for various reasons, it is necessary to parameterize the application starting from a configuration mechanism. In Delphi is common to use INI files to store the settings, but working with these files is a bit repetitive and unproductive.

The API PropertiesFile4Delphi facilitates this work with configuration files replacing the use of INI files. It is an API to manage simple text files, which are written with the **key=value** syntax, storing a unique key per line.

# Saving Properties File #

    uses 
	  PropertiesFile4D, 
	  PropertiesFile4D.Impl;
    
    procedure Save;
    var
      propertiesFile: IPropertiesFile;
    begin
      propertiesFile := TPropertiesFile.New;
      propertiesFile.PropertyItem['Config.App.Title'] := 'App Title';
      propertiesFile.PropertyItem['Config.App.Version'] := '1.0';
      propertiesFile.SaveToFile('AppConfig.properties');
    end;

# Loading Properties File #

    uses 
	  PropertiesFile4D, 
	  PropertiesFile4D.Impl;
    
    procedure Load;
    var
      propertiesFile: IPropertiesFile;
    begin
      propertiesFile := TPropertiesFile.New;
      propertiesFile.LoadFromFile('AppConfig.properties');
      Self.Caption := vPropFile.PropertyItem['Config.App.Title'];
    end;

# Mapping Support And Configuration Classes #

To further facilitate its use, PropertiesFile4Delphi API provides a set of mapping classes. This way you can work directly with classes rather than getting manipulating files in your source code.

The first step to using the configuration mechanism in an application is to create a specific class to store the desired parameters and write it down with **[PropertiesFile]** and inherit **TMappedPropertiesFile** class. Here's an example:
    
    uses 
      PropertiesFile4D.Mapping 
    
    [PropertiesFile('UserConfig.properties')]
    TUserConfig = class(TMappedPropertiesFile)
    private
      fName: string;
      fPass: string;
    public
      property Name: string read fName write fName;
      property Pass: string read fPass write fPass;
    end;

To save only use the class:

    procedure Save;
    var
       userConfig: TUserConfig;
    begin
       userConfig := TUserConfig.Create;
       try
         userConfig.Name := 'admin';
         userConfig.Pass := 'admin';
       finally
         userConfig.Free;
       end;
    end;

To load use only the class:

    procedure Access;
    var
       userConfig: TUserConfig;
    begin
       userConfig := TUserConfig.Create;
       try
         Login(userConfig.Name, userConfig.Pass);
       finally
         userConfig.Free;
       end;
    end;

In certain situations a common key **prefix** to all parameters of a configuration class is used. In this case, you can specify this prefix in the annotation
**[PropertiesFile]**. This allows, for example, that a same file resources to be shared by several configuration classes.

There are also other annotations that can be used in the configuration classes. Here is an example describing these annotations:

    uses 
      PropertiesFile4D.Mapping 
    
    // File name and common key prefix
    [PropertiesFile('UserConfig.properties', 'User')]
    // Specifies that will be a read-only configuration class
    [ReadOnly] 
    TUserConfig = class(TMappedPropertiesFile)
    private
       //Specifies what will be the name of the property in the file
       [PropertyItem('Name')] 
       //Specifies that this property can not be null
	   [NotNull]
       fName: string;
    
       [PropertyItem('Pass')]
       [NotNull]
       fPass: string;
    
	   //Specifies that this property is ignored not being saved in the file       
       [Ignore] 
       fKey: string;
    public
       property Name: string read fName;
       property Pass: string read fPass;
       property Key: string read fKey;
    end;

The PropertiesFile4Delphi allows the use of any primitive data type (Integer, String, Boolean, Double ...) in the properties of the mapped configuration classes.

The PropertiesFile4Delphi requires Delphi XE or greater and use it just add to the search path of the IDE or your project **PropertiesFile4Delphi\src** and then give **Uses** of sources.