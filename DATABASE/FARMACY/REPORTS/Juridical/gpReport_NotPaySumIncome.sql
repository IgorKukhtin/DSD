-- Function: gpReport_NotPaySumIncome()

DROP FUNCTION IF EXISTS gpReport_NotPaySumIncome (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_NotPaySumIncome(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (JuridicalCode Integer
             , JuridicalName TVarChar
             , JuridicalFromCode Integer
             , JuridicalFromName TVarChar
             , TotalSumm TFloat
             , TotalPaySumm TFloat
             , TotalPaySummDate TFloat
             , AmountBonus TFloat
             , AmountReturnOut TFloat
             , AmountOther TFloat
             , AmountPartialSale TFloat
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- Контролшь использования подразделения

    RETURN QUERY
        WITH tmpContainer AS
                         (SELECT Object_Movement.ObjectCode AS MovementId, Container.Amount
                          FROM Container
                               LEFT JOIN Object AS Object_Movement ON Object_Movement.Id = Container.ObjectId
                                                                  AND Object_Movement.DescId = zc_Object_PartionMovement()
                          WHERE Container.DescId = zc_Container_SummIncomeMovementPayment()
                            AND Container.Amount > 0
                         
                         ),
             tmpIncome AS 
                         (SELECT Movement_Income.*  
                               , MovementLinkObject_From.ObjectId           AS FromId
                               , MovementLinkObject_To.ObjectId             AS ToId
                               , MovementFloat_TotalSumm.ValueData          AS TotalSumm
                               , tmpContainer.Amount                        AS PaySumm
                               , CASE WHEN MovementDate_Payment.ValueData <= inEndDate THEN tmpContainer.Amount END AS PaySummDate
                          FROM Movement AS Movement_Income
                                                                       
                               LEFT JOIN tmpContainer ON Movement_Income.Id = tmpContainer.MovementId
                                                                       
                               LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                       ON MovementFloat_TotalSumm.MovementId =  Movement_Income.Id
                                                      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                          
                               LEFT JOIN MovementDate AS MovementDate_Payment
                                                      ON MovementDate_Payment.MovementId =  Movement_Income.Id
                                                     AND MovementDate_Payment.DescId = zc_MovementDate_Payment()                                                          
                                                                       
                          WHERE Movement_Income.DescId = zc_Movement_Income()
                            AND Movement_Income.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement_Income.StatusId = zc_Enum_Status_Complete()),
             tmpReturnOut AS 
                         (SELECT Movement_Income.Id  
                               , SUM(MovementFloat_TotalSumm.ValueData)      AS TotalSumm
                          FROM tmpIncome AS Movement_Income
                          
                               INNER JOIN Movement AS Movement_ReturnOut ON Movement_ReturnOut.ParentId = Movement_Income.Id
                                                  AND Movement_ReturnOut.StatusId = zc_Enum_Status_Complete()

                               LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                       ON MovementFloat_TotalSumm.MovementId =  Movement_ReturnOut.Id
                                                      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                                      
                          GROUP BY Movement_Income.Id  
                          ),
             tmpData AS   
                         (SELECT Movement_Income.FromId
                               , ObjectLink_Unit_Juridical.ChildObjectId    AS JuridicalId
                               , SUM(Movement_Income.TotalSumm)::TFloat     AS TotalSumm
                               , SUM(Movement_Income.PaySumm)::TFloat       AS PaySumm
                               , SUM(Movement_Income.PaySummDate)::TFloat   AS PaySummDate
                               --, SUM(ReturnOut.TotalSumm)::TFloat           AS ReturnOutSumm
                          FROM tmpIncome AS Movement_Income
                                                                       
                               LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                    ON ObjectLink_Unit_Juridical.ObjectId = Movement_Income.ToId
                                                   AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                                                       
                               --LEFT JOIN tmpReturnOut AS ReturnOut ON ReturnOut.Id = Movement_Income.Id

                          GROUP BY Movement_Income.FromId
                                 , ObjectLink_Unit_Juridical.ChildObjectId),
             tmpContainerBonus AS (SELECT CASE WHEN Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_Bonus()       THEN Container.Amount ELSE 0 END ::TFloat AS ContainerAmountBonus
                                        , CASE WHEN Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_ReturnOut()   THEN Container.Amount ELSE 0 END ::TFloat AS ContainerAmountReturnOut
                                        , CASE WHEN Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_Other()       THEN Container.Amount ELSE 0 END ::TFloat AS ContainerAmountOther
                                        , CASE WHEN Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_PartialSale() THEN Container.Amount ELSE 0 END ::TFloat AS ContainerAmountPartialSale
                                        , CLO_Juridical.ObjectId
                                        , CLO_JuridicalBasis.ObjectId  AS  JuridicalId
                                   FROM ContainerLinkObject AS CLO_JuridicalBasis
                                        INNER JOIN Container ON Container.Id =  CLO_JuridicalBasis.ContainerId
                                                            AND Container.DescId = zc_Container_SummIncomeMovementPayment() 
                                                            AND Container.Amount <> 0 
                                        LEFT JOIN ContainerLinkObject AS CLO_Juridical
                                                                      ON CLO_Juridical.ContainerId = Container.Id
                                                                     AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                   WHERE CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                  ),
             tmpContainerBonusSum AS (SELECT D.ObjectId
                                           , D.JuridicalId
                                           , SUM(D.ContainerAmountBonus)::TFloat       AS ContainerAmountBonus
                                           , SUM(D.ContainerAmountReturnOut)::TFloat   AS ContainerAmountReturnOut
                                           , SUM(D.ContainerAmountOther)::TFloat       AS ContainerAmountOther
                                           , SUM(D.ContainerAmountPartialSale)::TFloat AS ContainerAmountPartialSale
                                      FROM tmpContainerBonus  AS D
                                      GROUP BY D.ObjectId
                                             , D.JuridicalId)                          


    SELECT Movement_Income.JuridicalId
         , Object_Juridical.ValueData                 AS JuridicalName
         , Movement_Income.FromId
         , Object_From.ValueData                      AS FromName
         , Movement_Income.TotalSumm
         , Movement_Income.PaySumm
         , Movement_Income.PaySummDate
         , ContainerBonusSum.ContainerAmountBonus
         , ContainerBonusSum.ContainerAmountReturnOut
         , ContainerBonusSum.ContainerAmountOther
         , ContainerBonusSum.ContainerAmountPartialSale
    FROM tmpData AS Movement_Income
                                                                         
         LEFT JOIN Object AS Object_From ON Object_From.Id = Movement_Income.FromId

         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Movement_Income.JuridicalId
         
         LEFT JOIN tmpContainerBonusSum AS ContainerBonusSum ON ContainerBonusSum.JuridicalId = Movement_Income.JuridicalId
                                                            AND ContainerBonusSum.ObjectId = Movement_Income.FromId
         
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_NotPaySumIncome (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.03.22                                                       *
*/

select * from gpReport_NotPaySumIncome(inStartDate := ('01.01.2022')::TDateTime , inEndDate := ('28.03.2022')::TDateTime ,  inSession := '3');
