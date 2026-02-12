with tmpArt AS (select ObjectString_Article.ValueData
                       FROM Object AS Object_Goods
                            JOIN ObjectString AS ObjectString_Article
                                              ON ObjectString_Article.ObjectId = Object_Goods.Id
                                             AND ObjectString_Article.DescId = zc_ObjectString_Article()
                                             AND ObjectString_Article.ValueData <> ''
                where Object_Goods.DescId = zc_Object_Goods()
                group by ObjectString_Article.ValueData 
                having count(*) >1
               )
  --
 , tmpGoods AS (select Object_Goods.*, ObjectString_Article.ValueData AS Article
                FROM Object AS Object_Goods
                     JOIN ObjectString AS ObjectString_Article
                                       ON ObjectString_Article.ObjectId  = Object_Goods.Id
                                      AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                      AND ObjectString_Article.ValueData IN (SELECT tmpArt.ValueData FROM tmpArt)
                where Object_Goods.DescId = zc_Object_Goods()
               )
    -- если есть Остаток
  , tmpRes AS (select DISTINCT tmpGoods.*
               from tmpGoods
                    join Container ON Container.ObjectId = tmpGoods.Id
                                  AND Container.DescId   = zc_Container_Count()
                                  AND Container.Amount   > 0
              )
  -- есть остаток + несколько Article
  -- SELECT Article  FROM tmpRes group by Article having count(*) > 1

  -- select tmpGoods.*
  select tmpGoods.Article
  from tmpGoods
  -- нет остатка
  where tmpGoods.Id not in (select tmpRes.Id from tmpRes)
  group by Article
  having count(*) > 1