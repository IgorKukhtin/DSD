-- Function: gpSelect_MI_OrderInternal_Detail()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternal_Detail (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternal_Detail (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternal_Detail(
    IN inMovementId       Integer      , -- ключ Документа
    IN inShowAll          Boolean      , --
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , ReceiptServiceId Integer, ReceiptServiceCode Integer, ReceiptServiceName TVarChar
             , Article_ReceiptService TVarChar
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , Comment TVarChar
             , Amount TFloat
             , OperPrice TFloat
             , Hours TFloat
             , Summ TFloat
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры

     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH
     tmpIsErased AS (SELECT FALSE AS isErased
                    UNION ALL
                     SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                    )
        -- Результат
        SELECT 0  :: Integer   AS Id
             , MovementItem.Id AS ParentId
             , 0  :: Integer   AS ReceiptServiceId
             , 0  :: Integer   AS ReceiptServiceCode
             , ('Работа № ' || tmp.Num) :: TVarChar  AS ReceiptServiceName
             , '' :: TVarChar    AS Article_ReceiptService

             , 0  :: Integer  AS PersonalId
             , 0  :: Integer  AS PersonalCode
             , '' :: TVarChar AS PersonalName
             , '' :: TVarChar AS Comment

             , 0  :: TFloat   AS Amount
             , 0  :: TFloat   AS OperPrice
             , 0  :: TFloat   AS Hours
             , 0  :: TFloat   AS Summ

             , FALSE :: Boolean isErased

        FROM (SELECT '1' AS Num UNION SELECT '2' AS Num) AS tmp
             INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
        WHERE inShowAll = TRUE

       UNION ALL
        -- Результат
        SELECT MovementItem.Id
             , MovementItem.ParentId
             , MovementItem.ObjectId             AS ReceiptServiceId
             , Object_ReceiptService.ObjectCode  AS ReceiptServiceCode
             , Object_ReceiptService.ValueData   AS ReceiptServiceName
             , ObjectString_Article.ValueData    AS Article_ReceiptService

             , Object_Personal.Id                AS PersonalId
             , Object_Personal.ObjectCode        AS PersonalCode
             , Object_Personal.ValueData         AS PersonalName
             , MIString_Comment.ValueData        AS Comment

             , MovementItem.Amount          ::TFloat AS Amount
             , MIFloat_OperPrice.ValueData  ::TFloat AS OperPrice
             , MIFloat_Hours.ValueData      ::TFloat AS Hours
             , MIFloat_Summ.ValueData       ::TFloat AS Summ

             , MovementItem.isErased

        FROM tmpIsErased
             INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Detail()
                                    AND MovementItem.isErased   = tmpIsErased.isErased 

             LEFT JOIN Object AS Object_ReceiptService ON Object_ReceiptService.Id = MovementItem.ObjectId
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = MovementItem.ObjectId
                                   AND ObjectString_Article.DescId   = zc_ObjectString_Article()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Personal
                                              ON MILinkObject_Personal.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Personal.DescId         = zc_MILinkObject_Personal()
             LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MILinkObject_Personal.ObjectId

             LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                         ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                        AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
             LEFT JOIN MovementItemFloat AS MIFloat_Hours
                                         ON MIFloat_Hours.MovementItemId = MovementItem.Id
                                        AND MIFloat_Hours.DescId = zc_MIFloat_Hours()
             LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                         ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                        AND MIFloat_Summ.DescId         = zc_MIFloat_Summ()

             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId   = zc_MIString_Comment()
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.01.23         *
*/

-- тест
-- SELECT * from gpSelect_MI_OrderInternal_Detail (inMovementId:= 224, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
