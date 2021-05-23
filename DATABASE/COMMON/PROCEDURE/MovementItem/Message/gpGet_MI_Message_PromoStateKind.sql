-- Function: gpGet_MI_Message_PromoStateKind (Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpGet_MI_Message_PromoStateKind (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Message_PromoStateKind(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsComplete  Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementItemId Integer, PromoStateKindId Integer, PromoStateKindName TVarChar, Comment TVarChar)
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbMovementItemId   Integer;
  DECLARE vbPromoStateKindId Integer;
  DECLARE vbIsUserSigning1   Boolean;
  DECLARE vbIsUserSigning2   Boolean;
  DECLARE vbIsUserSigning3   Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_Promo());
     vbUserId:= lpGetUserBySession (inSession);


     -- Signing
     vbIsUserSigning1:= vbUserId IN (112324);  -- Колосинская С.А.
     vbIsUserSigning2:= vbUserId IN (280164, 133035);  -- Старецкая М.В. + Фурсов А.А.
     vbIsUserSigning3:= vbUserId IN (9463); -- Махота Д.П.
     -- vbIsUserSigning1:= vbUserId IN (133035, 5); -- Фурсов А.А.
     -- vbIsUserSigning2:= vbUserId IN (280164);    -- Старецкая М.В.

     -- последний
     SELECT tmp.Id, tmp.ObjectId
            INTO vbMovementItemId, vbPromoStateKindId
     FROM (SELECT MI.Id, MI.ObjectId
           FROM MovementItem AS MI
                JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoStateKind()
           WHERE MI.MovementId = inMovementId
             AND MI.DescId     = zc_MI_Message()
             AND MI.isErased   = FALSE
           ORDER BY MI.Id DESC
           LIMIT 1
          ) AS tmp;
          
     -- Проверка
     IF (vbIsUserSigning1 = TRUE AND COALESCE (vbPromoStateKindId, 0) NOT IN (zc_Enum_PromoStateKind_StartSign(), zc_Enum_PromoStateKind_Complete(), zc_Enum_PromoStateKind_Return()))
     OR (vbIsUserSigning2 = TRUE AND COALESCE (vbPromoStateKindId, 0) NOT IN (zc_Enum_PromoStateKind_Head(), zc_Enum_PromoStateKind_Complete(), zc_Enum_PromoStateKind_Return()))
     OR (vbIsUserSigning3 = TRUE AND COALESCE (vbPromoStateKindId, 0) NOT IN (zc_Enum_PromoStateKind_Main(), zc_Enum_PromoStateKind_Complete(), zc_Enum_PromoStateKind_Return()))
     THEN
         RAISE EXCEPTION 'Ошибка.Состояние <%> не может быть переведено в состояние <%>'
                       , lfGet_Object_ValueData_sh (vbPromoStateKindId)
                       , lfGet_Object_ValueData_sh (CASE WHEN inIsComplete = TRUE THEN zc_Enum_PromoStateKind_Complete() ELSE zc_Enum_PromoStateKind_Return() END)
                        ;
     END IF;


     -- Результат
     RETURN QUERY 
        SELECT CASE WHEN vbPromoStateKindId = CASE WHEN inIsComplete = TRUE THEN zc_Enum_PromoStateKind_Complete() ELSE zc_Enum_PromoStateKind_Return() END
                         THEN vbMovementItemId
                    ELSE 0
               END :: Integer AS MovementItemId
             , Object_PromoStateKind.Id               AS PromoStateKindId
             , Object_PromoStateKind.ValueData        AS PromoStateKindName
             , CASE WHEN vbPromoStateKindId = CASE WHEN inIsComplete = TRUE THEN zc_Enum_PromoStateKind_Complete() ELSE zc_Enum_PromoStateKind_Return() END
                         THEN (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbMovementItemId AND MIS.DescId = zc_MIString_Comment())
                    ELSE ''
               END :: TVarChar AS Comment
        FROM Object AS Object_PromoStateKind
        WHERE Object_PromoStateKind.Id = CASE WHEN inIsComplete = TRUE THEN zc_Enum_PromoStateKind_Complete() ELSE zc_Enum_PromoStateKind_Return() END
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.04.20         * 
*/

-- тест
-- SELECT * FROM gpGet_MI_Message_PromoStateKind (inMovementId:= 16390310, inIsComplete:= TRUE,  inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpGet_MI_Message_PromoStateKind (inMovementId:= 16390310, inIsComplete:= FALSE, inSession:= zfCalc_UserAdmin())
