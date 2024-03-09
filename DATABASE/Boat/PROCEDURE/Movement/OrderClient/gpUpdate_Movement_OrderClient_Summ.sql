-- Function: gpInsertUpdate_Movement_OrderClient()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderClient_Summ (Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderClient_Summ (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderClient_Summ(
    IN inId                          Integer   , -- Ключ объекта <Документ>
 INOUT ioSummTax                     TFloat    , -- 
 INOUT ioSummReal                    TFloat    , -- 
    IN inVATPercent                  TFloat    , --
    IN inDiscountTax                 TFloat    , --
    IN inDiscountNextTax             TFloat    , -- 
    IN inTransportSumm_load          TFloat    , --транспорт 
    IN inBasis_summ1_orig            TFloat, --для врм. расчета на форме
    IN inBasis_summ2_orig            TFloat, --для врм. расчета на форме
   OUT outSummDiscount1              TFloat , 
   OUT outSummDiscount2              TFloat ,
   OUT outSummDiscount3              TFloat ,
   OUT outSummDiscount_total         TFloat ,
   OUT outBasis_summ                 TFloat ,
   OUT outBasis_summ_transport       TFloat,
   OUT outBasisWVAT_summ_transport   TFloat,
    IN inIsBefore                    Boolean   , -- временный расчет на форме 
    IN inSession                     TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbNPP_old TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderClient());
     vbUserId := lpGetUserBySession (inSession);

     IF inIsBefore = FALSE
     THEN
     -- сохранили значение <НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), inId, inVATPercent);
     -- сохранили значение <% скидки>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountTax(), inId, inDiscountTax);
     -- сохранили значение <% скидки доп>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountNextTax(), inId, inDiscountNextTax);
     -- сохранили значение <% скидки доп>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TransportSumm_load(), inId, inTransportSumm_load);

     -- Результат
     PERFORM lpInsert_MovementItemProtocol (MovementItem.MovementItemId, vbUserId, FALSE)
     FROM (SELECT MovementItem.MovementItemId
               , lpInsertUpdate_MovementItem_OrderClient (ioId            := MovementItem.MovementItemId
                                                        , inMovementId    := inId
                                                        , inGoodsId       := MovementItem.ProductId
                                                        , inAmount        := MovementItem.Amount
                                                          -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
                                                        , ioOperPrice     := MovementItem.Basis_summ
                                                          -- ИТОГО Сумма продажи без НДС - без Скидки (Basis+options)
                                                        , inOperPriceList := MovementItem.Basis_summ_orig
                                                          -- ИТОГО Сумма продажи без НДС - без Скидки (Basis)
                                                        , inBasisPrice    := MovementItem.Basis_summ1_orig
                                                          --
                                                        , inCountForPrice := 1  ::TFloat
                                                        , inComment       := COALESCE ((SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = MovementItem.MovementItemId AND MIS.DescId = zc_MIString_Comment()), '')
                                                        , inUserId        := vbUserId
                                                        )
           FROM (WITH gpSelect AS (SELECT gpSelect.Id AS ProductId, gpSelect.Basis_summ, gpSelect.Basis_summ_orig, gpSelect.Basis_summ1_orig
                                   FROM gpSelect_Object_Product (inId, FALSE, FALSE, vbUserId :: TVarChar) AS gpSelect
                                   WHERE gpSelect.MovementId_OrderClient = inId
                                  )
                      SELECT gpSelect.ProductId, gpSelect.Basis_summ, gpSelect.Basis_summ_orig, gpSelect.Basis_summ1_orig
                           , MovementItem.Id AS MovementItemId
                           , MovementItem.Amount
                      FROM MovementItem
                           JOIN gpSelect ON gpSelect.ProductId = MovementItem.ObjectId
                      WHERE MovementItem.MovementId = inId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                ) AS MovementItem
          ) AS MovementItem
     ;

     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm_order (inId);

     -- расчет после !!!пересчета!!!
     IF ioSummReal > 0
     THEN
         ioSummTax:= COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TotalSumm()), 0)
                   - ioSummReal
                    ;
     ELSE
         ioSummReal:= 0;
     END IF;

     -- сохранили значение <Cумма откорректированной скидки, без НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummTax(), inId, ioSummTax); 
     -- сохранили значение <ИТОГО откорректированная сумма, с учетом всех скидок, без Транспорта, Сумма продажи без НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummReal(), inId, ioSummReal);

     ELSE  
          outSummDiscount1 :=  zfCalc_SummDiscount(COALESCE (inBasis_summ1_orig, 0), inDiscountTax);
          outSummDiscount2 :=  zfCalc_SummDiscount(COALESCE (inBasis_summ1_orig, 0) - zfCalc_SummDiscount(COALESCE (inBasis_summ1_orig, 0), inDiscountTax), inDiscountNextTax);
          outSummDiscount3 := (zfCalc_SummDiscount(COALESCE (inBasis_summ2_orig, 0), inDiscountTax) +  zfCalc_SummDiscount(COALESCE (inBasis_summ2_orig, 0) - zfCalc_SummDiscount(COALESCE (inBasis_summ2_orig, 0), inDiscountTax), inDiscountNextTax));

          outSummDiscount_total := (COALESCE (outSummDiscount1,0) + COALESCE (outSummDiscount2,0) + COALESCE (outSummDiscount3,0));
          outBasis_summ := (COALESCE (inBasis_summ1_orig, 0) + COALESCE (inBasis_summ2_orig, 0) - COALESCE (outSummDiscount_total,0)); 

          IF ioSummReal > 0
          THEN
              ioSummTax:= COALESCE (outBasis_summ, 0) - ioSummReal; 
              outBasis_summ_transport := ioSummReal + COALESCE (inTransportSumm_load,0);
          ELSE
              ioSummReal:= 0;  
              ioSummTax := 0;
              outBasis_summ_transport := (COALESCE (outBasis_summ,0) + COALESCE (inTransportSumm_load,0));
          END IF;
     
          outBasisWVAT_summ_transport := zfCalc_SummWVAT (outBasis_summ_transport, inVATPercent);
     END IF;
 
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.05.23         *
*/

-- тест
--