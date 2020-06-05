-- Function: gpGet_GoodsSearchRemainsVIP()

DROP FUNCTION IF EXISTS gpGet_GoodsSearchRemainsVIP (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_GoodsSearchRemainsVIP(
    IN inSession        TVarChar     -- ������ ������������
)
RETURNS TABLE (ID                  Integer
            , SummaUrgentlySendVIP TFloat
            , isBlockVIP           Boolean
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbSummaFormSendVIP TFloat;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
    SELECT Object_CashSettings.Id                                                          AS Id
         , COALESCE(ObjectFloat_CashSettings_SummaUrgentlySendVIP.ValueData, 0)::TFloat    AS SummaUrgentlySendVIP
         , COALESCE(ObjectBoolean_CashSettings_BlockVIP.ValueData, FALSE)           AS isBlockVIP
    FROM Object AS Object_CashSettings
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_SummaUrgentlySendVIP
                               ON ObjectFloat_CashSettings_SummaUrgentlySendVIP.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_SummaUrgentlySendVIP.DescId = zc_ObjectFloat_CashSettings_SummaUrgentlySendVIP()
         LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_BlockVIP
                                 ON ObjectBoolean_CashSettings_BlockVIP.ObjectId = Object_CashSettings.Id 
                                AND ObjectBoolean_CashSettings_BlockVIP.DescId = zc_ObjectBoolean_CashSettings_BlockVIP()
    WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
    LIMIT 1;
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.06.20                                                       *
*/

-- ����
-- select * from gpGet_GoodsSearchRemainsVIP(inSession := '3');
