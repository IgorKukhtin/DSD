﻿-- Function: gpGet_Object_ProductDocument_https()

DROP FUNCTION IF EXISTS gpGet_Object_ProductDocument_https(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProductDocument_https(
    IN inProductId                 Integer   , --
   OUT outHttps                    TVarChar  , --
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     outHttps:= 'https://agilis-jettenders.com/constructor-pdf/agilis-configuration'
      || '-'  || COALESCE ((SELECT Movement.InvNumber FROM MovementLinkObject AS MLO JOIN Movement ON Movement.Id = MLO.MovementId WHERE MLO.ObjectId = inProductId AND MLO.DescId = zc_MovementLinkObject_Product()
                           ), '000')
              || '.pdf'
             ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.04.21         *
*/

-- тест
-- SELECT gpGet_Object_ProductDocument_https (inProductId:= 252029, inSession:= '5')
