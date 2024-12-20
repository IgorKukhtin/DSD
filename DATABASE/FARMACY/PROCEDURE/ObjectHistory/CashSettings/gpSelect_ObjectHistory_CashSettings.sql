-- Function: gpSelect_ObjectHistory_CashSettings ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_CashSettings (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_CashSettings(
    IN inCashSettingsId    Integer   , -- �����
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, StartDate TDateTime, EndDate TDateTime
             , FixedPercent TFloat, FixedPercentB TFloat, FixedPercentC TFloat, FixedPercentD TFloat
             , PenMobApp TFloat, PrizeThreshold TFloat, MarkPlanThreshol TFloat, PercPlanMobileApp TFloat)
AS
$BODY$
BEGIN

    IF COALESCE(inCashSettingsId, 0) = 0
    THEN
      SELECT COALESCE(Object_CashSettings.Id, 0)
      INTO inCashSettingsId
      FROM Object AS Object_CashSettings
      WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
      LIMIT 1;
    END IF;

     -- �������� ������
    RETURN QUERY
        WITH ObjectHistory_CashSettings AS
        (
            SELECT 
                * 
            FROM 
                ObjectHistory
            WHERE 
                ObjectHistory.ObjectId = inCashSettingsId
                AND 
                ObjectHistory.DescId = zc_ObjectHistory_CashSettings()
        ),
        tmpObjectHistoryFloat AS (SELECT * 
                                  FROM ObjectHistoryFloat
                                  WHERE ObjectHistoryFloat.ObjectHistoryId IN (SELECT ObjectHistory_CashSettings.Id FROM ObjectHistory_CashSettings))
        SELECT
            ObjectHistory_CashSettings.Id                                   AS Id
          , ObjectHistory_CashSettings.StartDate                            AS StartDate
          , ObjectHistory_CashSettings.EndDate                              AS EndDate
          , ObjectHistoryFloat_CashSettings_FixedPercent.ValueData          AS FixedPercent
          , ObjectHistoryFloat_CashSettings_FixedPercentB.ValueData         AS FixedPercentB
          , ObjectHistoryFloat_CashSettings_FixedPercentC.ValueData         AS FixedPercentC
          , ObjectHistoryFloat_CashSettings_FixedPercentD.ValueData         AS FixedPercentD
          , ObjectHistoryFloat_CashSettings_PenMobApp.ValueData             AS PenMobApp
          , ObjectHistoryFloat_CashSettings_PrizeThreshold.ValueData        AS PrizeThreshold
          , ObjectHistoryFloat_CashSettings_MarkPlanThreshol.ValueData      AS MarkPlanThreshol
          , ObjectHistoryFloat_CashSettings_PercPlanMobileApp.ValueData     AS PercPlanMobileApp
        FROM 
            ObjectHistory_CashSettings

            LEFT JOIN tmpObjectHistoryFloat AS ObjectHistoryFloat_CashSettings_FixedPercent
                                            ON ObjectHistoryFloat_CashSettings_FixedPercent.ObjectHistoryId = ObjectHistory_CashSettings.Id
                                           AND ObjectHistoryFloat_CashSettings_FixedPercent.DescId = zc_ObjectHistoryFloat_CashSettings_FixedPercent()
            LEFT JOIN tmpObjectHistoryFloat AS ObjectHistoryFloat_CashSettings_FixedPercentB
                                            ON ObjectHistoryFloat_CashSettings_FixedPercentB.ObjectHistoryId = ObjectHistory_CashSettings.Id
                                           AND ObjectHistoryFloat_CashSettings_FixedPercentB.DescId = zc_ObjectHistoryFloat_CashSettings_FixedPercentB()
            LEFT JOIN tmpObjectHistoryFloat AS ObjectHistoryFloat_CashSettings_FixedPercentC
                                            ON ObjectHistoryFloat_CashSettings_FixedPercentC.ObjectHistoryId = ObjectHistory_CashSettings.Id
                                           AND ObjectHistoryFloat_CashSettings_FixedPercentC.DescId = zc_ObjectHistoryFloat_CashSettings_FixedPercentC()
            LEFT JOIN tmpObjectHistoryFloat AS ObjectHistoryFloat_CashSettings_FixedPercentD
                                            ON ObjectHistoryFloat_CashSettings_FixedPercentD.ObjectHistoryId = ObjectHistory_CashSettings.Id
                                           AND ObjectHistoryFloat_CashSettings_FixedPercentD.DescId = zc_ObjectHistoryFloat_CashSettings_FixedPercentD()

            LEFT JOIN tmpObjectHistoryFloat AS ObjectHistoryFloat_CashSettings_PenMobApp
                                            ON ObjectHistoryFloat_CashSettings_PenMobApp.ObjectHistoryId = ObjectHistory_CashSettings.Id
                                           AND ObjectHistoryFloat_CashSettings_PenMobApp.DescId = zc_ObjectHistoryFloat_CashSettings_PenMobApp()
                                           
            LEFT JOIN tmpObjectHistoryFloat AS ObjectHistoryFloat_CashSettings_PrizeThreshold
                                            ON ObjectHistoryFloat_CashSettings_PrizeThreshold.ObjectHistoryId = ObjectHistory_CashSettings.Id
                                           AND ObjectHistoryFloat_CashSettings_PrizeThreshold.DescId = zc_ObjectHistoryFloat_CashSettings_PrizeThreshold()
                                           
            LEFT JOIN tmpObjectHistoryFloat AS ObjectHistoryFloat_CashSettings_MarkPlanThreshol
                                            ON ObjectHistoryFloat_CashSettings_MarkPlanThreshol.ObjectHistoryId = ObjectHistory_CashSettings.Id
                                           AND ObjectHistoryFloat_CashSettings_MarkPlanThreshol.DescId = zc_ObjectHistoryFloat_CashSettings_MarkPlanThreshol()

            LEFT JOIN tmpObjectHistoryFloat AS ObjectHistoryFloat_CashSettings_PercPlanMobileApp
                                            ON ObjectHistoryFloat_CashSettings_PercPlanMobileApp.ObjectHistoryId = ObjectHistory_CashSettings.Id
                                           AND ObjectHistoryFloat_CashSettings_PercPlanMobileApp.DescId = zc_ObjectHistoryFloat_CashSettings_PercPlanMobileApp()

        ORDER BY ObjectHistory_CashSettings.StartDate;


END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_ObjectHistory_CashSettings (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.06.21                                                       *

*/

-- ����
-- SELECT * FROM gpSelect_ObjectHistory_CashSettings (0, '')

select * from gpSelect_ObjectHistory_CashSettings(inCashSettingsId := 0 ,  inSession := '3');