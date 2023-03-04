-- Function: lpInsertUpdate_MI_ChangePercent_byTax()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ChangePercent_byTax (integer, integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ChangePercent_byTax(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbToId       Integer;
   DECLARE vbContractId Integer;
   DECLARE vbPartnerId  Integer;
   DECLARE vbOperDate   TDateTime;
   DECLARE vbStartDate  TDateTime;
   DECLARE vbEndDate    TDateTime;
BEGIN

     --проверка
     IF COALESCE (inMovementId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;

     --данные их документа
     SELECT MovementLinkObject_To.ObjectId       AS ToId
          , MovementLinkObject_Contract.ObjectId AS ContractId
          , Movement.OperDate
          --, MovementLinkObject_Partner.ObjectId  AS PartnerId
    INTO vbToId, vbContractId, vbOperDate--, vbPartnerId
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

            /*LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            */

     WHERE Movement.Id = inMovementId
     ;
     --проверка
     IF COALESCE (vbToId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не выбрано Юр.лицо.';
     END IF;
      IF COALESCE (vbContractId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не выбран Договор.';
     END IF;

     vbStartDate := DATE_TRUNC ('MONTH', vbOperDate);
     vbEndDate   := DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';

     --перед записью удаляем сущ. строки
      UPDATE MovementItem
      SET isErased = TRUE
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.DescId     = zc_MI_Master()
        AND MovementItem.isErased   = FALSE;
     
     -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem_ChangePercent (ioId            := 0
                                                      , inMovementId    := inMovementId
                                                      , inGoodsId       := tmp.GoodsId
                                                      , inAmount        := tmp.Amount
                                                      , inPrice         := tmp.Price
                                                      , ioCountForPrice := tmp.CountForPrice
                                                      , inGoodsKindId   := tmp.GoodsKindId
                                                      , inUserId        := inUserId
                                                      ) 
     FROM (WITH
           tmpTax AS (SELECT Movement.Id 
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                       AND MovementLinkObject_To.ObjectId = vbToId

                           INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                        ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                       AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                       AND MovementLinkObject_Contract.ObjectId = vbContractId

                           /*LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                        ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                       AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()*/
                      WHERE Movement.DescId = zc_Movement_Tax()
                        AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                        --AND (MovementLinkObject_Partner.ObjectId = vbPartnerId OR vbPartnerId = 0) 
                      )
         , tmpMI AS (SELECT MovementItem.ObjectId           AS GoodsId
                          , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                          , MIFloat_Price.ValueData         AS Price
                          , MIFloat_CountForPrice.ValueData AS CountForPrice
                          , SUM (MovementItem.Amount)       AS Amount
                     FROM tmpTax
                          INNER JOIN MovementItem ON MovementItem.MovementId = tmpTax.Id
                                                 AND MovementItem.DescId = zc_MI_Master()
                                                 AND MovementItem.isErased = FALSE

                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                          LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                      ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                     AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                     GROUP BY MovementItem.ObjectId
                            , MILinkObject_GoodsKind.ObjectId
                            , MIFloat_Price.ValueData
                            , MIFloat_CountForPrice.ValueData 
                     )
         SELECT *
         FROM tmpMI
          ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.03.23         *
*/

-- тест
--