-- Function: gpGet_PrinterByUnit()

DROP FUNCTION IF EXISTS gpGet_PrinterByUser (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PrinterByUser(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbPrinter TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
 
     vbPrinter := COALESCE ((SELECT OS_User_Printer.ValueData 
                             FROM ObjectString AS OS_User_Printer
                             WHERE OS_User_Printer.ObjectId = vbUserId
                               AND OS_User_Printer.DescId = zc_ObjectString_User_Printer()
                            ), '') :: TVarChar ;

     -- RETURN 'Godex G500';
     RETURN vbPrinter;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.04.18         *
*/

-- тест
-- SELECT * FROM gpGet_PrinterByUser (inSession:= zfCalc_UserAdmin())
