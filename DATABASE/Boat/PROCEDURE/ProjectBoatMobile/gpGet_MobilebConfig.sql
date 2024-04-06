-- Function: gpGet_MobilebConfig()

DROP FUNCTION IF EXISTS gpGet_MobilebConfig (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MobilebConfig(
    IN inSession           TVarChar     -- ������ ������������
)
RETURNS TABLE (BarCodePref        TVarChar
             , ArticleSeparators  TVarChar  
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);
     
     -- ��������� �����
     RETURN QUERY
     SELECT zc_BarCodePref_Object()::TVarChar   AS BarCodePref
          , ' ,-'::TVarChar                     AS ArticleSeparators; 

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.04.24                                                       *
*/

-- ����
--
 select * from gpGet_MobilebConfig(inSession := '5');