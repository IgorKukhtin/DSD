-- Function: gpGet_Movement_Sale()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Sale(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , TotalCount TFloat
             , TotalSumm TFloat
             , TotalSummPrimeCost TFloat
             , UnitId Integer
             , UnitName TVarChar
             , JuridicalId Integer
             , JuridicalName TVarChar
             , PaidKindId Integer
             , PaidKindName TVarChar
             , Comment TVarChar

             , OperDateSP TDateTime
             , PartnerMedicalName TVarChar
             , InvNumberSP TVarChar
             , MedicSPName TVarChar
             , MemberSPName TVarChar
             )
AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Sale());

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0                                                AS Id
          , CAST (NEXTVAL ('movement_sale_seq') AS TVarChar) AS InvNumber
          , CURRENT_DATE::TDateTime                          AS OperDate
          , Object_Status.Code               	             AS StatusCode
          , Object_Status.Name              	             AS StatusName
          , 0::TFloat                                        AS TotalCount
          , 0::TFloat                                        AS TotalSumm
          , 0::TFloat                                        AS TotalSummPrimeCost
          , NULL::Integer                                    AS UnitId
          , NULL::TVarChar                                   AS UnitName
          , NULL::Integer                                    AS JuridicalId
          , NULL::TVarChar                                   AS JuridicalName
          , NULL::Integer                                    AS PaidKindId
          , NULL::TVarChar                                   AS PaidKindName
          , NULL::TVarChar                                   AS Comment

          , NULL::TDateTime                                  AS OperDateSP
          , NULL::TVarChar                                   AS PartnerMedicalName
          , NULL::TVarChar                                   AS InvNumberSP
          , NULL::TVarChar                                   AS MedicSPName
          , NULL::TVarChar                                   AS MemberSPName

        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
    ELSE
        RETURN QUERY
        SELECT
            Movement_Sale.Id
          , Movement_Sale.InvNumber
          , Movement_Sale.OperDate
          , Movement_Sale.StatusCode
          , Movement_Sale.StatusName
          , Movement_Sale.TotalCount
          , Movement_Sale.TotalSumm
          , Movement_Sale.TotalSummPrimeCost
          , Movement_Sale.UnitId
          , Movement_Sale.UnitName
          , Movement_Sale.JuridicalId
          , Movement_Sale.JuridicalName
          , Movement_Sale.PaidKindId
          , Movement_Sale.PaidKindName
          , Movement_Sale.Comment

          , COALESCE(Movement_Sale.OperDateSP, NULL) :: TDateTime AS OperDateSP
          , Movement_Sale.PartnerMedicalName
          , Movement_Sale.InvNumberSP
          , Movement_Sale.MedicSPName
          , Movement_Sale.MemberSPName
        FROM
            Movement_Sale_View AS Movement_Sale
        WHERE Movement_Sale.Id =  inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Sale (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 08.02.17         * add SP
 15.09.16         *
 13.10.15                                                                        *
*/
