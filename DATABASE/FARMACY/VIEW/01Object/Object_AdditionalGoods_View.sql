DROP VIEW IF EXISTS Object_AdditionalGoods_View;

CREATE OR REPLACE VIEW Object_AdditionalGoods_View
AS
    SELECT 
        ObjectLink_AdditionalGoods_GoodsMain.ObjectId AS Id
        
       ,Object_GoodsMain.Id                           AS GoodsMainId
       ,Object_GoodsMain.ObjectCode                   AS GoodsMainCode
       ,Object_GoodsMain.ValueData                    AS GoodsMainName

       ,Object_GoodsSecond.Id                         AS GoodsSecondId
       ,Object_GoodsSecond.ObjectCode                 AS GoodsSecondCode
       ,Object_GoodsSecond.ValueData                  AS GoodsSecondName
         
     FROM ObjectLink AS ObjectLink_AdditionalGoods_GoodsMain
        JOIN Object AS Object_GoodsMain
                    ON Object_GoodsMain.Id = ObjectLink_AdditionalGoods_GoodsMain.ChildObjectId
 
        JOIN ObjectLink AS ObjectLink_AdditionalGoods_GoodsSecond
                        ON ObjectLink_AdditionalGoods_GoodsSecond.ObjectId = ObjectLink_AdditionalGoods_GoodsMain.ObjectId
                       AND ObjectLink_AdditionalGoods_GoodsSecond.DescId = zc_ObjectLink_AdditionalGoods_GoodsSecond()
        JOIN Object AS Object_GoodsSecond
                    ON Object_GoodsSecond.Id = ObjectLink_AdditionalGoods_GoodsSecond.ChildObjectId
          
    WHERE ObjectLink_AdditionalGoods_GoodsMain.DescId = zc_ObjectLink_AdditionalGoods_GoodsMain();

ALTER TABLE Object_AdditionalGoods_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.07.14                         *
*/

-- тест
-- SELECT * FROM Object_Additionalgoods_View
