-- Function: gpReport_LiquidityChart()

DROP FUNCTION IF EXISTS gpReport_LiquidityChart (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_LiquidityChart(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE cur1 refcursor;
   DECLARE cur2 refcursor;
   DECLARE cur3 refcursor;
   DECLARE vbStartDate TDateTime;
   DECLARE vbIncomeDate TDateTime;
   DECLARE vbIncomeDateStart TDateTime;
   DECLARE vbQueryText   Text;
   DECLARE curJuridical   refcursor;
   DECLARE vbId Integer;
   DECLARE vbJuridicalId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры


    -- Остатки
    CREATE TEMP TABLE tmpContainer ON COMMIT DROP AS
    (WITH
        tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                         , Object_Juridical.Id                AS JuridicalId
                    FROM ObjectLink AS ObjectLink_Unit_Juridical

                       INNER JOIN Object AS Object_Juridical
                                         ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
                                        AND Object_Juridical.isErased = False

                       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                            AND ObjectLink_Juridical_Retail.ChildObjectId = 4
                    WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                      AND ObjectLink_Unit_Juridical.ChildObjectId <> 393053
                    ),

        tmpContainer AS (SELECT AnalysisContainer.UnitID                                                     AS UnitID
                              , SUM((AnalysisContainer.Saldo *
                                     AnalysisContainer.Price)::NUMERIC (16, 2))::TFloat                      AS Summa
                            FROM AnalysisContainer AS AnalysisContainer
                            GROUP BY AnalysisContainer.UnitID),

        tmpItemContainer AS (SELECT MovementItem.UnitID                                                       AS UnitID
                                  , date_trunc ('quarter', MovementItem.OperDate)                             AS OperDate     
                                  , SUM(MovementItem.SaldoSum)                                                AS Summa
                             FROM AnalysisContainerItem AS MovementItem
                             GROUP BY MovementItem.UnitID
                                    , date_trunc ('quarter', MovementItem.OperDate)),

        tmpUnitSum AS (SELECT MovementItem.UnitID
                            , MovementItem.OperDate
                            , COALESCE(tmpContainer.Summa, 0) - COALESCE(MovementItem.Summa, 0) - COALESCE(SUM(ItemContainerPrev.Summa), 0) AS Summa
                       FROM tmpItemContainer AS MovementItem  
                        
                            LEFT JOIN tmpContainer ON tmpContainer.UnitID = MovementItem.UnitID    
                       
                            LEFT JOIN tmpItemContainer AS ItemContainerPrev                    
                                                       ON ItemContainerPrev.UnitID = MovementItem.UnitID
                                                      AND ItemContainerPrev.OperDate > MovementItem.OperDate
                                                       
                       GROUP BY MovementItem.UnitID
                              , MovementItem.OperDate
                              , MovementItem.Summa
                              , tmpContainer.Summa)
                              
         SELECT tmpUnit.JuridicalId
              , MovementItem.OperDate
              , SUM(MovementItem.Summa)::TFloat          AS Summa
         FROM tmpUnitSum AS MovementItem   
                           
              INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementItem.UnitID
              
         WHERE MovementItem.OperDate >= '01.01.2017'
                            
         GROUP BY tmpUnit.JuridicalId
                , MovementItem.OperDate

         ORDER BY tmpUnit.JuridicalId
                , MovementItem.OperDate);   
                

    -- Все юр. лица
                                    
    CREATE TEMP TABLE tmpJuridical ON COMMIT DROP AS
    (WITH
       tmpJuridical AS (SELECT DISTINCT Container.JuridicalID
                        FROM tmpContainer as Container)
     SELECT
         Container.JuridicalID         AS JuridicalID
       , Object_Juridical.ValueData    AS JuridicalName
       , ROW_NUMBER() OVER (ORDER BY Container.JuridicalID)::Integer AS Id
     FROM tmpJuridical as Container

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Container.JuridicalID
     ORDER BY Container.JuridicalID);      
                
    -- Не опл. приходы
                
    CREATE TEMP TABLE tmpIncome ON COMMIT DROP AS
    (WITH
       tmpMovement_Income AS (SELECT Movement_Income.Id                                 AS Id
                                   , Movement_Income.OperDate                           AS OperDate    
                                   , MovementLinkObject_Juridical.ObjectId              AS JuridicalId
                                   , MovementFloat_TotalSumm.ValueData                  AS TotalSumm
                              FROM Movement AS Movement_Income

                                   INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                                 ON MovementLinkObject_Juridical.MovementId = Movement_Income.Id
                                                                AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                                                AND MovementLinkObject_Juridical.ObjectId <> 393053
                                                                
                                   INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                         ON ObjectLink_Juridical_Retail.ObjectId = MovementLinkObject_Juridical.ObjectId
                                                        AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                        AND ObjectLink_Juridical_Retail.ChildObjectId = 4

                                   LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                           ON MovementFloat_TotalSumm.MovementId = Movement_Income.Id
                                                          AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                              WHERE Movement_Income.DescId = zc_Movement_Income()
                                AND Movement_Income.StatusId = zc_Enum_Status_Complete()),
                                     
       tmpPayment_Income AS (SELECT Movement_Income.Id                                 AS Id    
                                  , Movement_Income.JuridicalId                        AS JuridicalId
                                  , Movement_Income.OperDate                           AS OperDateIncome
                                  , MovementItemContainer.OperDate                     AS OperDate    
                                  , MovementItemContainer.Amount                       AS TotalSumm
                             FROM tmpMovement_Income AS Movement_Income

                                  INNER JOIN Object AS Object_Movement
                                                    ON Object_Movement.ObjectCode = Movement_Income.Id
                                                   AND Object_Movement.DescId = zc_Object_PartionMovement()
                                  INNER JOIN Container ON Container.DescId = zc_Container_SummIncomeMovementPayment()
                                                      AND Container.ObjectId = Object_Movement.Id
                                                      AND Container.KeyValue like '%,'||Movement_Income.JuridicalId||';%'
                                  INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                  AND MovementItemContainer.MovementDescId in (zc_Movement_BankAccount(), zc_Movement_Payment())
                             ),
       tmpIncomeDate AS (SELECT DISTINCT date_trunc ('quarter', Movement.OperDate)   AS OperDate
                         FROM tmpMovement_Income AS Movement 
                         ),
       tmpIncomQeuarter AS (SELECT Movement.Id
                                 , Movement.JuridicalId
                                 , IncomeDate.OperDate
                                 , Movement.TotalSumm
                            FROM tmpIncomeDate AS IncomeDate
                             
                                 INNER JOIN tmpMovement_Income AS Movement 
                                                               ON Movement.OperDate < IncomeDate.OperDate
                                                              AND Movement.OperDate >= IncomeDate.OperDate - interval '1 year'
                               
                            ),
       tmpIncomQeuarterSum AS (SELECT Movement.JuridicalId
                                    , Movement.OperDate
                                    , SUM(Movement.TotalSumm)  AS TotalSumm
                                FROM tmpIncomQeuarter AS Movement
                                GROUP BY Movement.JuridicalId
                                       , Movement.OperDate                                
                                ),
       tmpPayQeuarterSum AS (SELECT Payment_Income.JuridicalId
                                  , IncomeDate.OperDate
                                  , Sum(Payment_Income.TotalSumm) AS Summa
                             FROM tmpIncomeDate AS IncomeDate
                               
                                  INNER JOIN tmpPayment_Income AS Payment_Income                    
                                                               ON Payment_Income.OperDateIncome < IncomeDate.OperDate
                                                              AND Payment_Income.OperDateIncome >= IncomeDate.OperDate - interval '1 year'
                                                              AND Payment_Income.OperDate < IncomeDate.OperDate

                             GROUP BY Payment_Income.JuridicalId
                                    , IncomeDate.OperDate)
                                
       SELECT Movement.JuridicalId
            , Movement.OperDate
            , (Movement.TotalSumm + COALESCE(PayQeuarterSum.Summa, 0))::TFloat  AS Summa
       FROM tmpIncomQeuarterSum AS Movement   
       
            INNER JOIN tmpPayQeuarterSum AS PayQeuarterSum
                                         ON PayQeuarterSum.JuridicalId = Movement.JuridicalId
                                        AND PayQeuarterSum.OperDate = Movement.OperDate

       WHERE Movement.OperDate >= '01.01.2017'

       ORDER BY Movement.JuridicalId
              , Movement.OperDate);   
              
    -- ********* Итоговая таблица *************
                                
    CREATE TEMP TABLE tmpResult (
            OperDate        TDateTime,
            OperDateText    TVarChar
    ) ON COMMIT DROP;
    
    
    INSERT INTO tmpResult
    SELECT DISTINCT COALESCE(Container.OperDate, Income.OperDate) 
         , to_char(COALESCE(Container.OperDate, Income.OperDate), 'YY Q') 
    FROM tmpContainer as Container

         FULL JOIN tmpIncome AS Income ON Income.JuridicalID = Container.JuridicalID
                                      AND Income.OperDate = Container.OperDate;    
     
    -- Заполняем данными
    OPEN curJuridical FOR
      SELECT tmpJuridical.Id
           , tmpJuridical.JuridicalId
      FROM tmpJuridical
      ORDER BY tmpJuridical.Id;


     -- начало цикла по курсору1
    LOOP
       -- данные по курсору1
       FETCH curJuridical INTO vbId, vbJuridicalId;
       -- если данные закончились, тогда выход
       IF NOT FOUND THEN EXIT; END IF;

       vbQueryText := 'ALTER TABLE tmpResult ' ||
                      '   ADD COLUMN SummaRemains' || COALESCE (vbId, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ' ||
                      ' , ADD COLUMN SummaIncome'  || COALESCE (vbId, 0)::Text || ' Integer NOT NULL DEFAULT 0 ' ||
                      ' , ADD COLUMN Summa'        || COALESCE (vbId, 0)::Text || ' Integer NOT NULL DEFAULT 0 ';
       EXECUTE vbQueryText;

       vbQueryText := 'UPDATE tmpResult SET SummaRemains' || COALESCE (vbId, 0)::Text || ' = COALESCE (T1.SummaRemains, 0) ' ||
                                         ', SummaIncome' || COALESCE (vbId, 0)::Text || ' = COALESCE (T1.SummaIncome, 0) ' ||
                                         ', Summa' || COALESCE (vbId, 0)::Text || ' = COALESCE (T1.Summa, 0) ' ||
                      ' FROM (SELECT
                                     COALESCE(Container.OperDate, Income.OperDate)                          AS OperDate
                                   , COALESCE(Container.Summa, 0)::TFloat                                   AS SummaRemains
                                   , COALESCE(Income.Summa, 0)::TFloat                                      AS SummaIncome
                                   , (COALESCE(Container.Summa, 0) - COALESCE(Income.Summa, 0))::TFloat     AS Summa

                                 FROM tmpContainer as Container

                                      FULL JOIN tmpIncome AS Income ON Income.JuridicalID = Container.JuridicalID
                                                                   AND Income.OperDate = Container.OperDate
                                 WHERE COALESCE(Container.JuridicalID, Income.JuridicalID) = ' || COALESCE (vbJuridicalId, 0)::Text || ') AS T1'||
                      ' WHERE tmpResult.OperDate = T1.OperDate';
       EXECUTE vbQueryText;
        
    END LOOP; -- финиш цикла по курсору1
    CLOSE curJuridical; -- закрыли курсор1    
     
    -- ********* Вывод результата *************

    -- По подразделениям
    OPEN cur1 FOR
    SELECT
        Juridical.ID
      , Juridical.JuridicalID
      , Juridical.JuridicalName
      , 'SummaRemains'||Juridical.ID::TVarChar  AS SummaRemains
      , 'SummaIncome'||Juridical.ID::TVarChar   AS SummaIncome
      , 'Summa'||Juridical.ID::TVarChar         AS Summa
    FROM tmpJuridical as Juridical;

    RETURN NEXT cur1;     
                               
    -- По подразделениям остатки
    OPEN cur2 FOR
    SELECT *
    FROM tmpResult 
    ORDER BY OperDate
    ;

    RETURN NEXT cur2;                        

    -- Итоги
    OPEN cur3 FOR
    SELECT
        to_char(Container.OperDate, 'YY Q')  AS OperDate
      , SUM(Container.SummaRemains)          AS SummaRemains
      , SUM(Container.SummaIncome)           AS SummaIncome
      , SUM(Container.Summa)                 AS Summa

    FROM (SELECT
                 COALESCE(Container.JuridicalID, Income.JuridicalID)                    AS JuridicalID
               , COALESCE(Container.OperDate, Income.OperDate)                          AS OperDate
               , Object_Juridical.ValueData                                             AS JuridicalName
               , COALESCE(Container.Summa, 0)::TFloat                                   AS SummaRemains
               , COALESCE(Income.Summa, 0)::TFloat                                      AS SummaIncome
               , (COALESCE(Container.Summa, 0) - COALESCE(Income.Summa, 0))::TFloat     AS Summa

             FROM tmpContainer as Container

                  FULL JOIN tmpIncome AS Income ON Income.JuridicalID = Container.JuridicalID
                                               AND Income.OperDate = Container.OperDate

                  LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE(Container.JuridicalID, Income.JuridicalID)
             ) as Container

    GROUP BY Container.OperDate;

    RETURN NEXT cur3;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.12.21                                                       *
*/

-- тест
-- BEGIN TRANSACTION;
-- select * from gpReport_LiquidityChart (inSession := '3');
-- COMMIT TRANSACTION;

select * from gpReport_LiquidityChart(inSession := '3');  