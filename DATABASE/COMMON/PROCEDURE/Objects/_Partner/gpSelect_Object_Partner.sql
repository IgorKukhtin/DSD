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
      AND ObjectLink.DescId = zc_ObjectLink_JuridicalGroup_Parent()
    WHERE Object.DescId = zc_Object_JuridicalGroup()
    UNION
    SELECT 
       Object_Partner.Id
     , Object_Partner.ObjectCode
     , CAST('' AS TVarChar)      AS JuridicalGroupName
     , Object_Juridical.ValueData       AS JuridicalName
     , Object_Partner.ValueData         AS Name
     , Object_Partner.isErased
     , ObjectLink_Juridical_JuridicalGroup.ChildObjectId AS JuridicalGroupId
     FROM Object AS Object_Partner
LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
       ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id 
      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
LEFT JOIN Object AS Object_Juridical
       ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
       ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
      AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
    WHERE Object_Partner.DescId = zc_Object_Partner();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_Partner(TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_Object_Partner('2')