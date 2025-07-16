with a_from as ( SELECT distinct Object_TradeMark.Id as TradeMarkId, Object_TradeMark.ValueData  
--           , Object_TradeMark.ValueData      AS TradeMarkName
FROM Object_GoodsByGoodsKind_View
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Order
                                    ON ObjectBoolean_Order.ObjectId = Object_GoodsByGoodsKind_View.Id
                                   AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                 ON ObjectLink_Goods_TradeMark.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
where ObjectBoolean_Order.ValueData = true
)

, a_to as (select distinct Object_TradeMark.Id as TradeMarkId, Object_TradeMark.ValueData  
                           FROM (SELECT Object_Sticker.* 
                                 FROM Object AS Object_Sticker 
                    	         
                                 WHERE Object_Sticker.DescId = zc_Object_Sticker()
                                    and Object_Sticker.isErased =false
                                ) AS Object_Sticker
                                
                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_Goods
                                                      ON ObjectLink_Sticker_Goods.ObjectId = Object_Sticker.Id
                                                     AND ObjectLink_Sticker_Goods.DescId = zc_ObjectLink_Sticker_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                 ON ObjectLink_Goods_TradeMark.ObjectId = ObjectLink_Sticker_Goods.ChildObjectId
                                AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
)

, a_to_2 as (select distinct Object_TradeMark.Id as TradeMarkId, Object_TradeMark.ValueData  
                           FROM Object AS Object_StickerFile
                    	         
            LEFT JOIN ObjectLink AS ObjectLink_StickerFile_TradeMark
                                 ON ObjectLink_StickerFile_TradeMark.ObjectId = Object_StickerFile.Id
                                AND ObjectLink_StickerFile_TradeMark.DescId = zc_ObjectLink_StickerFile_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_StickerFile_TradeMark.ChildObjectId

                            WHERE Object_StickerFile.DescId = zc_Object_StickerFile()
                              and Object_StickerFile.isErased =false
)

, tmp_one as (SELECT * FROM gpSelect_Object_StickerFile (FALSE, zfCalc_UserAdmin()) where Id = 1370976 ) -- ШАБЛОН + ТМ ВАРТО (Варус) - Український
/*select a_from.*
, gpInsertUpdate_Object_StickerFile(
    0 -- Id                       Integer,     -- ид
  , 0 -- incode                     Integer,     -- код
  , 0 -- JuridicalId              Integer,     --
  , a_from.TradeMarkId              
  , tmp_one.LanguageName             
  , tmp_one.Comment --                 TVarChar,    -- Примечание
  , ''  -- AS InfoTop                  
  , tmp_one.Width1       --            TFloat, 
  , tmp_one.Width2       --            TFloat,
  , tmp_one.Width3         --          TFloat,
  , tmp_one.Width4           --        TFloat,
  , tmp_one.Width5             --      TFloat,
  , tmp_one.Width6               --    TFloat,
  , tmp_one.Width7      --             TFloat,
  , tmp_one.Width8        --           TFloat,
  , tmp_one.Width9          --         TFloat,
  , tmp_one.Width10           --       TFloat,
  , tmp_one.Level1              --     TFloat, 
  , tmp_one.Level2--                   TFloat,
  , tmp_one.Left1   --                 TFloat, 
  , tmp_one.Left2     --               TFloat,
  , tmp_one.Width1_70_70--             TFloat, 
  , tmp_one.Width2_70_70  --           TFloat,
  , tmp_one.Width3_70_70    --         TFloat,
  , tmp_one.Width4_70_70      --       TFloat,
  , tmp_one.Width5_70_70        --     TFloat,
  , tmp_one.Width6_70_70   --          TFloat,
  , tmp_one.Width7_70_70     --        TFloat,
  , tmp_one.Width8_70_70       --      TFloat,
  , tmp_one.Width9_70_70         --    TFloat,
  , tmp_one.Width10_70_70          --  TFloat,
  , tmp_one.Level1_70_70  --           TFloat, 
  , tmp_one.Level2_70_70    --         TFloat,
  , tmp_one.Left1_70_70       --       TFloat, 
  , tmp_one.Left2_70_70         --     TFloat,

  , tmp_one.isDefault   --             Boolean ,    -- 
  , tmp_one.isSize70     --            Boolean ,    --
  , '5' -- inSession                  TVarChar     -- Пользователь
      )
*/
  , tmp_one.*

from a_from 
     left join a_to_2 as a_to on a_to.TradeMarkId = a_from .TradeMarkId
     left join tmp_one on 1=1
where a_to.TradeMarkId is null
  and a_from .TradeMarkId > 0
  and a_from .TradeMarkId not in (2894769 -- ;"ТМ 0,01 (Копейка)"
                                , 6451465 -- "ТМ Медведевский (Пилот)"
                                , 7289527 -- ""ТМ М'ясна Весна""
                                , 4158526 -- ;"ТМ Вигода"
                                , 7420157 -- TM TRIXI"
                                , 4062451 -- ;"супермаркет РОСТ"
                                , 6694326 -- ;"ТМ Chief Meister"
                              --, 10981795 -- ;"ТМ Fine Life"
                                , 7497146 -- ;"ТМ KOLBASO"
                             --, 2817538 -- ;"ТМ Metro Chef (Метро) "
                                , 10087670 -- ;"ТМ Ведмедівський"
                                , 2786306 -- ;"ТМ Кращий Вибір"
                                , 8844590 -- ;"ТМ "Родинна Ковбаска""
                              --, 10503801 -- ;"ТМ ТОКЕРИ"
                                , 2786307 -- "ТМ Щебпак"

                                )
order by 2