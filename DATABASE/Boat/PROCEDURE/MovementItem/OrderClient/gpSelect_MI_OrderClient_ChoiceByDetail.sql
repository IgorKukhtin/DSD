 -- Function: gpSelect_MI_OrderClient_ChoiceByDetail()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderClient_ChoiceByDetail (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderClient_ChoiceByDetail(
    IN inMovementId       Integer      , -- ключ Документа
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE ( Id         Integer
              , Code       Integer
              , Name       TVarChar
              , Article    TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     
     RETURN QUERY
     SELECT DISTINCT Object_Uzel.Id AS ObjectId
          , Object_Uzel.ObjectCode  AS ObjectCode
          , Object_Uzel.ValueData   AS ObjectName
          , ObjectString_Article_uzel.ValueData    AS Article
     FROM MovementItem 
                              
          LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                           ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_basis
                                           ON MILinkObject_Goods_basis.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Goods_basis.DescId         = zc_MILinkObject_GoodsBasis()

          LEFT JOIN Object AS Object_Uzel ON Object_Uzel.Id = CASE WHEN COALESCE (MILinkObject_Goods_basis.ObjectId, 0) > 0 THEN  COALESCE (MILinkObject_Goods_basis.ObjectId, 0) ELSE COALESCE (MILinkObject_Goods.ObjectId, 0)  END

          LEFT JOIN ObjectString AS ObjectString_Article_uzel
                                 ON ObjectString_Article_uzel.ObjectId = Object_Uzel.Id
                                AND ObjectString_Article_uzel.DescId   = zc_ObjectString_Article()
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId IN (zc_MI_Detail())
       AND MovementItem.isErased  = FALSE
       AND Object_Uzel.Id IS NOT NULL;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 хярнпхъ пюгпюанрйх: дюрю, юбрнп
               тЕКНМЧЙ х.б.   йСУРХМ х.б.   йКХЛЕМРЭЕБ й.х.
 12.08.25         *
*/

-- РЕЯР
-- SELECT * from gpSelect_MI_OrderClient_ChoiceByDetail (inMovementId:= 5490, inSession:= zfCalc_UserAdmin());
 