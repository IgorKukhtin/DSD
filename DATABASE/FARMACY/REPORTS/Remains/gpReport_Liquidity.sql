-- Function: gpReport_Liquidity()

DROP FUNCTION IF EXISTS gpReport_Liquidity (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Liquidity(
    IN inStartDate     TDateTime , -- Начало периода
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE cur1 refcursor;
   DECLARE cur2 refcursor;
   DECLARE cur3 refcursor;
   DECLARE cur4 refcursor;
   DECLARE vbStartDate TDateTime;
   DECLARE vbIncomeDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

  vbStartDate := DATE_TRUNC ('DAY', inStartDate);
  vbIncomeDate := DATE_TRUNC ('DAY', now());
  IF vbStartDate < vbIncomeDate
  THEN
    vbIncomeDate := vbStartDate;
  END IF;

    -- Остаки
  OPEN cur1 FOR
  WITH
    tmpContainer AS (SELECT AnalysisContainer.UnitID                                                     AS UnitID
                          , SUM(AnalysisContainer.Saldo)                                                 AS Saldo
                          , SUM((AnalysisContainer.Saldo *
                                 AnalysisContainer.Price)::NUMERIC (16, 2))::TFloat                      AS Summa
                        FROM AnalysisContainer AS AnalysisContainer
                        GROUP BY AnalysisContainer.UnitID),

    tmpItemContainer AS (SELECT MovementItem.UnitID                                                      AS UnitID
                             , SUM(MovementItem.Saldo)                                                   AS Saldo
                             , SUM(MovementItem.SaldoSum)                                                AS Summa
                        FROM AnalysisContainerItem AS MovementItem
                        WHERE MovementItem.Operdate >= vbStartDate
                        GROUP BY MovementItem.UnitID),
    tmpContainerRemainder AS (SELECT
                            Object_Juridical.ObjectCode                   AS JuridicalID
                          , Object_Juridical.ValueData                    AS JuridicalName
                          , tmpContainer.UnitID                           AS UnitID
                          , Object_Unit.ValueData                         AS UnitName
                          , tmpContainer.Saldo -
                            COALESCE (tmpItemContainer.Saldo, 0)          AS Saldo
                          , tmpContainer.Summa -
                            COALESCE (tmpItemContainer.Summa, 0)          AS SummaRemainder
                        FROM tmpContainer as tmpContainer

                            LEFT JOIN tmpItemContainer AS tmpItemContainer
                                                       ON tmpContainer.UnitID = tmpItemContainer.UnitID

                            LEFT JOIN Object AS Object_Unit
                                             ON Object_Unit.Id = tmpContainer.UnitID

                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId)


    SELECT
        tmpContainerRemainder.JuridicalID                  AS JuridicalID
      , tmpContainerRemainder.JuridicalName                AS JuridicalName
      , SUM(tmpContainerRemainder.SummaRemainder)          AS SummaRemainder

    FROM tmpContainerRemainder as tmpContainerRemainder
    WHERE tmpContainerRemainder.JuridicalID IS NOT NULL
    GROUP BY tmpContainerRemainder.JuridicalID
           , tmpContainerRemainder.JuridicalName
    ORDER BY tmpContainerRemainder.JuridicalName;

    RETURN NEXT cur1;

    -- Неоплаченые накладные
  OPEN cur2 FOR
  WITH
    tmpMovement_Income AS (SELECT Movement_Income.Id
             , Object_Juridical.ObjectCode      AS JuridicalId
             , Object_Juridical.ValueData                 AS JuridicalName
             , Object_To.Id                               AS ToId
             , Object_To.Name                             AS ToName
             , MovementFloat_TotalSumm.ValueData          AS TotalSumm
             , MovementFloat_TotalSumm.ValueData +
               COALESCE(SUM(MovementItemContainer.Amount), 0)          AS SummNoPay



        FROM Movement AS Movement_Income

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                     ON MovementLinkObject_Juridical.MovementId = Movement_Income.Id
                                    AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

        LEFT JOIN Object_Unit_View AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId

        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId = Movement_Income.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

           -- Партия накладной
                                    LEFT JOIN Object AS Object_Movement
                                                     ON Object_Movement.ObjectCode = Movement_Income.Id
                                                    AND Object_Movement.DescId = zc_Object_PartionMovement()
                                    LEFT JOIN Container ON Container.DescId = zc_Container_SummIncomeMovementPayment()
                                                       AND Container.ObjectId = Object_Movement.Id
                                                       AND Container.KeyValue like '%,'||MovementLinkObject_Juridical.ObjectId||';%'
                                    LEFT JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                       AND MovementItemContainer.MovementDescId in (zc_Movement_BankAccount(), zc_Movement_Payment())
                                       AND MovementItemContainer.OperDate < vbIncomeDate

        WHERE Movement_Income.DescId = zc_Movement_Income()
          AND Movement_Income.StatusId = zc_Enum_Status_Complete()
          AND Movement_Income.OperDate < vbIncomeDate
        GROUP BY Movement_Income.Id
             , Object_Juridical.ObjectCode
             , Object_Juridical.ValueData
             , Object_To.Id
             , Object_To.Name
             , MovementFloat_TotalSumm.ValueData)

        SELECT Movement_Income.JuridicalId       AS JuridicalId
             , Movement_Income.JuridicalName     AS JuridicalName
             , Sum(Movement_Income.SummNoPay)    AS SummNoPay
        FROM tmpMovement_Income AS Movement_Income
        GROUP BY Movement_Income.JuridicalId
             , Movement_Income.JuridicalName
         ORDER BY Movement_Income.JuridicalName;
    RETURN NEXT cur2;

    -- cash back
  OPEN cur3 FOR
         SELECT
                Object_Maker.ID                       AS ID
              , Object_Maker.ObjectCode               AS MarketCompanyID
              , Object_Maker.ValueData                AS MarketCompanyName
              , ObjectFloat_Maker_CashBack.ValueData  AS Summa
         FROM Object AS Object_Maker
             LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Maker_CashBack
                                         ON ObjectFloat_Maker_CashBack.ObjectId = Object_Maker.id
                                        and ObjectFloat_Maker_CashBack.descid = zc_ObjectFloat_Maker_CashBack()
         WHERE Object_Maker.DescId = zc_Object_Maker()
           AND Object_Maker.IsErased = False
         ORDER BY Object_Maker.ValueData;
    RETURN NEXT cur3;


    -- cash back
  OPEN cur4 FOR
         SELECT
                Object_Bank.ID                        AS ID
              , Object_Bank.ObjectCode                AS BankID
              , Object_Bank.ValueData                 AS BankName
              , ObjectFloat_Bank_Overdraft.ValueData  AS Summa
         FROM Object AS Object_Bank
             LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Bank_Overdraft
                                         ON ObjectFloat_Bank_Overdraft.ObjectId = Object_Bank.id
                                        and ObjectFloat_Bank_Overdraft.descid = zc_ObjectFloat_Bank_Overdraft()
         WHERE Object_Bank.DescId = zc_Object_Bank()
           AND Object_Bank.IsErased = False
         ORDER BY Object_Bank.ValueData;
    RETURN NEXT cur4;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 09.08.18        *
*/

-- тест
-- BEGIN TRANSACTION;
-- select * from gpReport_Liquidity (inStartDate := ('01.08.2018')::TDateTime , inSession := '3');
-- COMMIT TRANSACTION;

