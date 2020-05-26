-- Function: gpSelect_Object_DriverVIP()

DROP FUNCTION IF EXISTS gpSelect_Object_DriverVIP(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DriverVIP(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ChatIDSendVIP Integer) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());
   
   RETURN QUERY 
   SELECT Object_DriverSun.Id                        AS Id 
        , Object_DriverSun.ObjectCode                AS Code
        , Object_DriverSun.ValueData                 AS Name
        , DriverSun_ChatIDSendVIP.ValueData::Integer AS ChatIDSendVIP
   FROM Object AS Object_DriverSun
        LEFT JOIN ObjectFloat AS DriverSun_ChatIDSendVIP
                              ON DriverSun_ChatIDSendVIP.ObjectId = Object_DriverSun.Id 
                             AND DriverSun_ChatIDSendVIP.DescId = zc_ObjectFloat_DriverSun_ChatIDSendVIP()
   WHERE Object_DriverSun.DescId = zc_Object_DriverSun()
     AND Object_DriverSun.isErased = False
     AND COALESCE(DriverSun_ChatIDSendVIP.ValueData, 0) <> 0;   

END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_DriverVIP(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.08.19                                                       *
*/

-- ����
-- 
SELECT * FROM gpSelect_Object_DriverVIP('3')


