-- Function: gpSelect_Object_DiscountExternalTools()

DROP FUNCTION IF EXISTS gpSelect_Object_DiscountExternalTools (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DiscountExternalTools(
    IN inSession       TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer
             , DiscountExternalId Integer, DiscountExternalCode Integer, DiscountExternalName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar, JuridicalName TVarChar
             , UserName TVarChar
             , Password TVarChar
             , ExternalUnit TVarChar  
             , isErased Boolean
              ) AS
$BODY$
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountExternalTools());

      RETURN QUERY 
        SELECT Object_DiscountExternalTools.Id         AS Id
             , Object_DiscountExternalTools.ObjectCode AS Code

             , Object_DiscountExternal.Id         AS DiscountExternalId
             , Object_DiscountExternal.ObjectCode AS DiscountExternalCode
             , Object_DiscountExternal.ValueData  AS DiscountExternalName

             , Object_Unit.Id             AS UnitId
             , Object_Unit.ObjectCode     AS UnitCode
             , Object_Unit.ValueData      AS UnitName
             , Object_Juridical.ValueData AS JuridicalName

             , ObjectString_User.ValueData     AS UserName
             , ObjectString_Password.ValueData AS Password

             , ObjectString_ExternalUnit.ValueData AS ExternalUnit

             , Object_DiscountExternalTools.isErased

        FROM Object AS Object_DiscountExternalTools
             LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                  ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalTools.Id
                                 AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
             LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = ObjectLink_DiscountExternal.ChildObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Unit
                                  ON ObjectLink_Unit.ObjectId = Object_DiscountExternalTools.Id
                                 AND ObjectLink_Unit.DescId = zc_ObjectLink_DiscountExternalTools_Unit()
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_User
                                    ON ObjectString_User.ObjectId = Object_DiscountExternalTools.Id 
                                   AND ObjectString_User.DescId = zc_ObjectString_DiscountExternalTools_User()
             LEFT JOIN ObjectString AS ObjectString_Password
                                    ON ObjectString_Password.ObjectId = Object_DiscountExternalTools.Id 
                                   AND ObjectString_Password.DescId = zc_ObjectString_DiscountExternalTools_Password()

             LEFT JOIN ObjectString AS ObjectString_ExternalUnit
                                    ON ObjectString_ExternalUnit.ObjectId = Object_DiscountExternalTools.Id 
                                   AND ObjectString_ExternalUnit.DescId = zc_ObjectString_DiscountExternalTools_ExternalUnit()

        WHERE Object_DiscountExternalTools.DescId = zc_Object_DiscountExternalTools();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.
 16.05.17                                                       *
 20.07.16         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_DiscountExternalTools ('2')
