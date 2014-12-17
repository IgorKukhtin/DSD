-- Function: gpGet_Object_City()

DROP FUNCTION IF EXISTS gpGet_OrderExternal_ExportParam(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OrderExternal_ExportParam(
    IN inMovementId  Integer,       -- ���� ������� <������>
    IN inSession     TVarChar       -- ������ ������������
)

RETURNS TABLE (DefaultFileName TVarChar) AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMail TVarChar;
  DECLARE vbUserMail TVarChar;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId := lpGetUserBySession (inSession);


       RETURN QUERY
       SELECT
         'el_zakaz'::TVarChar;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_OrderExternal_ExportParam(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.12.14                         *  

*/

-- ����
-- SELECT * FROM gpGet_Object_City (0, '2')