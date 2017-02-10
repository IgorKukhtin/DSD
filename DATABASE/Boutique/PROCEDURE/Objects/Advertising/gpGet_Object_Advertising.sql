-- Function: gpGet_Object_Advertising(Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Advertising(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Advertising(
    IN inId          Integer,       -- ���� ������� <�����>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
    IF COALESCE (inId, 0) = 0
    THEN
    RETURN QUERY
        SELECT
            CAST (0 as Integer)                AS Id
          , lfGet_ObjectCode(0, zc_Object_Advertising()) AS Code
          , CAST ('' as TVarChar)              AS Name
          , CAST (NULL AS Boolean)             AS isErased;
    ELSE
        RETURN QUERY
        SELECT
            Object_Advertising.Id                     AS Id
          , Object_Advertising.ObjectCode             AS Code
          , Object_Advertising.ValueData              AS Name
          , Object_Advertising.isErased               AS isErased
        FROM Object AS Object_Advertising
        WHERE Object_Advertising.Id = inId;
   END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Advertising (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 31.10.15                                                                       *
*/

-- ����
-- SELECT * FROM  gpGet_Object_Advertising (2, '')
