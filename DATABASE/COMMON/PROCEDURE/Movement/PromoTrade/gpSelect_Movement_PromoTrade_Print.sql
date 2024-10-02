-- Function: gpSelect_Movement_PromoTrade_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_PromoTrade_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PromoTrade_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE Cursor3 refcursor;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PromoTrade());
     vbUserId:= lpGetUserBySession (inSession);


     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
            INTO vbDescId, vbStatusId, vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId;

  /*
     -- очень важная проверка
     IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete() AND vbUserId <> 5 -- !!!кроме Админа!!!
     THEN
         IF vbStatusId = zc_Enum_Status_Erased()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         IF vbStatusId = zc_Enum_Status_UnComplete()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         -- это уже странная ошибка
         RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
     END IF;
  */
    --
    CREATE TEMP TABLE _tmpMI ON COMMIT DROP AS
      SELECT tmp.*
      FROM gpSelect_MovementItem_PromoTradeGoods (inMovementId, FALSE, inSession) AS tmp;
    --
    CREATE TEMP TABLE _tmpHistory ON COMMIT DROP AS
      SELECT SUM (COALESCE (MF_AmountSale.ValueData,0))     AS AmountSale
           , SUM (COALESCE (MF_AmountReturnIn.ValueData,0)) AS AmountReturnIn
           , SUM (COALESCE (MF_SummSale.ValueData,0))       AS SummSale
           , SUM (COALESCE (MovementFloat_DebtSumm.ValueData,0)) AS DebtSumm
      FROM Movement
           LEFT JOIN MovementFloat AS MF_AmountSale
                                   ON MF_AmountSale.MovementId = Movement.Id
                                  AND MF_AmountSale.DescId = zc_MovementFloat_AmountSale()
           LEFT JOIN MovementFloat AS MF_SummSale
                                   ON MF_SummSale.MovementId = Movement.Id
                                  AND MF_SummSale.DescId = zc_MovementFloat_SummSale()
           LEFT JOIN MovementFloat AS MF_AmountReturnIn
                                   ON MF_AmountReturnIn.MovementId = Movement.Id
                                  AND MF_AmountReturnIn.DescId = zc_MovementFloat_AmountReturnIn()
           LEFT JOIN MovementFloat AS MovementFloat_DebtSumm 
                                   ON MovementFloat_DebtSumm.MovementId =  Movement.Id
                                  AND MovementFloat_DebtSumm.DescId = zc_MovementFloat_DebtSumm()
      WHERE Movement.DescId = zc_Movement_PromoTradeHistory()
        AND Movement.ParentId = inMovementId;

     --               
     OPEN Cursor1 FOR
      WITH
       tmpMovement AS (SELECT tmp.*
                       FROM  gpGet_Movement_PromoTrade (inMovementId, vbOperDate, FALSE, inSession) AS tmp
                       )

        SELECT
            1 ::Integer AS LineNo,
            'Мережа'::TVarChar as LineName,
            (SELECT tmpMovement.RetailName
             FROM tmpMovement)::TEXT AS LineValue
        UNION ALL
        SELECT
            2 ::Integer AS LineNo,
            'Юридична особа'::TVarChar as LineName,
            (SELECT tmpMovement.JuridicalName
             FROM tmpMovement)::TEXT AS LineValue
        UNION ALL
        SELECT
            3 ::Integer AS LineNo,
            'Вартість участі, грн'::TVarChar as LineName,
            (SELECT tmpMovement.CostPromo
             FROM tmpMovement)::TEXT AS LineValue
        UNION ALL
        SELECT
            4 ::Integer AS LineNo,
            'Період участі'::TVarChar as LineName,
            (SELECT TO_CHAR(tmpMovement.StartPromo, 'DD.MM.YYYY')||' - '||TO_CHAR(tmpMovement.EndPromo, 'DD.MM.YYYY')
             FROM tmpMovement)::TEXT AS LineValue
        UNION ALL
        SELECT
            5 ::Integer AS LineNo,
            'Умови участі'::TVarChar as LineName,
            (SELECT tmpMovement.PromoKindName
             FROM tmpMovement)::TEXT AS LineValue
        UNION ALL
        SELECT
            6 ::Integer AS LineNo,
            'Кількість SKU'::TVarChar as LineName,
            (SELECT COUNT(DISTINCT _tmpMI.GoodsCode) 
             FROM _tmpMI)::TEXT AS LineValue
        UNION ALL
        SELECT
            7 ::Integer AS LineNo,
            'Кількість торгових точок'::TVarChar as LineName,
            (SELECT SUM (COALESCE (tmp.PartnerCount,0))
             FROM (SELECT SUM (_tmpMI.PartnerCount) AS PartnerCount FROM _tmpMI WHERE COALESCE (_tmpMI.PartnerId,0) = 0 
                 UNION 
                   SELECT COUNT ( DISTINCT _tmpMI.PartnerId) AS PartnerCount FROM _tmpMI WHERE COALESCE (_tmpMI.PartnerId,0) <> 0
                  ) AS tmp
             )::TEXT AS LineValue
        UNION ALL
        SELECT
            8 ::Integer AS LineNo,
            'Торгова марка'::TVarChar as LineName,
            (SELECT STRING_AGG (DISTINCT CASE WHEN _tmpMI.TradeMarkName <> '' THEN _tmpMI.TradeMarkName || ' ' ELSE '' END , chr(13)) 
             FROM _tmpMI)::TEXT AS LineValue
        UNION ALL
        SELECT
            9 ::Integer AS LineNo,
            'Асортимент'::TVarChar as LineName,
            'додається'::TEXT AS LineValue
        UNION ALL
        SELECT
            10 ::Integer AS LineNo,
            'Плановий об''єм продажів в місяць, кг'::TVarChar as LineName,
            (SELECT CAST (SUM (_tmpMI.AmountPlan) AS NUMERIC (16,2))
             FROM _tmpMI)::TEXT AS LineValue
        UNION ALL
        SELECT
            11 ::Integer AS LineNo,
            'Плановий об''єм продажів в місяць, грн'::TVarChar as LineName,
            (SELECT CAST (SUM (_tmpMI.SummWithVATPlan) AS NUMERIC (16,2))
             FROM _tmpMI)::TEXT AS LineValue
        UNION ALL
        SELECT
            12 ::Integer AS LineNo,
            'Період окупності'::TVarChar as LineName,
            '' :: TEXT AS LineValue
        UNION ALL
        SELECT
            13 ::Integer AS LineNo,
            'Фактичний об''єм продажів в місяць, кг'::TVarChar as LineName,
            (SELECT CAST (SUM (_tmpHistory.AmountSale / 3) AS NUMERIC (16,2))
             FROM _tmpHistory)::TEXT AS LineValue
        UNION ALL
        SELECT
            14 ::Integer AS LineNo,
            'Фактичний об''єм продажів в місяць, грн'::TVarChar as LineName,
            (SELECT CAST (SUM (_tmpHistory.SummSale / 3) AS NUMERIC (16,2))
             FROM _tmpHistory)::TEXT AS LineValue
        UNION ALL
        SELECT
            15 ::Integer AS LineNo,
            '% повернень'::TVarChar as LineName,
            (SELECT CAST (CASE WHEN COALESCE (_tmpHistory.AmountSale,0) <> 0 THEN _tmpHistory.AmountReturnIn * 100 / _tmpHistory.AmountSale ELSE 0 END AS NUMERIC (16,1))
             FROM _tmpHistory)::TEXT AS LineValue
        UNION ALL
        SELECT
            16 ::Integer AS LineNo,
            'Просрочена дебіторська заборгованність, грн'::TVarChar as LineName,
            (SELECT CAST (_tmpHistory.DebtSumm AS NUMERIC (16,2))
             FROM _tmpHistory)::TEXT AS LineValue
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
       WITH
       tmpGoodsQuality AS (SELECT ObjectLink_Goods.ChildObjectId AS GoodsId
                                , CAST (CASE WHEN POSITION( 'год' IN ObjectString_Value2.ValueData) > 0 THEN CAST(LEFT (ObjectString_Value2.ValueData,POSITION( 'год' IN ObjectString_Value2.ValueData)-1 ) AS NUMERIC (16,0) ) / 24
                                             WHEN POSITION( 'діб' IN ObjectString_Value2.ValueData) > 0 THEN CAST(LEFT (ObjectString_Value2.ValueData,POSITION( 'діб' IN ObjectString_Value2.ValueData)-1 ) AS NUMERIC (16,0) )
                                             WHEN POSITION( 'доб' IN ObjectString_Value2.ValueData) > 0 THEN CAST(LEFT (ObjectString_Value2.ValueData,POSITION( 'доб' IN ObjectString_Value2.ValueData)-1 ) AS NUMERIC (16,0) )
                                             WHEN POSITION( 'міс' IN ObjectString_Value2.ValueData) > 0 THEN CAST(LEFT (ObjectString_Value2.ValueData,POSITION( 'міс' IN ObjectString_Value2.ValueData)-1 ) AS NUMERIC (16,0) ) * 30
                                             WHEN POSITION( 'рок' IN ObjectString_Value2.ValueData) > 0 THEN CAST(LEFT (ObjectString_Value2.ValueData,POSITION( 'рок' IN ObjectString_Value2.ValueData)-1 ) AS NUMERIC (16,0) ) * 364
                                        ELSE 0
                                        END AS NUMERIC (16,0) ) + 1 AS Value2   -- срок хранения в днях
                           FROM ObjectBoolean AS ObjectBoolean_Klipsa
                                INNER JOIN Object AS Object_GoodsQuality 
                                                  ON Object_GoodsQuality.Id = ObjectBoolean_Klipsa.ObjectId
                                                 AND Object_GoodsQuality.isErased = FALSE
                                LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                     ON ObjectLink_Goods.ObjectId = ObjectBoolean_Klipsa.ObjectId
                                                    AND ObjectLink_Goods.DescId = zc_ObjectLink_GoodsQuality_Goods()

                                LEFT JOIN ObjectString AS ObjectString_Value2
                                                       ON ObjectString_Value2.ObjectId = Object_GoodsQuality.Id 
                                                      AND ObjectString_Value2.DescId = zc_ObjectString_GoodsQuality_Value2()
                           WHERE ObjectBoolean_Klipsa.DescId = zc_ObjectBoolean_GoodsQuality_Klipsa()
                             AND ObjectBoolean_Klipsa.ValueData = TRUE
                           )

       SELECT tmpMI.Ord     
            , Object_GoodsGroup.ValueData AS GoodsGroupName
            , tmpMI.TradeMarkName 
            , tmpMI.GoodsCode
            , tmpMI.GoodsName
            , tmpMI.GoodsKindName
            , tmpMI.MeasureName
            , tmpMI.Amount
            , tmpMI.Summ
       FROM _tmpMI AS tmpMI
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
       WHERE COALESCE (tmpMI.GoodsId,0) <> 0 OR COALESCE (tmpMI.TradeMarkId,0) <> 0
       ;
    RETURN NEXT Cursor2;

     OPEN Cursor3 FOR
      WITH
       tmpSign AS (SELECT tmp.*
                       FROM  gpSelect_Movement_PromoTradeSign (inMovementId, inSession) AS tmp
                       )

        SELECT
            (SELECT tmpSign.Value FROM tmpSign WHERE tmpSign.Ord = 1) ::TVarChar AS UserName
          , (SELECT tmpSign.Value FROM tmpSign WHERE tmpSign.Ord = 2) ::TVarChar AS MemberName1
          , (SELECT tmpSign.Value FROM tmpSign WHERE tmpSign.Ord = 3) ::TVarChar AS MemberName2
          , (SELECT tmpSign.Value FROM tmpSign WHERE tmpSign.Ord = 4) ::TVarChar AS MemberName3
          , (SELECT tmpSign.Value FROM tmpSign WHERE tmpSign.Ord = 5) ::TVarChar AS MemberName4
          , (SELECT tmpSign.Value FROM tmpSign WHERE tmpSign.Ord = 6) ::TVarChar AS MemberName5
          , (SELECT tmpSign.Value FROM tmpSign WHERE tmpSign.Ord = 7) ::TVarChar AS MemberName6
      ;
    RETURN NEXT Cursor3;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.09.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_PromoTrade_Print (inMovementId := 29301131, inSession:= zfCalc_UserAdmin())
