-- Function: lfGet_Object_Status ()

-- DROP FUNCTION lfGet_Object_Status (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_Status(inStatusId Integer)

RETURNS TABLE (Code Integer, Name TVarChar)
AS
$BODY$
BEGIN
                                             
     -- �������� ������ � �������
     RETURN QUERY 
       SELECT 
             Object_Status.ObjectCode    AS Code
           , Object_Status.ValueData     AS Name
       FROM Object AS Object_Status
       WHERE Object_Status.Id = inStatusId;

END;
$BODY$

LANGUAGE PLPGSQL IMMUTABLE;                  
ALTER FUNCTION lfGet_Object_Status (Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.09.13                         *
*/

-- ����
-- SELECT * FROM lfGet_Object_Status(zc_Enum_Status_UnComplete())
