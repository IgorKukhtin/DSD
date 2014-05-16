-- Function: gpSelect_Movement_Tax()

DROP FUNCTION IF EXISTS gpSelect_Movement_Tax_Load (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Tax_Load(
    IN inStartDate      TDateTime , --
    IN inEndDate        TDateTime , --
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (NPP TVarChar,  NUM TVarChar,   DATEV TDateTime, NAZP TVarChar, IPN TVarChar, 
               ZAGSUM TFloat, BAZOP20 TFloat, SUMPDV TFloat,   ZVILN TFloat,
               EXPORT TFloat, PZOB TFloat,    NREZ TFloat,     KOR TFloat,    WMDTYPE TFloat, 
               WMDTYPESTR TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Tax());
     vbUserId:= inSession;

     --
     RETURN QUERY
     SELECT
             (row_number() OVER ())::TVarChar 
           , Movement.InvNumber				AS InvNumber
           , Movement.OperDate				AS OperDate
           , ObjectHistoryString_JuridicalDetails_FullName.ValueData   AS ToName
           , ObjectHistoryString_JuridicalDetails_INN.ValueData   AS INN
           , CASE Movement.DescId 
                  WHEN zc_Movement_Tax() THEN MovementFloat_TotalSummPVAT.ValueData      
                  ELSE - MovementFloat_TotalSummPVAT.ValueData
             END                                        AS TotalSummPVAT
           , CASE Movement.DescId 
                  WHEN zc_Movement_Tax() THEN MovementFloat_TotalSummMVAT.ValueData      
                  ELSE - MovementFloat_TotalSummMVAT.ValueData
             END                                        AS TotalSummMVAT
           , CASE Movement.DescId 
                  WHEN zc_Movement_Tax() THEN (MovementFloat_TotalSummPVAT.ValueData - MovementFloat_TotalSummMVAT.ValueData)::TFloat      
                  ELSE - (MovementFloat_TotalSummPVAT.ValueData - MovementFloat_TotalSummMVAT.ValueData)::TFloat
             END                                        AS SUMPDV
           , 0::TFloat AS ZVILN
           , 0::TFloat AS EXPORT
           , 0::TFloat AS PZOB
           , 0::TFloat AS NREZ
           , 0::TFloat AS KOR
           , 0::TFloat AS WMDTYPE
           , 'РК'::TVarChar
       FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

            LEFT JOIN ObjectHistory AS ObjectHistory_JuridicalDetails 
                   ON ObjectHistory_JuridicalDetails.ObjectId = MovementLinkObject_To.ObjectId
                  AND ObjectHistory_JuridicalDetails.DescId = zc_ObjectHistory_JuridicalDetails()
                  AND Movement.OperDate BETWEEN ObjectHistory_JuridicalDetails.StartDate AND ObjectHistory_JuridicalDetails.EndDate  
           LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_FullName
                  ON ObjectHistoryString_JuridicalDetails_FullName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                 AND ObjectHistoryString_JuridicalDetails_FullName.DescId = zc_ObjectHistoryString_JuridicalDetails_FullName()
           LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_INN
                  ON ObjectHistoryString_JuridicalDetails_INN.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                 AND ObjectHistoryString_JuridicalDetails_INN.DescId = zc_ObjectHistoryString_JuridicalDetails_INN()

      WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
        AND Movement.DescId in (zc_Movement_Tax(), zc_Movement_TaxCorrective()) AND Movement.StatusId = zc_Enum_Status_Complete();



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Tax_Load(TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.04.14                         *
 27.02.14                         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Tax (inStartDate:= '30.01.2013', inEndDate:= '02.02.2014', inIsRegisterDate:=FALSE, inIsErased :=TRUE, inSession:= '2')