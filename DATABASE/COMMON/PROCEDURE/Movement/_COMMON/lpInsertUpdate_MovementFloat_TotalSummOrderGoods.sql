-- Function: lpInsertUpdate_MovementFloat_TotalSummOrderGoods (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummOrderGoods (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummOrderGoods(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$

  DECLARE vbTotalCountKg  TFloat;
  DECLARE vbTotalCountSh  TFloat;
  DECLARE vbTotalCount    TFloat;
  DECLARE vbTotalSummMVAT TFloat;
  DECLARE vbTotalSummPVAT TFloat;
  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent    TFloat;
  
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;

    -- НДС
    SELECT COALESCE (ObjectBoolean_PriceWithVAT.ValueData, FALSE)
         , ObjectFloat_VATPercent.ValueData     AS VATPercent
  INTO vbPriceWithVAT, vbVATPercent
    FROM MovementLinkObject AS MovementLinkObject_PriceList
         LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                 ON ObjectBoolean_PriceWithVAT.ObjectId = MovementLinkObject_PriceList.ObjectId
                                AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
         LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                               ON ObjectFloat_VATPercent.ObjectId = MovementLinkObject_PriceList.ObjectId
                              AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
    WHERE MovementLinkObject_PriceList.MovementId = inMovementId
      AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
    ;

    SELECT SUM (CASE WHEN COALESCE (MovementItem.Amount,0) <> 0
                  THEN MovementItem.Amount
                  ELSE MIFloat_AmountSecond.ValueData
             END)                                AS TotalCountSh
             
             
         , SUM (MovementItem.Amount)                             AS TotalCountKg

         , SUM (MIFloat_AmountSecond.ValueData)                  AS TotalCountSh

           -- Сумма без НДС
         , SUM (CASE WHEN NOT vbPriceWithVAT OR vbVATPercent = 0
                          -- если цены без НДС или %НДС=0
                          THEN ( (CASE WHEN  Object_Measure.Id = zc_Measure_Sh()
                                         THEN (CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0 AND COALESCE (MovementItem.Amount,0) <> 0
                                                   THEN MovementItem.Amount / COALESCE (ObjectFloat_Weight.ValueData,1)
                                                   ELSE MIFloat_AmountSecond.ValueData
                                              END)
                                       ELSE (CASE WHEN COALESCE (MovementItem.Amount,0) <> 0
                                                  THEN COALESCE (MovementItem.Amount,0)
                                                  ELSE MIFloat_AmountSecond.ValueData * CASE WHEN  Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData,1) ELSE 1 END
                                             END )
                                  END)
                          * COALESCE(MovementItemFloat_Price.ValueData,0))
                     WHEN vbPriceWithVAT = TRUE
                          -- если цены c НДС
                          THEN CAST ( ((CASE WHEN  Object_Measure.Id = zc_Measure_Sh()
                                              THEN (CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0 AND COALESCE (MovementItem.Amount,0) <> 0
                                                        THEN MovementItem.Amount / COALESCE (ObjectFloat_Weight.ValueData,1)
                                                        ELSE MIFloat_AmountSecond.ValueData
                                                   END)
                                            ELSE (CASE WHEN COALESCE (MovementItem.Amount,0) <> 0
                                                       THEN COALESCE (MovementItem.Amount,0)
                                                       ELSE MIFloat_AmountSecond.ValueData * CASE WHEN  Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData,1) ELSE 1 END
                                                  END )
                                       END) * COALESCE(MovementItemFloat_Price.ValueData,0)) / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                     WHEN vbPriceWithVAT
                          -- если цены c НДС
                          THEN ((CASE WHEN  Object_Measure.Id = zc_Measure_Sh()
                                         THEN (CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0 AND COALESCE (MovementItem.Amount,0) <> 0
                                                   THEN MovementItem.Amount / COALESCE (ObjectFloat_Weight.ValueData,1)
                                                   ELSE MIFloat_AmountSecond.ValueData
                                              END)
                                       ELSE (CASE WHEN COALESCE (MovementItem.Amount,0) <> 0
                                                  THEN COALESCE (MovementItem.Amount,0)
                                                  ELSE MIFloat_AmountSecond.ValueData * CASE WHEN  Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData,1) ELSE 1 END
                                             END )
                                  END) * COALESCE(MovementItemFloat_Price.ValueData,0)) - CAST ( ((CASE WHEN  Object_Measure.Id = zc_Measure_Sh()
                                                                                                          THEN (CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0 AND COALESCE (MovementItem.Amount,0) <> 0
                                                                                                                    THEN MovementItem.Amount / COALESCE (ObjectFloat_Weight.ValueData,1)
                                                                                                                    ELSE MIFloat_AmountSecond.ValueData
                                                                                                               END)
                                                                                                        ELSE (CASE WHEN COALESCE (MovementItem.Amount,0) <> 0
                                                                                                                   THEN COALESCE (MovementItem.Amount,0)
                                                                                                                   ELSE MIFloat_AmountSecond.ValueData * CASE WHEN  Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData,1) ELSE 1 END
                                                                                                              END )
                                                                                                   END) * COALESCE(MovementItemFloat_Price.ValueData,0)) / (100 / vbVATPercent + 1) AS NUMERIC (16, 2))
                END) AS TotalSummMVAT

           -- Сумма с НДС
         ,SUM (CASE -- если цены с НДС
                WHEN vbPriceWithVAT OR vbVATPercent = 0
                     THEN ((CASE WHEN  Object_Measure.Id = zc_Measure_Sh()
                                   THEN (CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0 AND COALESCE (MovementItem.Amount,0) <> 0
                                             THEN MovementItem.Amount / COALESCE (ObjectFloat_Weight.ValueData,1)
                                             ELSE MIFloat_AmountSecond.ValueData
                                        END)
                                 ELSE (CASE WHEN COALESCE (MovementItem.Amount,0) <> 0
                                            THEN COALESCE (MovementItem.Amount,0)
                                            ELSE MIFloat_AmountSecond.ValueData * CASE WHEN  Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData,1) ELSE 1 END
                                       END )
                            END) * COALESCE(MovementItemFloat_Price.ValueData,0))
                -- если цены без НДС
                WHEN vbVATPercent > 0
                     THEN CAST ( (1 + vbVATPercent / 100) * ((CASE WHEN  Object_Measure.Id = zc_Measure_Sh()
                                                                     THEN (CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0 AND COALESCE (MovementItem.Amount,0) <> 0
                                                                               THEN MovementItem.Amount / COALESCE (ObjectFloat_Weight.ValueData,1)
                                                                               ELSE MIFloat_AmountSecond.ValueData
                                                                          END)
                                                                   ELSE (CASE WHEN COALESCE (MovementItem.Amount,0) <> 0
                                                                              THEN COALESCE (MovementItem.Amount,0)
                                                                              ELSE MIFloat_AmountSecond.ValueData * CASE WHEN  Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData,1) ELSE 1 END
                                                                         END )
                                                              END) * COALESCE(MovementItemFloat_Price.ValueData,0)) AS NUMERIC (16, 2))
           END) AS TotalSummPVAT

     INTO vbTotalCount
        , vbTotalCountKg
        , vbTotalCountSh
        , vbTotalSummMVAT
        , vbTotalSummPVAT
    FROM MovementItem
        LEFT OUTER JOIN MovementItemFloat AS MovementItemFloat_Price
                                          ON MovementItemFloat_Price.MovementItemId = MovementItem.Id
                                         AND MovementItemFloat_Price.DescId = zc_MIFloat_Price()
        LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                    ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                             ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                              ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
    WHERE MovementItem.MovementId = inMovementId 
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased = false;


    -- Сохранили свойство <Итого количество>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCount);
    -- Сохранили свойство <Итого количество>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountKg(), inMovementId, vbTotalCountKg);
    -- Сохранили свойство <Итого количество>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountSh(), inMovementId, vbTotalCountSh);

    -- Сохранили свойство <Итого сумма по накладной (без НДС)>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMVAT(), inMovementId, vbTotalSummMVAT);
    -- Сохранили свойство <Итого сумма по накладной (c НДС)>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPVAT(), inMovementId, vbTotalSummPVAT);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 09.07.16         * 
*/
