﻿-- Function: gpGet_Object_Form_HelpFile()

DROP FUNCTION IF EXISTS gpGet_Object_Form_HelpFile(TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Form_HelpFile(
    IN inFormName    TVarChar,      -- Форма 
   OUT outHelpFile   TVarChar,      -- Путь к файлу помощи
    IN inSession     TVarChar       -- текущий пользователь
)
RETURNS TVarChar
AS
$BODY$
DECLARE
BEGIN
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

    SELECT 
        ObjectString_HelpFile.ValueData 
    INTO 
        outHelpFile
    FROM 
        Object
        LEFT OUTER JOIN ObjectString AS ObjectString_HelpFile
                                     ON ObjectString_HelpFile.DescId = zc_ObjectString_Form_HelpFile() 
                                    AND ObjectString_HelpFile.ObjectId = Object.Id
    WHERE 
        Object.ValueData = inFormName AND 
        Object.DescId = zc_Object_Form();

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

-- SELECT * FROM gpUpdate_Object_Form_HelpFile ('TMainForm', 'https://docs.google.com/document/d/1PmZO5s2hUu_fg91CAeY7DNbiurcXv7KudU8a7QkNM9E/edit', '5')
