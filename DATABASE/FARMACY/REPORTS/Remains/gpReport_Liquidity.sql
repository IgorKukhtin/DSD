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
   DECLARE vbIncomeDateStart TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

  vbStartDate := DATE_TRUNC ('DAY', inStartDate);
  vbIncomeDate := DATE_TRUNC ('DAY', now());
  vbIncomeDateStart := vbIncomeDate - interval '1 year';
  IF vbStartDate < vbIncomeDate
  THEN
    vbIncomeDate := vbStartDate;
  END IF;

    -- Остаки
  OPEN cur1 FOR
  WITH
    tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
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
                          , SUM(AnalysisContainer.Saldo)                                                 AS Saldo
                          , SUM((AnalysisContainer.Saldo *
                                 AnalysisContainer.Price)::NUMERIC (16, 2))::TFloat                      AS Summa
                        FROM AnalysisContainer AS AnalysisContainer
                             INNER JOIN tmpUnit as tmpUnit ON tmpUnit.UnitId = AnalysisContainer.UnitID
                        GROUP BY AnalysisContainer.UnitID),

    tmpItemContainer AS (SELECT MovementItem.UnitID                                                      AS UnitID
                             , SUM(MovementItem.Saldo)                                                   AS Saldo
                             , SUM(MovementItem.SaldoSum)                                                AS Summa
                        FROM AnalysisContainerItem AS MovementItem
                             INNER JOIN tmpUnit as tmpUnit ON tmpUnit.UnitId = MovementItem.UnitID
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
                            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
                         )


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
    tmpMovement_Income AS (SELECT Movement_Income.Id      AS ID
             , Object_Juridical.ObjectCode                AS JuridicalId
             , Object_Juridical.ValueData                 AS JuridicalName
             , MovementFloat_TotalSumm.ValueData          AS TotalSumm
             , MovementFloat_TotalSumm.ValueData +
               COALESCE(SUM(MovementItemContainer.Amount), 0)          AS SummNoPay



        FROM Movement AS Movement_Income

        INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                     ON MovementLinkObject_Juridical.MovementId = Movement_Income.Id
                                    AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                    AND MovementLinkObject_Juridical.ObjectId <> 393053

        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = MovementLinkObject_Juridical.ObjectId
                            AND ObjectLink_Juridical_Retail.ChildObjectId = 4
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

        INNER JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId
                                             AND Object_Juridical.isErased = False

        INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                     AND MovementLinkObject_From.ObjectId not in (722768, 1475015)

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
          AND Movement_Income.OperDate <= vbIncomeDate
          AND Movement_Income.OperDate >= vbIncomeDateStart
        GROUP BY Movement_Income.Id
             , Object_Juridical.ObjectCode
             , Object_Juridical.ValueData
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
                Object_Overdraft.ID                        AS ID
              , Object_Overdraft.ObjectCode                AS BankID
              , Object_Overdraft.ValueData                 AS BankName
              , ObjectFloat_Overdraft_Summa.ValueData  AS Summa
         FROM Object AS Object_Overdraft
             LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Overdraft_Summa
                                         ON ObjectFloat_Overdraft_Summa.ObjectId = Object_Overdraft.id
                                        and ObjectFloat_Overdraft_Summa.descid = zc_ObjectFloat_Overdraft_Summa()
         WHERE Object_Overdraft.DescId = zc_Object_Overdraft()
           AND Object_Overdraft.IsErased = False
         ORDER BY Object_Overdraft.ValueData;
    RETURN NEXT cur4;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 27.08.18        *
 09.08.18        *
*/

-- тест
-- BEGIN TRANSACTION;
-- select * from gpReport_Liquidity (inStartDate := ('01.08.2018')::TDateTime , inSession := '3');
-- COMMIT TRANSACTION;
