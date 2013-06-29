--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MovementItemString_Comment', 'Комментарий' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MovementItemString_Comment');

INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MovementItemString_PartionGoods', 'Комментарий' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MovementItemString_PartionGoods');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.

 29.06.13                                        * НОВАЯ СХЕМА
 29.06.13                                        * zc_MovementItemString_PartionGoods
*/
