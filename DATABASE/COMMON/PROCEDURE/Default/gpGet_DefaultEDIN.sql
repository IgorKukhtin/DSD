-- Function: gpGet_DefaultEDIN()

DROP FUNCTION IF EXISTS gpGet_DefaultEDIN(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_DefaultEDIN(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Host TVarChar
             , UserName TVarChar
             , Password TVarChar
             , GLN  TVarChar
             , GLN_Epicentr TVarChar)
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGLN TVarChar;
  DECLARE vbGLN_Epicentr TVarChar;
BEGIN

   vbGLN := '4823036500001';
   vbGLN_Epicentr := '9864066866014';

   RETURN QUERY
    SELECT  'https://edo-v2.edin.ua'    :: TVarChar AS Host
          , 'uaalan'                    :: TVarChar AS UserName
          , '337cd73a'                  :: TVarChar AS Password
          , vbGLN
          , vbGLN_Epicentr
           ;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_DefaultEDIN (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.06.24                                                       *
 07.05.23                                                       *
*/

-- ����
-- 
SELECT * FROM gpGet_DefaultEDIN (zfCalc_UserAdmin())