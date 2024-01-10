-- Function: gpInsertUpdate_Movement_Loss()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Loss (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Loss (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Loss (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Loss(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Списания>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer   , -- Подразделение
    IN inArticleLossId       Integer   , -- Статьи списания
    IN inComment             TVarChar  , -- Примечание
    IN inConfirmedMarketing  TVarChar  , -- Комментарий маркетинга
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbCat_5  TFloat;
   DECLARE vbisCat_5 boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Loss());
     
     IF COALESCE (ioId, 0) <> 0 AND
        (COALESCE(inArticleLossId, 0) = 23653195) <>
        (COALESCE((SELECT MovementLinkObject_ArticleLoss.ObjectId
                   FROM MovementLinkObject AS MovementLinkObject_ArticleLoss
                   WHERE MovementLinkObject_ArticleLoss.MovementId = ioId
                     AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()), 0) = 23653195)
     THEN

        vbisCat_5 := inArticleLossId = 23653195;

        SELECT COALESCE(ObjectFloat_CashSettings_Cat_5.ValueData, 0)                                 AS Cat_5
        INTO vbCat_5
        FROM Object AS Object_CashSettings

             LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_Cat_5
                                   ON ObjectFloat_CashSettings_Cat_5.ObjectId = Object_CashSettings.Id 
                                  AND ObjectFloat_CashSettings_Cat_5.DescId = zc_ObjectFloat_CashSettings_Cat_5()

        WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
        LIMIT 1; 
    
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price()
                                                , MovementItemLoos.Id
                                                , CurrPRICE.Price)  
        FROM MovementItem AS MovementItemLoos
        
             INNER JOIN MovementItemFloat AS MIFloat_Price
                                          ON MIFloat_Price.MovementItemId = MovementItemLoos.Id
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()          

             INNER JOIN (SELECT Price_Goods.ChildObjectId               AS GoodsId
                              , CASE WHEN vbisCat_5 = TRUE
                                     THEN COALESCE (ObjectHistoryFloat_Price.ValueData * (100 - vbCat_5) / 100, 0)
                                     ELSE COALESCE (ObjectHistoryFloat_Price.ValueData, 0) END :: TFloat  AS Price
                         FROM ObjectLink AS ObjectLink_Price_Unit
                              INNER JOIN (SELECT DISTINCT tmpMI.ObjectId AS GoodsId 
                                          FROM MovementItem AS tmpMI
                                          WHERE tmpMI.MovementId = ioId
                                            AND tmpMI.DescId = zc_MI_Master()) tmpGoods ON 1 = 1
                              INNER JOIN ObjectLink AS Price_Goods
                                                    ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                                   AND Price_Goods.ChildObjectId = tmpGoods.GoodsId

                              -- получаем значения цены и НТЗ из истории значений на начало дня
                              LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                                      ON ObjectHistory_Price.ObjectId = Price_Goods.ObjectId
                                                     AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                     AND inOperDate >= ObjectHistory_Price.StartDate AND inOperDate < ObjectHistory_Price.EndDate
                              LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                           ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                          AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                         WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                           AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                        ) AS CurrPRICE ON CurrPRICE.GoodsId = MovementItemLoos.ObjectId

        WHERE MovementItemLoos.MovementId = ioId  
          AND MovementItemLoos.DescId = zc_MI_Master()
          AND COALESCE (MIFloat_Price.ValueData, 0) <> CurrPRICE.Price;
     
     END IF; 
	 
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_Loss (ioId                 := ioId
                                         , inInvNumber          := inInvNumber
                                         , inOperDate           := inOperDate
                                         , inUnitId             := inUnitId
                                         , inArticleLossId      := inArticleLossId
                                         , inComment            := inComment
                                         , inConfirmedMarketing := inConfirmedMarketing
                                         , inUserId             := vbUserId
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_Loss (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А..  Шаблий О.В.
 24.07.19                                                                                     *
 20.07.15                                                                      *
 */

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Loss (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inUnitId:= 1, inArticleLossId = 1, inComment = '', inSession:= '3')

