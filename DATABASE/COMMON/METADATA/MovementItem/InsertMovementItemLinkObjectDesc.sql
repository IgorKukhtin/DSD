-- insert into MovementItemLinkObjectDesc(Id, Code, ItemName)
-- SELECT zc_MovementItemLink_Partion(), 'Partion', 'Сущность c которой идет приход товара' 
--       WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Id = zc_MovementItemLink_Partion());

--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementItemLink_GoodsKind', 'Виды товаров' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MovementItemLink_GoodsKind');

INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'MovementItemLink_Asset', 'Основные средства (для которых закупается ТМЦ)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'MovementItemLink_Asset');

INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementItemLink_Receipt', 'Рецептуры' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MovementItemLink_Receipt');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.

 29.06.13                                        * НОВАЯ СХЕМА
 29.06.13                                        * MovementItemLink_Asset
*/
