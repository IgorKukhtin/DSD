--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
insert into MovementItemContainerDesc(Code, ItemName)
  SELECT 'zc_MovementItemContainer_Count', 'Проводки для товарного учета в количестве' WHERE NOT EXISTS (SELECT * FROM MovementItemContainerDesc WHERE Code = 'zc_MovementItemContainer_Count');

insert into MovementItemContainerDesc(Code, ItemName)
  SELECT 'zc_MovementItemContainer_Summ', 'Проводки для денежнного учета в суммах' WHERE NOT EXISTS (SELECT * FROM MovementItemContainerDesc WHERE Code = 'zc_MovementItemContainer_Summ');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.

 07.07.13         * НОВАЯ СХЕМА
*/