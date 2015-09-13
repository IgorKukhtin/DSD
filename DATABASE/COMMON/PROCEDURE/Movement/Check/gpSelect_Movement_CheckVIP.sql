DROP FUNCTION IF EXISTS gpSelect_Movement_CheckVIP (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_CheckVIP(
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  Id Integer, 
  InvNumber TVarChar, 
  OperDate TDateTime, 
  StatusCode Integer, 
  TotalCount TFloat, 
  TotalSumm TFloat, 
  UnitName TVarChar, 
  CashRegisterName TVarChar,
  CashMember TVarCHar,
  Bayer TVarChar,
  StatusId Integer)

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;   
     vbUnitId := vbUnitKey::Integer;

     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_UnComplete() AS StatusId
                          UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE)
         SELECT       
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , Movement_Check.StatusCode
           , Movement_Check.TotalCount
           , Movement_Check.TotalSumm
           , Movement_Check.UnitName
           , Movement_Check.CashRegisterName
		   , Movement_Check.CashMember
		   , Movement_Check.Bayer
		   , Movement_Check.StatusId
        FROM Movement_Check_View AS Movement_Check
          INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement_Check.StatusId
       WHERE 
		 Movement_Check.IsDeferred = True
		 --AND
		 --Movement_Check.CashMember is not null
		 AND
		 (
		   Movement_Check.UnitId = vbUnitId 
		   OR 
		   vbUnitId = 0
		 );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_CheckVIP (Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 12.09.2015                                                                   *[17:23] Кухтин Игорь: вторую кнопку закрыть и перекинуть их в запрос ВИП
 04.07.15                                                                     * 

*/

-- тест
-- SELECT * FROM gpSelect_Movement_CheckVIP (inIsErased := FALSE, inSession:= '2')