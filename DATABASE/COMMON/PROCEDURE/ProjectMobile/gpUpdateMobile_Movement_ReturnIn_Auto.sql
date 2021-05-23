-- Function: gpUpdateMobile_Movement_ReturnIn_Auto

DROP FUNCTION IF EXISTS gpUpdateMobile_Movement_ReturnIn_Auto (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMobile_Movement_ReturnIn_Auto (
    IN inMovementGUID TVarChar , -- глобальный идентификатор документа
    IN inSession      TVarChar   -- сессия пользователя
)
RETURNS TBlob
AS $BODY$
  DECLARE vbUserId Integer;

  DECLARE vbId          Integer;
  DECLARE vbStatusId    Integer;
  DECLARE vbOperDate    TDateTime;
  DECLARE vbPartner     Integer;
  DECLARE vbContractId  Integer;
  DECLARE vbPriceListId Integer;
  
  DECLARE vbMessageText Text:= '';
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...);
      vbUserId:= lpGetUserBySession (inSession);
      
      -- определение идентификатора документа по глобальному уникальному идентификатору
      SELECT MovementString_GUID.MovementId 
           , Movement.StatusId
           , Movement.OperDate
           , MovementLinkObject_From.ObjectId
           , MovementLinkObject_Contract.ObjectId
             INTO vbId 
                , vbStatusId
                , vbOperDate
                , vbPartner
                , vbContractId
      FROM MovementString AS MovementString_GUID
           JOIN Movement ON Movement.Id     = MovementString_GUID.MovementId
                        AND Movement.DescId = zc_Movement_ReturnIn() 
           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                       AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                        ON MovementLinkObject_Contract.MovementId = Movement.Id
                                       AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inMovementGUID;

      -- проверка на проведенный документ
      IF vbStatusId = zc_Enum_Status_Complete() 
      THEN
           RAISE EXCEPTION 'Возврат уже проведен, пересчет цен заблокирован.';
      END IF;

      IF COALESCE (vbId, 0) <> 0
      THEN
           IF vbStatusId <> zc_Enum_Status_UnComplete() 
           THEN 
                -- сначала распроводим документ
                PERFORM lpUnComplete_Movement (inMovementId:= vbId, inUserId:= vbUserId);
           END IF;


           -- если еще не было привязки
           IF NOT EXISTS (SELECT 1 FROM MovementItem
                          WHERE MovementItem.MovementId = vbId
                            AND MovementItem.DescId     = zc_MI_Child()
                            AND MovementItem.isErased   = FALSE
                            AND MovementItem.Amount     <> 0
                         )
              -- OR 1=1
           THEN
               -- таблица подразделений
               CREATE TEMP TABLE _tmpMI_noPromo (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat, Price TFloat) ON COMMIT DROP;
               -- Сохранили цены НЕ акционные
               INSERT INTO _tmpMI_noPromo (MovementItemId, GoodsId, GoodsKindId, Amount, Price)
                  SELECT MovementItem.Id                       AS MovementItemId
                       , MovementItem.ObjectId                 AS GoodsId
                       , MILinkObject_GoodsKind.ObjectId       AS GoodsKindId
                       , MovementItem.Amount                   AS Amount
                       , COALESCE (MIFloat_Price.ValueData, 0) AS Price
                  FROM MovementItem
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                       LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                  WHERE MovementItem.MovementId = vbId
                    AND MovementItem.DescId     = zc_MI_Master()
                    AND MovementItem.isErased   = FALSE
                   ;

               -- сначала попробуем поставить Акционные цены - как в Scale
               PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), tmp.MovementItemId, tmp.PricePromo)
               FROM (WITH tmpResult AS (SELECT tmpMI.MovementItemId
                                             , CASE WHEN (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = vbId AND MB.DescId = zc_MovementBoolean_PriceWithVAT()) = TRUE
                                                         THEN tmp.PriceWithVAT
                                                    WHEN 1=1
                                                         THEN tmp.PriceWithOutVAT
                                                    ELSE 0 -- ???может надо будет взять из прайса когда была акция ИЛИ любой продажи под эту акцию???
                                               END AS PricePromo
                                             , tmp.isChangePercent
                                        FROM _tmpMI_noPromo AS tmpMI
                                             INNER JOIN lpGet_Movement_Promo_Data_all (inOperDate     := vbOperDate
                                                                                     , inPartnerId    := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbId AND MLO.DescId = zc_MovementLinkObject_From())
                                                                                     , inContractId   := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                                                     , inUnitId       := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbId AND MLO.DescId = zc_MovementLinkObject_To())
                                                                                     , inGoodsId      := tmpMI.GoodsId
                                                                                     , inGoodsKindId  := tmpMI.GoodsKindId
                                                                                     , inIsReturn     := TRUE
                                                                                      ) AS tmp ON tmp.MovementId > 0
                                       )
                    -- Результат
                    SELECT tmpResult.MovementItemId, tmpResult.PricePromo, tmpResult.isChangePercent
                    FROM tmpResult
                   ) AS tmp;

               -- первый раз - автоматом сформировалась строчная часть - zc_MI_Child - для Promo
               vbMessageText:= lpUpdate_Movement_ReturnIn_Auto (inStartDateSale := DATE_TRUNC ('MONTH', vbOperDate) - INTERVAL '6 MONTH'
                                                              , inEndDateSale   := NULL
                                                              , inMovementId    := vbId
                                                              , inUserId        := -1 * vbUserId
                                                               );

               -- если не привязалось - 1
               IF EXISTS (SELECT 1
                          FROM (WITH tmpResult AS (SELECT MovementItem.ParentId, SUM (MovementItem.Amount) AS Amount
                                                   FROM MovementItem
                                                   WHERE MovementItem.MovementId = vbId
                                                     AND MovementItem.DescId     = zc_MI_Child()
                                                     AND MovementItem.isErased   = FALSE
                                                   GROUP BY MovementItem.ParentId
                                                  )
                               -- Результат
                               SELECT _tmpMI_noPromo.MovementItemId, _tmpMI_noPromo.Price
                               FROM _tmpMI_noPromo
                                    LEFT JOIN tmpResult ON tmpResult.ParentId = _tmpMI_noPromo.MovementItemId
                               WHERE _tmpMI_noPromo.Amount <> COALESCE (tmpResult.Amount, 0)
                              ) AS tmp
                         )
                  -- AND 1=0
               THEN
                   -- восстановим Цены что были - !!!ПЕРВЫЙ!!!
                   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), tmp.MovementItemId, tmp.Price)
                   FROM (WITH tmpResult AS (SELECT MovementItem.ParentId, SUM (MovementItem.Amount) AS Amount
                                            FROM MovementItem
                                            WHERE MovementItem.MovementId = vbId
                                              AND MovementItem.DescId     = zc_MI_Child()
                                              AND MovementItem.isErased   = FALSE
                                            GROUP BY MovementItem.ParentId
                                           )
                        -- Результат
                        SELECT _tmpMI_noPromo.MovementItemId, _tmpMI_noPromo.Price
                        FROM _tmpMI_noPromo
                             LEFT JOIN tmpResult ON tmpResult.ParentId = _tmpMI_noPromo.MovementItemId
                        WHERE _tmpMI_noPromo.Amount <> COALESCE (tmpResult.Amount, 0)
                       ) AS tmp;
    
                   -- еще раз - автоматом сформировали строчная часть - zc_MI_Child - Цены возврата - 14 дней
                   vbMessageText:= lpUpdate_Movement_ReturnIn_Auto (inStartDateSale := DATE_TRUNC ('MONTH', vbOperDate) - INTERVAL '6 MONTH'
                                                                  , inEndDateSale   := NULL
                                                                  , inMovementId    := vbId
                                                                  , inUserId        := -1 * vbUserId
                                                                   );

                   -- если не привязалось - 2
                   IF EXISTS (SELECT 1
                              FROM (WITH tmpResult AS (SELECT MovementItem.ParentId, SUM (MovementItem.Amount) AS Amount
                                                       FROM MovementItem
                                                       WHERE MovementItem.MovementId = vbId
                                                         AND MovementItem.DescId     = zc_MI_Child()
                                                         AND MovementItem.isErased   = FALSE
                                                       GROUP BY MovementItem.ParentId
                                                      )
                                   -- Результат
                                   SELECT _tmpMI_noPromo.MovementItemId, _tmpMI_noPromo.Price
                                   FROM _tmpMI_noPromo
                                        LEFT JOIN tmpResult ON tmpResult.ParentId = _tmpMI_noPromo.MovementItemId
                                   WHERE _tmpMI_noPromo.Amount <> COALESCE (tmpResult.Amount, 0)
                                  ) AS tmp
                             )
                      -- AND 1=0
                   THEN
                       -- найдем в следующем порядке: 1.1) ---акционный у контрагента 1.2) ---акционный у договора 1.3) ---акционный у юр.лица 2.1) обычный у контрагента 2.2) обычный у договора 2.3) обычный у юр.лица 3) zc_PriceList_Basis
                       vbPriceListId:= (SELECT COALESCE (ObjectLink_Partner_PriceList.ChildObjectId
                                                       , COALESCE (ObjectLink_Contract_PriceList.ChildObjectId
                                                                 , COALESCE (ObjectLink_Juridical_PriceList.ChildObjectId
                                                                           , zc_PriceList_Basis())))
                                        FROM Object AS Object_Partner
                                             LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                                                                  ON ObjectLink_Partner_PriceList.ObjectId = Object_Partner.Id
                                                                 AND ObjectLink_Partner_PriceList.DescId   = zc_ObjectLink_Partner_PriceList()
                                             LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                                                  ON ObjectLink_Contract_PriceList.ObjectId = vbContractId
                                                                 AND ObjectLink_Contract_PriceList.DescId   = zc_ObjectLink_Contract_PriceList()
                                             LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                  ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                                                 AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                             LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                                                  ON ObjectLink_Juridical_PriceList.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                                 AND ObjectLink_Juridical_PriceList.DescId   = zc_ObjectLink_Juridical_PriceList()
                                        WHERE Object_Partner.Id = vbPartner
                                       );

                       -- установим Цены за "сегодня"
                       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), tmp.MovementItemId, ObjectHistoryFloat_PriceListItem_Value.ValueData)
                       FROM (WITH tmpResult AS (SELECT MovementItem.ParentId, SUM (MovementItem.Amount) AS Amount
                                                FROM MovementItem
                                                WHERE MovementItem.MovementId = vbId
                                                 AND MovementItem.DescId     = zc_MI_Child()
                                                  AND MovementItem.isErased   = FALSE
                                                GROUP BY MovementItem.ParentId
                                               )
                            -- Результат
                            SELECT _tmpMI_noPromo.MovementItemId, _tmpMI_noPromo.GoodsId
                            FROM _tmpMI_noPromo
                                 LEFT JOIN tmpResult ON tmpResult.ParentId = _tmpMI_noPromo.MovementItemId
                            WHERE _tmpMI_noPromo.Amount <> COALESCE (tmpResult.Amount, 0)
                           ) AS tmp
                           JOIN ObjectLink AS ObjectLink_PriceListItem_Goods 
                                           ON ObjectLink_PriceListItem_Goods.ChildObjectId = tmp.GoodsId
                                          AND ObjectLink_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                           JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                           ON ObjectLink_PriceListItem_PriceList.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                          AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                          AND ObjectLink_PriceListItem_PriceList.ChildObjectId = vbPriceListId
                           JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                              ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                             AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem() 
                                             AND vbOperDate >= ObjectHistory_PriceListItem.StartDate AND vbOperDate < ObjectHistory_PriceListItem.EndDate
                           JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                   ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                  AND ObjectHistoryFloat_PriceListItem_Value.DescId          = zc_ObjectHistoryFloat_PriceListItem_Value()
                                                  AND ObjectHistoryFloat_PriceListItem_Value.ValueData       <> 0
                           ;
        
                       -- еще раз - автоматом сформировали строчная часть - zc_MI_Child - Цены возврата - за "сегодня"
                       vbMessageText:= lpUpdate_Movement_ReturnIn_Auto (inStartDateSale := DATE_TRUNC ('MONTH', vbOperDate) - INTERVAL '6 MONTH'
                                                                      , inEndDateSale   := NULL
                                                                      , inMovementId    := vbId
                                                                      , inUserId        := -1 * vbUserId
                                                                       );

                       -- если не привязалось - 3
                       IF EXISTS (SELECT 1
                                  FROM (WITH tmpResult AS (SELECT MovementItem.ParentId, SUM (MovementItem.Amount) AS Amount
                                                           FROM MovementItem
                                                           WHERE MovementItem.MovementId = vbId
                                                             AND MovementItem.DescId     = zc_MI_Child()
                                                             AND MovementItem.isErased   = FALSE
                                                           GROUP BY MovementItem.ParentId
                                                          )
                                       -- Результат
                                       SELECT _tmpMI_noPromo.MovementItemId, _tmpMI_noPromo.Price
                                       FROM _tmpMI_noPromo
                                            LEFT JOIN tmpResult ON tmpResult.ParentId = _tmpMI_noPromo.MovementItemId
                                       WHERE _tmpMI_noPromo.Amount <> COALESCE (tmpResult.Amount, 0)
                                      ) AS tmp
                                 )
                          -- AND 1=0
                       THEN
                           -- восстановим Цены что были - !!!ВТОРОЙ!!!
                           PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), tmp.MovementItemId, tmp.Price)
                           FROM (WITH tmpResult AS (SELECT MovementItem.ParentId, SUM (MovementItem.Amount) AS Amount
                                                    FROM MovementItem
                                                    WHERE MovementItem.MovementId = vbId
                                                      AND MovementItem.DescId     = zc_MI_Child()
                                                      AND MovementItem.isErased   = FALSE
                                                    GROUP BY MovementItem.ParentId
                                                   )
                                -- Результат
                                SELECT _tmpMI_noPromo.MovementItemId, _tmpMI_noPromo.Price
                                FROM _tmpMI_noPromo
                                     LEFT JOIN tmpResult ON tmpResult.ParentId = _tmpMI_noPromo.MovementItemId
                                WHERE _tmpMI_noPromo.Amount <> COALESCE (tmpResult.Amount, 0)
                               ) AS tmp;
            
                           -- еще раз - автоматом сформировали строчная часть - zc_MI_Child - Цены возврата - 14 дней
                           vbMessageText:= lpUpdate_Movement_ReturnIn_Auto (inStartDateSale := DATE_TRUNC ('MONTH', vbOperDate) - INTERVAL '6 MONTH'
                                                                          , inEndDateSale   := NULL
                                                                          , inMovementId    := vbId
                                                                          , inUserId        := -1 * vbUserId
                                                                           );
                       END IF; -- если не привязалось - 3

                   END IF; -- если не привязалось - 2

               END IF; -- если не привязалось - 1
                                                               
               -- вернем ошибку
               IF vbMessageText <> '' THEN
                 RAISE EXCEPTION '%', vbMessageText;
               END IF;
               
           END IF;

/*if vbUserId = 5
then
    RAISE EXCEPTION '<%>  %', (SELECT _tmpMI_noPromo.Price FROM _tmpMI_noPromo)
                            , (SELECT MIF_Price.ValueData
                               FROM MovementItem AS MI
                                    LEFT JOIN MovementItemFloat AS MIF_Price ON MIF_Price.MovementItemId = MI.Id AND MIF_Price.DescId = zc_MIFloat_Price()
                               WHERE MI.MovementId = vbId
                                 AND MI.DescId     = zc_MI_Master()
                              );
end if;*/

           -- удаляем
           PERFORM lpSetErased_Movement (inMovementId := vbId, inUserId:= vbUserId);

      END IF;

      RETURN vbMessageText::TBlob;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 21.08.17                                                        *
*/

-- тест
-- SELECT lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), 127263612, 119)
-- SELECT lpInsertUpdate_MovementString (zc_MovementString_GUID(), 11832911 , 'test_mobile_01')
-- SELECT gpUpdateMobile_Movement_ReturnIn_Auto (inMovementGUID:= '{D2399D25-513D-4F68-A1ED-FCD21C63A0B7}', inSession:= zfCalc_UserAdmin());
-- SELECT gpUpdateMobile_Movement_ReturnIn_Auto (inMovementGUID:= 'test_mobile_01', inSession:= zfCalc_UserAdmin());
