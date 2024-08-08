-- Function: gpInsertUpdate_Movement_OrderClient()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderClient_Summ (Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderClient_Summ (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderClient_Summ (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderClient_Summ (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderClient_Summ (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderClient_Summ(
    IN inId                          Integer, -- Ключ объекта <Документ>
 INOUT ioSummTax                     TFloat,  -- 
 INOUT ioSummReal                    TFloat,  -- 
    IN inVATPercent                  TFloat,  --
    IN inDiscountTax                 TFloat,  --
    IN inDiscountNextTax             TFloat,  -- 
    IN inTransportSumm_load          TFloat,  --транспорт 
    IN inTransportSumm               TFloat,  --транспорт 
    IN inBasis_summ1_orig            TFloat,  -- Без скидки, Цена продажи базовой модели лодки, без НДС
    IN inBasis_summ2_orig            TFloat,  -- Без скидки, Сумма опций, без НДС
   OUT outSummDiscount1              TFloat, 
   OUT outSummDiscount2              TFloat,
   OUT outSummDiscount3              TFloat,
   OUT outSummDiscount_total         TFloat,
   OUT outBasis_summ                 TFloat,
 INOUT ioBasis_summ_transport        TFloat,
 INOUT ioBasisWVAT_summ_transport    TFloat,
   OUT outTotalSummVAT               TFloat,
    IN inAmountInBankAccountAll      TFloat,  -- итого оплата для Эдит формы лодки
   OUT outAmountIn_remAll            TFloat,  -- Долг Итого  - для Эдит формы лодки 
    IN inIsBefore                    Boolean, -- временный расчет на форме 
    IN inIsEdit                      Boolean, 
    IN inSession                     TVarChar -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbNPP_old TFloat;
   DECLARE vbDiscountTax TFloat;
   DECLARE vbDiscountNextTax TFloat;
   DECLARE vbBasisWVAT_summ_transport TFloat;
   DECLARE vbBasis_summ_transport TFloat;
   DECLARE vbSummReal TFloat;
   DECLARE vbSummTax TFloat;
   DECLARE vbTransportsumm_load TFloat; 
   DECLARE vbTransportsumm      TFloat;  
   DECLARE vbVATPercent TFloat;
   DECLARE vbTotalSumm TFloat;
   DECLARE vbisVat Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderClient());
     vbUserId := lpGetUserBySession (inSession);
     
     --RETURN;

     -- если надо только сохранить
     IF inIsBefore = FALSE AND inIsEdit = TRUE
     THEN
     -- сохранили значение <НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), inId, inVATPercent);
     -- сохранили значение <% скидки>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountTax(), inId, inDiscountTax);
     -- сохранили значение <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountNextTax(), inId, inDiscountNextTax);
     -- сохранили значение <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TransportSumm_load(), inId, inTransportSumm_load);
     -- сохранили значение <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TransportSumm(), inId, inTransportSumm);

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

     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummTax(), inId, ioSummTax); 
     -- сохранили значение <ИТОГО откорректированная сумма, с учетом всех скидок, без Транспорта, Сумма продажи без НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummReal(), inId, ioSummReal);

     ELSE
 
         -- Получаем сохраненные параметры - для расчета в эдит форме
         IF inIsEdit = FALSE
         THEN
          vbDiscountTax    := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_DiscountTax());
          vbDiscountNextTax:= (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_DiscountNextTax());
          vbSummTax        := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummTax());
          
          vbTotalSumm      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TotalSumm());
          vbTransportSumm_load := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TransportSumm_load());
          vbTransportSumm      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TransportSumm());
          vbVATPercent     := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_VATPercent()); 
          --vbisVat          := FALSE;
          --vbBasis_summ_transport    := (COALESCE (vbTotalSumm,0) - COALESCE (vbSummTax,0) + COALESCE (vbTransportSumm_load,0));
          --vbBasisWVAT_summ_transport:= zfCalc_SummWVAT (vbBasis_summ_transport, vbVATPercent);
          --vbSummReal       := (COALESCE (vbTotalSumm,0) - COALESCE (vbSummTax,0));    
          vbBasis_summ_transport    := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_Basis_summ_transport_calc());
          vbBasisWVAT_summ_transport:= (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_BasisWVAT_summ_transport_calc());
          vbSummReal       := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummReal_calc());
          vbisVat          := COALESCE( (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inId AND MB.DescId = zc_MovementBoolean_isVat_calc()), FALSE);
         END IF;
   
         IF inIsEdit = TRUE
         THEN
          vbDiscountTax    := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_DiscountTax_calc());
          vbDiscountNextTax:= (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_DiscountNextTax_calc());

          vbSummTax        := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummTax_calc());
          vbSummReal       := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummReal_calc());
          vbBasis_summ_transport    := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_Basis_summ_transport_calc());
          vbBasisWVAT_summ_transport:= (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_BasisWVAT_summ_transport_calc());
          vbTransportSumm_load      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TransportSumm_load_calc());
          vbTransportSumm           := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TransportSumm_calc());
          vbVATPercent     := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_VATPercent_calc()); 
          vbisVat          := COALESCE( (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inId AND MB.DescId = zc_MovementBoolean_isVat_calc()),FALSE); --какое значение вносилось последним с НДС  Да - нет
     END IF;


    
      outSummDiscount1 :=  zfCalc_SummDiscount(COALESCE (inBasis_summ1_orig, 0), inDiscountTax);
      outSummDiscount2 :=  zfCalc_SummDiscount(COALESCE (inBasis_summ1_orig, 0) - zfCalc_SummDiscount(COALESCE (inBasis_summ1_orig, 0), inDiscountTax), inDiscountNextTax);
      --outSummDiscount3 := (zfCalc_SummDiscount(COALESCE (inBasis_summ2_orig, 0), inDiscountTax) +  zfCalc_SummDiscount(COALESCE (inBasis_summ2_orig, 0) - zfCalc_SummDiscount(COALESCE (inBasis_summ2_orig, 0), inDiscountTax), inDiscountNextTax));
      outSummDiscount3 := (COALESCE (inBasis_summ2_orig, 0)
                        - (-- выбор данных по опциям
                          WITH
                          tmpProdOptItems AS (SELECT tmp.*
                                              FROM gpSelect_Object_ProdOptItems (inMovementId_OrderClient:= inId, inIsShowAll:= FALSE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                              WHERE tmp.MovementId_OrderClient = inId
                                             )
                          SELECT SUM (CASE WHEN COALESCE (tmpProdOptItems.DiscountTax,0) <> 0 THEN zfCalc_SummDiscountTax (tmpProdOptItems.Sale_summ, COALESCE (tmpProdOptItems.DiscountTax,0)) 
                                                ELSE zfCalc_SummDiscountTax (zfCalc_SummDiscountTax (tmpProdOptItems.Sale_summ, COALESCE (inDiscountTax,0)), COALESCE (inDiscountNextTax,0) ) 
                                      END
                                      ) AS Sale_summ_OptItems
                          FROM tmpProdOptItems
                          ) ) ;
                               

        
         

         outSummDiscount_total := (COALESCE (outSummDiscount1,0) + COALESCE (outSummDiscount2,0) + COALESCE (outSummDiscount3,0));
         outBasis_summ := (COALESCE (inBasis_summ1_orig, 0) + COALESCE (inBasis_summ2_orig, 0) - COALESCE (outSummDiscount_total,0)); 

         outAmountIn_remAll := (COALESCE (ioBasisWVAT_summ_transport,0) - COALESCE (inAmountInBankAccountAll,0));
--RAISE EXCEPTION '2 Ошибка. Basis_summ_transport %    .', outSummDiscount_total;   

          -- если ничего не поменялось
         IF vbDiscountTax = inDiscountTax AND vbDiscountNextTax = inDiscountNextTax
            AND vbSummTax = ioSummTax AND vbSummReal = ioSummReal
            AND vbBasis_summ_transport = ioBasis_summ_transport AND vbBasisWVAT_summ_transport = ioBasisWVAT_summ_transport
            AND vbTransportSumm_load = inTransportSumm_load
            AND vbTransportSumm = inTransportSumm
            AND vbVATPercent = inVATPercent
         THEN
             -- !!!выход!!!
             RETURN;
         END IF;

         --vbisVat:= COALESCE (vbisVat,FALSE);

         --процент НДС  
         IF COALESCE (vbVATPercent,0) <> COALESCE (inVATPercent,0)
         THEN  
  
             IF COALESCE (vbisVat, False) = FALSE
             THEN
                 ioBasisWVAT_summ_transport := zfCalc_SummWVAT (vbBasis_summ_transport, inVATPercent);
                 ioSummTax :=  (outBasis_summ - (COALESCE (ioBasis_summ_transport,0) - COALESCE (inTransportSumm_load,0)- COALESCE (inTransportSumm,0)));
             ELSE
                 ioBasis_summ_transport := zfCalc_Summ_NoVAT (vbBasisWVAT_summ_transport, inVATPercent); 
                 ioBasisWVAT_summ_transport := zfCalc_SummWVAT (ioBasis_summ_transport, inVATPercent);
                 ioSummTax := (outBasis_summ - (zfCalc_Summ_NoVAT (ioBasisWVAT_summ_transport, inVATPercent) - COALESCE (inTransportSumm_load,0) - COALESCE (inTransportSumm,0))); 
             END IF; 
         --сумма со скидкой и транспортом без НДС
         ELSEIF COALESCE (vbBasis_summ_transport,0) <> COALESCE (ioBasis_summ_transport,0)
         THEN 
             --RAISE EXCEPTION '2 Ошибка. Basis_summ_transport %    -  %.', vbBasis_summ_transport, ioBasis_summ_transport;    
             --
             ioSummTax := (outBasis_summ - (COALESCE (ioBasis_summ_transport,0) - COALESCE (inTransportSumm_load,0)- COALESCE (inTransportSumm,0)));
             --
             PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isVat_calc(), inId, FALSE);
         -- сумма с НДС
         ELSEIF COALESCE (vbBasisWVAT_summ_transport,0) <> COALESCE (ioBasisWVAT_summ_transport,0)
         THEN  
            -- RAISE EXCEPTION '3 Ошибка. BasisWVAT_summ_transport %    -  %.', vbBasisWVAT_summ_transport, ioBasisWVAT_summ_transport;  
             --   
             ioSummTax := (outBasis_summ - (zfCalc_Summ_NoVAT (ioBasisWVAT_summ_transport, inVATPercent) - COALESCE (inTransportSumm_load,0) - COALESCE (inTransportSumm,0)) );
             --
             PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isVat_calc(), inId, True);
         --- изменилась ручн. скидка
         ELSEIF COALESCE (vbSummTax,0) <> COALESCE (ioSummTax,0)
         THEN  

             ioSummReal := outBasis_summ - COALESCE (ioSummTax,0); 
         --
         ELSEIF COALESCE (vbSummReal,0) <> COALESCE (ioSummReal,0)
         THEN
          --  RAISE EXCEPTION '5 Ошибка. SummReal %    -  %.', vbSummReal, ioSummReal;  
             ---
             ioSummTax:= COALESCE (outBasis_summ, 0) - ioSummReal; 
         END IF;      
         

         ioSummReal := COALESCE (outBasis_summ,0) - COALESCE (ioSummTax,0); 
         ioBasis_summ_transport := (COALESCE (outBasis_summ,0) - COALESCE (ioSummTax) + COALESCE (inTransportSumm_load,0)+ COALESCE (inTransportSumm,0)); 
         ioBasisWVAT_summ_transport := zfCalc_SummWVAT (ioBasis_summ_transport, inVATPercent);       

         outTotalSummVAT := ioBasisWVAT_summ_transport - ioBasis_summ_transport;
         
         --для єдит формі лодки
         outAmountIn_remAll := (COALESCE (ioBasisWVAT_summ_transport,0) - COALESCE (inAmountInBankAccountAll,0));
         
         --
         PERFORM lpInsertUpdate_MovementFloat (CASE WHEN inIsEdit = FALSE
                                                   THEN zc_MovementFloat_SummTax()
                                                   ELSE zc_MovementFloat_SummTax_calc()
                                              END, inId, ioSummTax);
       
         PERFORM lpInsertUpdate_MovementFloat (CASE WHEN inIsEdit = FALSE
                                                   THEN zc_MovementFloat_TransportSumm_load()
                                                   ELSE zc_MovementFloat_TransportSumm_load_calc()
                                              END, inId, inTransportSumm_load);

         PERFORM lpInsertUpdate_MovementFloat (CASE WHEN inIsEdit = FALSE
                                                   THEN zc_MovementFloat_TransportSumm()
                                                   ELSE zc_MovementFloat_TransportSumm_calc()
                                              END, inId, inTransportSumm);


         PERFORM lpInsertUpdate_MovementFloat (CASE WHEN inIsEdit = FALSE
                                                   THEN zc_MovementFloat_VATPercent()
                                                   ELSE zc_MovementFloat_VATPercent_calc()
                                              END, inId, inVATPercent);

         --IF inIsEdit = TRUE
         --THEN
              --
              PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Basis_summ_transport_calc(), inId, ioBasis_summ_transport);
              --
              PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_BasisWVAT_summ_transport_calc(), inId, ioBasisWVAT_summ_transport); 
              --
              PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummReal_calc(), inId, ioSummReal);

         --END IF;        
     
         IF inIsEdit = FALSE
         THEN
             -- сохранили значение <% скидки>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountTax(), inId, inDiscountTax);
             -- сохранили значение <% скидки доп>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountNextTax(), inId, inDiscountNextTax);
         END IF;
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
/*
select * from gpUpdate_Movement_OrderClient_Summ(inId := 664 , ioSummTax := 0 , ioSummReal := 0 , inVATPercent := 19 , inDiscountTax := 0 , inDiscountNextTax := 10
 , inTransportSumm_load := 1000 , inBasis_summ1_orig := 19950 , inBasis_summ2_orig := 13220
 , ioBasis_summ_transport := 24882.4 , ioBasisWVAT_summ_transport := 29610.04 , inAmountInBankAccountAll := 0, IsBefore := 'True' , inIsEdit := 'True' ,  inSession := '5');
*/
