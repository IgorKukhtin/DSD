-- Function: gpGet_Object_Branch()

--DROP FUNCTION gpGet_Object_Branch();

CREATE OR REPLACE FUNCTION gpGet_Object_Branch(
IN inId          Integer,       /* Бизнесы */
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, JuridicalId Integer, JuridicalName TVarChar) AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY 
     SELECT 
       Object.Id
     , Object.ObjectCode
     , Object.ValueData
     , Object.isErased
     , Juridical.Id        AS JuridicalId
     , Juridical.ValueData AS JuridicalName
     FROM Object
LEFT JOIN ObjectLink AS Branch_Juridical
       ON Branch_Juridical.ObjectId = Object.Id AND Branch_Juridical.DescId = zc_ObjectLink_Branch_Juridical()
LEFT JOIN Object AS Juridical
       ON Juridical.Id = Branch_Juridical.ChildObjectId
    WHERE Object.Id = inId;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_Branch(integer, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_User('2')