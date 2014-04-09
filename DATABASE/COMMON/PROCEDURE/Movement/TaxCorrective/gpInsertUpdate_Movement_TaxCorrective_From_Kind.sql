-- Function: gpInsertUpdate_Movement_TaxCorrective_From_Kind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective_From_Kind (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TaxCorrective_From_Kind (
    IN inMovementId           Integer  , -- ключ Документа
    IN inDocumentTaxKindId    Integer  , -- Тип формирования налогового документа
   OUT outDocumentTaxKindName TVarChar , --
    IN inSession              TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId           Integer;

   DECLARE vbMovementId_Tax   Integer;
   DECLARE vbAmount_Tax       TFloat;

   DECLARE vbOperDate         TDateTime;
   DECLARE vbPriceWithVAT     Boolean ;
   DECLARE vbVATPercent       TFloat;
   DECLARE vbFromId           Integer;
   DECLARE vbToId             Integer;
   DECLARE vbPartnerId        Integer;
   DECLARE vbContractId       Integer;

   DECLARE vbGoodsId     Integer;
   DECLARE vbGoodsKindId Integer;
   DECLARE vbAmount      TFloat;
   DECLARE vbOperPrice   TFloat;

   DECLARE curMI_ReturnIn refcursor;
   DECLARE curMI_Tax refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective());

     -- 
     IF inDocumentTaxKindId <> zc_Enum_DocumentTaxKind_Corrective()
     THEN
         RAISE EXCEPTION 'Ошибка.Неверно указан тип корректировки.';
     END IF;


     -- выбираем реквизиты для обновления/создания шапки НН
     SELECT Movement.OperDate
          , Movement.PriceWithVAT
          , Movement.VATPercent
          , ObjectLink_Partner_Juridical.ChildObjectId        -- от кого
          , ObjectLink_Contract_JuridicalBasis.ChildObjectId  -- кому
          , Movement.FromId           	                 -- контрагент
          , Movement.ContractId 
            INTO vbOperDate, vbPriceWithVAT, vbVATPercent, vbFromId, vbToId, vbPartnerId, vbContractId
     FROM gpGet_Movement_ReturnIn (inMovementId, CURRENT_DATE, inSession) AS Movement
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = Movement.FromId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                               ON ObjectLink_Contract_JuridicalBasis.ObjectId = Movement.ContractId
                              AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
     WHERE Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
    ;

     -- таблица - Данные
     CREATE TEMP TABLE _tmpMI_Return (GoodsId Integer, GoodsKindId Integer, Amount TFloat, OperPrice TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpMovement_find (MovementId_Corrective Integer, MovementId_Tax Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpResult (MovementId_Corrective Integer, MovementId_Tax Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat, OperPrice TFloat) ON COMMIT DROP;


     -- выбрали возвраты
     INSERT INTO _tmpMI_Return (GoodsId, GoodsKindId, Amount, OperPrice)
        SELECT MovementItem.ObjectId
             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
             , MovementItem.Amount
             , MIFloat_Price.ValueData
        FROM MovementItem
             INNER JOIN MovementItemFloat AS MIFloat_Price
                                          ON MIFloat_Price.MovementItemId = MovementItem.Id
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                         AND MIFloat_Price.ValueData <> 0
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE
          AND MovementItem.Amount <> 0;


     -- курсор1 - возвраты
     OPEN curMI_ReturnIn FOR
          SELECT GoodsId, GoodsKindId, Amount, OperPrice FROM _tmpMI_Return;

     -- начало цикла по курсору1 - возвраты
     LOOP
          -- данные по возвратам
          FETCH curMI_ReturnIn INTO vbGoodsId, vbGoodsKindId, vbAmount, vbOperPrice;
          -- если данные закончились, тогда выход
          IF NOT FOUND THEN EXIT; END IF;

          -- курсор2 - все налоговые !!!за минусом прошлых корректировок!!! по товару и цене
          OPEN curMI_Tax FOR
               SELECT tmpMovement_Tax.MovementId
                    , tmpMovement_Tax.Amount - COALESCE (tmpMovement_Corrective.Amount, 0) AS Amount
                     -- это все налоговые по покупатель, товар и цена
               FROM (SELECT Movement.Id AS MovementId
                          , Movement.OperDate
                          , COALESCE (MB_Registered.ValueData, FALSE) AS isRegistered
                          , SUM (MovementItem.Amount) AS Amount
                     FROM MovementLinkObject AS MLO_Partner
                          INNER JOIN Movement ON Movement.Id = MLO_Partner.ObjectId
                                             AND Movement.DescId = zc_Movement_Tax()
                                             AND Movement.StatusId = zc_Enum_Status_Complete()
                                             AND Movement.OperDate BETWEEN '01.08.2013' AND vbOperDate - 1
                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                 AND MovementItem.ObjectId = vbGoodsId
                                                 AND MovementItem.DescId = zc_MI_Master()
                                                 AND MovementItem.isErased   = FALSE
                                                 AND MovementItem.Amount <> 0
                          INNER JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.ValueData = vbOperPrice
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                          LEFT JOIN MovementBoolean AS MB_Registered
                                                    ON MB_Registered.MovementId = Movement.Id
                                                   AND MB_Registered.DescId = zc_MovementBoolean_Registered()
                     WHERE MLO_Partner.ObjectId = vbPartnerId
                       AND MLO_Partner.DescId = zc_MovementLinkObject_Partner()
                     GROUP BY Movement.Id
                            , Movement.OperDate
                    ) AS tmpMovement_Tax
                    -- это !!!все!!! корректировки по товар и цена (для !!!всех!!! налоговых)
                    LEFT JOIN (SELECT CASE WHEN MLM_Master.MovementChildId = inMovementId THEN 0 ELSE MLM_Child.MovementChildId END AS MovementId_Tax
                                    , SUM (MovementItem.Amount) AS Amount
                               FROM Movement
                                    INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.ObjectId = vbGoodsId
                                                           AND MovementItem.DescId = zc_MI_Master()
                                                           AND MovementItem.isErased   = FALSE
                                    INNER JOIN MovementItemFloat AS MIFloat_Price
                                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                AND MIFloat_Price.ValueData = vbOperPrice
                                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                    INNER JOIN MovementLinkMovement AS MLM_Child
                                                                    ON MLM_Child.MovementId = Movement.Id
                                                                   AND MLM_Child.DescId = zc_MovementLinkMovement_Child()
                                    INNER JOIN MovementLinkMovement AS MLM_Master
                                                                    ON MLM_Master.MovementId = Movement.Id
                                                                   AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
                               WHERE Movement.DescId = zc_Movement_TaxCorrective()
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                               GROUP BY MLM_Child.MovementChildId
                              ) AS tmpMovement_Corrective ON tmpMovement_Corrective.MovementId_Tax = Movement.Id
               WHERE tmpMovement_Tax.Amount > COALESCE (tmpMovement_Corrective.Amount, 0)
                 AND tmpMovement_Tax.isRegistered = FALSE
               ORDER BY tmpMovement_Tax.OperDate DESC, 3 DESC
              ;

          -- начало цикла по курсору2 - налоговые
          LOOP
              -- данные по налоговым
              FETCH curMI_Tax INTO vbMovementId_Tax, vbAmount_Tax;
              -- если данные закончились, или все кол-во найдено тогда выход
              IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

              --
              IF vbAmount_Tax > vbAmount
              THEN
                  -- получилось в налоговой больше чем искали, !!!сохраняем в табл-результата!!!
                  INSERT INTO _tmpResult (MovementId_Corrective, MovementId_Tax, GoodsId, GoodsKindId, Amount, OperPrice)
                     SELECT 0, vbMovementId_Tax, vbGoodsId, vbGoodsKindId, vbAmount, vbOperPrice;
                  -- обнуляем кол-во что бы больше не искать
                  vbAmount:= 0;
              ELSE
                  -- получилось в налоговой меньше чем искали, !!!сохраняем в табл-результата!!!
                  INSERT INTO _tmpResult (MovementId_Corrective, MovementId_Tax, GoodsId, GoodsKindId, Amount, OperPrice)
                     SELECT 0, vbMovementId_Tax, vbGoodsId, vbGoodsKindId, vbAmount_Tax, vbOperPrice;
                  -- уменьшаем на кол-во которое нашли и продолжаем поиск
                  vbAmount:= vbAmount - vbAmount_Tax;
              END IF;

          END LOOP; -- финиш цикла по курсору2 - налоговые
          CLOSE curMI_Tax; -- закрыли курсор2 - налоговые

     END LOOP; -- финиш цикла по курсору1 - возвраты
     CLOSE curMI_ReturnIn; -- закрыли курсор1 - возвраты


     -- !!!осталось сохранить данные!!!!


     -- находим те корректировки что есть у текущего возврата
     INSERT INTO _tmpMovement_find (MovementId_Corrective, MovementId_Tax)
        SELECT MLM_Master.MovementId, COALESCE (MLM_Child.MovementChildId, 0)
        FROM MovementLinkMovement AS MLM_Master
             LEFT JOIN MovementLinkMovement AS MLM_Child
                                            ON MLM_Child.MovementId = MLM_Master.MovementId
                                           AND MLM_Child.DescId = zc_MovementLinkMovement_Child()
        WHERE MLM_Master.MovementChildId = inMovementId
          AND MLM_Master.DescId = zc_MovementLinkMovement_Master();


     -- для табл-результата обновляем те корректировки что есть
     UPDATE _tmpResult SET MovementId_Corrective = _tmpMovement_find.MovementId_Corrective
     FROM _tmpMovement_find
     WHERE _tmpResult.MovementId_Tax = _tmpMovement_find.MovementId_Tax;


     -- удаляем строчную часть что была
     PERFORM gpMovementItem_TaxCorrective_SetErased (inMovementItemId:= MovementItem.Id
                                                   , inSession       := inSession
                                                    )
     FROM (SELECT MovementId_Corrective
           FROM _tmpResult
           WHERE MovementId_Corrective <> 0
           GROUP BY MovementId_Corrective
          ) AS tmpResult_update
          INNER JOIN MovementItem ON MovementItem.MovementId = tmpResult_update.MovementId_Corrective
                                 AND MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.isErased = FALSE;

     -- удаляем ненужные документы
     PERFORM lpSetErased_Movement (inMovementId       := tmpResult_delete.MovementId_Corrective
                                 , vbUserId           := vbUserId
                                  )
     FROM (SELECT _tmpMovement_find.MovementId_Corrective
           FROM _tmpMovement_find
                 LEFT JOIN _tmpResult ON _tmpResult.MovementId_Corrective = _tmpMovement_find.MovementId_Corrective
           WHERE _tmpResult.MovementId_Corrective IS NULL
           GROUP BY _tmpMovement_Corrective.MovementId
          ) AS tmpResult_delete;


     -- распроводим/восстанавливаем найденные документы
     PERFORM lpUnComplete_Movement (inMovementId       := tmpResult_update.MovementId_Corrective
                                  , vbUserId           := vbUserId
                                   )
     FROM (SELECT MovementId_Corrective
           FROM _tmpResult
           WHERE MovementId_Corrective <> 0
           GROUP BY MovementId_Corrective
          ) AS tmpResult_update;


     -- меняем заголовок для существующих корректировок 
     PERFORM lpInsertUpdate_Movement_TaxCorrective (ioId               := tmpResult_update.MovementId_Corrective
                                                  , inInvNumber        := Movement.InvNumber
                                                  , inInvNumberPartner := Movement.InvNumber
                                                  , inOperDate         := vbOperDate
                                                  , inChecked          := FALSE
                                                  , inDocument         := FALSE
                                                  , inPriceWithVAT     := vbPriceWithVAT
                                                  , inVATPercent       := vbVATPercent
                                                  , inFromId           := vbFromId
                                                  , inToId             := vbToId
                                                  , inPartnerId        := vbPartnerId
                                                  , inContractId       := vbContractId
                                                  , inDocumentTaxKindId:= inDocumentTaxKindId
                                                  , vbUserId           := vbUserId
                                                   )
     FROM (SELECT MovementId_Corrective
           FROM _tmpResult
           WHERE MovementId_Corrective <> 0
           GROUP BY MovementId_Corrective
          ) AS tmpResult_update
           JOIN Movement ON Movement.Id = tmpResult_update.MovementId_Corrective;


     -- создаем новые корректировки
     UPDATE _tmpResult SET MovementId_Corrective = tmpResult_insert.MovementId_Corrective
     FROM (SELECT lpInsertUpdate_Movement_TaxCorrective (ioId               :=0
                                                       , inInvNumber        := tmpResult_insert.InvNumber
                                                       , inInvNumberPartner := tmpResult_insert.InvNumber
                                                       , inOperDate         := vbOperDate
                                                       , inChecked          := FALSE
                                                       , inDocument         := FALSE
                                                       , inPriceWithVAT     := vbPriceWithVAT
                                                       , inVATPercent       := vbVATPercent
                                                       , inFromId           := vbFromId
                                                       , inToId             := vbToId
                                                       , inPartnerId        := vbPartnerId
                                                       , inContractId       := vbContractId
                                                       , inDocumentTaxKindId:= inDocumentTaxKindId
                                                       , vbUserId           := vbUserId
                                                      ) AS MovementId_Corrective
                , tmpResult_insert.MovementId_Tax
           FROM (SELECT NEXTVAL ('movement_taxcorrective_seq') AS InvNumber
                      , tmpResult_insert.MovementId_Tax
                 FROM (SELECT MovementId_Tax
                       FROM _tmpResult
                       WHERE MovementId_Corrective = 0
                       GROUP BY MovementId_Tax
                      ) AS tmpResult_insert
                ) AS tmpResult_insert
         ) AS tmpResult_insert
     WHERE _tmpResult.MovementId_Tax = tmpResult_insert.MovementId_Tax;


     -- создаем строчную часть заново
     PERFORM lpInsertUpdate_MovementItem_TaxCorrective (ioId                 := 0
                                                      , inMovementId         := _tmpResult.MovementId_Corrective
                                                      , inGoodsId            := _tmpResult.GoodsId
                                                      , inAmount             := _tmpResult.Amount
                                                      , inPrice              := _tmpResult.Price
                                                      , ioCountForPrice      := 1
                                                      , inGoodsKindId        := _tmpResult.GoodsKindId
                                                      , inUserId             := vbUserId
                                                       )
      FROM _tmpResult;


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= tmpResult_update.MovementId_Corrective)
     FROM (SELECT MovementId_Corrective
           FROM _tmpResult
           GROUP BY MovementId_Corrective
          ) AS tmpResult_update;


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= tmpResult_update.MovementId_Corrective)
     FROM (SELECT MovementId_Corrective
           FROM _tmpResult
           GROUP BY MovementId_Corrective
          ) AS tmpResult_update;


     -- ФИНИШ - Обязательно меняем статус документа
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete()
     FROM (SELECT MovementId_Corrective
           FROM _tmpResult
           GROUP BY MovementId_Corrective
          ) AS tmpResult_complete
     WHERE Movement.Id = tmpResult_complete.MovementId_Corrective;


     -- результат
     SELECT Object_TaxKind.ValueData
            INTO outDocumentTaxKindName
     FROM Object AS Object_TaxKind
     WHERE Object_TaxKind.Id = inDocumentTaxKindId;

/*
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete()
     WHERE Movement.DescId IN (zc_Movement_TaxCorrective(), zc_Movement_Tax())
       AND StatusId = zc_Enum_Status_UnComplete()
*/
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_TaxCorrective_From_Kind (Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.04.14                                        * ALL
 13.02.14                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_TaxCorrective_From_Kind (inMovementId := 21838, inDocumentTaxKindId:=80770, inSession := '5');
