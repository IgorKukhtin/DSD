-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_Movement_IncomeEdit (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_IncomeEdit(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , TotalSummMVAT TFloat
             , DiscountTax TFloat
             , SummTaxPVAT TFloat
             , SummTaxMVAT TFloat
             , SummPost TFloat
             , SummPack TFloat
             , SummInsur TFloat
             , TotalDiscountTax TFloat
             , TotalSummTaxPVAT TFloat
             , TotalSummTaxMVAT TFloat
             , Summ2 TFloat
             , Summ3 TFloat
             , Summ4 TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Income());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Документ не сохранен.';
     END IF;

     RETURN QUERY
        SELECT 
               Movement_Income.Id
             , MovementFloat_TotalSummMVAT.ValueData     :: TFloat AS TotalSummMVAT
               -- 1.1.
             , MovementFloat_DiscountTax.ValueData       :: TFloat AS DiscountTax
               -- 1.2.
             , MovementFloat_SummTaxPVAT.ValueData       :: TFloat AS SummTaxPVAT
               -- 1.3.
             , MovementFloat_SummTaxMVAT.ValueData       :: TFloat AS SummTaxMVAT
               -- 2.1.
             , MovementFloat_SummPost.ValueData          :: TFloat AS SummPost
               -- 2.2.
             , MovementFloat_SummPack.ValueData          :: TFloat AS SummPack
               -- 2.3.
             , MovementFloat_SummInsur.ValueData         :: TFloat AS SummInsur
               -- 3.1.
             , MovementFloat_TotalDiscountTax.ValueData  :: TFloat AS TotalDiscountTax
               -- 3.2.
             , MovementFloat_TotalSummTaxPVAT.ValueData  :: TFloat AS TotalSummTaxPVAT
               -- 3.3.
             , MovementFloat_TotalSummTaxMVAT.ValueData  :: TFloat AS TotalSummTaxMVAT
               -- сумма без НДС, после п.1.
             , (COALESCE (MovementFloat_TotalSummMVAT.ValueData,0)
                - COALESCE (MovementFloat_SummTaxMVAT.ValueData,0))      :: TFloat AS Summ2
               -- сумма без НДС, после п.2.
             , (COALESCE (MovementFloat_TotalSummMVAT.ValueData,0) 
                - COALESCE (MovementFloat_SummTaxMVAT.ValueData,0) 
                + COALESCE (MovementFloat_SummPost.ValueData,0)
                + COALESCE (MovementFloat_SummPack.ValueData,0)
                + COALESCE (MovementFloat_SummInsur.ValueData,0))        :: TFloat AS Summ3
               -- сумма без НДС, после п.3.
             , (COALESCE (MovementFloat_TotalSummMVAT.ValueData,0) 
                - COALESCE (MovementFloat_SummTaxMVAT.ValueData,0) 
                + COALESCE (MovementFloat_SummPost.ValueData,0)
                + COALESCE (MovementFloat_SummPack.ValueData,0)
                + COALESCE (MovementFloat_SummInsur.ValueData,0)
                - COALESCE (MovementFloat_TotalSummTaxMVAT.ValueData,0)) :: TFloat AS Summ4
        FROM Movement AS Movement_Income
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                     ON MovementFloat_TotalSummMVAT.MovementId = Movement_Income.Id
                                    AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

             LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                     ON MovementFloat_DiscountTax.MovementId = Movement_Income.Id
                                    AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()
             LEFT JOIN MovementFloat AS MovementFloat_SummTaxMVAT
                                     ON MovementFloat_SummTaxMVAT.MovementId = Movement_Income.Id
                                    AND MovementFloat_SummTaxMVAT.DescId = zc_MovementFloat_SummTaxMVAT()
             LEFT JOIN MovementFloat AS MovementFloat_SummTaxPVAT
                                     ON MovementFloat_SummTaxPVAT.MovementId = Movement_Income.Id
                                    AND MovementFloat_SummTaxPVAT.DescId = zc_MovementFloat_SummTaxPVAT()
             LEFT JOIN MovementFloat AS MovementFloat_SummPost
                                     ON MovementFloat_SummPost.MovementId = Movement_Income.Id
                                    AND MovementFloat_SummPost.DescId = zc_MovementFloat_SummPost()
             LEFT JOIN MovementFloat AS MovementFloat_SummPack
                                     ON MovementFloat_SummPack.MovementId = Movement_Income.Id
                                    AND MovementFloat_SummPack.DescId = zc_MovementFloat_SummPack()
             LEFT JOIN MovementFloat AS MovementFloat_SummInsur
                                     ON MovementFloat_SummInsur.MovementId = Movement_Income.Id
                                    AND MovementFloat_SummInsur.DescId = zc_MovementFloat_SummInsur()
             LEFT JOIN MovementFloat AS MovementFloat_TotalDiscountTax
                                     ON MovementFloat_TotalDiscountTax.MovementId = Movement_Income.Id
                                    AND MovementFloat_TotalDiscountTax.DescId = zc_MovementFloat_TotalDiscountTax()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummTaxMVAT
                                     ON MovementFloat_TotalSummTaxMVAT.MovementId = Movement_Income.Id
                                    AND MovementFloat_TotalSummTaxMVAT.DescId = zc_MovementFloat_TotalSummTaxMVAT()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummTaxPVAT
                                     ON MovementFloat_TotalSummTaxPVAT.MovementId = Movement_Income.Id
                                    AND MovementFloat_TotalSummTaxPVAT.DescId = zc_MovementFloat_TotalSummTaxPVAT()

        WHERE Movement_Income.Id = inMovementId
          AND Movement_Income.DescId = zc_Movement_Income()
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.10.21         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Income (inMovementId:= 1, inOperDate:= '02.02.2021', inSession:= zfCalc_UserAdmin())
