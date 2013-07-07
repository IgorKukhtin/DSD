--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
insert into ContainerDesc(Code, ItemName)
  SELECT 'zc_Container_Count', 'Счета товарного учета количества' WHERE NOT EXISTS (SELECT * FROM ContainerDesc WHERE Code = 'zc_Container_Count');

insert into ContainerDesc(Code, ItemName)
  SELECT 'zc_Container_Summ', 'Счета денежнного учета сумм' WHERE NOT EXISTS (SELECT * FROM ContainerDesc WHERE Code = 'zc_Container_Summ');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.07.13         * НОВАЯ СХЕМА
*/
