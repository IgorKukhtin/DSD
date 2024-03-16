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
             , Amount    TFloat
             , OperPrice TFloat
             , Hours     TFloat
             , Summ      TFloat
             , Comment   TVarChar
             , isErased  Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры

     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH tmpIsErased AS (SELECT FALSE AS isErased
                         UNION ALL
                          SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                         )
          -- OrderInternal - Master
        , tmpMI_Master AS (SELECT MovementItem.Id                        AS MovementItemId
                                , MovementItem.ObjectId                  AS ObjectId
                                , MovementItem.Amount                    AS Amount
                                , MIFloat_MovementId.ValueData ::Integer AS MovementId_OrderClient
                                , MovementItem.isErased                  AS isErased
                           FROM tmpIsErased
                                INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = tmpIsErased.isErased
                                LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                            ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                           AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                          )
          -- OrderInternal - существующие Работы
        , tmpMI_Detail AS (SELECT MovementItem.Id                        AS MovementItemId
                                , MovementItem.ParentId                  AS ParentId
                                  -- Работы
                                , MovementItem.ObjectId                  AS ReceiptServiceId
                                  -- Сотрудник
                                , MILinkObject_Personal.ObjectId         AS PersonalId
                                  -- Часы
                                , MovementItem.Amount                    AS Amount
                                  --
                                , MIFloat_OperPrice.ValueData            AS OperPrice
                                , MIFloat_Hours.ValueData                AS Hours
                                , MIFloat_Summ.ValueData                 AS Summ
                                , MIString_Comment.ValueData             AS Comment
                                , MovementItem.isErased                  AS isErased
                           FROM tmpIsErased
                                INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                       AND MovementItem.DescId     = zc_MI_Detail()
                                                       AND MovementItem.isErased   = tmpIsErased.isErased
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Personal
                                                                 ON MILinkObject_Personal.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Personal.DescId         = zc_MILinkObject_Personal()
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
                                                            AND MIString_Comment.DescId         = zc_MIString_Comment()
                          )
          -- OrderClient - Узлы - Child
        , tmpOrderClient AS (SELECT tmpMovement.MovementId_OrderClient
                                    -- узел
                                  , MI_Child.ObjectId AS GoodsId
                                    -- Узел (базовый) - для него поиск списка работ
                                  , COALESCE (MILinkObject_GoodsBasis.ObjectId, MI_Child.ObjectId) AS GoodsId_basis
                                   -- Шаблон сборка Узла
                                  , MILinkObject_ReceiptGoods.ObjectId AS ReceiptGoodsId
                             FROM (SELECT DISTINCT tmpMI_Master.MovementId_OrderClient FROM tmpMI_Master
                                  ) AS tmpMovement
                                  INNER JOIN MovementItem AS MI_Child
                                                          ON MI_Child.MovementId = tmpMovement.MovementId_OrderClient
                                                         AND MI_Child.DescId     = zc_MI_Child()
                                                         AND MI_Child.isErased   = FALSE
                                  -- Узел (базовый) 
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                                   ON MILinkObject_GoodsBasis.MovementItemId = MI_Child.Id
                                                                  AND MILinkObject_GoodsBasis.DescId         = zc_MILinkObject_GoodsBasis()
                                  -- Шаблон сборка Узла
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptGoods
                                                                   ON MILinkObject_ReceiptGoods.MovementItemId = MI_Child.Id
                                                                  AND MILinkObject_ReceiptGoods.DescId         = zc_MILinkObject_ReceiptGoods()
                            )
                -- шаблон сборки Узла - Работы
              , tmpReceiptItems AS (SELECT tmpOrderClient.MovementId_OrderClient
                                           -- реальный узел - с заменой если надо на ПФ
                                         , COALESCE (ObjectLink_GoodsChild.ChildObjectId, tmpOrderClient.GoodsId) AS GoodsId
                                           -- Узел (базовый) - для него поиск списка работ
                                         , tmpOrderClient.GoodsId_basis
                                           -- Шаблон сборка Узла
                                         , tmpOrderClient.ReceiptGoodsId
                                           -- Шаблон сборка Узла
                                         , Object_ReceiptGoods.Id AS ReceiptGoodsId_find

                                           -- Работы
                                         , Object_ReceiptService.Id         AS ReceiptServiceId
                                         , Object_ReceiptService.ObjectCode AS ReceiptServiceCode
                                         , Object_ReceiptService.ValueData  AS ReceiptServiceName

                                    FROM tmpOrderClient
                                         -- находим шаблон - или базовый ?или реальный? ?или Шаблон?
                                         INNER JOIN ObjectLink AS ObjectLink_Goods
                                                               ON ObjectLink_Goods.ChildObjectId = tmpOrderClient.GoodsId_basis -- tmpOrderClient.GoodsId
                                                              AND ObjectLink_Goods.DescId        = zc_ObjectLink_ReceiptGoods_Object()
                                         INNER JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id       = ObjectLink_Goods.ObjectId -- tmpOrderClient.ReceiptGoodsId
                                                                                 AND Object_ReceiptGoods.isErased = FALSE
                                         INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                               ON ObjectLink_ReceiptGoods.ChildObjectId = Object_ReceiptGoods.Id
                                                              AND ObjectLink_ReceiptGoods.DescId        = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                         INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id = ObjectLink_ReceiptGoods.ObjectId
                                                                                      AND Object_ReceiptGoods.isErased = FALSE
                                         INNER JOIN ObjectLink AS ObjectLink_Object
                                                               ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                              AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()
                                         -- только если работы
                                         INNER JOIN Object AS Object_ReceiptService
                                                           ON Object_ReceiptService.Id     = ObjectLink_Object.ChildObjectId
                                                          AND Object_ReceiptService.DescId = zc_Object_ReceiptService()

                                         -- GoodsId_child
                                         LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                                              ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()

                                    WHERE Object_ReceiptGoodsChild.DescId   = zc_Object_ReceiptGoodsChild()
                                      AND Object_ReceiptGoodsChild.isErased = FALSE
                                      -- без него
                                      -- AND  IS NULL
                                   )
        -- Результат
        SELECT 0 :: Integer                       AS Id
             , tmpMI_Master.MovementItemId        AS ParentId
             , tmpReceiptItems.ReceiptServiceId   AS ReceiptServiceId
             , tmpReceiptItems.ReceiptServiceCode AS ReceiptServiceCode
             , tmpReceiptItems.ReceiptServiceName AS ReceiptServiceName
             , ObjectString_Article.ValueData     AS Article_ReceiptService

             , 0  :: Integer  AS PersonalId
             , 0  :: Integer  AS PersonalCode
             , '' :: TVarChar AS PersonalName

             , 0  :: TFloat   AS Amount
             , 0  :: TFloat   AS OperPrice
             , 0  :: TFloat   AS Hours
             , 0  :: TFloat   AS Summ

             , '' :: TVarChar AS Comment

             , FALSE :: Boolean isErased

        FROM tmpReceiptItems
             INNER JOIN tmpMI_Master ON tmpMI_Master.ObjectId = tmpReceiptItems.GoodsId -- Реальный узел

             LEFT JOIN tmpMI_Detail ON tmpMI_Detail.ParentId         = tmpMI_Master.MovementItemId
                                   AND tmpMI_Detail.ReceiptServiceId = tmpReceiptItems.ReceiptServiceId

             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = tmpMI_Detail.ReceiptServiceId
                                   AND ObjectString_Article.DescId   = zc_ObjectString_Article()


        -- только те, кого не добавили
        WHERE tmpMI_Detail.ReceiptServiceId IS NULL
        --AND inShowAll = TRUE !!!Всегда

       UNION ALL
        -- Результат
        SELECT tmpMI_Detail.MovementItemId       AS Id
             , tmpMI_Detail.ParentId             AS ParentId
             , tmpMI_Detail.ReceiptServiceId     AS ReceiptServiceId
             , Object_ReceiptService.ObjectCode  AS ReceiptServiceCode
             , Object_ReceiptService.ValueData   AS ReceiptServiceName
             , ObjectString_Article.ValueData    AS Article_ReceiptService

             , Object_Personal.Id                AS PersonalId
             , Object_Personal.ObjectCode        AS PersonalCode
             , Object_Personal.ValueData         AS PersonalName

             , tmpMI_Detail.Amount      ::TFloat AS Amount
             , tmpMI_Detail.OperPrice   ::TFloat AS OperPrice
             , tmpMI_Detail.Hours       ::TFloat AS Hours
             , tmpMI_Detail.Summ        ::TFloat AS Summ

             , tmpMI_Detail.Comment              AS Comment

             , tmpMI_Detail.isErased

        FROM tmpMI_Detail

             LEFT JOIN Object AS Object_Personal       ON Object_Personal.Id       = tmpMI_Detail.PersonalId
             LEFT JOIN Object AS Object_ReceiptService ON Object_ReceiptService.Id = tmpMI_Detail.ReceiptServiceId
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = tmpMI_Detail.ReceiptServiceId
                                   AND ObjectString_Article.DescId   = zc_ObjectString_Article()

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
