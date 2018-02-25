-- Function: gpSelect_Object_PeriodYear_Choice

DROP FUNCTION IF EXISTS gpSelect_Object_PeriodYear_Choice (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PeriodYear_Choice(
       IN inSession          TVarChar
)
RETURNS TABLE (Id Integer, Name TVarChar, PeriodYear Integer
              ) 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Partner());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY 
       SELECT tmp.PeriodYear             AS Id
            , tmp.PeriodYear :: TVarChar AS Name
            , tmp.PeriodYear :: Integer  AS PeriodYear
       FROM (SELECT DISTINCT ObjectFloat_PeriodYear.ValueData :: Integer AS PeriodYear
             FROM ObjectFloat AS ObjectFloat_PeriodYear 
             WHERE ObjectFloat_PeriodYear.DescId = zc_ObjectFloat_Partner_PeriodYear()
            UNION ALL
             SELECT 0 :: Integer AS PeriodYear
            ) AS tmp
       ORDER BY tmp.PeriodYear DESC
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 10.02.18         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_PeriodYear_Choice (zfCalc_UserAdmin())
