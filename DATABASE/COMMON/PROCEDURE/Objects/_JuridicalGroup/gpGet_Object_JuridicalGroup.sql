-- Function: gpGet_Object_JuridicalGroup()

--DROP FUNCTION gpGet_Object_JuridicalGroup();

CREATE OR REPLACE FUNCTION gpGet_Object_JuridicalGroup(
IN inId          Integer,       /* Касса */
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, JuridicalGroupId Integer, JuridicalGroupName TVarChar) AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY 
     SELECT 
       Object.Id
     , Object.ObjectCode
     , Object.ValueData
     , Object.isErased
     , JuridicalGroup.Id AS JuridicalGroupId
     , JuridicalGroup.ValueData AS JuridicalGroupName
     FROM Object
LEFT JOIN ObjectLink 
       ON ObjectLink.ObjectId = Object.Id
      AND ObjectLink.DescId = zc_ObjectLink_JuridicalGroup_JuridicalGroup()
LEFT JOIN Object AS JuridicalGroup
       ON JuridicalGroup.Id = ObjectLink.ChildObjectId
    WHERE Object.Id = inId;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_JuridicalGroup(integer, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_User('2')