-- Function: gpGet_Object_Partner()

--DROP FUNCTION gpGet_Object_Partner();

CREATE OR REPLACE FUNCTION gpGet_Object_Partner(
IN inId          Integer,       /* Касса */
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, GLNCode TVarChar,
               JuridicalName TVarChar, JuridicalId Integer) AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY 
     SELECT 
       Object.Id                       AS Id
     , Object.ObjectCode               AS Code
     , Object.ValueData                AS Name
     , Object.isErased                 AS isErased
     , Partner_GLNCode.ValueData       AS GLNCode
     , Juridical.ValueData             AS JuridicalName
     , Juridical.Id                    AS JuridicalId
     FROM Object
LEFT JOIN ObjectString AS Partner_GLNCode 
       ON Partner_GLNCode.ObjectId = Object.Id AND Partner_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
LEFT JOIN ObjectLink AS Partner_Juridical
       ON Partner_Juridical.ObjectId = Object.Id AND Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
LEFT JOIN Object AS Juridical
       ON Juridical.Id = Partner_Juridical.ChildObjectId
    WHERE Object.Id = inId;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_Partner(integer, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_User('2')