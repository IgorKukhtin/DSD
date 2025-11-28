-- Function: gpSelect_Movement_Income_Print()
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderFinancePlan_Print (TDateTime, Integer, Boolean,Boolean,Boolean,Boolean,Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderFinancePlan_Print(
    IN inOperDate         TDateTime , -- Дата начю недели (для определения года)
    IN inWeekNumber       Integer   , -- Номер недели
    IN inisPlan_1         Boolean    , --
    IN inisPlan_2         Boolean    , --
    IN inisPlan_3         Boolean    , --
    IN inisPlan_4         Boolean    , --
    IN inisPlan_5         Boolean    , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
            Cursor2 refcursor;

    DECLARE vbDescId Integer;
            vbPlan           TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income_Print());
     vbUserId:= lpGetUserBySession (inSession);

    --проверка только 1 день должен быть выбран
    vbPlan := (CASE WHEN COALESCE (inisPlan_1,FALSE) = TRUE THEN 1 ELSE 0 END
             + CASE WHEN COALESCE (inisPlan_2,FALSE) = TRUE THEN 1 ELSE 0 END
             + CASE WHEN COALESCE (inisPlan_3,FALSE) = TRUE THEN 1 ELSE 0 END
             + CASE WHEN COALESCE (inisPlan_4,FALSE) = TRUE THEN 1 ELSE 0 END
             + CASE WHEN COALESCE (inisPlan_5,FALSE) = TRUE THEN 1 ELSE 0 END
             );

    IF COALESCE (vbPlan, 0) > 1 
    THEN
        RAISE EXCEPTION 'Ошибка.Выбрано больше 1 дня.';
    END IF;

    OPEN Cursor1 FOR
         SELECT inWeekNumber AS WeekNumber
              , inOperDate   AS StartDate
              , (inOperDate + INTERVAL '6 DAY')::TDateTime AS EndDate
              , CASE WHEN COALESCE (inisPlan_1,FALSE) = TRUE THEN 'Понедельник'
                     WHEN COALESCE (inisPlan_2,FALSE) = TRUE THEN 'Вторник'    
                     WHEN COALESCE (inisPlan_3,FALSE) = TRUE THEN 'Среда'      
                     WHEN COALESCE (inisPlan_4,FALSE) = TRUE THEN 'Четверг'    
                     WHEN COALESCE (inisPlan_5,FALSE) = TRUE THEN 'Пятница'    
                END ::TVarChar AS DayOfWeek
              , (inOperDate 
                + (''|| CASE WHEN COALESCE (inisPlan_1,FALSE) = TRUE THEN 0
                             WHEN COALESCE (inisPlan_2,FALSE) = TRUE THEN 1
                             WHEN COALESCE (inisPlan_3,FALSE) = TRUE THEN 2
                             WHEN COALESCE (inisPlan_4,FALSE) = TRUE THEN 3
                             WHEN COALESCE (inisPlan_5,FALSE) = TRUE THEN 4
                        END ||' DAY') ::Interval ) ::TDateTime AS OperDate
         ;
    RETURN NEXT Cursor1;
     
     
     
    OPEN Cursor2 FOR
      WITH
       tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
               UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                    )
     , tmpMovement AS (
                       SELECT Movement.Id
                            , Movement.Invnumber
                            , Movement.OperDate
                       FROM Movement
                            INNER JOIN MovementFloat AS MovementFloat_WeekNumber
                                                     ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                    AND MovementFloat_WeekNumber.DescId = zc_MovementFloat_WeekNumber()
                                                    AND MovementFloat_WeekNumber.ValueData = inWeekNumber
                       WHERE Movement.DescId = zc_Movement_OrderFinance()
                         AND Movement.StatusId IN (SELECT tmpStatus.StatusId FROM tmpStatus)
                         AND Movement.OperDate BETWEEN inOperDate - INTERVAL '14 DAY' AND inOperDate + INTERVAL '14 DAY'
                       )
     , tmpMLO_OrderFinance AS (SELECT *
                               FROM MovementLinkObject
                               WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementLinkObject.DescId = zc_MovementLinkObject_OrderFinance()
                               )    
  
     , tmpMI AS (SELECT MovementItem.MovementId
                      , MovementItem.Id       AS Id
                      , MovementItem.ObjectId AS ObjectId
                 FROM MovementItem
                 WHERE MovementItem.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
                   AND MovementItem.DescId = zc_MI_Master()
                   AND MovementItem.isErased = FALSE
                 )                         

     , tmpMovementItemFloat AS (SELECT *
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                  AND MovementItemFloat.DescId IN (CASE WHEN COALESCE (inisPlan_1,FALSE) = TRUE THEN zc_MIFloat_AmountPlan_1()
                                                                        WHEN COALESCE (inisPlan_2,FALSE) = TRUE THEN zc_MIFloat_AmountPlan_2()
                                                                        WHEN COALESCE (inisPlan_3,FALSE) = TRUE THEN zc_MIFloat_AmountPlan_3()
                                                                        WHEN COALESCE (inisPlan_4,FALSE) = TRUE THEN zc_MIFloat_AmountPlan_4()
                                                                        WHEN COALESCE (inisPlan_5,FALSE) = TRUE THEN zc_MIFloat_AmountPlan_5()
                                                                   END
                                                                   )
                                )

     , tmpMovementItemBoolean AS (SELECT *
                                  FROM MovementItemBoolean
                                  WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                    AND MovementItemBoolean.DescId IN (
                                                                     CASE WHEN COALESCE (inisPlan_1,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_1()
                                                                          WHEN COALESCE (inisPlan_2,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_2()
                                                                          WHEN COALESCE (inisPlan_3,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_3()
                                                                          WHEN COALESCE (inisPlan_4,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_4()
                                                                          WHEN COALESCE (inisPlan_5,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_5()
                                                                     END
                                                                     )
                                  )

     , tmpMovementItemString AS (SELECT *
                                 FROM MovementItemString
                                 WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                   AND MovementItemString.DescId IN (zc_MIString_Comment_pay()
                                                                   )
                                 )
     , tmpMILO_Contract AS (SELECT *
                            FROM MovementItemLinkObject
                            WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                              AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Contract()
                                                          )
                            ) 


       -- УП-Статья или Группа или ...
     , tmpOrderFinanceProperty AS (SELECT DISTINCT
                                          --Вид Планирования
                                          OL_OrderFinanceProperty_OrderFinance.ChildObjectId         AS OrderFinanceId
                                        , -- УП - Статья или Группа или ...
                                          OL_OrderFinanceProperty_Object.ChildObjectId               AS ObjectId
                                          -- № п/п группы
                                        , ObjectFloat_Group.ValueData                                AS NumGroup
                                   FROM ObjectLink AS OL_OrderFinanceProperty_OrderFinance
                                        INNER JOIN Object ON Object.Id       = OL_OrderFinanceProperty_OrderFinance.ObjectId
                                                         -- не удален
                                                         AND Object.isErased = FALSE
                                        -- УП - Статья или Группа или ...
                                        INNER JOIN ObjectLink AS OL_OrderFinanceProperty_Object
                                                              ON OL_OrderFinanceProperty_Object.ObjectId      = OL_OrderFinanceProperty_OrderFinance.ObjectId
                                                             AND OL_OrderFinanceProperty_Object.DescId        = zc_ObjectLink_OrderFinanceProperty_Object()
                                                             AND OL_OrderFinanceProperty_Object.ChildObjectId > 0

                                        -- № п/п группы
                                        LEFT JOIN ObjectFloat AS ObjectFloat_Group
                                                              ON ObjectFloat_Group.ObjectId = OL_OrderFinanceProperty_OrderFinance.ObjectId
                                                             AND ObjectFloat_Group.DescId   = zc_ObjectFloat_OrderFinanceProperty_Group()
                                   WHERE OL_OrderFinanceProperty_OrderFinance.DescId = zc_ObjectLink_OrderFinanceProperty_OrderFinance()
                                  )

        -- разворачивается по УП-статьям + № группы
      , tmpInfoMoney_OrderF AS (SELECT DISTINCT
                                    tmpOrderFinanceProperty.OrderFinanceId
                                  , Object_InfoMoney_View.InfoMoneyId
                                  , tmpOrderFinanceProperty.NumGroup
                             FROM Object_InfoMoney_View
                                  INNER JOIN tmpOrderFinanceProperty ON (tmpOrderFinanceProperty.ObjectId = Object_InfoMoney_View.InfoMoneyId
                                                                      OR tmpOrderFinanceProperty.ObjectId = Object_InfoMoney_View.InfoMoneyDestinationId
                                                                      OR tmpOrderFinanceProperty.ObjectId = Object_InfoMoney_View.InfoMoneyGroupId
                                                                        )
                             )


     , tmpMI_Data AS (SELECT MovementItem.MovementId
                           , MovementItem.Id                  AS Id
                           , Object_Juridical.Id              AS JuridicalId
                           , Object_Juridical.ValueData       AS JuridicalName
                           , tmpJuridicalDetails_View.OKPO    AS OKPO
                           , Object_InfoMoney.Id              AS InfoMoneyId
                           , Object_InfoMoney.ValueData       AS InfoMoneyName 
                           , Object_Contract.ValueData        AS ContractName
                
                           , MIFloat_AmountPlan.ValueData     AS AmountPlan
                           , MIString_Comment_pay.ValueData   AS Comment_pay
                       FROM tmpMI AS MovementItem
                            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId
                                                                AND Object_Juridical.DescId = zc_Object_Juridical()
                            LEFT JOIN ObjectHistory_JuridicalDetails_View AS tmpJuridicalDetails_View ON tmpJuridicalDetails_View.JuridicalId = Object_Juridical.Id
                
                            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan
                                                           ON MIFloat_AmountPlan.MovementItemId = MovementItem.Id

                            LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan
                                                             ON MIBoolean_AmountPlan.MovementItemId = MovementItem.Id

                            LEFT JOIN tmpMovementItemString AS MIString_Comment_pay
                                                            ON MIString_Comment_pay.MovementItemId = MovementItem.Id
                                                           AND MIString_Comment_pay.DescId = zc_MIString_Comment_pay()
    
                            LEFT JOIN tmpMILO_Contract AS MILinkObject_Contract
                                                       ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId

                            LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                 ON ObjectLink_Contract_InfoMoney.ObjectId = MILinkObject_Contract.ObjectId
                                                AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId
                
                       WHERE COALESCE (MIBoolean_AmountPlan.ValueData, True) = TRUE
                         AND COALESCE (MIFloat_AmountPlan.ValueData,0) <> 0
                    )

        SELECT tmpMI.JuridicalName       AS JuridicalName
             , tmpMI.ContractName        AS ContractName
             , tmpMI.OKPO                AS OKPO
             , tmpMI.InfoMoneyName       AS InfoMoneyName
             , tmpInfoMoney_OrderF.NumGroup AS NumGroup
             , SUM (COALESCE (tmpMI.AmountPlan,0))   ::TFloat   AS AmountPlan
        FROM tmpMovement
             LEFT JOIN tmpMLO_OrderFinance AS MovementLinkObject_OrderFinance
                                           ON MovementLinkObject_OrderFinance.MovementId = tmpMovement.Id
                                          --AND MovementLinkObject_OrderFinance.DescId = zc_MovementLinkObject_OrderFinance()
                      
             LEFT JOIN tmpMI_Data AS tmpMI ON tmpMI.MovementId = tmpMovement.Id
             LEFT JOIN tmpInfoMoney_OrderF ON tmpInfoMoney_OrderF.InfoMoneyId = tmpMI.InfoMoneyId
                                          AND tmpInfoMoney_OrderF.OrderFinanceId = MovementLinkObject_OrderFinance.ObjectId
        GROUP BY tmpMI.JuridicalName
               , tmpMI.ContractName
               , tmpMI.OKPO
               , tmpMI.InfoMoneyName
               , tmpInfoMoney_OrderF.NumGroup 
        ;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.11.25         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderFinancePlan_Print (inOperDate :='17.11.2025'::TDateTime , inWeekNumber:= 47,  inisPlan_1 := TRUE, inisPlan_2 := FAlSE, inisPlan_3 := FAlSE, inisPlan_4 := FAlSE, inisPlan_5 := FAlSE, inSession := '3'); 
-- FETCH ALL "<unnamed portal 10>";