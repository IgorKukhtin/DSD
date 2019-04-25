DROP FUNCTION IF EXISTS gpGet_Movement_InvNumberSP (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_InvNumberSP(
    IN inSPKindId      Integer,   -- ID соцпроекта
    IN inInvNumberSP   TVarChar,  -- Номер чека
   OUT outIsExists     Boolean,   -- Уже использован
    IN inSession       TVarChar   -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
  vbUserId:= lpGetUserBySession (inSession);

  IF EXISTS(SELECT 1
            FROM Movement 

                 INNER JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                               ON MovementLinkObject_SPKind.MovementId = Movement.Id
                                              AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                                              AND MovementLinkObject_SPKind.ObjectId = inSPKindId
                                              
                 INNER JOIN MovementString AS MovementString_InvNumberSP
                                           ON MovementString_InvNumberSP.MovementId = Movement.Id
                                          AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP() 
                                          AND MovementString_InvNumberSP.ValueData = inInvNumberSP

            WHERE Movement.OperDate >= DATE_TRUNC ('YEAR', CURRENT_DATE) 
              AND Movement.OperDate < DATE_TRUNC ('YEAR', CURRENT_DATE) + INTERVAL '1 YEAR'
              AND Movement.DescId = zc_Movement_Check()
              AND Movement.StatusId <> zc_Enum_Status_Erased()
            LIMIT 1)
  THEN
    outIsExists := True;  
  ELSE
    outIsExists := False;
  END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_InvNumberSP (Integer, TVarChar, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 22.04.19                                                                     * 
 18.04.19                                                                     * 

*/

-- тест
-- select * from gpGet_Movement_InvNumberSP(inSPKindId := 4823009 , inInvNumberSP := '0000-2M30-3K6P-481E' ,  inSession := '3');