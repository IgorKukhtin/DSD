-- Function: gpGet_Movement_OrderClient()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderClientEdit (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderClientEdit(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , VATPercent TFloat
               -- % скидки осн
             , DiscountTax TFloat
               -- % скидки доп
             , DiscountNextTax TFloat
               -- Cумма откорректированной скидки, без НДС
             , SummTax TFloat
               -- ИТОГО откорректированная сумма, с учетом всех скидок, без Транспорта, Сумма продажи без НДС
             , SummReal TFloat
             , SummReal_real TFloat
              -- ИТОГО Без скидки, Цена продажи базовой модели лодки, без НДС
             , Basis_summ1_orig        TFloat
               -- ИТОГО Без скидки, Сумма опций, без НДС
             , Basis_summ2_orig        TFloat
               -- ИТОГО Без скидки, Цена продажи базовой модели лодки + Сумма всех опций, без НДС
             , Basis_summ_orig         TFloat

               -- ИТОГО Сумма Скидки - без НДС
             , SummDiscount1           TFloat
             , SummDiscount2           TFloat
             , SummDiscount3           TFloat
             , SummDiscount_total      TFloat

               -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
             , Basis_summ              TFloat
               -- Сумма транспорт с сайта
             , TransportSumm_load     TFloat

              -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
             , Basis_summ_transport    TFloat
               -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
             , BasisWVAT_summ_transport TFloat 
             , t1 integer, t2 integer, t3 integer, t4 integer, t5 integer, t6 integer
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderClient());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Документ не сохранен.';
     END IF;

     RETURN QUERY
        WITH
        tmpSummProduct AS (SELECT  -- ИТОГО Без скидки, Цена продажи базовой модели лодки, без НДС
                                   gpSelect.Basis_summ1_orig
                                   -- ИТОГО Без скидки, Сумма опций, без НДС
                                 , gpSelect.Basis_summ2_orig
                                   -- ИТОГО Без скидки, Цена продажи базовой модели лодки + Сумма всех опций, без НДС
                                 , gpSelect.Basis_summ_orig

                                   -- ИТОГО Сумма Скидки - без НДС
                                 , gpSelect.SummDiscount1
                                 , gpSelect.SummDiscount2
                                 , gpSelect.SummDiscount3
                                 , gpSelect.SummDiscount_total

                                   -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
                                 , gpSelect.Basis_summ
                                   -- Сумма транспорт с сайта
                                 , gpSelect.TransportSumm_load

                                   -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
                                 , gpSelect.Basis_summ_transport
                                   -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
                                 , gpSelect.BasisWVAT_summ_transport

                           FROM gpSelect_Object_Product (inMovementId, FALSE, FALSE, '') AS gpSelect
                           WHERE gpSelect.MovementId_OrderClient = inMovementId
                          )
        -- Результат
        SELECT
            Movement_OrderClient.Id
            --
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)         :: TFloat AS VATPercent
          , COALESCE (MovementFloat_DiscountTax.ValueData, 0)        :: TFloat AS DiscountTax
          , COALESCE (MovementFloat_DiscountNextTax.ValueData, 0)    :: TFloat AS DiscountNextTax
            -- Cумма откорректированной скидки, без НДС
          , COALESCE (MovementFloat_SummTax.ValueData, 0)  :: TFLoat AS SummTax
            -- ИТОГО откорректированная сумма, с учетом всех скидок, без Транспорта, Сумма продажи без НДС
          , CASE WHEN MovementFloat_SummTax.ValueData <> 0 THEN COALESCE (tmpSummProduct.Basis_summ, 0) - MovementFloat_SummTax.ValueData ELSE 0 END :: TFloat AS SummReal
          , COALESCE (MovementFloat_SummReal.ValueData, 0) :: TFLoat AS SummReal_real
            -- 
            -- ИТОГО Без скидки, Цена продажи базовой модели лодки, без НДС
          ,  tmpSummProduct.Basis_summ1_orig        ::TFloat
            -- ИТОГО Без скидки, Сумма опций, без НДС
          , tmpSummProduct.Basis_summ2_orig         ::TFloat
            -- ИТОГО Без скидки, Цена продажи базовой модели лодки + Сумма всех опций, без НДС
          , tmpSummProduct.Basis_summ_orig          ::TFloat

            -- ИТОГО Сумма Скидки - без НДС
          , tmpSummProduct.SummDiscount1            ::TFloat
          , tmpSummProduct.SummDiscount2            ::TFloat
          , tmpSummProduct.SummDiscount3            ::TFloat
          , tmpSummProduct.SummDiscount_total       ::TFloat

            -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
          , tmpSummProduct.Basis_summ
           -- Сумма транспорт с сайта
          , tmpSummProduct.TransportSumm_load

           -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
          , tmpSummProduct.Basis_summ_transport
            -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
          , tmpSummProduct.BasisWVAT_summ_transport

         --  при открытии сохраняем текущие значения в расчетные
         , ( lpInsertUpdate_MovementFloat (zc_MovementFloat_SummTax_calc(), Movement_OrderClient.Id, COALESCE (MovementFloat_SummTax.ValueData, 0))) ::integer
         , lpInsertUpdate_MovementFloat (zc_MovementFloat_SummReal_calc(), Movement_OrderClient.Id, COALESCE (MovementFloat_SummReal.ValueData, 0))::integer
         , lpInsertUpdate_MovementFloat (zc_MovementFloat_TransportSumm_load_calc(), Movement_OrderClient.Id, tmpSummProduct.TransportSumm_load)::integer
         , lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent_calc(), Movement_OrderClient.Id, COALESCE (MovementFloat_VATPercent.ValueData, 0) )::integer
         , lpInsertUpdate_MovementFloat (zc_MovementFloat_Basis_summ_transport_calc(), Movement_OrderClient.Id, tmpSummProduct.Basis_summ_transport)    ::integer
         , lpInsertUpdate_MovementFloat (zc_MovementFloat_BasisWVAT_summ_transport_calc(), Movement_OrderClient.Id, tmpSummProduct.BasisWVAT_summ_transport)::integer
          
        FROM Movement AS Movement_OrderClient
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement_OrderClient.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                    ON MovementFloat_DiscountTax.MovementId = Movement_OrderClient.Id
                                   AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()

            LEFT JOIN MovementFloat AS MovementFloat_DiscountNextTax
                                    ON MovementFloat_DiscountNextTax.MovementId = Movement_OrderClient.Id
                                   AND MovementFloat_DiscountNextTax.DescId = zc_MovementFloat_DiscountNextTax()

            LEFT JOIN MovementFloat AS MovementFloat_SummReal
                                    ON MovementFloat_SummReal.MovementId = Movement_OrderClient.Id
                                   AND MovementFloat_SummReal.DescId = zc_MovementFloat_SummReal()

            LEFT JOIN MovementFloat AS MovementFloat_SummTax
                                    ON MovementFloat_SummTax.MovementId = Movement_OrderClient.Id
                                   AND MovementFloat_SummTax.DescId = zc_MovementFloat_SummTax()

            LEFT JOIN tmpSummProduct ON 1 = 1

        WHERE Movement_OrderClient.Id = inMovementId
          AND Movement_OrderClient.DescId = zc_Movement_OrderClient()
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.08.24         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderClientEdit (inMovementId:= 1, inSession:= zfCalc_UserAdmin())
