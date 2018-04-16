     -- !!!Check GoodsMainId!!!
    SELECT *
    FROM Object AS Object_Goods
        -- получается GoodsMainId
        LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = Object_Goods.Id
                                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
        LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

        -- связь с Юридические лица или Торговая сеть или ...
        LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                             ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
        LEFT JOIN Object AS Object_GoodsObject ON Object_GoodsObject.Id = ObjectLink_Goods_Object.ChildObjectId
        LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_isMain
                                  ON ObjectBoolean_Goods_isMain.ObjectId = Object_Goods.Id
                                 AND ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain()
                                 AND ObjectBoolean_Goods_isMain.ValueData = TRUE


    WHERE Object_Goods.DescId = zc_Object_Goods()
      AND ObjectBoolean_Goods_isMain.ObjectId IS NULL
      AND ObjectLink_Main.ChildObjectId IS NULL
      -- AND COALESCE (Object_GoodsObject.DescId, 0) NOT IN (zc_Object_Juridical(), zc_Object_GlobalConst(), zc_object_User(), zc_Object_Contract())
      -- AND COALESCE (Object_GoodsObject.DescId, 0) IN (0, zc_Object_Retail())
   ;
   
     -- !!!ALL!!!
     SELECT Object_Goods.*, tmpGoods.*
          /*, case when tmpGoods.Id is null then
            lpInsertUpdate_Object_Goods_Retail (ioId            := tmpGoods.Id
                                              , inCode          := Object_Goods.ObjectCode :: TVarChar
                                              , inName          := Object_Goods.ValueData
                                              , inGoodsGroupId  := ObjectLink_Goods_GoodsGroup.ChildObjectId
                                              , inMeasureId     := ObjectLink_Goods_Measure.ChildObjectId
                                              , inNDSKindId     := ObjectLink_Goods_NDSKind.ChildObjectId
                                              , inMinimumLot    := ObjectFloat_Goods_MinimumLot.ValueData
                                              , inReferCode     := ObjectFloat_Goods_ReferCode.ValueData :: Integer
                                              , inReferPrice    := ObjectFloat_Goods_ReferPrice.ValueData
                                              , inPrice         := ObjectFloat_Goods_Price.ValueData
                                              , inIsClose       := ObjectBoolean_Goods_Close.ValueData
                                              , inTOP           := ObjectBoolean_Goods_TOP.ValueData
                                              , inPercentMarkup	:= ObjectFloat_Goods_PercentMarkup.ValueData
                                              , inObjectId      := Object_Retail.Id
                                              , inUserId        := 3
                                               )
            end*/
/*
          , case when tmpGoods.Id is not null and ObjectBoolean_Goods_First.ValueData is not null
                      then lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_First(), tmpGoods.Id, ObjectBoolean_Goods_First.ValueData)
            end
          , case when tmpGoods.Id is not null and ObjectString_Goods_Maker.ValueData <> ''
                      then lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Maker(), tmpGoods.Id, ObjectString_Goods_Maker.ValueData)
            end
*/

     FROM (SELECT Object_Goods.*, ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId_main, Object_Retail_from.Id AS ObjectId
           FROM (SELECT MIN (Object_Retail.Id) AS Id FROM Object AS Object_Retail WHERE Object_Retail.DescId = zc_Object_Retail()
                ) AS Object_Retail_from
                INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                      ON ObjectLink_Goods_Object.ChildObjectId = Object_Retail_from.Id
                                     AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId
                          LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                               ON ObjectLink_LinkGoods_Goods.ChildObjectId = Object_Goods.Id
                                              AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                          LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                               ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                              AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
           WHERE ObjectLink_LinkGoods_GoodsMain.ChildObjectId > 0
          ) AS Object_Goods
          LEFT JOIN Object AS Object_Retail ON Object_Retail.DescId = zc_Object_Retail() AND Object_Retail.Id <> Object_Goods.ObjectId
                                           -- AND Object_Retail.Id = (select max (Id) from Object where DescId = zc_Object_Retail())
                                           AND Object_Retail.Id IN (7433742 , 7433743) -- select * from Object where DescId = zc_Object_Retail() order by id DESC
          

          LEFT JOIN 
          (SELECT Object_Goods.*, ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId_main, Object_Retail.Id AS ObjectId
           FROM (SELECT MIN (Object_Retail.Id) AS Id FROM Object AS Object_Retail WHERE Object_Retail.DescId = zc_Object_Retail()
                ) AS Object_Retail_from
                LEFT JOIN Object AS Object_Retail ON Object_Retail.DescId = zc_Object_Retail() -- AND Object_Retail.Id <> Object_Retail_from.Id
                                                 -- AND Object_Retail.Id = (select max (Id) from Object where DescId = zc_Object_Retail())
                                                 AND Object_Retail.Id IN (7433742 , 7433743)
                INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                      ON ObjectLink_Goods_Object.ChildObjectId = Object_Retail.Id
                                     AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId
                          LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                               ON ObjectLink_LinkGoods_Goods.ChildObjectId = Object_Goods.Id
                                              AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                          LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                               ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                              AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
           WHERE ObjectLink_LinkGoods_GoodsMain.ChildObjectId > 0
          ) AS tmpGoods ON tmpGoods.GoodsId_main = Object_Goods.GoodsId_main
                       AND tmpGoods.ObjectId = Object_Retail.Id


         LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                ON ObjectString_Goods_Maker.ObjectId = Object_Goods.Id
                               AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()   

         LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                              ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                             AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
         LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                              ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                             AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
        LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PercentMarkup
                              ON ObjectFloat_Goods_PercentMarkup.ObjectId = Object_Goods.Id
                             AND ObjectFloat_Goods_PercentMarkup.DescId = zc_ObjectFloat_Goods_PercentMarkup()   
        LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Price
                              ON ObjectFloat_Goods_Price.ObjectId = Object_Goods.Id
                             AND ObjectFloat_Goods_Price.DescId = zc_ObjectFloat_Goods_Price()   
        LEFT JOIN ObjectFloat AS ObjectFloat_Goods_MinimumLot
                              ON ObjectFloat_Goods_MinimumLot.ObjectId = Object_Goods.Id
                             AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()   
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                ON ObjectBoolean_Goods_Close.ObjectId = Object_Goods.Id
                               AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                ON ObjectBoolean_Goods_TOP.ObjectId = Object_Goods.Id
                               AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()

         LEFT JOIN ObjectFloat AS ObjectFloat_Goods_ReferCode
                               ON ObjectFloat_Goods_ReferCode.ObjectId = Object_Goods.Id
                              AND ObjectFloat_Goods_ReferCode.DescId = zc_ObjectFloat_Goods_ReferCode()
         LEFT JOIN ObjectFloat AS ObjectFloat_Goods_ReferPrice
                               ON ObjectFloat_Goods_ReferPrice.ObjectId = Object_Goods.Id
                              AND ObjectFloat_Goods_ReferPrice.DescId = zc_ObjectFloat_Goods_ReferPrice()
         LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_First
                                 ON ObjectBoolean_Goods_First.ObjectId = Object_Goods.Id
                                AND ObjectBoolean_Goods_First.DescId = zc_ObjectBoolean_Goods_First()
 where tmpGoods.GoodsId_main is null
-- where tmpGoods.GoodsId_main is not null
-- limit 11


     -- !!!LINK!!!
     SELECT Object_Goods_View_from.*, Object_Retail.*
          /*, gpInsertUpdate_Object_LinkGoods_Load (inGoodsMainCode    := Object_Goods_View_from.ObjectCode :: TVarChar
                                                , inGoodsCode        := Object_Goods_View_from.ObjectCode :: TVarChar
                                                , inRetailId         := Object_Retail.Id
                                                , inSession          := '3'
                                                 )*/
     FROM (SELECT Object_Goods.*, ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId_main, Object_Retail_from.Id AS ObjectId
           FROM (SELECT MIN (Object_Retail.Id) AS Id FROM Object AS Object_Retail WHERE Object_Retail.DescId = zc_Object_Retail()
                ) AS Object_Retail_from
                INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                      ON ObjectLink_Goods_Object.ChildObjectId = Object_Retail_from.Id
                                     AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId

                          LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                               ON ObjectLink_LinkGoods_Goods.ChildObjectId = Object_Goods.Id
                                              AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                          LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                               ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                              AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
           WHERE ObjectLink_LinkGoods_GoodsMain.ChildObjectId > 0
          ) AS Object_Goods_View_from
          LEFT JOIN Object AS Object_Retail ON Object_Retail.DescId = zc_Object_Retail() -- AND Object_Retail.Id <> Object_Goods_View_from.ObjectId
                                           -- AND Object_Retail.Id = (select max (Id) from Object where DescId = zc_Object_Retail())
                                           AND Object_Retail.Id IN (7433742 , 7433743)

          -- inner JOIN Object_Goods_View on Object_Goods_View.ObjectId = Object_Retail.Id
          --        and Object_Goods_View.GoodsCode = Object_Goods_View_from.GoodsCode


/*
     SELECT *
          , gpInsertUpdate_Object_LinkGoods_Load (inGoodsMainCode    := '25995'
                                                , inGoodsCode        := '25995'
                                                , inRetailId         := Object_Retail.Id
                                                , inSession          := '3'
                                                 )
     FROM (SELECT Object_Retail_from.Id AS ObjectId
           FROM (SELECT MIN (Object_Retail.Id) AS Id FROM Object AS Object_Retail WHERE Object_Retail.DescId = zc_Object_Retail()
                ) AS Object_Retail_from
          ) AS Object_Goods_View_from
          LEFT JOIN Object AS Object_Retail ON Object_Retail.DescId = zc_Object_Retail() AND Object_Retail.Id <> Object_Goods_View_from.ObjectId
*/