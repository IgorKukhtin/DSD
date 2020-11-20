-- Function: gpGet_Object_AmbulantClinicSP (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_AmbulantClinicSP (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_AmbulantClinicSP(
    IN inId          Integer,       -- ������ ������� 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar)
AS
$BODY$
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_AmbulantClinicSP()) AS Code
           , CAST ('' as TVarChar)  AS Name;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_AmbulantClinicSP.Id            AS Id
           , Object_AmbulantClinicSP.ObjectCode    AS Code
           , Object_AmbulantClinicSP.ValueData     AS Name
       FROM OBJECT AS Object_AmbulantClinicSP
       WHERE Object_AmbulantClinicSP.Id = inId;
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_AmbulantClinicSP (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.11.20                                                       *

*/

-- ����
-- SELECT * FROM gpGet_Object_AmbulantClinicSP(0,'3')