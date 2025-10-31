-- Function: gpInsert_bi_Table_ProfitLoss

DROP FUNCTION IF EXISTS gpInsert_bi_Table_ProfitLoss (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_bi_Table_ProfitLoss(
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
BEGIN
      -- inStartDate:='01.01.2025';
      --

      IF EXTRACT (HOUR FROM CURRENT_TIMESTAMP) NOT IN (11) OR 1=1
      THEN
          DELETE FROM _bi_Table_ProfitLoss WHERE OperDate BETWEEN inStartDate AND inEndDate;
      END IF;


      -- РЕЗУЛЬТАТ
      INSERT INTO _bi_Table_ProfitLoss (-- Id партии
                                        ContainerId_pl
                                        -- Дата
                                      , OperDate
                                        -- Id документа
                                      , MovementId
                                        -- Вид документа
                                      , MovementDescId
                                        -- № документа
                                      , InvNumber
                                        -- Примечание документ
                                      , MovementId_comment

                                        -- Статья ОПиУ
                                      , ProfitLossId
                                        -- Бизнес
                                      , BusinessId

                                        -- Филиал затрат (Філія)
                                      , BranchId_pl
                                        -- Подразделение затрат (Підрозділ)
                                      , UnitId_pl

                                        -- Статья УП
                                      , InfoMoneyId

                                        -- Подразделение учета (Місце обліку)
                                      , UnitId
                                        -- Оборудование (Направление затрат)
                                      , AssetId
                                        -- Автомобиль (Направление затрат, место учета)
                                      , CarId
                                        -- Физ лицо
                                      , MemberId
                                        -- Статья списания (Стаття списання, Направление затрат)
                                      , ArticleLossId

                                        -- Об'єкт напрявлення
                                      , DirectionId
                                        -- Об'єкт призначення
                                      , DestinationId

                                        -- От кого (место учета) - информативно
                                      , FromId
                                        -- Кому (место учета, Направление затрат) - информативно
                                      , ToId

                                        -- Товар
                                      , GoodsId
                                        -- Вид Товара
                                      , GoodsKindId
                                        -- Вид Товара (только при производстве сырой ПФ)
                                      , GoodsKindId_gp

                                        -- Кол-во (вес)
                                      , OperCount
                                        -- Кол-во (шт.)
                                      , OperCount_sh
                                        -- Сумма
                                      , OperSumm
                                       )
              -- Результат
              SELECT ContainerId_pl
                     -- Дата
                   , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN inEndDate ELSE tmpReport.OperDate END AS OperDate
                     -- Id документа
                   , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE MovementId END AS MovementId
                     -- Вид документа
                   , tmpReport.MovementDescId
                     -- № документа
                   , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE zfConvert_StringToNumber (Movement.InvNumber) END AS InvNumber
                     -- Примечание документ
                   , MovementId_comment

                     -- Статья ОПиУ
                   , ProfitLossId
                     -- Бизнес
                   , BusinessId

                     -- Филиал затрат (Філія)
                   , BranchId_pl
                     -- Подразделение затрат (Підрозділ)
                   , UnitId_pl

                     -- Статья УП
                   , InfoMoneyId

                     -- Подразделение учета (Місце обліку)
                   , UnitId
                     -- Оборудование (Направление затрат)
                   , AssetId
                     -- Автомобиль (Направление затрат, место учета)
                   , CarId
                     -- Физ лицо
                   , MemberId
                     -- Статья списания (Стаття списання, Направление затрат)
                   , ArticleLossId

                     -- Об'єкт напрявлення
                   , DirectionId
                     -- Об'єкт призначення
                   , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE DestinationId END AS DestinationId

                     -- От кого (место учета) - информативно
                   , FromId
                     -- Кому (место учета, Направление затрат) - информативно
                   , ToId

                     -- Товар
                   , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE GoodsId END AS GoodsId
                     -- Вид Товара
                   , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE GoodsKindId END AS GoodsKindId
                     -- Вид Товара (только при производстве сырой ПФ)
                   , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE GoodsKindId_gp END AS GoodsKindId_gp

                     -- Кол-во (вес)
                   , SUM (OperCount)
                     -- Кол-во (шт.)
                   , SUM (OperCount_sh)
                     -- Сумма
                   , SUM (OperSumm)

              FROM lpReport_bi_ProfitLoss (inStartDate              := inStartDate
                                         , inEndDate                := inEndDate
                                         , inUserId                 := zfCalc_UserAdmin() :: Integer
                                             ) AS tmpReport
                   LEFT JOIN Movement ON Movement.Id = MovementId
              GROUP BY ContainerId_pl
                       -- Дата
                     , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN inEndDate ELSE tmpReport.OperDate END
                       -- Id документа
                     , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE MovementId END
                       -- Вид документа
                     , tmpReport.MovementDescId
                       -- № документа
                     , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE zfConvert_StringToNumber (Movement.InvNumber) END
                       -- Примечание документ
                     , MovementId_comment
  
                       -- Статья ОПиУ
                     , ProfitLossId
                       -- Бизнес
                     , BusinessId
  
                       -- Филиал затрат (Філія)
                     , BranchId_pl
                       -- Подразделение затрат (Підрозділ)
                     , UnitId_pl
  
                       -- Статья УП
                     , InfoMoneyId
  
                       -- Подразделение учета (Місце обліку)
                     , UnitId
                       -- Оборудование (Направление затрат)
                     , AssetId
                       -- Автомобиль (Направление затрат, место учета)
                     , CarId
                       -- Физ лицо
                     , MemberId
                       -- Статья списания (Стаття списання, Направление затрат)
                     , ArticleLossId
  
                       -- Об'єкт напрявлення
                     , DirectionId
                       -- Об'єкт призначення
                     , DestinationId
  
                       -- От кого (место учета) - информативно
                     , FromId
                       -- Кому (место учета, Направление затрат) - информативно
                     , ToId
  
                       -- Товар
                     , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE GoodsId END
                       -- Вид Товара
                     , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE GoodsKindId END
                       -- Вид Товара (только при производстве сырой ПФ)
                     , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE GoodsKindId_gp END

                 HAVING SUM (OperCount) <> 0 OR SUM (OperSumm) <> 0
                ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.10.25                                        * all
*/

/*
SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.09.2025', inEndDate:= '30.09.2025', inSession:= zfCalc_UserAdmin())
SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.08.2025', inEndDate:= '31.08.2025', inSession:= zfCalc_UserAdmin())
SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.07.2025', inEndDate:= '31.07.2025', inSession:= zfCalc_UserAdmin())


SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.01.2025', inEndDate:= '31.01.2025', inSession:= zfCalc_UserAdmin())
SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.02.2025', inEndDate:= '28.02.2025', inSession:= zfCalc_UserAdmin())
SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.03.2025', inEndDate:= '31.03.2025', inSession:= zfCalc_UserAdmin())
SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.04.2025', inEndDate:= '30.04.2025', inSession:= zfCalc_UserAdmin())
SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.05.2025', inEndDate:= '31.05.2025', inSession:= zfCalc_UserAdmin())
SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.06.2025', inEndDate:= '30.06.2025', inSession:= zfCalc_UserAdmin())
*/
-- тест
-- DELETE FROM  _bi_Table_ProfitLoss WHERE OperDate between '20.07.2025' and '20.07.2025'
-- SELECT OperDate, AccountName_all, sum(StartSumm_a), sum(StartSumm_p)  FROM _bi_Table_ProfitLoss left join _bi_Guide_Account_View on _bi_Guide_Account_View.Id = _bi_Table_ProfitLoss.AccountId where OperDate between '01.09.2025' and '01.09.2025' GROUP BY OperDate, AccountName_all ORDER BY 1 DESC, 2
-- SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.09.2025', inEndDate:= '30.09.2025', inSession:= zfCalc_UserAdmin())
