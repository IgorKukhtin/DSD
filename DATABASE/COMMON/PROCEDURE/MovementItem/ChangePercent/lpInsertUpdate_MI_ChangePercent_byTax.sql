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

     --перед записью удаляем сущ. строки и мастер и чайлд
      UPDATE MovementItem
      SET isErased = TRUE
      WHERE MovementItem.MovementId = inMovementId
      --  AND MovementItem.DescId     = zc_MI_Child()
        AND MovementItem.isErased   = FALSE;
 
 
      CREATE TEMP TABLE tmpTax (Id Integer) ON COMMIT DROP;
      INSERT INTO tmpTax (Id)
            SELECT Movement.Id 
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
              AND Movement.StatusId <> zc_Enum_Status_Erased()
              --AND (MovementLinkObject_Partner.ObjectId = vbPartnerId OR vbPartnerId = 0)
            ;


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
           tmpMI AS (SELECT MovementItem.*
                     FROM tmpTax
                          INNER JOIN MovementItem ON MovementItem.MovementId = tmpTax.Id
                                                 AND MovementItem.DescId = zc_MI_Master()
                                                 AND MovementItem.isErased = FALSE
                     )

         , tmpMILO AS (SELECT MovementItemLinkObject.*
                       FROM MovementItemLinkObject
                       WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                         AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind())
                       )

         , tmpMIFloat AS (SELECT MovementItemFloat.*
                          FROM MovementItemFloat
                          WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                            AND MovementItemFloat.DescId IN (zc_MIFloat_Price(), zc_MIFloat_CountForPrice())
                          )


         , tmpMI_Tax AS (SELECT MovementItem.ObjectId           AS GoodsId
                              , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                              , MIFloat_Price.ValueData         AS Price
                              , MIFloat_CountForPrice.ValueData AS CountForPrice
                              , SUM (MovementItem.Amount)       AS Amount
                         FROM tmpMI AS MovementItem
                              LEFT JOIN tmpMIFloat AS MIFloat_Price
                                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN tmpMIFloat AS MIFloat_CountForPrice
                                                   ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                  AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
 
                              LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                         GROUP BY MovementItem.ObjectId
                                , MILinkObject_GoodsKind.ObjectId
                                , MIFloat_Price.ValueData
                                , MIFloat_CountForPrice.ValueData 
                         )
        
         SELECT *
         FROM tmpMI_Tax
         ) AS tmp;

    
     --чайлд , данные из докю продажи из налоговых
     PERFORM lpInsertUpdate_MI_ChangePercent_Child (ioId          := 0
                                                  , inParentId    := tmp.ParentId
                                                  , inMovementId  := inMovementId
                                                  , inGoodsId     := tmp.GoodsRealId
                                                  , inGoodsKindId := tmp.GoodsKindRealId
                                                  , inUnitId      := tmp.UnitId
                                                  , inAmount      := tmp.AmountPartner
                                                  , inUserId      := inUserId
                                                  )
     FROM (WITH
           --находим док. продаж
           tmpSale AS (SELECT MLM_MovementLinkMovement.MovementId AS Id
                       FROM MovementLinkMovement AS MLM_MovementLinkMovement
                       WHERE MLM_MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                         AND MLM_MovementLinkMovement.MovementChildId IN (SELECT DISTINCT tmpTax.Id FROM tmpTax)
                       )
         , tmpMLO_From AS (SELECT MovementLinkObject.*
                           FROM MovementLinkObject 
                           WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpSale.Id FROM tmpSale)
                             AND MovementLinkObject.DescId =  zc_MovementLinkObject_From()
                           )

         , tmpMI AS (SELECT MovementLinkObject_From.ObjectId  AS UnitId
                          , MovementItem.ObjectId AS GoodsId
                          , MovementItem.Id
                     FROM tmpSale
                          INNER JOIN tmpMLO_From AS MovementLinkObject_From
                                                 ON MovementLinkObject_From.MovementId = tmpSale.Id

                          INNER JOIN MovementItem ON MovementItem.MovementId = tmpSale.Id
                                                 AND MovementItem.DescId = zc_MI_Master()
                                                 AND MovementItem.isErased = FALSE
                     )
  
         , tmpMILO AS (SELECT MovementItemLinkObject.*
                       FROM MovementItemLinkObject
                       WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                         AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsReal()
                                                             , zc_MILinkObject_GoodsKindReal()
                                                             , zc_MILinkObject_GoodsKind()
                                                              )
                       )

         , tmpMIFloat AS (SELECT MovementItemFloat.*
                          FROM MovementItemFloat
                          WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                            AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPartner(), zc_MIFloat_Price())
                          )

         , tmpMI_Sale AS (SELECT tmpMI.UnitId
                               , tmpMI.GoodsId AS GoodsId
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                               , COALESCE (MILinkObject_GoodsReal.ObjectId, tmpMI.GoodsId) AS GoodsRealId
                               , COALESCE (MILinkObject_GoodsKindReal.ObjectId, MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindRealId
                               , MIFloat_Price.ValueData AS Price
                               , SUM (COALESCE (MIFloat_AmountPartner.ValueData,0))                 AS AmountPartner 
                          FROM tmpMI
                               LEFT JOIN tmpMILO AS MILinkObject_GoodsReal
                                                 ON MILinkObject_GoodsReal.MovementItemId = tmpMI.Id
                                                AND MILinkObject_GoodsReal.DescId = zc_MILinkObject_GoodsReal()
                               LEFT JOIN tmpMILO AS MILinkObject_GoodsKindReal
                                                 ON MILinkObject_GoodsKindReal.MovementItemId = tmpMI.Id
                                                AND MILinkObject_GoodsKindReal.DescId = zc_MILinkObject_GoodsKindReal() 

                               LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                                 ON MILinkObject_GoodsKind.MovementItemId = tmpMI.Id
                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                               LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                                    ON MIFloat_AmountPartner.MovementItemId = tmpMI.Id
                                                   AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner() 
                               LEFT JOIN tmpMIFloat AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = tmpMI.Id
                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price() 

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                    ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpMI.GoodsId
                                                   AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

                          WHERE ObjectLink_Goods_GoodsGroup.ChildObjectId NOT IN (1960, 1865)
                         GROUP BY tmpMI.UnitId
                                , tmpMI.GoodsId 
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                , COALESCE (MILinkObject_GoodsReal.ObjectId, tmpMI.GoodsId)
                                , COALESCE (MILinkObject_GoodsKindReal.ObjectId, MILinkObject_GoodsKind.ObjectId, 0)
                                , MIFloat_Price.ValueData
                          )
         --сохраненные строки мастера
         , tmpMI_Master AS (SELECT * FROM gpSelect_MovementItem_ChangePercent (inMovementId:= inMovementId, inIsErased:= FALSE, inSession:= inUserId::TVarChar))

          SELECT tmpMI_Sale.GoodsRealId
               , tmpMI_Sale.GoodsKindRealId
               , tmpMI_Sale.UnitId
               , tmpMI_Master.Id AS ParentId
               , SUM (tmpMI_Sale.AmountPartner) AS AmountPartner
          FROM tmpMI_Sale
               LEFT JOIN tmpMI_Master ON tmpMI_Master.GoodsId = tmpMI_Sale.GoodsId
                                     AND tmpMI_Master.GoodsKindId = tmpMI_Sale.GoodsKindId
                                     AND tmpMI_Master.Price = tmpMI_Sale.Price
          GROUP BY tmpMI_Sale.GoodsRealId
                 , tmpMI_Sale.GoodsKindRealId
                 , tmpMI_Sale.UnitId
                 , tmpMI_Master.Id
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
--select * from gpSelect_MI_ChangePercent_Child(inMovementId := 24733245 , inIsErased := 'False' ,  inSession := '9457');


/*
  --данные их документа
     SELECT MovementLinkObject_To.ObjectId       AS ToId
          , MovementLinkObject_Contract.ObjectId AS ContractId
          , Movement.OperDate
          --, MovementLinkObject_Partner.ObjectId  AS PartnerId
  --  INTO vbToId, vbContractId, vbOperDate--, vbPartnerId
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

            / *LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            * /

     WHERE Movement.Id = 24930561 
     ;
            
            
            
             --чайлд , данные из докю продажи из налоговых
     SELECT lpInsertUpdate_MI_ChangePercent_Child (ioId          := 0
                                                  , inParentId    := tmp.ParentId
                                                  , inMovementId  := 24930561 
                                                  , inGoodsId     := tmp.GoodsRealId
                                                  , inGoodsKindId := tmp.GoodsKindRealId
                                                  , inUnitId      := tmp.UnitId
                                                  , inAmount      := tmp.AmountPartner
                                                  , inUserId      := 9457
                                                  )
     FROM (WITH 
     tmpTax AS (
            SELECT Movement.Id 
            FROM Movement
                 INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                             AND MovementLinkObject_To.ObjectId = 8793437 --vbToId

                 INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                              ON MovementLinkObject_Contract.MovementId = Movement.Id
                                             AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                             AND MovementLinkObject_Contract.ObjectId = 8875106 --vbContractId

                 / *LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                              ON MovementLinkObject_Partner.MovementId = Movement.Id
                                             AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()* /
            WHERE Movement.DescId = zc_Movement_Tax()
              AND Movement.OperDate BETWEEN '01.03.2023' AND '31.03.2023'--vbStartDate AND vbEndDate
              AND Movement.StatusId <> zc_Enum_Status_Erased()
              )
           --находим док. продаж
          , tmpSale AS (SELECT MLM_MovementLinkMovement.MovementId AS Id
                       FROM MovementLinkMovement AS MLM_MovementLinkMovement
                       WHERE MLM_MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                         AND MLM_MovementLinkMovement.MovementChildId IN (SELECT DISTINCT tmpTax.Id FROM tmpTax)
                       )
         , tmpMLO_From AS (SELECT MovementLinkObject.*
                           FROM MovementLinkObject 
                           WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpSale.Id FROM tmpSale)
                             AND MovementLinkObject.DescId =  zc_MovementLinkObject_From()
                           )

         , tmpMI AS (SELECT MovementLinkObject_From.ObjectId  AS UnitId
                          , MovementItem.ObjectId AS GoodsId
                          , MovementItem.Id
                     FROM tmpSale
                          INNER JOIN tmpMLO_From AS MovementLinkObject_From
                                                 ON MovementLinkObject_From.MovementId = tmpSale.Id

                          INNER JOIN MovementItem ON MovementItem.MovementId = tmpSale.Id
                                                 AND MovementItem.DescId = zc_MI_Master()
                                                 AND MovementItem.isErased = FALSE
                     )
  
         , tmpMILO AS (SELECT MovementItemLinkObject.*
                       FROM MovementItemLinkObject
                       WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                         AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsReal()
                                                             , zc_MILinkObject_GoodsKindReal()
                                                             , zc_MILinkObject_GoodsKind()
                                                              )
                       )

         , tmpMIFloat AS (SELECT MovementItemFloat.*
                          FROM MovementItemFloat
                          WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                            AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPartner(), zc_MIFloat_Price())
                          )

         , tmpMI_Sale AS (SELECT tmpMI.UnitId
                               , tmpMI.GoodsId AS GoodsId
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                               , COALESCE (MILinkObject_GoodsReal.ObjectId, tmpMI.GoodsId) AS GoodsRealId
                               , COALESCE (MILinkObject_GoodsKindReal.ObjectId, MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindRealId
                               , MIFloat_Price.ValueData AS Price
                               , SUM (COALESCE (MIFloat_AmountPartner.ValueData,0))                 AS AmountPartner 
                          FROM tmpMI
                               LEFT JOIN tmpMILO AS MILinkObject_GoodsReal
                                                 ON MILinkObject_GoodsReal.MovementItemId = tmpMI.Id
                                                AND MILinkObject_GoodsReal.DescId = zc_MILinkObject_GoodsReal()
                               LEFT JOIN tmpMILO AS MILinkObject_GoodsKindReal
                                                 ON MILinkObject_GoodsKindReal.MovementItemId = tmpMI.Id
                                                AND MILinkObject_GoodsKindReal.DescId = zc_MILinkObject_GoodsKindReal() 

                               LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                                 ON MILinkObject_GoodsKind.MovementItemId = tmpMI.Id
                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                               LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                                    ON MIFloat_AmountPartner.MovementItemId = tmpMI.Id
                                                   AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner() 
                               LEFT JOIN tmpMIFloat AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = tmpMI.Id
                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price() 


                               LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                    ON ObjectLink_Goods_GoodsGroup.ObjectId = COALESCE (MILinkObject_GoodsReal.ObjectId, tmpMI.GoodsId)
                                                   AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

                          WHERE ObjectLink_Goods_GoodsGroup.ChildObjectId NOT IN (1960, 1865)
                         GROUP BY tmpMI.UnitId
                                , tmpMI.GoodsId 
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                , COALESCE (MILinkObject_GoodsReal.ObjectId, tmpMI.GoodsId)
                                , COALESCE (MILinkObject_GoodsKindReal.ObjectId, MILinkObject_GoodsKind.ObjectId, 0)
                                , MIFloat_Price.ValueData
                          )
         --сохраненные строки мастера
        , tmpMI_Master AS (SELECT * FROM gpSelect_MovementItem_ChangePercent (inMovementId:= 24930561 , inIsErased:= FALSE, inSession:=  '9457'::TVarChar))

          SELECT tmpMI_Sale.GoodsRealId
               , tmpMI_Sale.GoodsKindRealId
               , tmpMI_Sale.UnitId
               , tmpMI_Master.Id AS ParentId
               , SUM (tmpMI_Sale.AmountPartner) AS AmountPartner
          FROM tmpMI_Sale
               LEFT JOIN tmpMI_Master ON tmpMI_Master.GoodsId = tmpMI_Sale.GoodsId
                                     AND tmpMI_Master.GoodsKindId = tmpMI_Sale.GoodsKindId
                                     AND tmpMI_Master.Price = tmpMI_Sale.Price
          GROUP BY tmpMI_Sale.GoodsRealId
                 , tmpMI_Sale.GoodsKindRealId
                 , tmpMI_Sale.UnitId
                 , tmpMI_Master.Id
          ) AS tmp; 

*/