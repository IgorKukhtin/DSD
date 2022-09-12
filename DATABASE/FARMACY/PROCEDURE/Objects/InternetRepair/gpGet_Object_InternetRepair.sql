-- Function: gpGet_Object_Education (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_InternetRepair (Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_InternetRepair(
    IN inId          Integer,        --
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Education());

    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
        RAISE EXCEPTION '�� ���������� �������������';
    END IF;
    vbUnitId := vbUnitKey::Integer;

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_InternetRepair()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
     RETURN QUERY
     SELECT
           Object_InternetRepair.Id             AS Id
         , Object_InternetRepair.ObjectCode     AS Code
         , Object_InternetRepair.ValueData      AS Name
         , Object_InternetRepair.isErased       AS isErased
     FROM OBJECT AS Object_InternetRepair
     WHERE Object_InternetRepair.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_InternetRepair(integer, TVarChar) OWNER TO postgres;


------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.09.22                                                       *              
*/

-- ����
-- SELECT * FROM gpGet_Object_InternetRepair(0, '3')