-- В редмайне не описан используется в gpSelect_Movement_Income_PrintSticker 
CREATE OR REPLACE FUNCTION zc_MIBoolean_Print() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Print'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Print', 'Печатать стикер' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Print'); 

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Полятыкин А.А.
 25.05.17                                                         *
 27.01.17         * add zc_MIBoolean_Print
*/
