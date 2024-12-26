-- Function: gpGet_MI_WeighingPartner_ActDiff_Edit (Integer, TVarChar)

-- DROP FUNCTION IF EXISTS gpGet_MI_WeighingPartner_ActDiff_Edit (Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_WeighingPartner_ActDiff_Edit (Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_WeighingPartner_ActDiff_Edit(
    IN inMovementId        Integer  , -- ключ Документа
    IN inId                Integer  , -- 1.Взвешивание - док поставщика
    IN inId_check          Integer  , -- идентификатор строки
    IN inGoodsId           Integer  ,
    IN inGoodsKindId       Integer  ,
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumberPartner TVarChar, OperDate TDateTime, OperDatePartner TDateTime
             , GoodsId Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName TVarChar
             , AmountPartnerSecond TFloat
             , PricePartner TFloat
             , SummPartner  TFloat
             , isPriceWithVAT Boolean
             , isAmountPartnerSecond Boolean
             , isReturnOut Boolean
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId     Integer;
   DECLARE vbCount  Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);


     -- Проверка
     IF inId_check > 0 AND COALESCE (inId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Перейдите в режим "Показать весь список".';
     END IF;

     IF inId >0
     THEN
         -- пробуем найти строку  по ключю MovementId + GoodsId + GoodsKindId
         SELECT MAX (MovementItem.Id) AS Id
              , COUNT (*) AS Count
                INTO vbId, vbCount
         FROM MovementItem
              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     = zc_MI_Master()
           AND MovementItem.isErased   = FALSE
           AND MovementItem.ObjectId   = inGoodsId
           AND MovementItem.Id         = inId
          ;

     ELSE
         -- пробуем найти строку  по ключю MovementId + GoodsId + GoodsKindId
         SELECT MAX (MovementItem.Id) AS Id
              , COUNT (*) AS Count
                INTO vbId, vbCount
         FROM MovementItem
              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId = zc_MI_Master()
           AND MovementItem.isErased = FALSE
           AND MovementItem.ObjectId = inGoodsId
           AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = COALESCE (inGoodsKindId, 0)
          ;

     END IF;

    -- если нашли больше 1 строки - ошибка
    IF vbCount > 1
    THEN
        RAISE EXCEPTION 'Ошибка.Найдено больше одной строки для редактирования.';
    END IF;


    -- Результат
    RETURN QUERY
        WITH
        tmpMI_Float AS (SELECT MovementItemFloat.*
                        FROM MovementItemFloat
                        WHERE MovementItemFloat.MovementItemId = vbId
                          AND MovementItemFloat.DescId IN (zc_MIFloat_PricePartner()
                                                         , zc_MIFloat_AmountPartnerSecond()
                                                         , zc_MIFloat_SummPartner())
                       )
      , tmpMI_Boolean AS (SELECT MovementItemBoolean.*
                          FROM MovementItemBoolean
                          WHERE MovementItemBoolean.MovementItemId = vbId
                            AND MovementItemBoolean.DescId IN (zc_MIBoolean_AmountPartnerSecond()
                                                             , zc_MIBoolean_PriceWithVAT()
                                                             , zc_MIBoolean_ReturnOut()
                                                             )
                         )

      , tmpMI_String AS (SELECT MovementItemString.*
                         FROM MovementItemString
                         WHERE MovementItemString.MovementItemId = vbId
                           AND MovementItemString.DescId IN (zc_MIString_Comment()
                                                            )
                         )

        SELECT vbId AS Id
             , Movement.InvNumber
             , MovementString_InvNumberPartner.ValueData  ::TVarChar AS InvNumberPartner
             , Movement.OperDate
             , MovementDate_OperDatePartner.ValueData    ::TDateTime AS OperDatePartner

             , Object_Goods.Id                  AS GoodsId
             , ('('||Object_Goods.ObjectCode||') '||Object_Goods.ValueData) ::TVarChar   AS GoodsName
             , Object_GoodsKind.Id              AS GoodsKindId
             , Object_GoodsKind.ValueData       AS GoodsKindName

               -- Количество Поставщика - Документ Поставщика
             , COALESCE (MIFloat_AmountPartnerSecond.ValueData, 0) ::TFloat AS AmountPartnerSecond
               --цена поставщика
             ,  COALESCE (MIFloat_PricePartner.ValueData, 0)       ::TFloat AS PricePartner
               -- Сумма Поставщика
             , COALESCE (MIFloat_SummPartner.ValueData, 0)         ::TFloat AS SummPartner
               -- Цена/Сумма с НДС (да/нет)
             , COALESCE (MIBoolean_PriceWithVAT.ValueData, FALSE)        :: Boolean AS isPriceWithVAT
               -- Признак "без оплаты"
             , COALESCE (MIBoolean_AmountPartnerSecond.ValueData, FALSE) :: Boolean AS isAmountPartnerSecond
               -- Возврат да/нет
             , COALESCE (MIBoolean_ReturnOut.ValueData, FALSE)           :: Boolean AS isReturnOut
               --
             , COALESCE (MIString_Comment.ValueData,'')                  :: TVarChar AS Comment

        FROM Movement
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId     = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = inGoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = inGoodsKindId
            -- Признак "без оплаты"
            LEFT JOIN tmpMI_Boolean AS MIBoolean_AmountPartnerSecond
                                    ON MIBoolean_AmountPartnerSecond.MovementItemId = vbId
                                   AND MIBoolean_AmountPartnerSecond.DescId         = zc_MIBoolean_AmountPartnerSecond()
            -- Цена/Сумма с НДС (да/нет)
            LEFT JOIN tmpMI_Boolean AS MIBoolean_PriceWithVAT
                                    ON MIBoolean_PriceWithVAT.MovementItemId = vbId
                                   AND MIBoolean_PriceWithVAT.DescId         = zc_MIBoolean_PriceWithVAT()
            -- Возврат да/нет
            LEFT JOIN tmpMI_Boolean AS MIBoolean_ReturnOut
                                    ON MIBoolean_ReturnOut.MovementItemId = vbId
                                   AND MIBoolean_ReturnOut.DescId         = zc_MIBoolean_ReturnOut()

            LEFT JOIN tmpMI_String AS MIString_Comment
                                   ON MIString_Comment.MovementItemId = vbId
                                  AND MIString_Comment.DescId = zc_MIString_Comment()
            -- Количество Поставщика - Документ Поставщика
            LEFT JOIN tmpMI_Float AS MIFloat_AmountPartnerSecond
                                  ON MIFloat_AmountPartnerSecond.MovementItemId = vbId
                                 AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()
            -- Цена Поставщика
            LEFT JOIN tmpMI_Float AS MIFloat_PricePartner
                                  ON MIFloat_PricePartner.MovementItemId = vbId
                                 AND MIFloat_PricePartner.DescId = zc_MIFloat_PricePartner()
            -- Сумма Поставщика
            LEFT JOIN tmpMI_Float AS MIFloat_SummPartner
                                  ON MIFloat_SummPartner.MovementItemId = vbId
                                 AND MIFloat_SummPartner.DescId         = zc_MIFloat_SummPartner()
        WHERE Movement.Id = inMovementId
        ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 24.11.24                                        * all
*/

-- тест
-- select * from gpGet_MI_WeighingPartner_ActDiff_Edit (inMovementId:= 29849294, inId:= 0, inId_check:= 0, inGoodsId := 11489208 , inGoodsKindId := 8335 ,  inSession := '9457');
