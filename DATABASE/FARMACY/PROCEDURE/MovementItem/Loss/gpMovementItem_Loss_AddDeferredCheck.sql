-- Function: gpMovementItem_Loss_AddDeferredCheck

DROP FUNCTION IF EXISTS gpMovementItem_Loss_AddDeferredCheck (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Loss_AddDeferredCheck(
    IN inMovementId       Integer,   -- Списание
    IN inCheckID          Integer,   -- Чек
    IN inSession          TVarChar  -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbComent TVarChar;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbCat_5  TFloat;
   DECLARE vbisCat_5 boolean;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inMovementId, 0) = 0
    THEN
      RAISE EXCEPTION 'Документ не созранен.';
    END IF;


    SELECT Format('Чек %s от %s кол-во %s сумма %s покупатель %s'
         , Movement_Check.InvNumber
         , TO_CHAR (Movement_Check.OperDate, 'dd.mm.yyyy')
         , Movement_Check.TotalCount
         , Movement_Check.TotalSumm
         , COALESCE (Object_BuyerForSite.ValueData, MovementString_Bayer.ValueData , ''))
    INTO vbComent
    FROM Movement_Check_View AS Movement_Check
	     LEFT JOIN MovementString AS MovementString_Bayer
                                      ON MovementString_Bayer.MovementId = Movement_Check.Id
                                     AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                      ON MovementLinkObject_BuyerForSite.MovementId = Movement_Check.Id
                                     AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
         LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
    WHERE Movement_Check.Id = inCheckID;

    -- сохранили <Примечание>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), inMovementId, vbComent);
    
    --Определили подразделение для розничной цены и дату для остатка
    SELECT MovementLinkObject_Unit.ObjectId
         , Movement_Loss.OperDate 
         , MovementLinkObject_ArticleLoss.ObjectId = 23653195
    INTO vbUnitId, vbOperDate, vbisCat_5
    FROM Movement AS Movement_Loss
        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement_Loss.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                     ON MovementLinkObject_ArticleLoss.MovementId = Movement_Loss.Id
                                    AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
    WHERE Movement_Loss.Id = inMovementId;
    

    SELECT COALESCE(ObjectFloat_CashSettings_Cat_5.ValueData, 0)                                 AS Cat_5
    INTO vbCat_5
    FROM Object AS Object_CashSettings

         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_Cat_5
                               ON ObjectFloat_CashSettings_Cat_5.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_Cat_5.DescId = zc_ObjectFloat_CashSettings_Cat_5()

    WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
    LIMIT 1;    
    
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price()
                                            , lpInsertUpdate_MovementItem_Loss (ioId                 := COALESCE(MovementItemLoos.Id,0)
                                                                              , inMovementId         := inMovementId
                                                                              , inGoodsId            := MovementItemCheck.ObjectId
                                                                              , inAmount             := MovementItemCheck.Amount
                                                                              , inUserId             := vbUserId)
                                            , MovementItemCheck.Price)  
    FROM (WITH CurrPRICE AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                                  , CASE WHEN vbisCat_5 = TRUE
                                         THEN COALESCE (ObjectHistoryFloat_Price.ValueData * (100 - vbCat_5) / 100, 0)
                                         ELSE COALESCE (ObjectHistoryFloat_Price.ValueData, 0) END :: TFloat  AS Price
                             FROM ObjectLink AS ObjectLink_Price_Unit
                                  INNER JOIN (SELECT DISTINCT tmpMI.ObjectId AS GoodsId 
                                              FROM MovementItem AS tmpMI
                                              WHERE tmpMI.MovementId = inCheckID
                                                AND tmpMI.IsErased = False
                                                AND tmpMI.DescId = zc_MI_Master()) tmpGoods ON 1 = 1
                                  INNER JOIN ObjectLink AS Price_Goods
                                                        ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                       AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                                       AND Price_Goods.ChildObjectId = tmpGoods.GoodsId

                                  -- получаем значения цены и НТЗ из истории значений на начало дня
                                  LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                                          ON ObjectHistory_Price.ObjectId = Price_Goods.ObjectId
                                                         AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                         AND vbOperDate >= ObjectHistory_Price.StartDate AND vbOperDate < ObjectHistory_Price.EndDate
                                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                               ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                              AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                             WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                               AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                            )
    
          SELECT MovementItemCheck.ObjectId
               , SUM(MovementItemCheck.Amount)  AS Amount
               , CASE WHEN vbisCat_5 = TRUE AND COALESCE(MAX(CurrPRICE.Price), 0) > 0
                      THEN MAX(CurrPRICE.Price)
                      ELSE MAX(MIFloat_Price.ValueData) END AS Price
          FROM MovementItem AS MovementItemCheck
               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                           ON MIFloat_Price.MovementItemId = MovementItemCheck.Id
                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()          
               LEFT JOIN CurrPRICE ON CurrPRICE.GoodsId = MovementItemCheck.ObjectId
          WHERE MovementItemCheck.MovementId = inCheckID
          AND MovementItemCheck.IsErased = False
          AND MovementItemCheck.DescId = zc_MI_Master()
          GROUP BY MovementItemCheck.ObjectId) AS MovementItemCheck

         LEFT OUTER JOIN MovementItem AS MovementItemLoos
                                      ON MovementItemLoos.MovementId = inMovementId  
                                     AND MovementItemLoos.ObjectId = MovementItemCheck.ObjectId 
                                     AND MovementItemLoos.DescId = zc_MI_Master();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.04.21                                                       * add BuyerForSite
 19.07.19                                                       *
*/

-- тест
-- select * from gpMovementItem_Loss_AddDeferredCheck(inMovementId := 34457829 , inCheckID := 34458058 ,  inSession := '3');