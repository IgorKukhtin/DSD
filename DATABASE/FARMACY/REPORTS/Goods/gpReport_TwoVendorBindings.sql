 -- Function: gpReport_TwoVendorBindings()

DROP FUNCTION IF EXISTS gpReport_TwoVendorBindings (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TwoVendorBindings(
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
               GuudsId           Integer
             , GuudsCodeInt      Integer
             , GuudsCode         TVarChar
             , GuudsName         TVarChar
             , ObjectID          Integer
             , ObjectName        TVarChar

             , GoodsM1ID         Integer
             , GoodsM1Code       Integer
             , GoodsM1Name       TVarChar
             , GoodsM2ID         Integer
             , GoodsM2Code       Integer
             , GoodsM2Name       TVarChar
             , NumberLinks       Integer
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    WITH LinkGoods AS (SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId  AS GoodsMainId
                            , ObjectLink_LinkGoods_Goods.ChildObjectId      AS GoodsId
                        FROM ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                             INNER JOIN ObjectBoolean AS ObjectBoolean_Goods_isMain
                                                      ON ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain()
                                                     AND ObjectBoolean_Goods_isMain.ObjectId = ObjectLink_LinkGoods_GoodsMain.ChildObjectId
                             LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                             ON ObjectLink_LinkGoods_Goods.ObjectId = ObjectLink_LinkGoods_GoodsMain.ObjectId
                                            AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                             -- связь с Юридические лица или Торговая сеть или ...
                             INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                  ON ObjectLink_Goods_Object.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                                 AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                             INNER JOIN Object AS Object_GoodsObject ON Object_GoodsObject.Id = ObjectLink_Goods_Object.ChildObjectId
                                              AND Object_GoodsObject.DescId = zc_Object_Juridical()
                        WHERE ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain())
       , GoodsDBL AS (SELECT
                             Object_Goods.Id
                           , min(LinkGoods.GoodsMainId )::Integer AS MinID
                           , max(LinkGoods.GoodsMainId )::Integer AS MaxID
                           , count(*)::Integer                    AS NumberLinks

                      FROM Object AS Object_Goods

                           -- получается GoodsMainId
                           LEFT JOIN  LinkGoods ON LinkGoods.GoodsId = Object_Goods.Id

                           -- связь с Юридические лица или Торговая сеть или ...
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                                ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                                               AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                           LEFT JOIN Object AS Object_GoodsObject ON Object_GoodsObject.Id = ObjectLink_Goods_Object.ChildObjectId
                           LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId


                      WHERE Object_Goods.DescId = zc_Object_Goods()
                        AND Object_GoodsObject.DescId = zc_Object_Juridical()
                      GROUP BY Object_Goods.Id, Object_Goods.ObjectCode, Object_Goods.ValueData
                      HAVING count(*) > 1)




   SELECT
             Object_Goods.Id
           , Object_Goods.ObjectCode                  AS Code
           , ObjectString_Goods_Code.valuedata        AS Code
           , Object_Goods.ValueData                   AS Name
           , Object_GoodsObject.ID                    AS ID
           , Object_GoodsObject.ValueData             AS Name

           , Object_GoodsM1.id       	              AS ID
           , Object_GoodsM1.ObjectCode                AS Code
           , Object_GoodsM1.ValueData                 AS Name
           , Object_GoodsM2.id       	              AS ID
           , Object_GoodsM2.ObjectCode                AS Code
           , Object_GoodsM2.ValueData                 AS Name
           , GoodsDBL.NumberLinks                     AS NumberLinks
    FROM GoodsDBL

         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = GoodsDBL.ID

         LEFT JOIN ObjectString AS ObjectString_Goods_Code
                                ON ObjectString_Goods_Code.ObjectId = Object_Goods.Id
                               AND ObjectString_Goods_Code.DescId = zc_ObjectString_Goods_Code()

         LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                              ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                             AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
         LEFT JOIN Object AS Object_GoodsObject ON Object_GoodsObject.Id = ObjectLink_Goods_Object.ChildObjectId

         LEFT JOIN Object AS Object_GoodsM1 ON Object_GoodsM1.Id = GoodsDBL.minID
         LEFT JOIN Object AS Object_GoodsM2 ON Object_GoodsM2.Id = GoodsDBL.maxID;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.03.20                                                       *
*/

-- тест
-- select * from gpReport_TwoVendorBindings(inSession := '3');
