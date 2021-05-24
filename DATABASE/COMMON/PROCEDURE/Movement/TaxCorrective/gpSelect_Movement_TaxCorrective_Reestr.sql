-- Function: gpSelect_Movement_TaxCorrective_Reestr()

DROP FUNCTION IF EXISTS gpSelect_Movement_TaxCorrective_Reestr (TDateTime, TDateTime, Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TaxCorrective_Reestr(
    IN inStartDate      TDateTime , --
    IN inEndDate        TDateTime , --
    IN inIsRegisterDate Boolean ,
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Tax());
     vbUserId:= lpGetUserBySession (inSession);

     --
    OPEN Cursor1 FOR

       SELECT OH_JuridicalDetails.*, inStartDate AS Start_Date, inEndDate AS End_Date
       FROM Object AS ObjectJuridical
            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails
                                                                ON OH_JuridicalDetails.JuridicalId = ObjectJuridical.Id
                                                               AND inStartDate >= OH_JuridicalDetails.StartDate AND inStartDate < OH_JuridicalDetails.EndDate
       WHERE ObjectJuridical.id = zc_Juridical_Basis();
    RETURN NEXT Cursor1;

--*****************************************************************

    OPEN Cursor2 FOR


       SELECT
              tmpReestr.*, OH_JuridicalDetails.*

       FROM (SELECT * FROM gpSelect_Movement_TaxCorrective (inStartDate, inEndDate, inIsRegisterDate
                                           ,  FALSE, inSession)) AS tmpReestr
            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails
                                                                ON OH_JuridicalDetails.JuridicalId = tmpReestr.FromId
                                                               AND OperDate < OH_JuridicalDetails.StartDate AND OperDate < OH_JuridicalDetails.EndDate
       WHERE tmpReestr.StatusCode = 2
       ORDER BY ToName, OperDate, InvNumber_Master, InvNumberPartner_Master, InvNumberPartner_Child
      ;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_TaxCorrective_Reestr (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.04.14                                                          *
*/

-- тест
/*
BEGIN;
 SELECT * FROM gpSelect_Movement_TaxCorrective_Reestr (inStartDate:= '01.12.2013', inEndDate:= '02.12.2013', inIsRegisterDate:= FALSE, inSession:= zfCalc_UserAdmin())
COMMIT;
*/
