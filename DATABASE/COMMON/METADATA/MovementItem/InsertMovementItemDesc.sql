--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

INSERT INTO MovementItemDesc (Code, ItemName)
  SELECT 'zc_MI_Master', 'Главный элемент документа' WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Code = 'zc_MI_Master');

INSERT INTO MovementItemDesc (Code, ItemName)
  SELECT 'zc_MI_Child', 'Подчиненный элемент документа' WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Code = 'zc_MI_Child');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.

 30.06.13                                        * rename zc_MI...
 30.06.13                                        * НОВАЯ СХЕМА
*/
