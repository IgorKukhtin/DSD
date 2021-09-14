-- Function: gpGet_Object_PayrollTypeVIP()

DROP FUNCTION IF EXISTS gpGet_Object_PayrollTypeVIP(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PayrollTypeVIP(
    IN inId          Integer,       -- ���� ������� <>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ShortName TVarChar
             , PercentPhone TFloat, PercentOther TFloat
             , isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PayrollTypeVIP());
   
   IF inId < 0
   THEN
     RAISE EXCEPTION '������. ��������� ��������� �������  ���������.';
   END IF;

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_PayrollTypeVIP()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST ('' as TVarChar)  AS ShortName
           
           , CAST (Null as TFloat)  AS PercentPhone
           , CAST (Null as TFloat)  AS PercentOther 

           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY
       SELECT
             Object_PayrollTypeVIP.Id                       AS Id
           , Object_PayrollTypeVIP.ObjectCode               AS Code
           , Object_PayrollTypeVIP.ValueData                AS Name

           , ObjectString_ShortName.ValueData               AS ShortName


           , ObjectFloat_PercentPhone.ValueData             AS PercentPhone
           , ObjectFloat_PercentOther.ValueData             AS PercentOther 

           , Object_PayrollTypeVIP.isErased                 AS isErased

       FROM Object AS Object_PayrollTypeVIP

            LEFT JOIN ObjectFloat AS ObjectFloat_PercentPhone
                                  ON ObjectFloat_PercentPhone.ObjectId = Object_PayrollTypeVIP.Id
                                 AND ObjectFloat_PercentPhone.DescId = zc_ObjectFloat_PayrollTypeVIP_PercentPhone()

            LEFT JOIN ObjectFloat AS ObjectFloat_PercentOther
                                  ON ObjectFloat_PercentOther.ObjectId = Object_PayrollTypeVIP.Id
                                 AND ObjectFloat_PercentOther.DescId = zc_ObjectFloat_PayrollTypeVIP_PercentOther()

            LEFT JOIN ObjectString AS ObjectString_ShortName
                                   ON ObjectString_ShortName.ObjectId = Object_PayrollTypeVIP.Id 
                                  AND ObjectString_ShortName.DescId = zc_ObjectString_PayrollTypeVIP_ShortName()

       WHERE Object_PayrollTypeVIP.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.09.21                                                        *

*/

-- ����
-- SELECT * FROM gpGet_Object_PayrollTypeVIP (17737396 , '3')