-- Function: gpGet_Movement

DROP FUNCTION IF EXISTS gpGet_Movement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement(
    IN inMovementId        Integer  , -- ключ Документа
   OUT outMovementId       Integer  , -- 
   OUT outDocumentKindId   Integer  , -- 
   OUT outMovementDescId   Integer  , -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ZakazInternal());

       SELECT Movement.Id
            , CASE WHEN MovementLinkObject_DocumentKind.ObjectId IN (zc_Enum_DocumentKind_RealDelicShp(), zc_Enum_DocumentKind_RealDelicMsg())
                        THEN zc_Enum_DocumentKind_CuterWeight()
                   ELSE COALESCE (MovementLinkObject_DocumentKind.ObjectId, 0)
              END AS DocumentKindId
            , Movement.DescId
              INTO outMovementId, outDocumentKindId, outMovementDescId
       FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentKind
                                         ON MovementLinkObject_DocumentKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
       WHERE Movement.Id = inMovementId
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.16                                        * 
*/

-- тест
-- SELECT * FROM gpGet_Movement (inMovementId:= 1, inSession:= '2')
