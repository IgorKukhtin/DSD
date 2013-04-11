-- Function: gpSelect_Object_Juridical()

--DROP FUNCTION gpSelect_Object_Juridical(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Juridical(
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, JuridicalGroupName TVarChar, Name TVarChar, isErased BOOLEAN, JuridicalGroupId Integer) AS
$BODY$BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY 
      SELECT 
       Object.Id
     , Object.ObjectCode
     , Object.ValueData         AS JuridicalGroupName
     , CAST('' AS TVarChar)     AS Name
     , Object.isErased
     , ObjectLink.ChildObjectId AS JuridicalGroupId
     FROM Object
LEFT JOIN ObjectLink 
       ON ObjectLink.ObjectId = Object.Id
      AND ObjectLink.DescId = zc_ObjectLink_JuridicalGroup_JuridicalGroup()
    WHERE Object.DescId = zc_Object_JuridicalGroup()
    UNION
    SELECT 
       Object.Id
     , Object.ObjectCode
     , CAST('' AS TVarChar)     AS JuridicalGroupName
     , Object.ValueData         AS Name
     , Object.isErased
     , Juridical_JuridicalGroup.ChildObjectId AS JuridicalGroupId
     FROM Object
LEFT JOIN ObjectLink AS Juridical_JuridicalGroup
       ON Juridical_JuridicalGroup.ObjectId = Object.Id 
      AND Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
    WHERE Object.DescId = zc_Object_Juridical();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_Juridical(TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_Object_Juridical('2')