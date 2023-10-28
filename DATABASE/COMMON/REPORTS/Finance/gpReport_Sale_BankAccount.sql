-- Function: gpReport_Sale_BankAccount

DROP FUNCTION IF EXISTS gpReport_Sale_BankAccount (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_Sale_BankAccount(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inPaidKindId       Integer,    -- ФО
    IN inJuridicalId      Integer,    -- Юр лицо
    IN inContractId       Integer,    --  договор (для оплаты и продажи - должны совпадать)
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, OperDate TDatetime, InvNumber TVarChar, StatusCode Integer
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar 
             , PaidKindName TVarChar
             , TotalSumm TFloat
             , TotalSumm_Pay TFloat
             , Summ_Pay TFloat 
             , Amount_SendDebt TFloat
             , Amount_pay      TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    WITH     
  
    tmpPaidKind AS (SELECT inPaidKindId AS Id
                    WHERE COALESCE (inPaidKindId,0) <> 0
                UNION
                   SELECT Object.Id
                   FROM Object
                   WHERE Object.DescId = zc_Object_PaidKind()
                      AND COALESCE (inPaidKindId,0) = 0
                   )

    --документы продаж за период
  , tmpMovement_Sale AS (SELECT Movement.*
                              , MovementLinkObject_PaidKind.ObjectId       AS PaidKindId 
                              , MovementLinkObject_Contract.ObjectId       AS ContractId
                              , MovementLinkObject_To.ObjectId             AS ToId
                              , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                              , MovementFloat_TotalSumm.ValueData          AS TotalSumm
                              , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_Contract.ObjectId, MovementLinkObject_PaidKind.ObjectId ORDER BY Movement.OperDate) AS Ord
                         FROM Movement 
                              INNER JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                            ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                           AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                                           AND MovementLinkObject_PaidKind.ObjectId IN (SELECT tmpPaidKind.Id FROM tmpPaidKind)
            
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                           AND (MovementLinkObject_Contract.ObjectId = inContractId OR COALESCE (inContractId,0) = 0)

                              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                              INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                   AND ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId
                              LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                      ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                     AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()                                                 
                         WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                           AND Movement.DescId = zc_Movement_Sale()
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                         ) 

  , tmpMovement_BancAccount AS(WITH 
                               tmpMovement AS (SELECT Movement.*
                                               FROM Movement
                                               WHERE Movement.DescId IN (zc_Movement_BankAccount(), zc_Movement_SendDebt())
                                                 AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                               )
                             , tmpMI AS (SELECT MovementItem.*
                                         FROM MovementItem
                                         WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                           AND MovementItem.DescId = zc_MI_Master()
                                           AND MovementItem.isErased = FALSE
                                         )                                  
                             , tmpObject_BankAccount AS (SELECT Object_BankAccount_View.*
                                                         FROM Object_BankAccount_View
                                                         WHERE Object_BankAccount_View.JuridicalId = inJuridicalId OR COALESCE (inJuridicalId,0) = 0 
                                                        )
                             , tmpMILO_Contract AS (SELECT MovementItemLinkObject.*
                                                    FROM MovementItemLinkObject
                                                    WHERE MovementItemLinkObject.DescId = zc_MILinkObject_Contract() 
                                                      AND MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                      AND (MovementItemLinkObject.ObjectId = inContractId OR COALESCE (inContractId,0) = 0)
                                                    )
                             , tmpMILO_MoneyPlace AS (SELECT MovementItemLinkObject.*
                                                      FROM MovementItemLinkObject
                                                      WHERE MovementItemLinkObject.DescId = zc_MILinkObject_MoneyPlace() 
                                                        AND MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                        AND (MovementItemLinkObject.ObjectId = inJuridicalId OR COALESCE (inJuridicalId,0) = 0)
                                                      )
                                           
                                                  
                             SELECT MILinkObject_Contract.ObjectId      AS ContractId
                                  , MILinkObject_MoneyPlace.ObjectId    AS JuridicalId
                                  , zc_Enum_PaidKind_FirstForm()        AS PaidKindId
                                  , SUM (CASE WHEN MovementItem.Amount > 0 THEN MovementItem.Amount
                                         ELSE 0
                                         END)                       ::TFloat AS AmountIn
                             FROM tmpMovement AS Movement
                                 INNER JOIN tmpMI AS MovementItem
                                                  ON MovementItem.MovementId = Movement.Id

                                 --INNER JOIN tmpObject_BankAccount AS Object_BankAccount_View ON Object_BankAccount_View.Id = MovementItem.ObjectId
                                                   
                                 INNER JOIN tmpMILO_Contract AS MILinkObject_Contract
                                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                 INNER JOIN tmpMILO_MoneyPlace AS MILinkObject_MoneyPlace
                                                               ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
            
                             GROUP BY MILinkObject_Contract.ObjectId
                                    , MILinkObject_MoneyPlace.ObjectId
                                    , zc_Enum_PaidKind_FirstForm()
                            ) 
  --взаимозачет
  , tmpMovement_SendDebt AS(WITH 
                               tmpMovement AS (SELECT Movement.*
                                               FROM Movement
                                               WHERE Movement.DescId IN ( zc_Movement_SendDebt())
                                                 AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                               )
          
                             , tmpMI AS (SELECT MovementItem.*
                                         FROM MovementItem
                                         WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                           AND MovementItem.isErased = FALSE
                                         )                                  

                             , tmpMILO AS (SELECT * FROM MovementItemLinkObject WHERE MovementItemLinkObject.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI))
                             , tmpMIFloat AS (SELECT * FROM MovementItemFloat WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI))
          
                          -- AND (MovementItemLinkObject.ObjectId = inContractId OR COALESCE (inContractId,0) = 0)
                          -- AND (MovementItemLinkObject.ObjectId = inJuridicalId OR COALESCE (inJuridicalId,0) = 0)
                             , tmpTotalSumm_Child AS (SELECT MILinkObject_Contract_To.ObjectId        AS ContractId
                                                           , COALESCE (ObjectLink_Partner_JuridicalTo.ChildObjectId, Object_Juridical_To.Id) AS JuridicalId
                                                           , MILinkObject_PaidKind_To.ObjectId        AS PaidKindId
                                                           , SUM (MI_Child.Amount)*(-1)      ::TFloat AS Amount
                                                      FROM tmpMovement AS Movement
                                                          LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                                                  ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                                                 AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                         
                                                          LEFT JOIN tmpMI AS MI_Child 
                                                                          ON MI_Child.MovementId = Movement.Id
                                                                         AND MI_Child.DescId     = zc_MI_Child()
                                                                                       
                                                          LEFT JOIN Object AS Object_Juridical_To ON Object_Juridical_To.Id = MI_Child.ObjectId
                                                          LEFT JOIN ObjectDesc AS ObjectToDesc ON ObjectToDesc.Id = Object_Juridical_To.DescId
                                              
                                                          LEFT JOIN ObjectLink AS ObjectLink_Partner_JuridicalTo
                                                                               ON ObjectLink_Partner_JuridicalTo.ObjectId = MI_Child.ObjectId
                                                                              AND ObjectLink_Partner_JuridicalTo.DescId = zc_ObjectLink_Partner_Juridical()
                                              
                                                          INNER JOIN tmpMILO AS MILinkObject_Contract_To
                                                                             ON MILinkObject_Contract_To.MovementItemId = MI_Child.Id
                                                                            AND MILinkObject_Contract_To.DescId = zc_MILinkObject_Contract()
                                                                            AND (MILinkObject_Contract_To.ObjectId = inContractId OR COALESCE (inContractId,0) = 0)
                                              
                                                          INNER JOIN tmpMILO AS MILinkObject_PaidKind_To
                                                                             ON MILinkObject_PaidKind_To.MovementItemId = MI_Child.Id
                                                                            AND MILinkObject_PaidKind_To.DescId = zc_MILinkObject_PaidKind()
                                                                            AND (MILinkObject_PaidKind_To.ObjectId = inPaidKindId OR COALESCE (inPaidKindId,0) = 0)
                                                      WHERE (COALESCE (ObjectLink_Partner_JuridicalTo.ChildObjectId, Object_Juridical_To.Id) = inJuridicalId OR COALESCE (inJuridicalId,0) = 0)
                                                      GROUP BY MILinkObject_Contract_To.ObjectId
                                                             , COALESCE (ObjectLink_Partner_JuridicalTo.ChildObjectId, Object_Juridical_To.Id)
                                                             , MILinkObject_PaidKind_To.ObjectId
                                                      )

                             , tmpTotalSumm_Master AS (SELECT MILinkObject_Contract_From.ObjectId      AS ContractId
                                                            , COALESCE (ObjectLink_Partner_JuridicalFrom.ChildObjectId, Object_Juridical_From.Id) AS JuridicalId
                                                            , MILinkObject_PaidKind_From.ObjectId      AS PaidKindId
                                                            , SUM (MI_Master.Amount)*(-1)     ::TFloat AS Amount
                                                       FROM tmpMovement AS Movement
                                                           LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                                                   ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                                                  AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                          
                                                           LEFT JOIN tmpMI AS MI_Master 
                                                                           ON MI_Master.MovementId = Movement.Id
                                                                          AND MI_Master.DescId     = zc_MI_Master()
                                               
                                                           LEFT JOIN Object AS Object_Juridical_From ON Object_Juridical_From.Id = MI_Master.ObjectId
                                                           LEFT JOIN ObjectDesc AS ObjectFromDesc ON ObjectFromDesc.Id = Object_Juridical_From.DescId
                                               
                                                           LEFT JOIN ObjectLink AS ObjectLink_Partner_JuridicalFrom
                                                                                ON ObjectLink_Partner_JuridicalFrom.ObjectId = MI_Master.ObjectId
                                                                               AND ObjectLink_Partner_JuridicalFrom.DescId = zc_ObjectLink_Partner_Juridical()
                                               
                                                           INNER JOIN tmpMILO AS MILinkObject_Contract_From
                                                                              ON MILinkObject_Contract_From.MovementItemId = MI_Master.Id
                                                                             AND MILinkObject_Contract_From.DescId = zc_MILinkObject_Contract()
                                                                             AND (MILinkObject_Contract_From.ObjectId = inContractId OR COALESCE (inContractId,0) = 0)
                                               
                                                           INNER JOIN tmpMILO AS MILinkObject_PaidKind_From
                                                                              ON MILinkObject_PaidKind_From.MovementItemId = MI_Master.Id
                                                                             AND MILinkObject_PaidKind_From.DescId = zc_MILinkObject_PaidKind()
                                                                             AND (MILinkObject_PaidKind_From.ObjectId = inPaidKindId OR COALESCE (inPaidKindId,0) = 0)
                                               
                                                       WHERE (COALESCE (ObjectLink_Partner_JuridicalFrom.ChildObjectId, Object_Juridical_From.Id) = inJuridicalId OR COALESCE (inJuridicalId,0) = 0)
                                                       GROUP BY MILinkObject_Contract_From.ObjectId
                                                              , COALESCE (ObjectLink_Partner_JuridicalFrom.ChildObjectId, Object_Juridical_From.Id)
                                                              , MILinkObject_PaidKind_From.ObjectId
                                                       )

                             SELECT tmp.JuridicalId
                                  , tmp.ContractId
                                  , tmp.PaidKindId
                                  , SUM (tmp.Amount) AS Amount
                             FROM (SELECT tmp.JuridicalId
                                        , tmp.ContractId
                                        , tmp.PaidKindId
                                        , tmp.Amount
                                   FROM tmpTotalSumm_Master AS tmp
                                UNION
                                   SELECT tmp.JuridicalId
                                        , tmp.ContractId
                                        , tmp.PaidKindId
                                        , tmp.Amount
                                   FROM tmpTotalSumm_Child AS tmp
                                  ) AS tmp
                             GROUP BY tmp.JuridicalId
                                    , tmp.ContractId
                                    , tmp.PaidKindId
                           )

  --накопительная сумма долга
  , tmpMov_Sale AS (SELECT t1.Id
                         , t1.StatusId
                         , t1.OperDate
                         , t1.InvNumber
                         , t1.PaidKindId 
                         , t1.ContractId
                         , t1.ToId
                         , t1.JuridicalId
                         , t1.TotalSumm
                         , t1.ord
                       , sum (COALESCE (t2.TotalSumm,0)) + COALESCE (t1.TotalSumm,0)  AS TotalSumm_calc
                    from tmpMovement_Sale AS t1
                       LEFT JOIN tmpMovement_Sale AS t2 ON t2.JuridicalId = t1.JuridicalId
                                                       AND t2.ContractId = t1.ContractId
                                                       AND t2.PaidKindId = t1.PaidKindId
                                                       AND t2.Ord < t1.Ord
                    GROUP BY t1.Id
                           , t1.StatusId
                           , t1.OperDate
                           , t1.InvNumber
                           , t1.PaidKindId 
                           , t1.ContractId
                           , t1.ToId
                           , t1.JuridicalId
                           , t1.TotalSumm
                           , t1.ord
                    order by t1.ContractId
                           , t1.JuridicalId, t1.ord
                    )
  --
  , tmpSumma AS (SELECT tmp.JuridicalId
                      , tmp.ContractId
                      , tmp.PaidKindId
                      , SUM (tmp.AmountIn)        AS AmountIn
                      , SUM (tmp.Amount_pay)      AS Amount_pay
                      , SUM (tmp.Amount_SendDebt) AS Amount_SendDebt
                 FROM (SELECT tmp.JuridicalId
                            , tmp.ContractId
                            , tmp.PaidKindId
                            , tmp.AmountIn
                            , tmp.AmountIn AS Amount_pay
                            , 0            AS Amount_SendDebt
                       FROM tmpMovement_BancAccount AS tmp
                    UNION
                       SELECT tmp.JuridicalId
                            , tmp.ContractId
                            , tmp.PaidKindId
                            , tmp.Amount AS AmountIn 
                            , 0          AS Amount_pay
                            , tmp.Amount AS Amount_SendDebt
                       FROM tmpMovement_SendDebt AS tmp
                      ) AS tmp
                 GROUP BY tmp.JuridicalId
                        , tmp.ContractId
                        , tmp.PaidKindId
                )

  , tmpData AS (SELECT tmpMov_Sale.Id
                     , tmpMov_Sale.StatusId
                     , tmpMov_Sale.OperDate
                     , tmpMov_Sale.InvNumber
                     , tmpMov_Sale.PaidKindId 
                     , tmpMov_Sale.ContractId
                     , tmpMov_Sale.ToId
                     , tmpMov_Sale.JuridicalId
                     , tmpMov_Sale.TotalSumm
                     , tmpMov_Sale.ord
                     , tmpSumma.AmountIn        AS TotalSumm_Pay
                     , tmpSumma.Amount_SendDebt AS Amount_SendDebt
                     , tmpSumma.Amount_pay      AS Amount_pay
                     , CASE WHEN tmpSumma_2.AmountIn >= tmpMov_Sale.TotalSumm_calc THEN tmpMov_Sale.TotalSumm
                            ELSE 0
                       END AS Summ_Pay 
                FROM tmpMov_Sale
                    --Сумма оплаты
                    LEFT JOIN tmpSumma ON tmpSumma.JuridicalId = tmpMov_Sale.JuridicalId
                                      AND tmpSumma.ContractId = tmpMov_Sale.ContractId
                                      AND tmpSumma.PaidKindId = tmpMov_Sale.PaidKindId
                                      AND tmpMov_Sale.Ord = 1
                    --сумма для расчета распределения
                    LEFT JOIN tmpSumma AS tmpSumma_2
                                       ON tmpSumma_2.JuridicalId = tmpMov_Sale.JuridicalId
                                      AND tmpSumma_2.ContractId = tmpMov_Sale.ContractId
                                      AND tmpSumma_2.PaidKindId = tmpMov_Sale.PaidKindId
                )

     SELECT
         tmpData.Id AS MovementId
       , tmpData.OperDate
       , tmpData.InvNumber
       , Object_Status.ObjectCode        AS StatusCode
       , Object_Contract.Id              AS ContractId
       , Object_Contract.ObjectCode      AS ContractCode
       , Object_Contract.ValueData       AS ContractName 
       , Object_Juridical.Id             AS JuridicalId
       , Object_Juridical.ObjectCode     AS JuridicalCode
       , Object_Juridical.ValueData      AS JuridicalName
       , Object_Partner.Id               AS PartnerId
       , Object_Partner.ObjectCode       AS PartnerCode
       , Object_Partner.ValueData        AS PartnerName
       , Object_PaidKind.ValueData       AS PaidKindName
       
       , tmpData.TotalSumm     ::TFloat
       , tmpData.TotalSumm_Pay :: TFloat
       , tmpData.Summ_Pay      :: TFloat
       , tmpData.Amount_SendDebt ::TFloat
       , tmpData.Amount_pay    :: TFloat
     FROM tmpData
         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
         LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpData.ContractId 
         LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.ToId
         LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpData.PaidKindId
         LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpData.StatusId

     ORDER BY Object_Juridical.ValueData
            , Object_Contract.ValueData
            , Object_PaidKind.ValueData
            , tmpData.Ord
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.10.23         *
*/

-- тест
-- SELECT * FROM gpReport_Sale_BankAccount (inStartDate:= '01.10.2023', inEndDate:= '10.10.2023', inPaidKindId:= 3, inJuridicalId:= 15088 , inContractId:= 0, inSession:= '2');
