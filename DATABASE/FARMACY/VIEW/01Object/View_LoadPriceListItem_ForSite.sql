-- View: View_LoadPriceListItem_ForSite

DROP VIEW IF EXISTS View_LoadPriceListItem_ForSite;

CREATE OR REPLACE VIEW View_LoadPriceListItem_ForSite AS
    SELECT 
         Object_Goods.Id                                         as id
       , Object_Goods.ObjectCode                                 as article
       , Object_Goods.ValueData                                  as name
       , ObjectFloat_Goods_Site.ValueData :: Integer             as Id_Site
       , ObjectLink_Goods_Object.ChildObjectId                   as ObjectId
       , (LoadPriceListItem.Price * ((100 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)) / 100)) :: TFloat AS Price -- Цена С НДС
       , LoadPriceListItem.Price AS Price_original -- Цена
       , ObjectFloat_NDSKind_NDS.ValueData AS NDS

       , Object_Juridical.Id         AS JuridicalId
       , Object_Juridical.ObjectCode AS JuridicalCode
       , Object_Juridical.ValueData  AS JuridicalName

       , Object_Contract.Id         AS ContractId
       , Object_Contract.ObjectCode AS ContractCode
       , Object_Contract.ValueData  AS ContractName

    FROM LoadPriceListItem
        INNER JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
        LEFT JOIN (SELECT DISTINCT JuridicalId, ContractId, isPriceClose
                   FROM lpSelect_Object_JuridicalSettingsRetail (lpGet_DefaultValue('zc_Object_Retail', zfCalc_UserSite() :: Integer)  :: Integer)
                  ) AS JuridicalSettings
                    ON JuridicalSettings.JuridicalId = LoadPriceList.JuridicalId
                   AND JuridicalSettings.ContractId  = LoadPriceList.ContractId

        -- получается GoodsMainId
        /*INNER JOIN ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = LoadPriceListItem.GoodsId
                                                  AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
        LEFT JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                               AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()*/

        LEFT JOIN ObjectLink AS ObjectLink_Main2 ON ObjectLink_Main2.ChildObjectId = LoadPriceListItem.GoodsId -- ObjectLink_Main.ChildObjectId
                                                AND ObjectLink_Main2.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
        INNER JOIN ObjectLink AS ObjectLink_Child2 ON ObjectLink_Child2.ObjectId = ObjectLink_Main2.ObjectId
                                                  AND ObjectLink_Child2.DescId = zc_ObjectLink_LinkGoods_Goods()

        LEFT OUTER JOIN Object AS Object_Juridical ON Object_Juridical.Id = LoadPriceList.JuridicalId
        LEFT OUTER JOIN Object AS Object_Contract  ON Object_Contract.Id = LoadPriceList.ContractId

        LEFT OUTER JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Child2.ChildObjectId
        -- связь с Юридические лица или Торговая сеть или ...
        LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                             ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()

        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   


        LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Site
                                    ON ObjectFloat_Goods_Site.ObjectId = Object_Goods.Id
                                   AND ObjectFloat_Goods_Site.DescId = zc_ObjectFloat_Goods_Site();

ALTER TABLE View_LoadPriceListItem_ForSite  OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 08.04.16                                        *
*/

-- Select * from View_LoadPriceListItem_ForSite LIMIT 100
