-- Function: gpFarmacy_Scheduler()

DROP FUNCTION IF EXISTS gpFarmacy_Scheduler(TVarChar);

CREATE OR REPLACE FUNCTION gpFarmacy_Scheduler(
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 Text;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;

    IF COALESCE((SELECT count(*) as CountProc
                 FROM pg_stat_activity
                 WHERE state = 'active'
                   AND query ilike '%gpFarmacy_Scheduler%'), 0) > 1
    THEN
      Return;
    END IF;

    -- �������� ����������� ����������
    BEGIN
       PERFORM gpInsertUpdate_Movement_TechnicalRediscount_Formation (inSession := zfCalc_UserAdmin());
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpInsertUpdate_Movement_TechnicalRediscount_Formation', True, text_var1::TVarChar, vbUserId);
    END;

    -- ��������� �������� ������ � ������� ����������
    BEGIN
      UPDATE Object_Goods_Juridical SET GoodsMainId = tmpLink.GoodsMainId
      FROM (select Max(ObjectLink_LinkGoods_Main_jur.ChildObjectId)  AS GoodsMainId
                            , ObjectLink_LinkGoods_Child_jur.ChildObjectId AS GoodsId
                       from  ObjectLink AS ObjectLink_LinkGoods_Main_jur

                             INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Child_jur
                                                   ON ObjectLink_LinkGoods_Child_jur.ObjectId = ObjectLink_LinkGoods_Main_jur.ObjectId
                                                  AND ObjectLink_LinkGoods_Child_jur.DescId = zc_ObjectLink_LinkGoods_Goods()

                             INNER JOIN ObjectLink AS ObjectLink_Goods_Object_jur
                                                   ON ObjectLink_Goods_Object_jur.ObjectId = ObjectLink_LinkGoods_Child_jur.ChildObjectId
                                                  AND ObjectLink_Goods_Object_jur.DescId = zc_ObjectLink_Goods_Object()

                             INNER JOIN Object ON Object.Id =ObjectLink_Goods_Object_jur.ChildObjectId
                                              AND Object.DescId = zc_Object_Juridical()

                       where ObjectLink_LinkGoods_Main_jur.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                       group by ObjectLink_LinkGoods_Child_jur.ChildObjectId) AS tmpLink
      WHERE Object_Goods_Juridical.ID = tmpLink.GoodsId
        AND COALESCE (Object_Goods_Juridical.GoodsMainId, 0) = 0;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run UPDATE Object_Goods_Juridical', True, text_var1::TVarChar, vbUserId);
    END;

    -- ���������� ��������
    BEGIN
      IF date_part('DAY',  CURRENT_DATE)::Integer IN (1, 2) AND date_part('HOUR',  CURRENT_TIME)::Integer = 6
      THEN
         PERFORM gpSelect_Calculation_MoneyBoxSun (inUnitID := 0, inSession := zfCalc_UserAdmin());
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpSelect_Calculation_MoneyBoxSun', True, text_var1::TVarChar, vbUserId);
    END;

    -- ���������� �����
    BEGIN
      IF date_part('HOUR',  CURRENT_TIME)::Integer = '6' AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 30
      THEN
         PERFORM gpSelect_Calculation_Retail_Fund (inSession := zfCalc_UserAdmin());
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpSelect_Calculation_Unit_Fund', True, text_var1::TVarChar, vbUserId);
    END;

    -- �������� ������� ��������
    BEGIN
      IF CURRENT_DATE = date_trunc('month', CURRENT_DATE) + INTERVAL '1 MONTH' - INTERVAL '1 DAY' AND date_part('HOUR',  CURRENT_TIME)::Integer = 21
         AND NOT EXISTS(SELECT 1 FROM Movement
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                                           ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                                          AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()    
                        WHERE Movement.OperDate  = CURRENT_DATE
                          AND Movement.DescId = zc_Movement_Loss()
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                          AND COALESCE(MovementLinkObject_ArticleLoss.ObjectId, 0) = 13892113)
      THEN
         PERFORM grInsert_Movement_LossOverdue (inSession := zfCalc_UserAdmin());
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run grInsert_Movement_LossOverdue', True, text_var1::TVarChar, vbUserId);
    END;

    -- �������� ������ ���������� VIP �����������
    BEGIN
       PERFORM gpSetErased_Movement_Send(Movement.id, zfCalc_UserAdmin())
       FROM Movement
            INNER JOIN MovementBoolean AS MovementBoolean_VIP
                                       ON MovementBoolean_VIP.MovementId = Movement.Id
                                      AND MovementBoolean_VIP.DescId = zc_MovementBoolean_VIP()

            INNER JOIN MovementBoolean AS MovementBoolean_Confirmed
                                       ON MovementBoolean_Confirmed.MovementId = Movement.Id
                                      AND MovementBoolean_Confirmed.DescId = zc_MovementBoolean_Confirmed()

            LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                      ON MovementBoolean_Deferred.MovementId = Movement.Id
                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
       WHERE Movement.DescId = zc_Movement_Send()
         AND Movement.StatusId = zc_Enum_Status_UnComplete()
         AND Movement.OperDate < CURRENT_DATE
         AND COALESCE (MovementBoolean_VIP.ValueData, FALSE) = TRUE
         AND COALESCE (MovementBoolean_Confirmed.ValueData, FALSE) = FALSE      
         AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE; 
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run SetErased_Movement_Send_VIP', True, text_var1::TVarChar, vbUserId);
    END;

    -- ����������� ������� ����
    BEGIN
      IF date_part('HOUR',  CURRENT_TIME)::Integer = '6' AND date_part('MINUTE',  CURRENT_TIME)::Integer > 30
      THEN
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_FirstCheck(), tmpMovementCheck.UnitId, tmpMovementCheck.OperDate)
         FROM (SELECT AnalysisContainerItem.UnitId 
                    , MIN(AnalysisContainerItem.OperDate)    AS OperDate
               FROM AnalysisContainerItem
               WHERE AnalysisContainerItem.AmountCheck > 0
               GROUP BY AnalysisContainerItem.UnitId) AS tmpMovementCheck;
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run FirstCheck', True, text_var1::TVarChar, vbUserId);
    END;

    -- ������ ��� ����� �� ���, ������ � �����������
    BEGIN
      PERFORM gpUpdate_MovementItem_DeferredLincObject (inSession := zfCalc_UserAdmin());
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpUpdate_MovementItem_DeferredLincObject', True, text_var1::TVarChar, vbUserId);
    END;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.03.20                                                       * add gpInsertUpdate_Movement_TechnicalRediscount_Formation
 15.02.20                                                       *
*/

-- SELECT * FROM Log_Run_Schedule_Function order by Log_Run_Schedule_Function.DateInsert desc
-- SELECT * FROM gpFarmacy_Scheduler (inSession := zfCalc_UserAdmin())

