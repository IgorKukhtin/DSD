-- Function: gpSelect_Object_PayrollTypeVIP()

DROP FUNCTION IF EXISTS gpSelect_Object_PayrollTypeVIP(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PayrollTypeVIP(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , Code Integer, Name TVarChar
             , ShortName TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PayrollTypeVIP());

   RETURN QUERY
   SELECT
          Object_PayrollTypeVIP.Id             AS Id
        , Object_PayrollTypeVIP.ObjectCode     AS Code
        , Object_PayrollTypeVIP.ValueData      AS Name
        
        , ObjectString_ShortName.ValueData  AS ShortName

        , Object_PayrollTypeVIP.isErased       AS isErased
   FROM Object AS Object_PayrollTypeVIP

        LEFT JOIN ObjectString AS ObjectString_ShortName
                               ON ObjectString_ShortName.ObjectId = Object_PayrollTypeVIP.Id 
                              AND ObjectString_ShortName.DescId = zc_ObjectString_PayrollTypeVIP_ShortName()

   WHERE Object_PayrollTypeVIP.DescId = zc_Object_PayrollTypeVIP();

END;$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.09.21                                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_PayrollTypeVIP('3')