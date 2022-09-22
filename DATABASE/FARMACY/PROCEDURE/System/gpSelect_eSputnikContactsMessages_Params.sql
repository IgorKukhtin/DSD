-- Function:  gpSelect_eSputnikContactsMessages_Params

DROP FUNCTION IF EXISTS gpSelect_eSputnikContactsMessages_Params (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_eSputnikContactsMessages_Params (
    IN inSession TVarChar
)
RETURNS TABLE (DataStart     TDateTime
             , DataEnd       TDateTime
             , UserName      TVarChar
             , Password      TVarChar
) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   -- ��� ���������...
   RETURN QUERY
   SELECT (CURRENT_DATE - INTERVAL '1 MONTH')::TDateTime
        , CURRENT_DATE::TDateTime
        , 'info@neboley.dp.ua'::TVarChar
        , 'Max1256937841'::TVarChar;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.09.22                                                       *

*/

-- ����
-- 
select * from gpSelect_eSputnikContactsMessages_Params ('3');