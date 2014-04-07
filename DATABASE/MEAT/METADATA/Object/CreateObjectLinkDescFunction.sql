--------------------------- !!!!!!!!!!!!!!!!!!!!!!!!!
--------------------------- !!! ВРЕМЕННЫЕ ОБЪЕКТЫ !!!
--------------------------- !!!!!!!!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner1CLink_Partner() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner1CLink_Partner'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Partner1CLink_Partner', 'Ссылка на точку доставки в объекте связь точек доставки и кодов в 1С', zc_Object_Partner1CLink(), zc_Object_Partner() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner1CLink_Partner');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner1CLink_Branch() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner1CLink_Branch'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Partner1CLink_Branch', 'Ссылка на филиал в объекте связь точек доставки и кодов в 1С', zc_Object_Partner1CLink(), zc_Object_Branch() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner1CLink_Branch');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner1CLink_Contract() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner1CLink_Contract'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Partner1CLink_Contract', 'Ссылка на договор в объекте связь точек доставки и кодов в 1С', zc_Object_Partner1CLink(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner1CLink_Contract');


CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind1CLink_Branch() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind1CLink_Branch'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsByGoodsKind1CLink_Branch', 'zc_ObjectLink_GoodsByGoodsKind1CLink_Branch', zc_Object_GoodsByGoodsKind1CLink(), zc_Object_Branch() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind1CLink_Branch');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind1CLink_Goods() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind1CLink_Goods'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsByGoodsKind1CLink_Goods', 'zc_ObjectLink_GoodsByGoodsKind1CLink_Goods', zc_Object_GoodsByGoodsKind1CLink(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind1CLink_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind', 'zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind', zc_Object_GoodsByGoodsKind1CLink(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.14                                        * add zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind
 28.01.14                         * 
*/
