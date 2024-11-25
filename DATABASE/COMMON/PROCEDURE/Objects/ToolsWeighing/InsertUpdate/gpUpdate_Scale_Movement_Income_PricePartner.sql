-- Function: gpUpdate_Scale_Movement_Income_PricePartner()

DROP FUNCTION IF EXISTS gpUpdate_Scale_Movement_Income_PricePartner (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_Movement_Income_PricePartner(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inBranchCode          Integer   , --
    IN inIsUpdate            Boolean   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (isPrice_diff   Boolean
             , GoodsId        Integer
             , GoodsCode      Integer
             , GoodsName      TVarChar
             , GoodsKindName  TVarChar
             , Amount         TFloat
             , AmountPartner  TFloat
             , OperPrice      TFloat
             , PricePartner   TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbContractId Integer;
   DECLARE vbMovementDescId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement_check());
     vbUserId:= lpGetUserBySession (inSession);


     -- Проверка
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ <Взвешивание> не сформирован.';
     END IF;

     -- параметры из документа
     vbMovementDescId:= (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId);

     -- параметры из документа
     vbContractId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract());
     -- Проверка
     IF COALESCE (vbContractId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Договор не указан.';
     END IF;


     -- таблица - элементы Спецификации
     CREATE TEMP TABLE _tmpContractGoods ON COMMIT DROP
        AS (SELECT lpGet.GoodsId, CASE WHEN lpGet.GoodsKindId > 0 THEN lpGet.GoodsKindId ELSE zc_GoodsKind_Basis() END AS GoodsKindId, lpGet.ValuePrice, lpGet.ValuePrice_from, lpGet.ValuePrice_to
                   -- цена
                 , lpGet.ValuePrice_notVat, lpGet.ValuePrice_from_notVat, lpGet.ValuePrice_to_notVat
                   -- цена
                 , lpGet.ValuePrice_addVat, lpGet.ValuePrice_from_addVat, lpGet.ValuePrice_to_addVat

            FROM lpGet_MovementItem_ContractGoods (inOperDate    := CASE vbMovementDescId
                                                                         WHEN zc_Movement_WeighingPartner()
                                                                              THEN (SELECT gpGet_Scale_OperDate (inIsCeh       := FALSE
                                                                                                              , inBranchCode  := inBranchCode
                                                                                                              , inSession     := inSession
                                                                                                               ))
                                                                         WHEN zc_Movement_Income()
                                                                              THEN COALESCE ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                                                           , (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
                                                                                            )
                                                                    END

                                                 , inJuridicalId := 0
                                                 , inPartnerId   := 0
                                                 , inContractId  := vbContractId
                                                 , inGoodsId     := 0
                                                 , inUserId      := vbUserId
                                                  ) AS lpGet
           );


     -- таблица - элементы Взвешивание - Приход
     CREATE TEMP TABLE _tmpMI ON COMMIT DROP
        AS (SELECT MovementItem.Id AS MovementItemId
                 , MovementItem.ObjectId AS GoodsId
                 , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId
                 , MovementItem.Amount
                 , COALESCE (MIFloat_AmountPartnerSecond.ValueData, MIFloat_AmountPartner.ValueData, 0) :: TFloat AS AmountPartner
                   -- цена по спецификации
                 , COALESCE (MIFloat_Price.ValueData, 0)         :: TFloat AS Price
                   -- цена поставщика - из накладной - ввод в контроле
                 , COALESCE (MIFloat_PricePartner.ValueData, 0)  :: TFloat AS PricePartner
                 , COALESCE (MIBoolean_PriceWithVAT.ValueData, FALSE) :: Boolean AS isPriceWithVAT
            FROM MovementItem
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                 LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                             ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                            AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                                            AND vbMovementDescId = zc_Movement_Income()
                 LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerSecond
                                             ON MIFloat_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                            AND MIFloat_AmountPartnerSecond.DescId         = zc_MIFloat_AmountPartnerSecond()
                                            AND vbMovementDescId = zc_Movement_WeighingPartner()
                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                            AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                 LEFT JOIN MovementItemFloat AS MIFloat_PricePartner
                                             ON MIFloat_PricePartner.MovementItemId = MovementItem.Id
                                            AND MIFloat_PricePartner.DescId         = zc_MIFloat_PricePartner()
                 -- Цена с НДС (да/нет)
                 LEFT JOIN MovementItemBoolean AS MIBoolean_PriceWithVAT
                                               ON MIBoolean_PriceWithVAT.MovementItemId = MovementItem.Id
                                              AND MIBoolean_PriceWithVAT.DescId         = zc_MIBoolean_PriceWithVAT()
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId     = zc_MI_Master()
              AND MovementItem.isErased   = FALSE
           );


     -- Обновляются цены - из Спецификации
     IF inIsUpdate = TRUE AND zc_Movement_WeighingPartner() = (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId)
     THEN
         -- сохранили протокол
         PERFORM lpInsert_MovementItemProtocol (_tmpMI.MovementItemId, vbUserId, FALSE)
         FROM (SELECT lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), _tmpMI.MovementItemId, _tmpContractGoods.ValuePrice)
                     , _tmpMI.MovementItemId
               FROM _tmpMI
                    INNER JOIN _tmpContractGoods
                            ON _tmpContractGoods.GoodsId     = _tmpMI.GoodsId
                           AND _tmpContractGoods.GoodsKindId = _tmpMI.GoodsKindId
                           AND _tmpContractGoods.ValuePrice  <> _tmpMI.Price
                           AND _tmpContractGoods.ValuePrice  > 0
              ) AS _tmpMI;

     END IF;


    -- Результат - отклонение
     RETURN QUERY
       SELECT CASE WHEN _tmpMI.PricePartner <> CASE WHEN _tmpMI.isPriceWithVAT = TRUE
                                                    -- с НДС
                                                    THEN _tmpContractGoods.ValuePrice_addVat
                                                    -- без НДС
                                                    ELSE _tmpContractGoods.ValuePrice_notVat
                                               END
                   THEN TRUE
                   ELSE FALSE
              END :: Boolean AS isPrice_diff
            , _tmpMI.GoodsId
            , Object_Goods.ObjectCode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName
            , Object_GoodsKind.ValueData  AS GoodsKindName
            , _tmpMI.Amount
            , _tmpMI.AmountPartner
              -- цена Спецификации
            , CASE WHEN _tmpMI.isPriceWithVAT = TRUE
                   -- с НДС
                   THEN _tmpContractGoods.ValuePrice_addVat
                   -- без НДС
                   ELSE _tmpContractGoods.ValuePrice_notVat
              END AS Price

              -- цена
            , _tmpMI.PricePartner

       FROM _tmpMI
            LEFT JOIN _tmpContractGoods
                   ON _tmpContractGoods.GoodsId     = _tmpMI.GoodsId
                  AND _tmpContractGoods.GoodsKindId = _tmpMI.GoodsKindId
                  AND _tmpContractGoods.ValuePrice  > 0
                  -- AND inIsUpdate = TRUE

            LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = _tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _tmpMI.GoodsKindId
       WHERE _tmpMI.Amount <> _tmpMI.AmountPartner
          OR _tmpMI.PricePartner <> CASE WHEN _tmpMI.isPriceWithVAT = TRUE
                                         -- с НДС
                                         THEN _tmpContractGoods.ValuePrice_addVat
                                         -- без НДС
                                         ELSE _tmpContractGoods.ValuePrice_notVat
                                    END
       ORDER BY CASE WHEN _tmpMI.PricePartner <> CASE WHEN _tmpMI.isPriceWithVAT = TRUE
                                                      -- с НДС
                                                      THEN _tmpContractGoods.ValuePrice_addVat
                                                      -- без НДС
                                                      ELSE _tmpContractGoods.ValuePrice_notVat
                                                 END
                     THEN 0
                     ELSE 1
                END
       LIMIT 1
      ;
       


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.10.24                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Scale_Movement_Income_PricePartner (inMovementId:= 29844891, inBranchCode:= 201, inIsUpdate:= TRUE, inSession:= '5')
