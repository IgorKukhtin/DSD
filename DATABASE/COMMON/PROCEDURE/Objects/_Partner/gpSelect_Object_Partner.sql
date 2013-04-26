-- Function: gpSelect_Object_Partner()

--DROP FUNCTION gpSelect_Object_Partner(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Partner(
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, JuridicalGroupName TVarChar, JuridicalName TVarChar, Name TVarChar, isErased BOOLEAN, JuridicalGroupId Integer) AS
$BODY$BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY 
      SELECT 
       Object.Id
     , Object.ObjectCode
     , Object.ValueData         AS JuridicalGroupName
     , CAST('' AS TVarChar)     AS JuridicalName
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
       Partner.Id
     , Partner.ObjectCode
     , CAST('' AS TVarChar)      AS JuridicalGroupName
     , Juridical.ValueData       AS JuridicalName
     , Partner.ValueData         AS Name
     , Partner.isErased
     , Juridical_JuridicalGroup.ChildObjectId AS JuridicalGroupId
     FROM Object AS Partner
LEFT JOIN ObjectLink AS Partner_Juridical
       ON Partner_Juridical.ObjectId = Object.Id 
      AND Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
LEFT JOIN Object AS Juridical
       ON Juridical.Id = Partner_Juridical.ChildObjectId
LEFT JOIN ObjectLink AS Juridical_JuridicalGroup
       ON Juridical_JuridicalGroup.ObjectId = Juridical.Id
      AND Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
    WHERE Object.DescId = zc_Object_Partner();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_Partner(TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_Object_Partner('2')