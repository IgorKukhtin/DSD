-- Function: gpInsertUpdate_Movement_TaxCorrective_From_Kind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective_From_Kind (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TaxCorrective_From_Kind (
    IN inMovementId             Integer  , -- ключ Документа
    IN inDocumentTaxKindId      Integer  , -- Тип формирования налогового документа
    IN inDocumentTaxKindId_inf  Integer  , -- Тип формирования налогового документа
    IN inIsTaxLink              Boolean  , -- Признак привязки к налоговым
   OUT outDocumentTaxKindId     Integer  , --
   OUT outDocumentTaxKindName   TVarChar , --
   OUT outMovementId_Corrective Integer  , --
    IN inSession                TVarChar   -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId           Integer;

   DECLARE vbStatusId  Integer;
   DECLARE vbInvNumber TVarChar;

   DECLARE vbMovementId_Tax   Integer;
   DECLARE vbAmount_Tax       TFloat;

   DECLARE vbMovementDescId   Integer;
   DECLARE vbOperDate         TDateTime;
   DECLARE vbPriceWithVAT     Boolean ;
   DECLARE vbVATPercent       TFloat;
   DECLARE vbFromId           Integer;
   DECLARE vbToId             Integer;
   DECLARE vbPartnerId        Integer;
   DECLARE vbContractId       Integer;
   DECLARE vbDiscountPercent     TFloat;
   DECLARE vbExtraChargesPercent TFloat;

   DECLARE vbGoodsId     Integer;
   DECLARE vbGoodsKindId Integer;
   DECLARE vbAmount      TFloat;
   DECLARE vbOperPrice   TFloat;

   DECLARE curMI_ReturnIn refcursor;
   DECLARE curMI_Tax refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective());

     -- это значит пользователь установил в журнале "другой" тип формирования
     IF inDocumentTaxKindId_inf <> 0 THEN inDocumentTaxKindId:= inDocumentTaxKindId_inf; END IF;

     -- это тип формирования по дефолту
     IF COALESCE (inDocumentTaxKindId, 0) = 0
     THEN inDocumentTaxKindId:= zc_Enum_DocumentTaxKind_Corrective();
     END IF;

     -- 
     IF inDocumentTaxKindId NOT IN (zc_Enum_DocumentTaxKind_Corrective(), zc_Enum_DocumentTaxKind_CorrectivePrice())
     THEN
         RAISE EXCEPTION 'Ошибка.Неверно указан тип корректировки.';
     END IF;


     -- определяются параметры для <Налогового документа>
     SELECT Movement.StatusId
          , Movement.InvNumber
          , Movement.DescId AS MovementDescId
          , CASE WHEN Movement.DescId = zc_Movement_ReturnIn()
                      THEN MovementDate_OperDatePartner.ValueData -- совпадает с датой контрагента
                 ELSE Movement.OperDate  -- совпадает с документом inMovementId
            END AS OperDate
          , MovementBoolean_PriceWithVAT.ValueData AS PriceWithVAT
          , MovementFloat_VATPercent.ValueData AS VATPercent
          , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN ObjectLink_Partner_Juridical.ChildObjectId ELSE MovementLinkObject_From.ObjectId END AS FromId
          , ObjectLink_Contract_JuridicalBasis.ChildObjectId AS ToId -- От кого - всегда главное юр.лицо из договора
          , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MovementLinkObject_From.ObjectId ELSE MovementLinkObject_Partner.ObjectId END AS PartnerId
          , COALESCE (MovementLinkObject_ContractFrom.ObjectId, MovementLinkObject_Contract.ObjectId) AS ContractId
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -1 * MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
          , CASE WHEN Movement.DescId = zc_Movement_PriceCorrective()
                      THEN zc_Enum_DocumentTaxKind_CorrectivePrice() -- !!!всегда такая!!!
                 ELSE inDocumentTaxKindId -- !!!не меняется!!!
            END AS DocumentTaxKindId
            INTO vbStatusId, vbInvNumber
               , vbMovementDescId, vbOperDate, vbPriceWithVAT, vbVATPercent, vbFromId, vbToId, vbPartnerId, vbContractId
               , vbDiscountPercent, vbExtraChargesPercent, inDocumentTaxKindId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                       ON MovementLinkObject_Partner.MovementId = Movement.Id
                                      AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractFrom
                                       ON MovementLinkObject_ContractFrom.MovementId = Movement.Id
                                      AND MovementLinkObject_ContractFrom.DescId = zc_MovementLinkObject_ContractFrom()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                               ON ObjectLink_Contract_JuridicalBasis.ObjectId = COALESCE (MovementLinkObject_ContractFrom.ObjectId, MovementLinkObject_Contract.ObjectId)
                              AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
     WHERE Movement.Id = inMovementId
    ;

     -- проверка - проведенные/удаленные документы Изменять нельзя
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION 'Ошибка.Формирование <Корректировки к налоговой> на основании документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;


     -- таблица - Данные
     CREATE TEMP TABLE _tmpMI_Return (GoodsId Integer, GoodsKindId Integer, OperPrice TFloat, CountForPrice TFloat, Amount TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpMovement_find (MovementId_Corrective Integer, MovementId_Tax Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpResult (MovementId_Corrective Integer, MovementId_Tax Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat, OperPrice TFloat, CountForPrice TFloat) ON COMMIT DROP;
     -- данные для курсор2 - отдельно !!!для оптимизации!!!
     CREATE TEMP TABLE _tmp1_SubQuery (MovementId Integer, OperDate TDateTime, isRegistered Boolean, Amount TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmp2_SubQuery (MovementId_Tax Integer, Amount TFloat) ON COMMIT DROP;

     -- выбрали <Возврат от покупателя> или <Перевод долга (приход)> или <Корректировка цены>
     INSERT INTO _tmpMI_Return (GoodsId, GoodsKindId, OperPrice, CountForPrice, Amount)
        SELECT tmpMI.GoodsId
             , tmpMI.GoodsKindId
             , tmpMI.OperPrice
             , tmpMI.CountForPrice
             , tmpMI.Amount
        FROM (SELECT MovementItem.ObjectId AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                   , CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent <> 0
                               -- в корректировках цены всегда будут без НДС
                               THEN CAST (CASE WHEN vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0 THEN CAST ( (1 + (vbExtraChargesPercent - vbDiscountPercent) / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2)) ELSE COALESCE (MIFloat_Price.ValueData, 0) END
                                        / (1 + vbVATPercent / 100) AS NUMERIC (16, 4))
                          ELSE CASE WHEN vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0 THEN CAST ( (1 + (vbExtraChargesPercent - vbDiscountPercent) / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2)) ELSE COALESCE (MIFloat_Price.ValueData, 0) END
                     END AS OperPrice
                   , MIFloat_CountForPrice.ValueData AS CountForPrice
                   , SUM (CASE WHEN vbMovementDescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) WHEN vbMovementDescId IN (zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective()) THEN MovementItem.Amount ELSE 0 END) AS Amount
              FROM MovementItem
                   INNER JOIN MovementItemFloat AS MIFloat_Price
                                                ON MIFloat_Price.MovementItemId = MovementItem.Id
                                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                               AND MIFloat_Price.ValueData <> 0
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                              AND MIFloat_AmountPartner.ValueData <> 0
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId     = zc_MI_Master()
                AND MovementItem.isErased   = FALSE
              GROUP BY MovementItem.ObjectId
                     , MILinkObject_GoodsKind.ObjectId
                     , MIFloat_Price.ValueData 
                     , MIFloat_CountForPrice.ValueData
             ) AS tmpMI
        WHERE tmpMI.Amount <> 0
       ;

     IF inIsTaxLink = FALSE OR vbMovementDescId = zc_Movement_PriceCorrective()
     THEN 
          -- в этом случае не будет привязки, но есть поиск !!!одной!!! корректировки что есть у текущего <Возврат от покупателя> или <Перевод долга (приход)>
          WITH tmpMovement_Corrective AS (SELECT MLM_Master.MovementId AS MovementId_Corrective, COALESCE (MLM_Child.MovementChildId, 0) AS MovementId_Tax
                                          FROM MovementLinkMovement AS MLM_Master
                                               INNER JOIN Movement AS Movement_TaxCorrective ON Movement_TaxCorrective.Id = MLM_Master.MovementId
                                                                                            AND Movement_TaxCorrective.StatusId <> zc_Enum_Status_Erased()
                                               LEFT JOIN MovementLinkMovement AS MLM_Child
                                                                              ON MLM_Child.MovementId = MLM_Master.MovementId
                                                                             AND MLM_Child.DescId = zc_MovementLinkMovement_Child()
                                          WHERE MLM_Master.MovementChildId = inMovementId
                                            AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
                                          GROUP BY MLM_Master.MovementId, COALESCE (MLM_Child.MovementChildId, 0)
                                         )
             , tmpMovement_Corrective_Count AS (SELECT COUNT(*) AS myCOUNT FROM tmpMovement_Corrective)
          INSERT INTO _tmpResult (MovementId_Corrective, MovementId_Tax, GoodsId, GoodsKindId, Amount, OperPrice, CountForPrice)
             SELECT COALESCE (tmpMovement_Corrective.MovementId_Corrective, 0)
                  , COALESCE (tmpMovement_Corrective.MovementId_Tax, 0)
                  , GoodsId, GoodsKindId, Amount, OperPrice, CountForPrice
             FROM _tmpMI_Return
                  LEFT JOIN tmpMovement_Corrective_Count ON tmpMovement_Corrective_Count.myCOUNT = 1
                  LEFT JOIN tmpMovement_Corrective ON tmpMovement_Corrective_Count.myCOUNT IS NOT NULL
            ;
     ELSE
         -- курсор1 - возвраты
         OPEN curMI_ReturnIn FOR
              SELECT GoodsId, GoodsKindId, Amount, OperPrice FROM _tmpMI_Return;

         -- начало цикла по курсору1 - возвраты
         LOOP
              -- данные по возвратам
              FETCH curMI_ReturnIn INTO vbGoodsId, vbGoodsKindId, vbAmount, vbOperPrice;
              -- если данные закончились, тогда выход
              IF NOT FOUND THEN EXIT; END IF;


     -- 
     DELETE FROM _tmp1_SubQuery;
     DELETE FROM _tmp2_SubQuery;
     -- данные для курсор2 - отдельно !!!для оптимизации!!!
     INSERT INTO _tmp1_SubQuery (MovementId, OperDate, isRegistered, Amount)
                         SELECT Movement.Id AS MovementId
                              , Movement.OperDate
                              , COALESCE (MB_Registered.ValueData, FALSE) AS isRegistered
                              , SUM (MovementItem.Amount) AS Amount
                         FROM MovementLinkObject AS MLO_Partner
                              INNER JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                              ON MovementLinkMovement_Master.MovementId = MLO_Partner.MovementId
                                                             AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                              INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Master.MovementChildId
                                                 AND Movement.DescId = zc_Movement_Tax()
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                                 AND Movement.OperDate BETWEEN '01.08.2013' :: TDateTime AND vbOperDate - interval '1 day'
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                           AND MovementLinkObject_Contract.ObjectId = vbContractId
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
                           AND MLO_Partner.DescId IN (zc_MovementLinkObject_To(), zc_MovementLinkObject_Partner())
                         GROUP BY Movement.Id
                                , Movement.OperDate
                                , MB_Registered.ValueData;
                        
     -- данные для курсор2 - отдельно !!!для оптимизации!!!
              WITH tmpMovement AS (SELECT Movement.Id
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
                                   WHERE Movement.DescId = zc_Movement_TaxCorrective()
                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                                   GROUP BY Movement.Id)
     INSERT INTO _tmp2_SubQuery (MovementId_Tax, Amount)
                                   SELECT CASE WHEN MLM_Master.MovementChildId = inMovementId THEN 0 ELSE MLM_Child.MovementChildId END AS MovementId_Tax
                                        , SUM (Movement.Amount) AS Amount
                                   FROM tmpMovement AS Movement
                                        INNER JOIN MovementLinkMovement AS MLM_Child
                                                                        ON MLM_Child.MovementId = Movement.Id
                                                                       AND MLM_Child.DescId = zc_MovementLinkMovement_Child()
                                        INNER JOIN MovementLinkMovement AS MLM_Master
                                                                        ON MLM_Master.MovementId = Movement.Id
                                                                       AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
                                   GROUP BY CASE WHEN MLM_Master.MovementChildId = inMovementId THEN 0 ELSE MLM_Child.MovementChildId END;

              -- курсор2 - все налоговые !!!за минусом прошлых корректировок!!! по товару и цене
              OPEN curMI_Tax FOR
                   SELECT tmpMovement_Tax.MovementId
                        , tmpMovement_Tax.Amount - COALESCE (tmpMovement_Corrective.Amount, 0) AS Amount
                         -- это все налоговые по покупатель, товар и цена
                   FROM _tmp1_SubQuery AS tmpMovement_Tax
                        -- это !!!все!!! корректировки по товар и цена (для !!!всех!!! налоговых)
                        LEFT JOIN _tmp2_SubQuery AS tmpMovement_Corrective ON tmpMovement_Corrective.MovementId_Tax = tmpMovement_Tax.MovementId
                   WHERE tmpMovement_Tax.Amount > COALESCE (tmpMovement_Corrective.Amount, 0)
                     AND tmpMovement_Tax.isRegistered = FALSE
                   ORDER BY tmpMovement_Tax.OperDate DESC, 2 DESC
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
                      INSERT INTO _tmpResult (MovementId_Corrective, MovementId_Tax, GoodsId, GoodsKindId, Amount, OperPrice, CountForPrice)
                         SELECT 0, vbMovementId_Tax, vbGoodsId, vbGoodsKindId, vbAmount, vbOperPrice, 1 AS CountForPrice;
                      -- обнуляем кол-во что бы больше не искать
                      vbAmount:= 0;
                  ELSE
                      -- получилось в налоговой меньше чем искали, !!!сохраняем в табл-результата!!!
                      INSERT INTO _tmpResult (MovementId_Corrective, MovementId_Tax, GoodsId, GoodsKindId, Amount, OperPrice, CountForPrice)
                         SELECT 0, vbMovementId_Tax, vbGoodsId, vbGoodsKindId, vbAmount_Tax, vbOperPrice, 1 AS CountForPrice;
                      -- уменьшаем на кол-во которое нашли и продолжаем поиск
                      vbAmount:= vbAmount - vbAmount_Tax;
                  END IF;

              END LOOP; -- финиш цикла по курсору2 - налоговые
              CLOSE curMI_Tax; -- закрыли курсор2 - налоговые

         END LOOP; -- финиш цикла по курсору1 - возвраты
         CLOSE curMI_ReturnIn; -- закрыли курсор1 - возвраты

     END IF; -- завершили привязку к налоговым или не привязку (т.е. все данные в табл-результат)


     -- !!!осталось сохранить данные!!!!


     -- находим те корректировки что есть у текущего <Возврат от покупателя> или <Перевод долга (приход)>
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


     -- распроводим/восстанавливаем найденные документы
     PERFORM lpUnComplete_Movement (inMovementId       := tmpResult_update.MovementId_Corrective
                                  , inUserId           := vbUserId
                                   )
     FROM (SELECT MovementId_Corrective
           FROM _tmpResult
           WHERE MovementId_Corrective <> 0
           GROUP BY MovementId_Corrective
          ) AS tmpResult_update;

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
                                 , inUserId           := vbUserId
                                  )
     FROM (SELECT _tmpMovement_find.MovementId_Corrective
           FROM _tmpMovement_find
                 LEFT JOIN _tmpResult ON _tmpResult.MovementId_Corrective = _tmpMovement_find.MovementId_Corrective
           WHERE _tmpResult.MovementId_Corrective IS NULL
           GROUP BY _tmpMovement_find.MovementId_Corrective
          ) AS tmpResult_delete;



     -- меняем заголовок для существующих корректировок 
     PERFORM lpInsertUpdate_Movement_TaxCorrective (ioId               := tmpResult_update.MovementId_Corrective
                                                  , inInvNumber        := Movement.InvNumber
                                                  , inInvNumberPartner := COALESCE ((SELECT ValueData FROM MovementString WHERE MovementId = tmpResult_update.MovementId_Corrective AND DescId = zc_MovementString_InvNumberPartner()), '')
                                                  , inInvNumberBranch  := COALESCE ((SELECT ValueData FROM MovementString WHERE MovementId = tmpResult_update.MovementId_Corrective AND DescId = zc_MovementString_InvNumberBranch()), '')
                                                  , inOperDate         := vbOperDate
                                                  , inChecked          := COALESCE ((SELECT ValueData FROM MovementBoolean WHERE MovementId = tmpResult_update.MovementId_Corrective AND DescId = zc_MovementBoolean_Checked()), FALSE)
                                                  , inDocument         := COALESCE ((SELECT ValueData FROM MovementBoolean WHERE MovementId = tmpResult_update.MovementId_Corrective AND DescId = zc_MovementBoolean_Document()), FALSE)
                                                  , inPriceWithVAT     := FALSE -- в корректировках цены всегда будут без НДС -- vbPriceWithVAT
                                                  , inVATPercent       := vbVATPercent
                                                  , inFromId           := vbFromId
                                                  , inToId             := vbToId
                                                  , inPartnerId        := vbPartnerId
                                                  , inContractId       := vbContractId
                                                  , inDocumentTaxKindId:= inDocumentTaxKindId
                                                  , inUserId           := vbUserId
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
                                                       , inInvNumber        := tmpResult_insert.InvNumber :: TVarChar
                                                       , inInvNumberPartner := tmpResult_insert.InvNumberPartner :: TVarChar
                                                       , inInvNumberBranch  := ''
                                                       , inOperDate         := vbOperDate
                                                       , inChecked          := FALSE
                                                       , inDocument         := FALSE
                                                       , inPriceWithVAT     := FALSE -- в корректировках цены всегда будут без НДС -- vbPriceWithVAT
                                                       , inVATPercent       := vbVATPercent
                                                       , inFromId           := vbFromId
                                                       , inToId             := vbToId
                                                       , inPartnerId        := vbPartnerId
                                                       , inContractId       := vbContractId
                                                       , inDocumentTaxKindId:= inDocumentTaxKindId
                                                       , inUserId           := vbUserId
                                                      ) AS MovementId_Corrective
                , tmpResult_insert.MovementId_Tax
           FROM (SELECT NEXTVAL ('movement_taxcorrective_seq') AS InvNumber
                      , lpInsertFind_Object_InvNumberTax (zc_Movement_TaxCorrective(), vbOperDate, CASE WHEN lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective()) = zc_Enum_Process_AccessKey_DocumentOdessa()
                                                                                                             THEN '6' -- !!!Одесса!!!
                                                                                                        ELSE ''
                                                                                                   END) AS InvNumberPartner
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
                                                      , inPrice              := _tmpResult.OperPrice
                                                      , ioCountForPrice      := _tmpResult.CountForPrice
                                                      , inGoodsKindId        := _tmpResult.GoodsKindId
                                                      , inUserId             := vbUserId
                                                       )
     FROM _tmpResult;


     -- сохранили связь с <Тип формирования налогового документа> у <Возврат от покупателя> или <Перевод долга (приход)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), inMovementId, inDocumentTaxKindId);

     -- сформировали связь Корректировок с <Возврат от покупателя> или <Перевод долга (приход)>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), MovementId_Corrective, inMovementId)
     FROM (SELECT MovementId_Corrective
           FROM _tmpResult
           GROUP BY MovementId_Corrective
          ) AS tmpResult_update;

     -- сформировали связь Корректировок с Налоговыми
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), MovementId_Corrective, MovementId_Tax)
     FROM (SELECT MovementId_Corrective, MovementId_Tax
           FROM _tmpResult
           GROUP BY MovementId_Corrective, MovementId_Tax
          ) AS tmpResult_update;


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= tmpResult_update.MovementId_Corrective)
     FROM (SELECT MovementId_Corrective
           FROM _tmpResult
           GROUP BY MovementId_Corrective
          ) AS tmpResult_update;


     -- ФИНИШ - Проводим все Корректировки
     PERFORM lpComplete_Movement_TaxCorrective (inMovementId := tmpResult_complete.MovementId_Corrective
                                              , inUserId     := vbUserId)
     FROM (SELECT MovementId_Corrective
           FROM _tmpResult
           GROUP BY MovementId_Corrective
          ) AS tmpResult_complete;


     -- результат
     IF (SELECT COUNT(*) FROM (SELECT MovementId_Corrective FROM _tmpResult GROUP BY MovementId_Corrective) AS tmp) = 1
     THEN
         outMovementId_Corrective:= (SELECT MAX (MovementId_Corrective) FROM _tmpResult);
     END IF;

     -- результат
     SELECT Object_TaxKind.Id, Object_TaxKind.ValueData
            INTO outDocumentTaxKindId, outDocumentTaxKindName
     FROM Object AS Object_TaxKind
     WHERE Object_TaxKind.Id = inDocumentTaxKindId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_TaxCorrective_From_Kind (Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 31.07.14                                        * add outMovementId_Corrective
 06.06.14                                        * add проверка - проведенные/удаленные документы Изменять нельзя
 03.06.14                                        * add в налоговых цены всегда будут без НДС + в корректировках цены всегда будут без НДС
 03.06.14                                        * add zc_Movement_PriceCorrective
 29.05.14                                        * add zc_MovementLinkObject_Partner
 20.05.14                                        * add zc_Movement_TransferDebtIn
 10.05.14                                        * add lpComplete_Movement_TaxCorrective
 01.05.14                                        * add lpInsertFind_Object_InvNumberTax
 10.04.14                                        * ALL
 13.02.14                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_TaxCorrective_From_Kind (inMovementId := 21838, inDocumentTaxKindId:=80770, inSession := '5');
