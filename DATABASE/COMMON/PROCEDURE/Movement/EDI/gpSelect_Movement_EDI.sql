-- Function: gpSelect_Movement_ZakazInternal()

 DROP FUNCTION gpSelect_Movement_EDI (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_EDI(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
             , PartnerId Integer, PartnerName TVarChar,  JuridicalId Integer, JuridicalName TVarChar
             , GLNCode TVarChar,  GLNPlaceCode TVarChar, OKPO TVarChar
             , SaleInvNumber TVarChar, SaleOperDate TDateTime, LoadJuridicalName TVarChar)
AS
$BODY$
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ZakazInternal());

     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode    AS StatusCode
           , Object_Status.ValueData     AS StatusName

           , MovementFloat_TotalCount.ValueData  AS TotalCount
          
           , Object_Partner.Id                 AS PartnerId
           , Object_Partner.ValueData          AS PartnerName
           , Object_Juridical.Id               AS JuridicalId
           , Object_Juridical.ValueData        AS JuridicalName
           , MovementString_GLNCode.ValueData  AS GLNCode 
           , MovementString_GLNPlaceCode.ValueData  AS GLNPlaceCode 
           , MovementString_OKPO.ValueData     AS OKPO 
           , MovementString_SaleInvNumber.ValueData  AS SaleInvNumber
           , MovementDate_SaleOperDate.ValueData   AS SaleOperDate
           , MovementString_JuridicalName.ValueData AS LoadJuridicalName

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementString AS MovementString_GLNCode
                                     ON MovementString_GLNCode.MovementId =  Movement.Id
                                    AND MovementString_GLNCode.DescId = zc_MovementString_GLNCode()

            LEFT JOIN MovementString AS MovementString_OKPO
                                     ON MovementString_OKPO.MovementId =  Movement.Id
                                    AND MovementString_OKPO.DescId = zc_MovementString_OKPO()

            LEFT JOIN MovementString AS MovementString_GLNPlaceCode
                                     ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                    AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()

            LEFT JOIN MovementString AS MovementString_JuridicalName
                                     ON MovementString_JuridicalName.MovementId =  Movement.Id
                                    AND MovementString_JuridicalName.DescId = zc_MovementString_JuridicalName()

            LEFT JOIN MovementString AS MovementString_SaleInvNumber
                                     ON MovementString_SaleInvNumber.MovementId =  Movement.Id
                                    AND MovementString_SaleInvNumber.DescId = zc_MovementString_SaleInvNumber()

            LEFT JOIN MovementDate AS MovementDate_SaleOperDate
                                   ON MovementDate_SaleOperDate.MovementId =  Movement.Id
                                  AND MovementDate_SaleOperDate.DescId = zc_MovementDate_SaleOperDate()
                                   
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
           
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

       WHERE Movement.DescId = zc_Movement_EDI()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate;
  


END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_EDI (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.05.14                         *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_EDI (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= '2')