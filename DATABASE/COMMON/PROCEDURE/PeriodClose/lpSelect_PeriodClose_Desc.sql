-- Function: lpSelect_PeriodClose_Desc (TVarChar)

DROP FUNCTION IF EXISTS lpSelect_PeriodClose_Desc (TVarChar);
DROP FUNCTION IF EXISTS lpSelect_PeriodClose_Desc (Integer);

CREATE OR REPLACE FUNCTION lpSelect_PeriodClose_Desc(
    IN inUserId  Integer -- пользователь
)
RETURNS TABLE (DescId Integer, MovementDescId Integer, DescName TVarChar)
AS
$BODY$
BEGIN

     -- Результат - Хардкодим, временно ? :)
     RETURN QUERY 
        -- Продажа; Возврат от покупателя
        SELECT 1                     AS DescId
             , MovementDesc.Id       AS MovementDescId
             , MovementDesc.ItemName AS DescName
        FROM MovementDesc
        WHERE Id IN (zc_Movement_Sale()/*, zc_Movement_ReturnIn()*/ /*, zc_Movement_SendOnPrice()*/)

       UNION ALL
        SELECT 2                     AS DescId
             , MovementDesc.Id       AS MovementDescId
             , MovementDesc.ItemName AS DescName
        FROM MovementDesc
        WHERE Id IN (zc_Movement_ReturnIn())


       UNION ALL
        -- Налоговая накладная; Корректировка к налоговой накладной
        SELECT 3                     AS DescId
             , MovementDesc.Id       AS MovementDescId
             , MovementDesc.ItemName AS DescName
        FROM MovementDesc
        WHERE Id IN (zc_Movement_Tax()/*, zc_Movement_TaxCorrective()*/)
       UNION ALL
        -- Налоговая накладная; Корректировка к налоговой накладной
        SELECT 4                     AS DescId
             , MovementDesc.Id       AS MovementDescId
             , MovementDesc.ItemName AS DescName
        FROM MovementDesc
        WHERE Id IN (zc_Movement_TaxCorrective())

       UNION ALL
        -- Начисления услуг по Юридическому лицу; Начисления по Юридическому лицу (расходы будущих периодов)
        SELECT 11                     AS DescId
             , MovementDesc.Id       AS MovementDescId
             , MovementDesc.ItemName AS DescName
        FROM MovementDesc
      --WHERE Id IN (zc_Movement_Service(), zc_Movement_ProfitLossService())
        WHERE Id IN (zc_Movement_Service())

       UNION ALL
        -- Перевод долга (расход); Перевод долга (приход)
        SELECT 12                     AS DescId
             , MovementDesc.Id       AS MovementDescId
             , MovementDesc.ItemName AS DescName
        FROM MovementDesc
        WHERE Id IN (zc_Movement_TransferDebtIn(), zc_Movement_TransferDebtOut())

       ORDER BY 1, 2
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpSelect_PeriodClose_Desc (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.04.16                                        *
*/

-- тест
-- SELECT * FROM lpSelect_PeriodClose_Desc (inUserId:= zfCalc_UserAdmin() :: Integer); 
