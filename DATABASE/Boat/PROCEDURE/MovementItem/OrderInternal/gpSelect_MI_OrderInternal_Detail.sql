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
             
             , GoodsId_master   Integer
             , GoodsCode_master Integer
             , GoodsName_master TVarChar
             , DescName_master  TVarChar
             , Amount_master    TFloat
             , Article_master   TVarChar
             , MovementId_OrderClient Integer
             , InvNumber_OrderClient  TVarChar
             , InvNumberFull_OrderClient TVarChar
             , OperDate_OrderClient      TDateTime
             , FromName_OrderClient      TVarChar
             , ProductName_OrderClient   TVarChar
             , CIN_OrderClient           TVarChar             
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
             , MI_Master.Id    AS ParentId
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

             , Object_Goods.Id           AS GoodsId_master
             , Object_Goods.ObjectCode   AS GoodsCode_master
             , Object_Goods.ValueData    AS GoodsName_master
             , ObjectDesc.ItemName       AS DescName_master
             , MI_Master.Amount ::TFloat AS Amount_master
             , ObjectString_Article_master.ValueData AS Article_master
             , Movement_OrderClient.Id                                              AS MovementId_OrderClient
             , zfConvert_StringToNumber (Movement_OrderClient.InvNumber):: TVarChar AS InvNumber_OrderClient 
             , ('№ ' || Movement_OrderClient.InvNumber || ' от ' || zfConvert_DateToString (Movement_OrderClient.OperDate) :: TVarChar ) :: TVarChar  AS InvNumberFull_OrderClient
             , Movement_OrderClient.OperDate                                        AS OperDate_OrderClient
             , Object_From.ValueData                                                AS FromName_OrderClient

             , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased)  AS ProductName_OrderClient
             , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,Object_Product.isErased) AS CIN_OrderClient

        FROM (SELECT '1' AS Num UNION SELECT '2' AS Num) AS tmp
             INNER JOIN MovementItem AS MI_Master
                                     ON MI_Master.MovementId = inMovementId
                                    AND MI_Master.DescId     = zc_MI_Master()
                                    AND MI_Master.isErased   = FALSE

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Master.ObjectId 
             LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId

             LEFT JOIN ObjectString AS ObjectString_Article_master
                                    ON ObjectString_Article_master.ObjectId = MI_Master.ObjectId
                                   AND ObjectString_Article_master.DescId = zc_ObjectString_Article()
                
             LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                         ON MIFloat_MovementId.MovementItemId = MI_Master.Id
                                        AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
             LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = MIFloat_MovementId.ValueData::Integer
                 
             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                          ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                         AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
             LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId  

             LEFT JOIN ObjectString AS ObjectString_CIN
                                    ON ObjectString_CIN.ObjectId = Object_Product.Id
                                   AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()
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
             --
             , Object_Goods.Id           AS GoodsId_master
             , Object_Goods.ObjectCode   AS GoodsCode_master
             , Object_Goods.ValueData    AS GoodsName_master
             , ObjectDesc.ItemName       AS DescName_master
             , MI_Master.Amount ::TFloat AS Amount_master
             , ObjectString_Article_master.ValueData AS Article_master
             , Movement_OrderClient.Id                                              AS MovementId_OrderClient
             , zfConvert_StringToNumber (Movement_OrderClient.InvNumber):: TVarChar AS InvNumber_OrderClient 
             , ('№ ' || Movement_OrderClient.InvNumber || ' от ' || zfConvert_DateToString (Movement_OrderClient.OperDate) :: TVarChar ) :: TVarChar  AS InvNumberFull_OrderClient
             , Movement_OrderClient.OperDate                                        AS OperDate_OrderClient
             , Object_From.ValueData                                                AS FromName_OrderClient

             , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased)  AS ProductName_OrderClient
             , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,Object_Product.isErased) AS CIN_OrderClient
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
             --данные из мастера
             LEFT JOIN MovementItem AS MI_Master
                                    ON MI_Master.MovementId = inMovementId
                                   AND MI_Master.Id = MovementItem.ParentId
                                   AND MI_Master.DescId     = zc_MI_Master()
                                   AND MI_Master.isErased   = FALSE --tmpIsErased.isErased

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Master.ObjectId 
             LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId

             LEFT JOIN ObjectString AS ObjectString_Article_master
                                    ON ObjectString_Article_master.ObjectId = MI_Master.ObjectId
                                   AND ObjectString_Article_master.DescId = zc_ObjectString_Article()
                
             LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                         ON MIFloat_MovementId.MovementItemId = MI_Master.Id
                                        AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
             LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = MIFloat_MovementId.ValueData::Integer
                 
             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                          ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                         AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
             LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId  

             LEFT JOIN ObjectString AS ObjectString_CIN
                                    ON ObjectString_CIN.ObjectId = Object_Product.Id
                                   AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()
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
