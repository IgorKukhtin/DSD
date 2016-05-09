-- Function: gpSelect_Object_ImportType()

DROP FUNCTION IF EXISTS gpSelect_Object_ImportGroup(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportGroup(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Name TVarChar, isErased boolean) AS
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
             Object_ImportGroup.Id           AS Id
           , Object_ImportGroup.ValueData    AS Name
           
           , Object_ImportGroup.isErased     AS isErased
           
       FROM Object AS Object_ImportGroup
                 JOIN ObjectLink AS ObjectLink_ImportGroup_Object
                                 ON ObjectLink_ImportGroup_Object.ObjectId = Object_ImportGroup.Id
                                AND ObjectLink_ImportGroup_Object.DescId = zc_ObjectLink_ImportGroup_Object()
                                -- !!!��������!!!
                                -- AND (ObjectLink_ImportGroup_Object.ChildObjectId = vbObjectId OR vbObjectId = 0)
      ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ImportGroup(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.09.14                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ImportType ('2')
