--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
INSERT INTO MovementBooleanDesc (Code ,itemname)
  SELECT 'zc_MovementBoolean_PriceWithVAT','цена с НДС (да/нет)'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_PriceWithVAT');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.

 07.07.13         * НОВАЯ СХЕМА
*/