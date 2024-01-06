-- Function: gpSelect_Movement_Invoice_Item()

DROP FUNCTION IF EXISTS gpSelect_Movement_Invoice_Item (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Invoice_Item(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inClientId      Integer ,
    IN inIsErased      Boolean ,
    IN inSession       TVarChar   -- сессия пользователя
)
RETURNS TABLE (MovementId Integer
             , Id         Integer
             , GoodsId    Integer
             , GoodsCode  Integer
             , GoodsName  TVarChar
             , Article    TVarChar
             , Amount     TFloat
             , OperPrice  TFloat
             , Summа      TFloat 
             , Summа_WVAT TFloat
             , Summа_VAT  TFloat
             , Comment    TVarChar
             , Ord Integer
             , isErased   Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbReceiptNumber Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId := lpGetUserBySession (inSession);

     -- !!!Временно замена!!!
     IF inEndDate < CURRENT_DATE THEN inEndDate:= CURRENT_DATE; END IF;


     -- Результат
     RETURN QUERY
      WITH
       tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
               UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
               UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                    )

     , tmpMovement AS (SELECT Movement.*
                            , COALESCE (MovementLinkObject_Object.ObjectId, 0) AS ObjectId
                      FROM tmpStatus
                           INNER JOIN Movement ON Movement.StatusId = tmpStatus.StatusId
                                              AND Movement.DescId = zc_Movement_Invoice()
                                              AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Object
                                                        ON MovementLinkObject_Object.MovementId = Movement.Id
                                                       AND MovementLinkObject_Object.DescId = zc_MovementLinkObject_Object()
                      WHERE MovementLinkObject_Object.ObjectId = inClientId
                        OR COALESCE (inClientId, 0) = 0
                      )

       -- Результат
       SELECT Movement.Id                     AS MovementId
            , MovementItem.Id                 AS Id
            , MovementItem.ObjectId           AS GoodsId
            , Object_Goods.ObjectCode         AS GoodsCode
            , Object_Goods.ValueData          AS GoodsName
            , ObjectString_Article.ValueData  AS Article
            , MovementItem.Amount         ::TFloat AS Amount
            , MIFloat_OperPrice.ValueData ::TFloat AS OperPrice
            , (COALESCE (MovementItem.Amount,0) * COALESCE (MIFloat_OperPrice.ValueData, 0)) ::TFloat AS Summа 
            , zfCalc_SummWVAT_4 (COALESCE (MovementItem.Amount,0) * COALESCE (MIFloat_OperPrice.ValueData, 0), MovementFloat_VATPercent.ValueData) ::TFloat Summа_WVAT
            , (zfCalc_SummWVAT_4 (COALESCE (MovementItem.Amount,0) * COALESCE (MIFloat_OperPrice.ValueData, 0),MovementFloat_VATPercent.ValueData) -  (COALESCE (MovementItem.Amount,0) * COALESCE (MIFloat_OperPrice.ValueData, 0))) ::TFloat Summа_VAT 
            , MIString_Comment.ValueData      AS Comment
            , ROW_NUMBER() OVER (ORDER BY MovementItem.Id ASC) :: Integer AS Ord
            , MovementItem.isErased           AS isErased

       FROM tmpMovement AS Movement 
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND (MovementItem.isErased = inIsErased OR inIsErased = TRUE)
            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id     = MovementItem.ObjectId
                                            AND Object_Goods.DescId = zc_Object_Goods()

            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = MovementItem.ObjectId
                                  AND ObjectString_Article.DescId   = zc_ObjectString_Article()
          ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.12.23         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Invoice_Item (inStartDate:= '01.01.2021', inEndDate:= '18.02.2021', inClientId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
