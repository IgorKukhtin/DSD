-- Function: gpGet_Movement_UnnamedEnterprises()

DROP FUNCTION IF EXISTS gpGet_Movement_UnnamedEnterprises (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_UnnamedEnterprises(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , TotalSumm TFloat
             , UnitId Integer
             , UnitName TVarChar
             , ClientsByBankId Integer
             , ClientsByBankName TVarChar
             , Comment TVarChar
             , AmountAccount TFloat
             , AccountNumber TVarChar
             , AmountPayment TFloat
             , DatePayment TDateTime
             )
AS
$BODY$
   DECLARE vbUnitId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_UnnamedEnterprises());

    -- определяем подразделение ()
--    vbUnitId := COALESCE ((SELECT tmp.UnitId FROM gpGet_UserUnit(inSession) AS tmp), 0);
    vbUnitId := 0;
    
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0                                                AS Id
          , CAST (NEXTVAL ('movement_UnnamedEnterprises_seq') AS TVarChar) AS InvNumber
          , CURRENT_DATE::TDateTime                          AS OperDate
          , Object_Status.Code               	             AS StatusCode
          , Object_Status.Name              	             AS StatusName
          , 0::TFloat                                        AS TotalSumm
          , COALESCE (Object_Unit.Id, NULL)       ::Integer  AS UnitId
          , COALESCE (Object_Unit.ValueData, NULL)::TVarChar AS UnitName
          , NULL::Integer                                    AS ClientsByBankId
          , NULL::TVarChar                                   AS ClientsByBankName
          , NULL::TVarChar                                   AS Comment
          , NULL::TFloat                                     AS AmountAccount 
          , NULL::TVarChar                                   AS AccountNumber 
          , NULL::TFloat                                     AS AmountPayment
          , NULL::TDateTime                                  AS DatePayment 

        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = vbUnitId;
    ELSE
        RETURN QUERY
        SELECT
            Movement.Id
          , Movement.InvNumber
          , Movement.OperDate
          , Object_Status.ObjectCode                 AS StatusCode
          , Object_Status.ValueData                  AS StatusName
          , COALESCE(MovementFloat_TotalSumm.ValueData,0)::TFloat  AS TotalSumm
          , Object_Unit.Id                           AS UnitId
          , Object_Unit.ValueData                    AS UnitName
          , Object_ClientsByBank.Id                  AS ClientsByBankId
          , Object_ClientsByBank.ValueData           AS ClientsByBankName
          , MovementString_Comment.ValueData         AS Comment
          , MovementFloat_AmountAccount.ValueData    AS AmountAccount 
          , MovementString_AccountNumber.ValueData   AS AccountNumber 
          , MovementFloat_AmountPayment.ValueData    AS AmountPayment
          , MovementDate_DatePayment.ValueData       AS DatePayment 

        FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            INNER JOIN Object AS Object_Unit
                             ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ClientsByBank
                                         ON MovementLinkObject_ClientsByBank.MovementId = Movement.Id
                                        AND MovementLinkObject_ClientsByBank.DescId = zc_MovementLinkObject_ClientsByBank()
            LEFT JOIN Object AS Object_ClientsByBank
                             ON Object_ClientsByBank.Id = MovementLinkObject_ClientsByBank.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_AmountAccount
                                    ON MovementFloat_AmountAccount.MovementId = Movement.Id
                                   AND MovementFloat_AmountAccount.DescId = zc_MovementFloat_AmountAccount()

            LEFT JOIN MovementString AS MovementString_AccountNumber
                                     ON MovementString_AccountNumber.MovementId = Movement.Id
                                    AND MovementString_AccountNumber.DescId = zc_MovementString_AccountNumber()

            LEFT JOIN MovementFloat AS MovementFloat_AmountPayment
                                    ON MovementFloat_AmountPayment.MovementId = Movement.Id
                                   AND MovementFloat_AmountPayment.DescId = zc_MovementFloat_AmountPayment()

            LEFT JOIN MovementDate AS MovementDate_DatePayment
                                   ON MovementDate_DatePayment.MovementId = Movement.Id
                                  AND MovementDate_DatePayment.DescId = zc_MovementDate_DatePayment()

        WHERE Movement.Id =  inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_UnnamedEnterprises (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 30.09.18         *
*/

-- select * from gpGet_Movement_UnnamedEnterprises(inMovementId := 0 , inOperDate := ('30.04.2017')::TDateTime ,  inSession := '3');

