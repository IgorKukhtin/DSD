-- Function: gpSelect_Object_ImportType()

DROP FUNCTION IF EXISTS gpSelect_Object_ImportGroupItems(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportGroupItems(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, ImportSettingsId Integer, Name TVarChar, ImportGroupId Integer, isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;  

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportType());
   vbUserId := lpGetUserBySession (inSession); 
   vbObjectId := COALESCE(lpGet_DefaultValue('zc_Object_Retail', vbUserId)::Integer, 0);

   RETURN QUERY 
       SELECT 
             ObjectLink_ImportGroupItems_ImportSettings.ObjectId  AS Id
           , Object_ImportSettings.Id        AS ImportSettingsId
           , Object_ImportSettings.ValueData AS Name
           , ObjectLink_ImportGroup_Object.ObjectId AS ImportGroupId
           , false                           AS isErased
           
       FROM Object AS Object_ImportSettings

                 JOIN ObjectLink AS ObjectLink_ImportGroup_Object
                                 ON ObjectLink_ImportGroup_Object.DescId = zc_ObjectLink_ImportGroup_Object()
                                -- !!!��������!!!
                                -- AND (ObjectLink_ImportGroup_Object.ChildObjectId = vbObjectId OR vbObjectId = 0)

                 JOIN ObjectLink AS ObjectLink_ImportGroupItems_ImportGroup
                                 ON ObjectLink_ImportGroupItems_ImportGroup.DescId = zc_ObjectLink_ImportGroupItems_ImportGroup()
                                AND ObjectLink_ImportGroupItems_ImportGroup.ChildObjectId = ObjectLink_ImportGroup_Object.ObjectId

                 JOIN ObjectLink AS ObjectLink_ImportGroupItems_ImportSettings
                                 ON ObjectLink_ImportGroupItems_ImportSettings.DescId = zc_ObjectLink_ImportGroupItems_ImportSettings()
                                AND ObjectLink_ImportGroupItems_ImportSettings.ChildObjectId = Object_ImportSettings.Id
                                AND ObjectLink_ImportGroupItems_ImportSettings.ObjectId = ObjectLink_ImportGroupItems_ImportGroup.ObjectId
                ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ImportGroupItems(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.09.14                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ImportType ('2')
