 -- Function: gpSelect_MovementItem_OrderFinance_Child()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderFinance_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderFinance_Child(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , InvNumber  TVarChar
             , GoodsName TVarChar
             , Comment TVarChar
             , Amount TFloat
             
             , MovementItemId_OrderIncome Integer
             --, MovementId_OrderIncome Integer
             --, InvNumber_OrderIncome TVarChar, OperDate_OrderIncome TDateTime
             
             , isSign Boolean
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderFinance());
     vbUserId:= lpGetUserBySession (inSession);
     

     -- Результат
     RETURN QUERY
     WITH
     tmpMI_Child AS (SELECT MovementItem.*
                     FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                          JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                           AND MovementItem.DescId     = zc_MI_Child()
                                           AND MovementItem.isErased   = tmpIsErased.isErased

                    )

       -- Результат
       SELECT
             MovementItem.Id                         AS Id
           , MovementItem.ParentId
           , MIString_InvNumber.ValueData ::TVarChar AS InvNumber
           , MIString_GoodsName.ValueData ::TVarChar AS GoodsName
           , MIString_Comment.ValueData   ::TVarChar AS Comment
           , MovementItem.Amount          ::TFloat   AS Amount
           
           , MIFloat_MovementItemId.ValueData           ::Integer AS MovementItemId_OrderIncome 
           
           , COALESCE (MIBoolean_Sign.ValueData, FALSE) ::Boolean AS isSign
           , MovementItem.isErased                      ::Boolean AS isErased

       FROM tmpMI_Child AS MovementItem
            LEFT JOIN MovementItemString AS MIString_GoodsName
                                         ON MIString_GoodsName.MovementItemId = MovementItem.Id
                                        AND MIString_GoodsName.DescId = zc_MIString_GoodsName()

            LEFT JOIN MovementItemString AS MIString_InvNumber
                                         ON MIString_InvNumber.MovementItemId = MovementItem.Id
                                        AND MIString_InvNumber.DescId = zc_MIString_InvNumber()

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                        ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                       AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()

            LEFT JOIN MovementItemBoolean AS MIBoolean_Sign
                                          ON MIBoolean_Sign.MovementItemId = MovementItem.Id
                                         AND MIBoolean_Sign.DescId = zc_MIBoolean_Sign()

      UNION ALL
       -- Пустая строчка для удобства
       SELECT
             0                   AS Id
           , MovementItem.Id     AS ParentId
           , ''    ::TVarChar    AS InvNumber
           , ''    ::TVarChar    AS GoodsName
           , ''    ::TVarChar    AS Comment
           , 0     ::TFloat      AS Amount
                   
           , 0     ::Integer     AS MovementItemId_OrderIncome 
           
           , FALSE ::Boolean     AS isSign
           , MovementItem.isErased

       FROM MovementItem
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = FALSE
         AND 1=0
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.01.26         *
*/

-- тест
--
-- SELECT * FROM gpSelect_MovementItem_OrderFinance_Child (inMovementId:= 20081622, inIsErased:= FALSE, inSession:= '9818')
