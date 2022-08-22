-- Function:  gpSelect_UkraineAlarm

DROP FUNCTION IF EXISTS gpSelect_UkraineAlarm (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_UkraineAlarm (
    IN inStartDate TDateTime,
    IN inEndDate TDateTime,
    IN inSession TVarChar
)
RETURNS TABLE (ID            Integer
             , regionId      Integer
             , regionName    TVarChar
             , startDate     TDateTime
             , endDate       TDateTime
             , alertType     TVarChar
             , Color_Calc    Integer
) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   -- ��� ���������...
   RETURN QUERY
   SELECT UkraineAlarm.ID
        , UkraineAlarm.regionId
        , CASE WHEN UkraineAlarm.regionId = 42 THEN '���������� �����'
               WHEN UkraineAlarm.regionId = 44 THEN '����������� �����'
               WHEN UkraineAlarm.regionId = 47 THEN 'ͳ����������� �����'
               WHEN UkraineAlarm.regionId = 332 THEN '�. ����� �� ���������� ������������ �������'
               WHEN UkraineAlarm.regionId = 351 THEN '�. ͳ������ �� ͳ���������� ������������ �������'
               WHEN UkraineAlarm.regionId = 300 THEN '�. ��������� �� ��������� ������������ �������'
               ELSE '��������������� �������' END::TVarChar
        , UkraineAlarm.startDate
        , UkraineAlarm.endDate
        , UkraineAlarm.alertType
        , CASE WHEN UkraineAlarm.endDate IS NULL THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc

   FROM UkraineAlarm
   WHERE UkraineAlarm.startDate >= inStartDate
     AND UkraineAlarm.startDate < inEndDate + INTERVAL '1 DAY';

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 15.04.18        *                                                                         *

*/

-- ����
-- 
select * from gpSelect_UkraineAlarm ('2022-08-01'::TDateTime, '2022-08-31'::TDateTime, '3');