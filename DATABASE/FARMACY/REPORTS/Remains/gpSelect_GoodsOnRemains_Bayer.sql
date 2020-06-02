-- Function: gpSelect_GoodsOnRemains_Bayer()

DROP FUNCTION IF EXISTS gpSelect_GoodsOnRemains_Bayer (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnRemains_Bayer(
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar, Token TVarChar
             , BarCode TVarChar, CodeRazom Integer, GoodsName TVarChar,  Amount Integer

              ) AS
$BODY$
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountExternalTools());

    RETURN QUERY
    WITH
          -- Подразделения
      tmpUnit AS (SELECT Object_Unit.Id                          AS UnitId
                       , Object_Unit.ObjectCode                  AS UnitCode
                       , Object_Unit.ValueData                   AS UnitName

                       , ObjectString_Token.ValueData            AS Token

                  FROM Object AS Object_DiscountExternalTools
                       LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                            ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalTools.Id
                                           AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
                       LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = ObjectLink_DiscountExternal.ChildObjectId
                       LEFT JOIN ObjectLink AS ObjectLink_Unit
                                            ON ObjectLink_Unit.ObjectId = Object_DiscountExternalTools.Id
                                           AND ObjectLink_Unit.DescId = zc_ObjectLink_DiscountExternalTools_Unit()
                       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                            ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                           AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                       LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

                       LEFT JOIN ObjectString AS ObjectString_User
                                              ON ObjectString_User.ObjectId = Object_DiscountExternalTools.Id
                                             AND ObjectString_User.DescId = zc_ObjectString_DiscountExternalTools_User()
                       LEFT JOIN ObjectString AS ObjectString_Password
                                              ON ObjectString_Password.ObjectId = Object_DiscountExternalTools.Id
                                             AND ObjectString_Password.DescId = zc_ObjectString_DiscountExternalTools_Password()

                       LEFT JOIN ObjectString AS ObjectString_ExternalUnit
                                              ON ObjectString_ExternalUnit.ObjectId = Object_DiscountExternalTools.Id
                                             AND ObjectString_ExternalUnit.DescId = zc_ObjectString_DiscountExternalTools_ExternalUnit()

                       LEFT JOIN ObjectString AS ObjectString_Token
                                              ON ObjectString_Token.ObjectId = Object_DiscountExternalTools.Id
                                             AND ObjectString_Token.DescId = zc_ObjectString_DiscountExternalTools_Token()

                  WHERE Object_DiscountExternalTools.DescId = zc_Object_DiscountExternalTools()
                    AND Object_DiscountExternal.ObjectCode = 4
                    AND COALESCE(ObjectString_Token.ValueData, '') <> ''
                    AND Object_DiscountExternalTools.isErased = False),
      tmpGooad AS (SELECT Object_BarCode.Id           AS Id
                        , Object_BarCode.ObjectCode   AS Code
                        , Object_BarCode.ValueData    AS BarCodeName

                        , Object_Goods.Id             AS GoodsId
                        , Object_Goods.ObjectCode     AS GoodsCode
                        , Object_Goods.ValueData      AS GoodsName

                        , Object_Object.Id            AS ObjectId
                        , Object_Object.ValueData     AS ObjectName

                        , Object_Goods_Retail.ID      AS GoodsRetailId

                     FROM Object AS Object_BarCode
                         LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                              ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                             AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_BarCode_Goods.ChildObjectId

                         LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                              ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                             AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                         LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId

                         INNER JOIN Object_Goods_Retail AS OG_Retail ON OG_Retail.Id = Object_Goods.Id
                         INNER JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = OG_Retail.GoodsMainId
                         INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = Object_Goods_Main.Id


                     WHERE Object_BarCode.DescId = zc_Object_BarCode()
                       AND Object_Object.ObjectCode = 4
                       AND COALESCE(Object_BarCode.ValueData, '') <> ''
                       AND Object_BarCode.isErased = False),
      tmpContainer AS (SELECT Container.ObjectId         AS GoodsId
                            , Container.WhereObjectId    AS UnitId
                            , tmpGooad.BarCodeName       AS BarCodeName
                            , tmpGooad.GoodsName         AS GoodsName
                            , COALESCE(ObjectFloat_CodeRazom.ValueData, 0)::Integer  AS CodeRazom
                            , Sum(Container.Amount)      AS Amount
                       FROM tmpUnit

                            INNER JOIN tmpGooad ON 1 = 1

                            INNER JOIN Container ON Container.WhereObjectId = tmpUnit.UnitId
                                                AND Container.ObjectId = tmpGooad.GoodsRetailId

                            LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                          ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                         AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                            LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                            -- элемент прихода
                            LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                            INNER JOIN Movement ON Movement.Id = MI_Income.MovementId
                            -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                        ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                            -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                            LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                                 -- AND 1=0

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = COALESCE (MI_Income_find.MovementId ,MI_Income.MovementId)
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                            LEFT JOIN ObjectFloat AS ObjectFloat_CodeRazom
                                                  ON ObjectFloat_CodeRazom.ObjectId = MovementLinkObject_From.ObjectId
                                                 AND ObjectFloat_CodeRazom.DescId = zc_ObjectFloat_Juridical_CodeRazom()
                       WHERE Container.DescId = zc_Container_Count()
                         AND Container.Amount <> 0
                       GROUP BY Container.ObjectId
                              , Container.WhereObjectId
                              , tmpGooad.BarCodeName
                              , tmpGooad.GoodsName
                              , ObjectFloat_CodeRazom.ValueData
                       HAVING Sum(Container.Amount) > 0
                       )

    SELECT tmpUnit.UnitId
         , tmpUnit.UnitCode
         , tmpUnit.UnitName
         , tmpUnit.Token

         , tmpContainer.BarCodeName
         , tmpContainer.CodeRazom
         , tmpContainer.GoodsName
         , trunc(tmpContainer.Amount)::Integer
    FROM tmpUnit
         INNER JOIN tmpContainer ON  tmpContainer.UnitId = tmpUnit.UnitId
    WHERE trunc(tmpContainer.Amount) > 0
      AND COALESCE (tmpContainer.CodeRazom, 0) > 0
    ORDER BY tmpUnit.UnitCode;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 16.05.17                                                       *
 20.07.16         *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsOnRemains_Bayer ('3')