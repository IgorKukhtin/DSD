-- Function: gpSelect_Movement_PriceList()

DROP FUNCTION IF EXISTS gpSelect_Movement_PriceList (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PriceList(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , ContractId Integer, ContractName TVarChar
             , AreaId Integer, AreaName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , PriceListId Integer
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
--     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

       SELECT
             Movement.Id                          AS Id
           , Movement.InvNumber                   AS InvNumber
           , Movement.OperDate                    AS OperDate
           , Object_Status.ObjectCode             AS StatusCode
           , Object_Status.ValueData              AS StatusName
           , Object_Juridical.Id                  AS JuridicalId
           , Object_Juridical.ValueData           AS JuridicalName
           , Object_Contract.Id                   AS ContractId
           , Object_Contract.ValueData            AS ContractName
           , Object_Area.Id                       AS AreaId
           , Object_Area.ValueData                AS AreaName
           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
   
           , LoadPriceList.Id                     AS PriceListId

       FROM Movement 
            JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId 

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                         ON MovementLinkObject_Area.MovementId = Movement.Id
                                        AND MovementLinkObject_Area.DescId = zc_MovementLinkObject_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = MovementLinkObject_Area.ObjectId
            
            LEFT JOIN LoadPriceList ON LoadPriceList.JuridicalId          = Object_Juridical.Id
                                   AND LoadPriceList.ContractId           = Object_Contract.Id
                                   AND COALESCE (LoadPriceList.AreaId, 0) = COALESCE (Object_Area.Id, 0)
            
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate  
       AND Movement.DescId = zc_Movement_PriceList();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_PriceList (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.10.17         * 
 02.03.16         *
 01.07.14                                                        *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_PriceList (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')