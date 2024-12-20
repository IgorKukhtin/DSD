-- Function: gpSelect_MI_ProductionPersonal_Master()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ProductionPersonal (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_ProductionPersonal_Master (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionPersonal_Master (
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , ProductId Integer, ProductCode Integer, ProductName TVarChar
             , CIN TVarChar, EngineNum TVarChar, EngineName TVarChar
             , MovementId_OrderClient Integer
             , OperDate_OrderClient  TDateTime
             , InvNumber_OrderClient TVarChar
             , StatusCode_OrderClient Integer
             , StatusName_OrderClient TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar 
             , Comment TVarChar
             , Amount TFloat
             , StartBeginDate TDateTime
             , EndBeginDate TDateTime
             , InsertName TVarChar, InsertDate TDateTime
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId       Integer;
  DECLARE vbToId         Integer;
  DECLARE vbFromId       Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ProductionPersonal());
    vbUserId := lpGetUserBySession (inSession);

       RETURN QUERY
       WITH
       tmpIsErased AS (SELECT FALSE AS isErased
                        UNION ALL
                       SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                      )
     , tmpMI AS   (SELECT MovementItem.ObjectId
                        , MovementItem.Amount
                        , MovementItem.Id
                        , MovementItem.isErased
                   FROM tmpIsErased
                      JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = tmpIsErased.isErased
                     )

         -- результат
            SELECT
                MovementItem.Id                    AS Id
              , MovementItem.ObjectId              AS PersonalId
              , Object_Personal.ObjectCode         AS PersonalCode
              , Object_Personal.ValueData          AS PersonalName

              , Object_Product.Id                  AS ProductId
              , Object_Product.ObjectCode          AS ProductCode
              , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased)         AS ProductName
              , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData, Object_Product.isErased)       AS CIN
              , zfCalc_ValueData_isErased (ObjectString_EngineNum.ValueData, Object_Product.isErased) AS EngineNum
              , Object_Engine.ValueData            AS EngineName

              , Movement_OrderClient.Id            AS MovementId_OrderClient
              , Movement_OrderClient.OperDate      AS OperDate_OrderClient
              , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumber_OrderClient
              , Object_Status.ObjectCode   AS StatusCode_OrderClient
              , Object_Status.ValueData    AS TVarChar  

              , Object_Goods.Id            AS GoodsId
              , Object_Goods.ObjectCode    AS GoodsCode
              , Object_Goods.ValueData     AS GoodsName 
              , MIString_Comment.ValueData ::TVarChar AS Comment

              , MovementItem.Amount           ::TFloat

              , MIDate_StartBegin.ValueData        AS StartBeginDate
              , MIDate_EndBegin.ValueData          AS EndBeginDate

              , Object_Insert.ValueData            AS InsertName
              , MIDate_Insert.ValueData            AS InsertDate

              , MovementItem.isErased
            FROM tmpMI AS MovementItem
                 LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementItem.ObjectId

                 LEFT JOIN MovementItemLinkObject AS MILO_Product
                                                  ON MILO_Product.MovementItemId = MovementItem.Id
                                                 AND MILO_Product.DescId = zc_MILinkObject_Product()
                 LEFT JOIN Object AS Object_Product ON Object_Product.Id = MILO_Product.ObjectId

                 LEFT JOIN MovementItemDate AS MIDate_StartBegin
                                            ON MIDate_StartBegin.MovementItemId = MovementItem.Id
                                           AND MIDate_StartBegin.DescId = zc_MIDate_StartBegin()
                 LEFT JOIN MovementItemDate AS MIDate_EndBegin
                                            ON MIDate_EndBegin.MovementItemId = MovementItem.Id
                                           AND MIDate_EndBegin.DescId = zc_MIDate_EndBegin()

                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                  ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MILinkObject_Goods.ObjectId

                 LEFT JOIN MovementItemString AS MIString_Comment
                                              ON MIString_Comment.MovementItemId = MovementItem.Id
                                             AND MIString_Comment.DescId = zc_MIString_Comment()

                 LEFT JOIN MovementItemDate AS MIDate_Insert
                                            ON MIDate_Insert.MovementItemId = MovementItem.Id
                                           AND MIDate_Insert.DescId = zc_MIDate_Insert()
                 LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                  ON MILO_Insert.MovementItemId = MovementItem.Id
                                                 AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                 LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

                 LEFT JOIN ObjectString AS ObjectString_CIN
                                        ON ObjectString_CIN.ObjectId = Object_Product.Id
                                       AND ObjectString_CIN.DescId   = zc_ObjectString_Product_CIN()
                 LEFT JOIN ObjectString AS ObjectString_EngineNum
                                        ON ObjectString_EngineNum.ObjectId = Object_Product.Id
                                       AND ObjectString_EngineNum.DescId   = zc_ObjectString_Product_EngineNum()
                 LEFT JOIN ObjectLink AS ObjectLink_Engine
                                      ON ObjectLink_Engine.ObjectId = Object_Product.Id
                                     AND ObjectLink_Engine.DescId   = zc_ObjectLink_Product_Engine()
                 LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Engine.ChildObjectId

                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                              ON MovementLinkObject_Product.ObjectId = Object_Product.Id
                                             AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                 LEFT JOIN Movement AS Movement_OrderClient
                                    ON Movement_OrderClient.Id = MovementLinkObject_Product.MovementId
                                   AND Movement_OrderClient.DescId = zc_Movement_OrderClient()
                 LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_OrderClient.StatusId

            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.21         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_ProductionPersonal_Master (inMovementId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MI_ProductionPersonal_Master (inMovementId:= 218 , inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
