-- Function: gpSelect_Object_JuridicalArea()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalArea(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalArea(
    IN inJuridicalId Integer,       -- 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Comment TVarChar 
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , AreaId Integer, AreaCode Integer, AreaName TVarChar
             , Email TVarChar
             , isDefault Boolean
             , isErased boolean
             ) AS
$BODY$BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_JuridicalArea());

     RETURN QUERY  
       SELECT 
             Object_JuridicalArea.Id          AS Id
           , Object_JuridicalArea.ObjectCode  AS Code
           , Object_JuridicalArea.ValueData   AS Comment
           
           , Object_Juridical.Id              AS JuridicalId
           , Object_Juridical.ObjectCode      AS JuridicalCode
           , Object_Juridical.ValueData       AS JuridicalName

           , Object_Area.Id                   AS AreaId
           , Object_Area.ObjectCode           AS AreaCode
           , Object_Area.ValueData            AS AreaName

           , ObjectString_JuridicalArea_Email.ValueData  AS Email
           , COALESCE (ObjectBoolean_JuridicalArea_Default.ValueData, FALSE)  AS isDefault
           
           , Object_JuridicalArea.isErased AS isErased
           
       FROM Object AS Object_JuridicalArea
            INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                  ON ObjectLink_JuridicalArea_Juridical.ObjectId = Object_JuridicalArea.Id 
                                 AND ObjectLink_JuridicalArea_Juridical.DescId = zc_ObjectLink_JuridicalArea_Juridical()
                                 AND (ObjectLink_JuridicalArea_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_JuridicalArea_Juridical.ChildObjectId       
            
            LEFT JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                 ON ObjectLink_JuridicalArea_Area.ObjectId = Object_JuridicalArea.Id 
                                AND ObjectLink_JuridicalArea_Area.DescId = zc_ObjectLink_JuridicalArea_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_JuridicalArea_Area.ChildObjectId                     
   
            LEFT JOIN ObjectString AS ObjectString_JuridicalArea_Email
                                   ON ObjectString_JuridicalArea_Email.ObjectId = Object_JuridicalArea.Id 
                                  AND ObjectString_JuridicalArea_Email.DescId = zc_ObjectString_JuridicalArea_Email()
                                 
            LEFT JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_Default
                                    ON ObjectBoolean_JuridicalArea_Default.ObjectId = Object_JuridicalArea.Id
                                   AND ObjectBoolean_JuridicalArea_Default.DescId = zc_ObjectBoolean_JuridicalArea_Default()
     WHERE Object_JuridicalArea.DescId = zc_Object_JuridicalArea()
         ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.09.17         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_JuridicalArea('2')